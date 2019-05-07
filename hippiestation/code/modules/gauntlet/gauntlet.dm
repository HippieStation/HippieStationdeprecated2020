GLOBAL_VAR_INIT(gauntlet_snapped, FALSE)
GLOBAL_VAR_INIT(gauntlet_equipped, FALSE)

/obj/item/infinity_gauntlet
	name = "Badmin Gauntlet"
	icon = 'hippiestation/icons/obj/infinity.dmi'
	icon_state = "gauntlet"
	force = 22.5
	throwforce = 12
	block_chance = 25
	var/locked_on = FALSE
	var/stone_mode = BLUESPACE_STONE
	var/list/stones = list()
	var/static/list/all_stones = list(SYNDIE_STONE, BLUESPACE_STONE, SERVER_STONE, LAG_STONE, CLOWN_STONE, GHOST_STONE)
	var/static/list/stone_types = list(
		SYNDIE_STONE = /obj/item/infinity_stone/syndie,
		BLUESPACE_STONE = /obj/item/infinity_stone/bluespace, 
		SERVER_STONE = /obj/item/infinity_stone/server, 
		LAG_STONE = /obj/item/infinity_stone/lag, 
		CLOWN_STONE = /obj/item/infinity_stone/clown, 
		GHOST_STONE = /obj/item/infinity_stone/ghost)
	var/static/list/stone_weights = list(
		SYNDIE_STONE = list(
			"Head of Security" = 70,
			"Captain" = 60,
			"Security Officer" = 20,
			"Head of Personnel" = 15
		),
		BLUESPACE_STONE = list(
			"Research Director" = 60,
			"Scientist" = 20,
			"Mime" = 15
		),
		SERVER_STONE = list(
			"Chief Engineer" = 60,
			"Curator" = 45,
			"Station Engineer" = 30,
			"Atmospheric Technician" = 30
		),
		LAG_STONE = list(
			"Quartermaster" = 40,
			"Cargo Technician" = 20
		),
		GHOST_STONE = list(
			"Captain" = 55,
			"Head of Personnel" = 45,
			"Chaplain" = 25
		)
	)


/obj/item/infinity_gauntlet/Initialize()
	. = ..()
	AddComponent(/datum/component/spell_catalyst)
	update_icon()

/obj/item/infinity_gauntlet/examine(mob/user)
	. = ..()
	for(var/obj/item/infinity_stone/IS in stones)
		to_chat(user, "<span class='bold notice'>[IS.name] mode</span>")
		IS.ShowExamine(user)

/obj/item/infinity_gauntlet/proc/GetStone(stone_type)
	for(var/obj/item/infinity_stone/I in stones)
		if(I.stone_type == stone_type)
			return I
	return

/obj/item/infinity_gauntlet/proc/DoTheSnap()
	var/mob/living/snapper = usr
	var/list/mobs_to_wipe = GLOB.player_list.Copy()
	shuffle_inplace(mobs_to_wipe)
	var/to_wipe = FLOOR(mobs_to_wipe.len/2, 1)
	var/wiped = 0
	to_chat(world, "<span class='danger italics'>You feel as if something big has happened.</span>")
	for(var/mob/living/L in mobs_to_wipe)
		if(wiped >= to_wipe)
			break
		if(snapper == L)
			continue
		addtimer(CALLBACK(L, /mob/living.proc/dust, TRUE), rand(5 SECONDS, 10 SECONDS))
		wiped++

/obj/item/infinity_gauntlet/proc/GetWeightedChances(list/job_list, list/blacklist)
	var/list/jobs = list()
	var/list/weighted_list = list()
	for(var/A in job_list)
		jobs += A
	for(var/datum/mind/M in SSticker.minds)
		if(M.current && !considered_afk(M) && considered_alive(M, TRUE) && is_station_level(M.current.z) && !(M.current in blacklist) && (M.assigned_role in jobs))
			weighted_list[M.current] = job_list[M.assigned_role]
	return weighted_list

/obj/item/infinity_gauntlet/proc/MakeStonekeepers(mob/living/current_user)
	var/list/has_a_stone = list(current_user)
	for(var/stone in all_stones)
		var/list/to_get_stones = GetWeightedChances(stone_weights[stone], has_a_stone)
		var/mob/living/L
		if(LAZYLEN(to_get_stones))
			L = pickweight(to_get_stones)
		else
			var/list/minds = list()
			for(var/datum/mind/M in SSticker.minds)
				if(M.current && !considered_afk(M) && considered_alive(M, TRUE) && is_station_level(M.current.z) && !(M.current in has_a_stone))
					minds += M
			if(LAZYLEN(minds))
				var/datum/mind/M = pick(minds)
				L = M.current
		var/stone_type = stone_types[stone]
		var/obj/item/infinity_stone/IS = new stone_type(L ? get_turf(L) : null)
		if(L && istype(L))
			has_a_stone += L
			var/datum/antagonist/stonekeeper/SK = L.mind.add_antag_datum(/datum/antagonist/stonekeeper)
			SK = L.mind.has_antag_datum(/datum/antagonist/stonekeeper)
			var/datum/objective/stonekeeper/SKO = new
			SKO.stone = IS
			SKO.update_explanation_text()
			SK.objectives += SKO
			L.mind.announce_objectives()
			L.put_in_hands(IS)
			L.equip_to_slot(IS, SLOT_IN_BACKPACK)


/obj/item/infinity_gauntlet/proc/FullyAssembled()
	for(var/stone in all_stones)
		if(!GetStone(stone))
			return FALSE
	return TRUE

/obj/item/infinity_gauntlet/proc/GetStoneColor(stone_type)
	var/obj/item/infinity_stone/IS = GetStone(stone_type)
	if(IS && istype(IS))
		return IS.color
	return "#DC143C" //crimson by default

/obj/item/infinity_gauntlet/proc/UpdateAbilities(mob/living/user)
	for(var/obj/item/infinity_stone/IS in stones)
		IS.RemoveAbilities(user)
	if(FullyAssembled())
		for(var/obj/item/infinity_stone/IS in stones)
			if(IS && istype(IS))
				IS.GiveAbilities(user)
	else
		var/obj/item/infinity_stone/IS = GetStone(stone_mode)
		if(IS && istype(IS))
			IS.GiveAbilities(user)

/obj/item/infinity_gauntlet/update_icon()
	cut_overlays()
	var/index = 1
	var/image/veins = image(icon = 'hippiestation/icons/obj/infinity.dmi', icon_state = "glow-overlay")
	veins.color = GetStoneColor(stone_mode)
	add_overlay(veins)
	for(var/obj/item/infinity_stone/IS in stones)
		var/I = index
		if(IS.stone_type == stone_mode)
			I = 0
		var/image/O = image(icon = 'hippiestation/icons/obj/infinity.dmi', icon_state = "[I]-stone")
		O.color = IS.color
		add_overlay(O)
		index++

/obj/item/infinity_gauntlet/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!locked_on)
		return ..()
	if(!isliving(user))
		return ..()
	var/obj/item/infinity_stone/IS = GetStone(stone_mode)
	if(!IS || !istype(IS))
		return ..()
	switch(user.a_intent)
		if(INTENT_DISARM)
			IS.DisarmEvent(target, user, proximity_flag)
		if(INTENT_HARM)
			IS.HarmEvent(target, user, proximity_flag)
		if(INTENT_GRAB)
			IS.GrabEvent(target, user, proximity_flag)
		if(INTENT_HELP)
			IS.HelpEvent(target, user, proximity_flag)

/obj/item/infinity_gauntlet/attack_self(mob/living/user)
	if(!istype(user))
		return
	if(!locked_on)
		var/prompt = alert("Would you like to truly wear the Badmin Gauntlet? You will be unable to remove it!", "Confirm", "Yes", "No")
		if (prompt == "Yes")
			user.dropItemToGround(src)
			if(user.put_in_hands(src))
				GLOB.gauntlet_equipped = TRUE
				user.apply_status_effect(/datum/status_effect/agent_pinpointer/gauntlet)
				priority_announce("A Wizard has declared that he will wipe out half the universe with the Badmin Gauntlet!\nStones have been scattered across the station. Protect anyone who holds one!", title = "Declaration of War", sound = 'hippiestation/sound/misc/wizard_wardec.ogg')
				add_trait(TRAIT_NODROP, GAUNTLET_TRAIT)
				locked_on = TRUE
				visible_message("<span class='danger bold'>The badmin gauntlet clamps to [user]'s hand!</span>")
				MakeStonekeepers(user)
				user.AddSpell(new /obj/effect/proc_holder/spell/self/infinity/regenerate_gauntlet)
				user.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/repulse/gauntlet)
				var/datum/antagonist/wizard/W = user.mind.has_antag_datum(/datum/antagonist/wizard)
				if(W && istype(W))
					for(var/datum/objective/O in W.objectives)
						W.objectives -= O
						qdel(O)
					W.objectives += new /datum/objective/snap
					user.mind.announce_objectives()
			else
				to_chat(user, "<span class='danger'>You do not have an empty hand for the Badmin Gauntlet.</span>")
		return
	if(!LAZYLEN(stones))
		to_chat(user, "<span class='danger'>You have no stones yet.</span>")
		return
	var/list/gauntlet_radial = list()
	for(var/obj/item/infinity_stone/I in stones)
		var/image/IM = image(icon = I.icon, icon_state = I.icon_state)
		IM.color = I.color
		gauntlet_radial[I.stone_type] = IM
	var/chosen = show_radial_menu(user, src, gauntlet_radial, custom_check = CALLBACK(src, .proc/check_menu, user))
	if(!check_menu(user))
		return
	if(chosen)
		stone_mode = chosen
		UpdateAbilities(user)
		update_icon()

/obj/item/infinity_gauntlet/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/infinity_stone))
		if(!locked_on)
			to_chat(user, "<span class='notice'>You need to wear the gauntlet first.</span>")
			return
		var/obj/item/infinity_stone/IS = I
		if(!GetStone(IS.stone_type))
			user.visible_message("<span class='danger bold'>[user] drops the [IS] into the Badmin Gauntlet.</span>")
			IS.forceMove(src)
			stones += IS
			UpdateAbilities(user)
			update_icon()
			if(FullyAssembled() && !GLOB.gauntlet_snapped)
				user.AddSpell(new /obj/effect/proc_holder/spell/self/infinity/snap)
				user.visible_message("<span class='userdanger'>A massive surge of power courses through [user]. You feel as though your very existence is in danger!</span>", 
					"<span class='danger bold'>You have fully assembled the Badmin Gauntlet. You can use all stone abilities no matter the mode, and can SNAP using the ability.</span>")
			return
	return ..()

/obj/item/infinity_gauntlet/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE

/////////////////////////////////////////////
/////////////////// SPELLS //////////////////
/////////////////////////////////////////////
//Weaker versions of Syndie Stone spells

/obj/effect/proc_holder/spell/aoe_turf/repulse/gauntlet
	name = "Badmin Gauntlet: Shockwave"
	desc = "Knock down everyone around down and away from you."
	range = 4
	charge_max = 250
	clothes_req = FALSE
	human_req = FALSE
	staff_req = FALSE
	invocation_type = "none"

/obj/effect/proc_holder/spell/self/infinity/regenerate_gauntlet
	name = "Badmin Gauntlet: Regenerate"
	desc = "Regenerate 2 health per second. Requires you to stand still."
	action_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_icon_state = "regenerate"

/obj/effect/proc_holder/spell/self/infinity/regenerate_gauntlet/cast(list/targets, mob/user)
	if(isliving(user))
		var/mob/living/L = user
		while(do_after(L, 10, FALSE, L))
			L.visible_message("<span class='notice'>[L]'s wounds heal!</span>")
			L.heal_overall_damage(2, 2, 2, null, TRUE)
			if(L.getBruteLoss() + L.getFireLoss() + L.getStaminaLoss() < 1)
				to_chat(user, "<span class='notice'>You are fully healed.</span>")
				return

/obj/effect/proc_holder/spell/self/infinity/snap
	name = "SNAP"
	desc = "Snap the Badmin Gauntlet, erasing half the life in the universe."
	action_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_icon_state = "gauntlet"

/obj/effect/proc_holder/spell/self/infinity/snap/cast(list/targets, mob/living/user)
	var/obj/item/infinity_gauntlet/IG = locate() in user
	if(!IG || !istype(IG))
		return
	var/prompt = alert("Are you REALLY sure you'd like to erase half the life in the universe?", "SNAP?", "YES!", "No")
	if(prompt == "YES!")
		user.emote("snap")
		IG.DoTheSnap()
		GLOB.gauntlet_snapped = TRUE
		user.RemoveSpell(src)
		SSshuttle.emergencyNoRecall = TRUE
		SSshuttle.emergency.request(null, set_coefficient = 0.3)

/obj/screen/alert/status_effect/agent_pinpointer/gauntlet
	name = "Badmin Gauntlet Pinpointer"

/datum/status_effect/agent_pinpointer/gauntlet
	id = "gauntlet_pinpointer"
	minimum_range = 1
	range_fuzz_factor = 0
	alert_type = /obj/screen/alert/status_effect/agent_pinpointer/gauntlet

/datum/status_effect/agent_pinpointer/gauntlet/scan_for_target()
	scan_target = null
	if(owner)
		var/obj/item/infinity_gauntlet/IG = locate() in owner
		for(var/stone in IG.all_stones)
			if(!IG.GetStone(stone))
				var/stone_type = IG.stone_types[stone]
				var/obj/item/infinity_stone/IS = locate(stone_type) in world
				if(!IS || !istype(IS))
					continue
				scan_target = IS
				break


/datum/objective/snap
	name = "snap"
	explanation_text = "Snap out half the life in the universe with the Badmin Gauntlet"

/datum/objective/snap/check_completion()
	return GLOB.gauntlet_snapped
