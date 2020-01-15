//Originally coded for HippieStation by Steamp0rt, shared under the AGPL license.

GLOBAL_VAR_INIT(gauntlet_snapped, FALSE)
GLOBAL_VAR_INIT(gauntlet_equipped, FALSE)
GLOBAL_VAR_INIT(revengers_autocalled, FALSE)
GLOBAL_LIST_INIT(badmin_stones, list(SYNDIE_STONE, BLUESPACE_STONE, SUPERMATTER_STONE, LAG_STONE, CLOWN_STONE, GHOST_STONE))
GLOBAL_LIST_INIT(badmin_stone_types, list(
		SYNDIE_STONE = /obj/item/badmin_stone/syndie,
		BLUESPACE_STONE = /obj/item/badmin_stone/bluespace,
		SUPERMATTER_STONE = /obj/item/badmin_stone/supermatter,
		LAG_STONE = /obj/item/badmin_stone/lag,
		CLOWN_STONE = /obj/item/badmin_stone/clown,
		GHOST_STONE = /obj/item/badmin_stone/ghost))
GLOBAL_LIST_INIT(badmin_stone_weights, list(
		SYNDIE_STONE = list(
			"Head of Security" = 70,
			"Captain" = 60,
			"Security Officer" = 20,
			"Head of Personnel" = 15
		),
		BLUESPACE_STONE = list(
			"Research Director" = 60,
			"Scientist" = 20,
			"Mime" = 15,
			"Assistant" = 5
		),
		SUPERMATTER_STONE = list(
			"Chief Engineer" = 60,
			"Station Engineer" = 30,
			"Atmospheric Technician" = 30
		),
		LAG_STONE = list(
			"Quartermaster" = 40,
			"Cargo Technician" = 20
		),
		GHOST_STONE = list(
			"Chief Medical Officer" = 50,
			"Chaplain" = 50
		),
		CLOWN_STONE = list(
			"Clown" = 100
		)
	))
GLOBAL_VAR_INIT(telescroll_time, 0)

/obj/item/badmin_gauntlet
	name = "Badmin Gauntlet"
	icon = 'hippiestation/icons/obj/infinity.dmi'
	/*
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi' */
	icon_state = "gauntlet"
	item_state = null // need a new in-hand
	force = 25
	armour_penetration = 70
	var/badmin = FALSE
	var/next_flash = 0
	var/flash_index = 1
	var/locked_on = FALSE
	var/stone_mode = null
	var/ert_canceled = FALSE
	var/list/stones = list()
	var/list/spells = list()
	var/datum/martial_art/cqc/martial_art
	var/mutable_appearance/flashy_aura
	var/mob/living/carbon/last_aura_holder
	var/hnnnnnnnnngh = FALSE

/obj/item/badmin_gauntlet/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	AddComponent(/datum/component/spell_catalyst)
	martial_art = new
	flashy_aura = mutable_appearance('hippiestation/icons/obj/infinity.dmi', "aura", -MUTATIONS_LAYER)
	update_icon()
	spells += new /obj/effect/proc_holder/spell/self/infinity/regenerate
	spells += new /obj/effect/proc_holder/spell/self/infinity/shockwave
	spells += new /obj/effect/proc_holder/spell/self/infinity/gauntlet_bullcharge
	spells += new /obj/effect/proc_holder/spell/self/infinity/gauntlet_jump
	spells += new /obj/effect/proc_holder/spell/self/infinity/armor

/obj/item/badmin_gauntlet/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/badmin_gauntlet/process()
	if(!FullyAssembled())
		return
	if(world.time < next_flash)
		return
	if(!iscarbon(loc))
		return
	var/mob/living/carbon/C = loc
	if(last_aura_holder && C != last_aura_holder)
		last_aura_holder.cut_overlay(flashy_aura)
	last_aura_holder = C
	C.cut_overlay(flashy_aura)
	var/static/list/stone_colors = list("#ff0130", "#266ef6", "#ECF332", "#FFC0CB", "#20B2AA", "#e429f2")
	var/index = (flash_index <= 6) ? flash_index : 1
	flashy_aura.color = stone_colors[index]
	C.add_overlay(flashy_aura)
	flash_index = index + 1
	next_flash = world.time + (hnnnnnnnnngh ? 1 : 5)

/obj/item/badmin_gauntlet/examine(mob/user)
	. = ..()
	for(var/obj/item/badmin_stone/IS in stones)
		. += "<span class='bold notice'>[IS.name] mode:</span>"
		for(var/A in IS.ability_text)
			. += "<span class='notice'>[A]</span>"

/obj/item/badmin_gauntlet/ex_act(severity, target)
	return

/obj/item/badmin_gauntlet/proc/GetStone(stone_type)
	for(var/obj/item/badmin_stone/I in stones)
		if(I.stone_type == stone_type)
			return I
	return

/obj/item/badmin_gauntlet/proc/DoSnap(mob/living/snapee)
	var/dust_time = rand(5 SECONDS, 10 SECONDS)
	if(prob(25))
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, snapee, "<span class='danger'>You don't feel so good...</span>"), dust_time - 3 SECONDS)
	addtimer(CALLBACK(src, .proc/Dustify, snapee), dust_time)

/obj/item/badmin_gauntlet/proc/Dustify(mob/living/victim)
	var/dust_sound = pick(
		'hippiestation/sound/effects/snap/snap1.wav',
		'hippiestation/sound/effects/snap/snap2.wav',
		'hippiestation/sound/effects/snap/snap3.wav',
		'hippiestation/sound/effects/snap/snap4.wav',
		'hippiestation/sound/effects/snap/snap5.wav',
		'hippiestation/sound/effects/snap/snap6.wav')
	playsound(victim, dust_sound, 100, TRUE)
#if DM_VERSION < 513
	victim.dust(TRUE)
#else
	var/obj/effect/snap_rt/snap_effect = new(victim.loc, REF(victim))
	victim.filters += filter(type="displace", size=256, render_target="*snap[REF(victim)]")
	animate(victim, alpha=0, time=20, easing=(EASE_IN | SINE_EASING))
	sleep(5)
	victim.spawn_dust(TRUE)
	sleep(15)
	victim.death(TRUE)
	if(victim.buckled)
		victim.buckled.unbuckle_mob(victim, force = TRUE)
	qdel(snap_effect)
	QDEL_IN(victim, 5)
#endif

/obj/item/badmin_gauntlet/proc/DoTheSnap(mob/living/snapper = usr)
	GLOB.gauntlet_snapped = TRUE
	if(snapper.InCritical())
		snapper.say("You should've gone for the head...", forced = "badmin gauntlet")
	snapper.visible_message("<span class='userdanger'>[snapper] raises their Badmin Gauntlet into the air, and... <i>snap.</i></span>")
	SEND_SOUND(world, sound('hippiestation/sound/effects/SNAP.ogg'))
	for(var/mob/M in GLOB.mob_list)
		if(isliving(M))
			var/mob/living/L = M
			addtimer(CALLBACK(L, /mob/living.proc/overlay_fullscreen, "thanos_snap", /obj/screen/fullscreen/thanos_snap), 10)
			addtimer(CALLBACK(L, /mob/living.proc/clear_fullscreen, "thanos_snap"), 35)
	var/list/eligible_mobs = list()	
	for(var/mob/living/L in GLOB.mob_living_list)
		if(L.stat == DEAD || !L.ckey || L == snapper)
			continue
		eligible_mobs += L
	var/players_to_wipe = max(FLOOR(eligible_mobs.len/2, 1), 1)
	to_chat(world, "<span class='userdanger italics'>You feel as if something big has happened.</span>")
	for(var/i = 1 to players_to_wipe)
		var/mob/living/L = pick_n_take(eligible_mobs)
		DoSnap(L)
	_CallRevengers()
	INVOKE_ASYNC(src, .proc/TotallyFine)
	log_game("[key_name(snapper)] snapped, wiping out [players_to_wipe] players.")
	message_admins("[key_name(snapper)] snapped, wiping out [players_to_wipe] players.")

/obj/item/badmin_gauntlet/proc/TotallyFine()
	sleep(10 SECONDS)
	priority_announce("A power surge of unseen proportions has been detected in your sector. Event has been flagged DEVASTATION-CLASS.\n\
						Approximate Power: %$!#ERROR Joules\n\
						Expected Fatalities: Approximately 50% of all life.", "Central Command Higher Dimensional Affairs", 'sound/misc/airraid.ogg')
	sleep(15 SECONDS)
	priority_announce("Attempting to contain source of power surge. Deploying solution package.\n\
						Deployment ETA: 90 SECONDS. ","Central Command Higher Dimensional Affairs")
	sleep(5 SECONDS)
	set_security_level(SEC_LEVEL_DELTA)
	SSshuttle.registerHostileEnvironment(src)
	SSshuttle.lockdown = TRUE
	sleep(76 SECONDS)
	SEND_SOUND(world, sound('sound/machines/alarm.ogg'))
	sleep(9 SECONDS)
	Cinematic(CINEMATIC_THANOS, world, CALLBACK(GLOBAL_PROC,/proc/ending_helper))

/obj/item/badmin_gauntlet/proc/GetWeightedChances(list/job_list, list/blacklist)
	var/list/jobs = list()
	var/list/weighted_list = list()
	for(var/A in job_list)
		jobs += A
	for(var/datum/mind/M in SSticker.minds)
		if(M.current && !considered_afk(M) && considered_alive(M, TRUE) && is_station_level(M.current.z) && !(M.current in blacklist) && (M.assigned_role in jobs))
			weighted_list[M.current] = job_list[M.assigned_role]
	return weighted_list

/obj/item/badmin_gauntlet/proc/MakeStonekeepers(mob/living/current_user)
	var/list/has_a_stone = list(current_user)
	for(var/stone in GLOB.badmin_stones)
		var/list/to_get_stones = GetWeightedChances(GLOB.badmin_stone_weights[stone], has_a_stone)
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
		var/stone_type = GLOB.badmin_stone_types[stone]
		var/obj/item/badmin_stone/IS = new stone_type(L ? L.drop_location() : null)
		if(L && istype(L))
			has_a_stone += L
			var/datum/antagonist/stonekeeper/SK = L.mind.add_antag_datum(/datum/antagonist/stonekeeper)
			SK = L.mind.has_antag_datum(/datum/antagonist/stonekeeper)
			var/datum/objective/stonekeeper/SKO = new
			SKO.stone = IS
			SKO.owner = L.mind
			SKO.update_explanation_text()
			SK.objectives += SKO
			L.mind.announce_objectives()
			L.put_in_hands(IS)
			L.equip_to_slot(IS, SLOT_IN_BACKPACK)


/obj/item/badmin_gauntlet/proc/FullyAssembled()
	ADD_TRAIT(src, TRAIT_NODROP, GAUNTLET_TRAIT)
	for(var/stone in GLOB.badmin_stones)
		if(!GetStone(stone))
			return FALSE
	return TRUE

/obj/item/badmin_gauntlet/proc/GetStoneColor(stone_type)
	var/obj/item/badmin_stone/IS = GetStone(stone_type)
	if(IS && istype(IS))
		return IS.color
	return "#DC143C" //crimson by default

/obj/item/badmin_gauntlet/proc/OnEquip(mob/living/user)
	for(var/obj/effect/proc_holder/spell/A in spells)
		user.mob_spell_list += A
		A.action.Grant(user)
	user.AddComponent(/datum/component/stationloving)
	var/datum/antagonist/wizard/W = user.mind.has_antag_datum(/datum/antagonist/wizard)
	if(W && istype(W))
		for(var/datum/objective/O in W.objectives)
			W.objectives -= O
			qdel(O)
		W.objectives += new /datum/objective/snap
		W.can_hijack = HIJACK_NEUTRAL
		user.mind.announce_objectives()
	user.move_resist = INFINITY

/obj/item/badmin_gauntlet/proc/OnUnquip(mob/living/user)
	user.cut_overlay(flashy_aura)
	var/datum/component/stationloving/stationloving = user.GetComponent(/datum/component/stationloving)
	if(stationloving)
		user.TakeComponent(stationloving)
	for(var/obj/effect/proc_holder/spell/A in spells)
		user.mob_spell_list -= A
		A.action.Remove(user)
	user.move_resist = initial(user.move_resist)
	TakeAbilities(user)

/obj/item/badmin_gauntlet/pickup(mob/user)
	. = ..()
	if(locked_on && isliving(user))
		visible_message("<span class='danger'>The Badmin Gauntlet attaches to [user]'s hand!.</span>")
		OnEquip(user)

/obj/item/badmin_gauntlet/dropped(mob/user)
	. = ..()
	if(locked_on && isliving(user))
		visible_message("<span class='danger'>The Badmin Gauntlet falls off of [user].</span>")
		OnUnquip(user)

/obj/item/badmin_gauntlet/proc/TakeAbilities(mob/living/user)
	for(var/obj/item/badmin_stone/IS in stones)
		IS.RemoveAbilities(user, TRUE)
		IS.TakeVisualEffects(user)
		IS.TakeStatusEffect(user)
	for(var/obj/effect/proc_holder/spell/A in spells)
		user.mob_spell_list -= A
		A.action.Remove(user)
	if(ishuman(user))
		martial_art.remove(user)

// warning: contains snowflake code for syndie stone
/obj/item/badmin_gauntlet/proc/GiveAbilities(mob/living/user)
	var/obj/item/badmin_stone/syndie = GetStone(SYNDIE_STONE)
	if(!syndie)
		for(var/obj/effect/proc_holder/spell/A in spells)
			user.mob_spell_list += A
			A.action.Grant(user)
	if(ishuman(user))
		if(stone_mode != SYNDIE_STONE && (!GetStone(stone_mode) || !stone_mode))
			martial_art.teach(user)
	if(syndie)
		syndie.GiveAbilities(user, TRUE)
	if(FullyAssembled())
		for(var/obj/item/badmin_stone/IS in stones)
			if(IS && istype(IS) && IS.stone_type != SYNDIE_STONE)
				IS.GiveAbilities(user, TRUE)
	else
		var/obj/item/badmin_stone/IS = GetStone(stone_mode)
		if(IS && istype(IS))
			IS.GiveVisualEffects(user)
			if(stone_mode != SYNDIE_STONE)
				IS.GiveAbilities(user, TRUE)

/obj/item/badmin_gauntlet/proc/UpdateAbilities(mob/living/user)
	TakeAbilities(user)
	GiveAbilities(user)

/obj/item/badmin_gauntlet/update_icon()
	cut_overlays()
	var/index = 1
	if(stone_mode)
		var/image/veins = image(icon = 'hippiestation/icons/obj/infinity.dmi', icon_state = "glow-overlay")
		veins.color = GetStoneColor(stone_mode)
		add_overlay(veins)
	for(var/obj/item/badmin_stone/IS in stones)
		var/I = index
		if(IS.stone_type == stone_mode)
			I = 0
		var/image/O = image(icon = 'hippiestation/icons/obj/infinity.dmi', icon_state = "[I]-stone")
		O.color = IS.color
		add_overlay(O)
		index++

/obj/item/badmin_gauntlet/melee_attack_chain(mob/user, atom/target, params)
	if(!tool_attack_chain(user, target) && pre_attack(target, user, params))
		if(user == target)
			if(target && !QDELETED(src))
				afterattack(target, user, 1, params)
		else
			var/resolved = target.attackby(src, user, params)
			if(!resolved && target && !QDELETED(src))
				afterattack(target, user, 1, params)

/obj/item/badmin_gauntlet/proc/AttackThing(mob/user, atom/target)
	. = FALSE
	if(istype(target, /obj/item/badmin_stone))
		. = TRUE
		if(!locked_on)
			to_chat(user, "<span class='notice'>You need to wear the gauntlet first.</span>")
			return TRUE
		var/obj/item/badmin_stone/IS = target
		if(!GetStone(IS.stone_type))
			user.visible_message("<span class='danger bold'>[user] drops the [IS] into the Badmin Gauntlet.</span>")
			if(IS.stone_type == SYNDIE_STONE)
				force = 27.5
			IS.forceMove(src)
			stones += IS
			var/datum/component/stationloving/stationloving = IS.GetComponent(/datum/component/stationloving)
			if(stationloving)
				stationloving.RemoveComponent()
			UpdateAbilities(user)
			update_icon()
			if(FullyAssembled() && !GLOB.gauntlet_snapped)
				user.visible_message("<span class='userdanger'>A massive surge of power begins to course through [user]. You feel as though your very existence is in danger!</span>",
					"<span class='danger bold'>The power from all the Badmin Stones begin to course through you!</span>")
				INVOKE_ASYNC(src, .proc/FullPowerSequence, user)
			return TRUE
	else if(istype(target, /obj/mecha))
		. = TRUE
		var/obj/mecha/mech = target
		mech.take_damage(17.5) // 17.5 extra damage against mechs, because this calls AFTER hitting something
	else if(istype(target, /obj/structure/safe))
		. = TRUE
		var/obj/structure/safe/S = target
		user.visible_message("<span class='danger'>[user] begins to pry open [S]!<span>", "<span class='notice'>We begin to pry open [S]...</span>")
		if(do_after(user, 35, target = S))
			user.visible_message("<span class='danger'>[user] pries open [S]!<span>", "<span class='notice'>We pry open [S]!</span>")
			S.tumbler_1_pos = S.tumbler_1_open
			S.tumbler_2_pos = S.tumbler_2_open
			S.open = TRUE
			S.update_icon()
			S.updateUsrDialog()
	else if(isclosedturf(target))
		var/turf/closed/T = target
		if(istype(get_area(T), /area/wizard_station))
			to_chat(user, "<span class='warning'>You know better than to violate the security of The Den, best wait until you leave to start smashing down walls.</span>")
			return FALSE
		if(istype(T, /turf/closed/indestructible))
			to_chat(user, "<span class='warning'>You can't seem to smash down \the [T]!</span>")
			return FALSE
		if(!GetStone(SYNDIE_STONE))
			. = TRUE
			user.visible_message("<span class='danger'>[user] begins to charge up a punch...</span>", "<span class='notice'>We begin to charge a punch...</span>")
			if(do_after(user, 15, target = T))
				playsound(T, 'sound/effects/bang.ogg', 50, 1)
				user.visible_message("<span class='danger'>[user] punches down [T]!</span>")
				T.ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
		else
			playsound(T, 'sound/effects/bang.ogg', 50, 1)
			user.visible_message("<span class='danger'>[user] punches down [T]!</span>")
			T.ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
	else if(istype(target, /obj/structure/closet))
		var/obj/structure/closet/C = target
		. = TRUE
		C.broken = TRUE
		C.locked = FALSE
		C.open()
		C.update_icon()
		playsound(C, 'sound/effects/bang.ogg', 50, 1)
		user.visible_message("<span class='danger'>[user] smashes open [C]!<span>")
	else if(istype(target, /obj/structure/table) || istype(target, /obj/structure/window) || istype(target, /obj/structure/grille))
		var/obj/structure/T = target
		if(istype(get_area(T), /area/wizard_station))
			to_chat(user, "<span class='warning'>You know better than to violate the security of The Den, best wait until you leave to start smashing down stuff.</span>")
			return FALSE
		. = TRUE
		playsound(T, 'sound/effects/bang.ogg', 50, 1)
		user.visible_message("<span class='danger'>[user] smashes [T]!<span>")
		T.take_damage(INFINITY)

/obj/item/badmin_gauntlet/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!locked_on)
		return ..()
	if(!isliving(user))
		return ..()
	var/obj/item/badmin_stone/IS = GetStone(stone_mode)
	if(!IS || !istype(IS))
		switch(user.a_intent)
			if(INTENT_DISARM)
				if(ishuman(target) && ishuman(user) && proximity_flag)
					martial_art.disarm_act(user, target)
			if(INTENT_HARM)
				if(ishuman(target) && ishuman(user) && proximity_flag)
					martial_art.harm_act(user, target)
				if(proximity_flag)
					AttackThing(user, target)
			if(INTENT_GRAB)
				if(ishuman(target) && ishuman(user) && proximity_flag)
					martial_art.grab_act(user, target)
			if(INTENT_HELP)
				if(ishuman(target) && ishuman(user) && proximity_flag)
					martial_art.help_act(user, target)
		return
	switch(user.a_intent)
		if(INTENT_DISARM)
			IS.DisarmEvent(target, user, proximity_flag)
		if(INTENT_HARM) // there's no harm intent on the stones anyways
			if(proximity_flag && !AttackThing(user, target))
				IS.HarmEvent(target, user, proximity_flag)
		if(INTENT_GRAB)
			IS.GrabEvent(target, user, proximity_flag)
		if(INTENT_HELP)
			IS.HelpEvent(target, user, proximity_flag)

/obj/item/badmin_gauntlet/proc/clash_with_gods(god)
	if(!istype(loc, /mob/living/carbon))
		return
	if(istype(god, /obj/singularity/narsie))
		send_to_playing_players("<span class='hierophant'><font size=5>Who are you, to intrude and threaten balance?</font></span>\n\
								<span class='narsie'><font size=5>Foolish mortal. You are NOTHING before me.</font></span>\n\
								<span class='hierophant'><font size=5>You should choose your words more wisely. You will be nothing before me.</font></span>")
		for(var/mob/M in GLOB.mob_list)
			if(!isnewplayer(M))
				flash_color(M, flash_color="#966400", flash_time=1)
				shake_camera(M, 4, 3)
		sound_to_playing_players('sound/magic/clockwork/narsie_attack.ogg')
		sound_to_playing_players('hippiestation/sound/effects/SNAP.ogg')
	else if(istype(god, /obj/structure/destructible/clockwork/massive/ratvar))
		send_to_playing_players("<span class='hierophant'><font size=5>Leave.</font></span>\n\
								<span class='heavy_brass'><font size=5>HERETIC. I SHALL BURN YOUR CORPSE IN THE FORGES FOR MANY MILLENIA.</font></span>\n\
								<span class='hierophant'><font size=5>Rot, machine.</font></span>")
		for(var/mob/M in GLOB.mob_list)
			if(!isnewplayer(M))
				flash_color(M, flash_color="#966400", flash_time=1)
				shake_camera(M, 4, 3)
		sound_to_playing_players('sound/magic/clockwork/ratvar_attack.ogg')
		sound_to_playing_players('hippiestation/sound/effects/SNAP.ogg')
	qdel(god)

/obj/item/badmin_gauntlet/attack_self(mob/living/user)
	if(!istype(user))
		return
	if(!locked_on)
		var/prompt = alert("Would you like to truly wear the Badmin Gauntlet? You will be unable to remove it!", "Confirm", "Yes", "No")
		if (prompt == "Yes")
			if(locked_on)
				return
			user.dropItemToGround(src)
			if(user.put_in_hands(src))
				locked_on = TRUE
				if(ishuman(user))
					var/mob/living/carbon/human/H = user
					H.set_species(/datum/species/ganymede)
					H.doUnEquip(H.wear_suit)
					H.doUnEquip(H.w_uniform)
					H.doUnEquip(H.head)
					H.doUnEquip(H.back)
					H.doUnEquip(H.shoes)
					var/obj/item/clothing/head/hippie/ganymedian/GH = new(get_turf(user))
					var/obj/item/clothing/suit/hippie/ganymedian/GS = new(get_turf(user))
					var/obj/item/clothing/under/hippie/ganymedian/GJ = new(get_turf(user))
					var/obj/item/clothing/shoes/ganymedian/Gs = new(get_turf(user))
					var/obj/item/tank/jetpack/ganypack/GP = new(get_turf(user))
					var/obj/item/teleportation_scroll/TS = new(get_turf(user))
					H.equip_to_appropriate_slot(GJ)
					H.equip_to_appropriate_slot(GH)
					H.equip_to_appropriate_slot(GS)
					H.equip_to_appropriate_slot(Gs)
					H.equip_to_appropriate_slot(TS)
					H.equip_to_slot(GP, SLOT_BACK)
				GLOB.gauntlet_equipped = TRUE
				for(var/obj/item/spellbook/SB in world)
					if(SB.owner == user)
						qdel(SB)
				user.apply_status_effect(/datum/status_effect/agent_pinpointer/gauntlet)
				if(!badmin)
					if(LAZYLEN(GLOB.wizardstart))
						user.forceMove(pick(GLOB.wizardstart))
					priority_announce("A Wizard has declared that he will wipe out half the universe with the Badmin Gauntlet!\n\
						Stones have been scattered across the station. Protect anyone who holds one!\n\
						We've allocated a large amount of resources to you, for protecting the Stones:\n\
						Cargo has been given $50k to spend\n\
						Science has been given 50k techpoints, and a large amount of minerals.\n\
						In addition, we've moved your Artifical Intelligence unit to your Bridge, and reinforced your telecommunications machinery.", title = "Declaration of War", sound = 'hippiestation/sound/misc/wizard_wardec.ogg')
					// give cargo/sci money
					var/datum/bank_account/cargo_moneys = SSeconomy.get_dep_account(ACCOUNT_CAR)
					var/datum/bank_account/sci_moneys = SSeconomy.get_dep_account(ACCOUNT_SCI)
					if(cargo_moneys)
						cargo_moneys.adjust_money(50000)
					if(sci_moneys)
						sci_moneys.adjust_money(50000)
						SSresearch.science_tech.add_point_type(TECHWEB_POINT_TYPE_DEFAULT, 50000)
					// give sci materials
					var/obj/structure/closet/supplypod/bluespacepod/sci_pod = new()
					sci_pod.explosionSize = list(0,0,0,0)
					var/list/materials_to_give_science = list(/obj/item/stack/sheet/metal,
						/obj/item/stack/sheet/plasteel,
						/obj/item/stack/sheet/mineral/diamond,
						/obj/item/stack/sheet/mineral/uranium,
						/obj/item/stack/sheet/mineral/titanium,
						/obj/item/stack/sheet/mineral/plasma,
						/obj/item/stack/sheet/mineral/gold,
						/obj/item/stack/sheet/mineral/silver,
						/obj/item/stack/sheet/glass,
						/obj/item/stack/ore/bluespace_crystal/artificial)
					for(var/mat in materials_to_give_science)
						var/obj/item/stack/sheet/S = new mat(sci_pod)
						S.amount = 50
						S.update_icon()
					var/list/sci_tiles = list()
					for(var/turf/T in get_area_turfs(/area/science/lab))
						if(!T.density)
							var/clear = TRUE
							for(var/obj/O in T)
								if(O.density)
									clear = FALSE
									break
							if(clear)
								sci_tiles += T
					if(LAZYLEN(sci_tiles))
						new /obj/effect/DPtarget(get_turf(pick(sci_tiles)), sci_pod)
					// make telecomms machinery invincible
					for(var/obj/machinery/telecomms/TC in world)
						if(istype(get_area(TC), /area/tcommsat))
							TC.resistance_flags |= INDESTRUCTIBLE
					for(var/obj/machinery/power/apc/APC in world)
						if(istype(get_area(APC), /area/tcommsat))
							APC.resistance_flags |= INDESTRUCTIBLE
					// move ai(s) to bridge
					var/list/bridge_tiles = list()
					for(var/turf/T in get_area_turfs(/area/bridge))
						if(!T.density)
							var/clear = TRUE
							for(var/obj/O in T)
								if(O.density)
									clear = FALSE
									break
							if(clear)
								bridge_tiles += T
					if(LAZYLEN(bridge_tiles))
						for(var/mob/living/silicon/ai/AI in GLOB.ai_list)
							var/obj/structure/closet/supplypod/bluespacepod/ai_pod = new
							AI.forceMove(ai_pod)
							AI.move_resist = MOVE_FORCE_NORMAL
							new /obj/effect/DPtarget(get_turf(pick(bridge_tiles)), ai_pod)
					GLOB.telescroll_time = world.time + 10 MINUTES
					addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, user, "<span class='notice bold'>You can now teleport to the station.</span>"), 10 MINUTES)
					addtimer(CALLBACK(src, .proc/_CallRevengers), 25 MINUTES)
					CONFIG_SET(number/shuttle_refuel_delay, max(CONFIG_GET(number/shuttle_refuel_delay), 30 MINUTES))
					to_chat(user, "<span class='notice bold'>You need to wait 10 minutes before teleporting to the station.</span>")
				to_chat(user, "<span class='notice bold'>You can click on the pinpointer at the top right to track a stone.</span>")
				to_chat(user, "<span class='notice bold'>Examine a stone/the gauntlet to see what each intent does.</span>")
				to_chat(user, "<span class='notice bold'>You can smash walls, tables, grilles, windows, and safes on HARM intent.</span>")
				to_chat(user, "<span class='notice bold'>Be warned -- you may be mocked if you kill innocents, that does not bring balance!</span>")
				visible_message("<span class='danger bold'>The badmin gauntlet clamps to [user]'s hand!</span>")
				user.mind.RemoveAllSpells()
				UpdateAbilities(user)
				OnEquip(user)
				if(!badmin)
					MakeStonekeepers(user)
			else
				to_chat(user, "<span class='danger'>You do not have an empty hand for the Badmin Gauntlet.</span>")
		return
	if(!LAZYLEN(stones))
		to_chat(user, "<span class='danger'>You have no stones yet.</span>")
		return
	var/list/gauntlet_radial = list()
	for(var/obj/item/badmin_stone/I in stones)
		var/image/IM = image(icon = I.icon, icon_state = I.icon_state)
		IM.color = I.color
		gauntlet_radial[I.stone_type] = IM
	if(!GetStone(SYNDIE_STONE))
		gauntlet_radial["none"] = image(icon = 'hippiestation/icons/obj/infinity.dmi', icon_state = "none")
	var/chosen = show_radial_menu(user, src, gauntlet_radial)
	if(chosen)
		if(chosen == "none")
			stone_mode = null
		else
			stone_mode = chosen
		UpdateAbilities(user)
		update_icon()

/obj/item/badmin_gauntlet/Topic(href, list/href_list)
	. = ..()
	if(href_list["cancel"])
		if(!check_rights(R_ADMIN) || ert_canceled) // no href exploits for you, karma!
			return
		message_admins("[key_name_admin(usr)] cancelled the automatic Revengers ERT.")
		log_admin_private("[key_name(usr)] cancelled the automatic Revengers ERT.")
		ert_canceled = TRUE

/obj/item/badmin_gauntlet/proc/_CallRevengers()
	if(GLOB.revengers_autocalled)
		return
	message_admins("Revengers ERT being auto-called in 15 seconds (<a href='?src=[REF(src)];cancel=1'>CANCEL</a>)")
	addtimer(CALLBACK(src, .proc/CallRevengers), 15 SECONDS)

/obj/item/badmin_gauntlet/proc/CallRevengers()
	if(ert_canceled)
		return
	message_admins("The Revengers ERT has been auto-called.")
	log_game("The Revengers ERT has been auto-called.")

	var/datum/ert/revengers/ertemplate = new
	var/list/mob/dead/observer/candidates = pollGhostCandidates("Do you wish to be an Revenger?", "deathsquad", null)
	var/teamSpawned = FALSE

	if(candidates.len > 0)
		//Pick the (un)lucky players
		var/numagents = min(ertemplate.teamsize,candidates.len)

		//Create team
		var/datum/team/ert/ert_team = new ertemplate.team
		if(ertemplate.rename_team)
			ert_team.name = ertemplate.rename_team

		//Asign team objective
		var/datum/objective/missionobj = new
		missionobj.team = ert_team
		missionobj.explanation_text = ertemplate.mission
		missionobj.completed = TRUE
		ert_team.objectives += missionobj
		ert_team.mission = missionobj

		var/list/spawnpoints = GLOB.emergencyresponseteamspawn
		while(numagents && candidates.len)
			if (numagents > spawnpoints.len)
				numagents--
				continue // This guy's unlucky, not enough spawn points, we skip him.
			var/spawnloc = spawnpoints[numagents]
			var/mob/dead/observer/chosen_candidate = pick(candidates)
			candidates -= chosen_candidate
			if(!chosen_candidate.key)
				continue

			//Spawn the body
			var/mob/living/carbon/human/ERTOperative = new ertemplate.mobtype(spawnloc)
			chosen_candidate.client.prefs.copy_to(ERTOperative)
			ERTOperative.key = chosen_candidate.key

			ERTOperative.set_species(/datum/species/human)

			//Give antag datum
			var/datum/antagonist/ert/ert_antag

			if(numagents == 1)
				ert_antag = new ertemplate.leader_role
			else
				ert_antag = ertemplate.roles[WRAP(numagents,1,length(ertemplate.roles) + 1)]
				ert_antag = new ert_antag

			ERTOperative.mind.add_antag_datum(ert_antag,ert_team)
			ERTOperative.mind.assigned_role = ert_antag.name

			//Logging and cleanup
			log_game("[key_name(ERTOperative)] has been selected as an [ert_antag.name]")
			numagents--
			teamSpawned++

		if (teamSpawned)
			message_admins("Revengers ERT has auto-spawned with the mission: [ertemplate.mission]")
			GLOB.revengers_autocalled = TRUE

		//Open the Armory doors
		if(ertemplate.opendoors)
			for(var/obj/machinery/door/poddoor/ert/door in GLOB.airlocks)
				door.open()
				CHECK_TICK

/obj/item/badmin_gauntlet/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/badmin_stone))
		if(!locked_on)
			to_chat(user, "<span class='notice'>You need to wear the gauntlet first.</span>")
			return
		var/obj/item/badmin_stone/IS = I
		if(!GetStone(IS.stone_type))
			user.visible_message("<span class='danger bold'>[user] drops the [IS] into the Badmin Gauntlet.</span>")
			if(IS.stone_type == SYNDIE_STONE)
				force = 27.5
			IS.forceMove(src)
			stones += IS
			var/datum/component/stationloving/stationloving = IS.GetComponent(/datum/component/stationloving)
			if(stationloving)
				stationloving.RemoveComponent()
			UpdateAbilities(user)
			update_icon()
			if(FullyAssembled() && !GLOB.gauntlet_snapped)
				user.visible_message("<span class='userdanger'>A massive surge of power begins to course through [user], stunning them in place!</span>",
					"<span class='danger bold'>The power from all the Badmin Stones begin to course through you!</span>")
				INVOKE_ASYNC(src, .proc/FullPowerSequence, user)
			return
	return ..()

/obj/item/badmin_gauntlet/proc/FullPowerSequence(mob/living/thanos)
	thanos.emote("scream")
	hnnnnnnnnngh = TRUE
	if(do_after_mob(thanos, src, 5 SECONDS, TRUE))
		hnnnnnnnnngh = FALSE
		if(thanos.stat == DEAD)
			to_chat(thanos, "<span class='big danger'>You died while absorbing the power of the Badmin Stones. Too bad!</span>")
			return
		if(thanos.InCritical())
			DoTheSnap(thanos)
			return
		thanos.AddSpell(new /obj/effect/proc_holder/spell/self/infinity/snap)
	else
		hnnnnnnnnngh = FALSE

/////////////////////////////////////////////
/////////////////// SPELLS //////////////////
/////////////////////////////////////////////
//Weaker versions of Syndie Stone spells

/obj/effect/proc_holder/spell/self/infinity/shockwave
	name = "Badmin Gauntlet: Shockwave"
	desc = "Stomp down and send out a slow-moving shockwave that is capable of knocking people down."
	charge_max = 250
	clothes_req = FALSE
	human_req = FALSE
	staff_req = FALSE
	action_background_icon_state = "bg_default"
	action_icon_state = "stomp"
	range = 5
	sound = 'sound/effects/bang.ogg'

/obj/effect/proc_holder/spell/self/infinity/shockwave/cast(list/targets, mob/user)
	user.visible_message("<span class='danger'>[user] stomps down!</span>")
	INVOKE_ASYNC(src, .proc/shockwave, user, get_turf(user))

/obj/effect/proc_holder/spell/self/infinity/shockwave/proc/shockwave(mob/user, turf/center)
	for(var/i = 1 to range)
		var/to_hit = range(center, i) - range(center, i-1)
		for(var/turf/T in to_hit)
			new /obj/effect/temp_visual/gravpush(T)
		for(var/mob/living/L in to_hit)
			if(L == user)
				continue
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(istype(H.shoes, /obj/item/clothing/shoes/magboots))
					var/obj/item/clothing/shoes/magboots/M = H.shoes
					if(M.magpulse)
						to_chat(L, "<span class='notice'>You stay upright due to your stable footing!</span>")
						continue
				if(istype(H.shoes, /obj/item/clothing/shoes/combat/swat) || istype(H.shoes, /obj/item/clothing/shoes/combat/coldres/nanojump))
					to_chat(L, "<span class='notice'>You stay upright due to your stable footing!</span>")
					continue
			L.visible_message("<span class='danger'>[L] is knocked down by a shockwave!</span>", "<span class='danger bold'>A shockwave knocks you off your feet!</span>")
			L.Paralyze(35)
		sleep(1)

/obj/effect/proc_holder/spell/self/infinity/armor
	name = "Badmin Gauntlet: Tank Armor"
	desc = "Change your defense focus -- tank melee, tank ballistics, or tank energy."
	charge_max = 30 SECONDS
	clothes_req = FALSE
	human_req = FALSE
	staff_req = FALSE
	action_icon = 'icons/effects/effects.dmi'
	action_icon_state = "shield1"
	action_background_icon_state = "bg_default"
	var/last_mode

/obj/effect/proc_holder/spell/self/infinity/armor/proc/add_to_phys(mob/living/carbon/human/H, amt, typ)
	switch(typ)
		if("Ballistics")
			H.physiology.armor.bullet += amt
		if("Energy")
			H.physiology.armor.energy += amt
			H.physiology.armor.laser += amt
		if("Melee")
			H.physiology.armor.melee += amt

/obj/effect/proc_holder/spell/self/infinity/armor/cast(list/targets, mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/list/radial = list()
	radial["Ballistics"] = image(icon = 'hippiestation/icons/obj/guns/projectile.dmi', icon_state = "cshotgun")
	radial["Energy"] = image(icon = 'hippiestation/icons/obj/guns/energy.dmi', icon_state = "retro")
	radial["Melee"] = image(icon = 'icons/obj/items_and_weapons.dmi', icon_state = "fireaxe1")
	var/chosen = show_radial_menu(H, H, radial)
	if(chosen)
		if(last_mode)
			add_to_phys(H, -20, last_mode)
		add_to_phys(H, 20, chosen)
		to_chat(H, "<span class='notice'>[last_mode ? "You switch your resistance focus from [lowertext(last_mode)] to" : "You are now more resistant to"] [lowertext(chosen)] attacks.</span>")
		last_mode = chosen

/obj/effect/proc_holder/spell/self/infinity/regenerate
	name = "Badmin Gauntlet: Regenerate"
	desc = "Regenerate 3 health per second. Requires you to stand still."
	action_icon_state = "regenerate"
	action_background_icon_state = "bg_default"
	stat_allowed = TRUE
	var/default_regen = 3


/obj/effect/proc_holder/spell/self/infinity/regenerate/cast(list/targets, mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.on_fire)
			to_chat(L, "<span class='notice'>The fire interferes with your regeneration!</span>")
			revert_cast(L)
			return
		if(L.stat == DEAD)
			to_chat(L, "<span class='notice'>You can't regenerate out of death.</span>")
			revert_cast(L)
			return
		while(do_after_oiim(L, 10, L))
			L.visible_message("<span class='notice'>[L]'s wounds heal!</span>")
			var/healing_amt = default_regen
			if(isspaceturf(get_turf(user)))
				to_chat(L, "<span class='notice italics'>Your healing is reduced due to the fact you're in space!</span>")
				healing_amt = default_regen * 0.5
			L.heal_overall_damage(healing_amt, healing_amt, healing_amt, null, TRUE)
			L.adjustToxLoss(-healing_amt)
			L.adjustOxyLoss(-healing_amt)
			if(L.getBruteLoss() + L.getFireLoss() + L.getStaminaLoss() < 1)
				to_chat(user, "<span class='notice'>You are fully healed.</span>")
				return

/obj/effect/proc_holder/spell/self/infinity/gauntlet_bullcharge
	name = "Badmin Gauntlet: Bull Charge"
	desc = "Imbue yourself with power, and charge forward, smashing through anyone in your way!"
	action_background_icon_state = "bg_default"
	action_icon_state = "charge"
	charge_max = 250
	sound = 'sound/magic/repulse.ogg'

/obj/effect/proc_holder/spell/self/infinity/gauntlet_bullcharge/cast(list/targets, mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.mario_star = TRUE
		C.super_mario_star = FALSE
		ADD_TRAIT(user, TRAIT_IGNORESLOWDOWN, YEET_TRAIT)
		user.visible_message("<span class='danger'>[user] charges!</span>")
		addtimer(CALLBACK(src, .proc/done, C), 50)

/obj/effect/proc_holder/spell/self/infinity/gauntlet_bullcharge/proc/done(mob/living/carbon/user)
	user.mario_star = FALSE
	user.super_mario_star = FALSE
	REMOVE_TRAIT(user, TRAIT_IGNORESLOWDOWN, YEET_TRAIT)
	user.visible_message("<span class='danger'>[user] relaxes...</span>")

/obj/effect/proc_holder/spell/self/infinity/gauntlet_jump
	name = "Badmin Gauntlet: Super Jump"
	desc = "With a bit of startup time, leap across the station to wherever you'd like!"
	action_background_icon_state = "bg_default"
	action_icon_state = "jump"
	charge_max = 300

/obj/effect/proc_holder/spell/self/infinity/gauntlet_jump/revert_cast(mob/user)
	. = ..()
	user.opacity = initial(user.opacity)
	user.mouse_opacity = initial(user.mouse_opacity)
	user.pixel_y = 0
	user.alpha = 255

// i really hope this never runtimes
/obj/effect/proc_holder/spell/self/infinity/gauntlet_jump/cast(list/targets, mob/user)
	if(istype(get_area(user), /area/wizard_station))
		to_chat(user, "<span class='warning'>You can't jump here!</span>")
		revert_cast(user)
		return
	INVOKE_ASYNC(src, .proc/do_jaunt, user)

/obj/effect/proc_holder/spell/self/infinity/gauntlet_jump/proc/do_jaunt(mob/living/target)
	target.notransform = TRUE
	var/turf/mobloc = get_turf(target)
	var/obj/effect/dummy/phased_mob/spell_jaunt/infinity/holder = new(mobloc)

	var/mob/living/passenger
	if(isliving(target.pulling) && target.grab_state >= GRAB_AGGRESSIVE)
		passenger = target.pulling
		holder.passenger = passenger

	target.visible_message("<span class='danger bold'>[target] LEAPS[passenger ? ", bringing [passenger] up with them" : ""]!</span>")
	target.opacity = FALSE
	target.mouse_opacity = FALSE
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		C.super_leaping = TRUE
	if(passenger)
		passenger.opacity = FALSE
		passenger.mouse_opacity = FALSE
		animate(passenger, pixel_y = 128, alpha = 0, time = 4.5, easing = LINEAR_EASING)
	animate(target, pixel_y = 128, alpha = 0, time = 4.5, easing = LINEAR_EASING)
	sleep(4.5)

	if(passenger)
		passenger.forceMove(holder)
		passenger.reset_perspective(holder)
		passenger.notransform = FALSE
	target.forceMove(holder)
	target.reset_perspective(holder)
	target.notransform = FALSE //mob is safely inside holder now, no need for protection.

	sleep(7.5 SECONDS)

	if(target.loc != holder && (passenger && passenger.loc != holder)) //mob warped out of the warp
		qdel(holder)
		return
	mobloc = get_turf(target.loc)
	target.mobility_flags &= ~MOBILITY_MOVE
	if(passenger)
		passenger.mobility_flags &= ~MOBILITY_MOVE
	holder.reappearing = TRUE

	if(passenger)
		passenger.forceMove(mobloc)
		passenger.Paralyze(50)
		passenger.take_overall_damage(17.5)
	playsound(target, 'sound/effects/bang.ogg', 50, 1)
	target.forceMove(mobloc)
	target.visible_message("<span class='danger bold'>[target] slams down from above[passenger ? ", slamming [passenger] down to the floor" : ""]!</span>")

	target.setDir(holder.dir)
	animate(target, pixel_y = 0, alpha = 255, time = 4.5, easing = LINEAR_EASING)
	if(passenger)
		passenger.setDir(holder.dir)
		animate(passenger, pixel_y = 0, alpha = 255, time = 4.5, easing = LINEAR_EASING)
	sleep(4.5)
	target.opacity = initial(target.opacity)
	target.mouse_opacity = initial(target.mouse_opacity)
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		C.super_leaping = FALSE
	if(passenger)
		passenger.opacity = initial(passenger.opacity)
		passenger.mouse_opacity = initial(passenger.mouse_opacity)
	qdel(holder)
	if(!QDELETED(target))
		if(mobloc.density)
			for(var/direction in GLOB.alldirs)
				var/turf/T = get_step(mobloc, direction)
				if(T)
					if(target.Move(T))
						break
		target.mobility_flags |= MOBILITY_MOVE
	if(!QDELETED(passenger))
		passenger.mobility_flags |= MOBILITY_MOVE

/obj/effect/dummy/phased_mob/spell_jaunt/infinity
	name = "shadow"
	icon = 'hippiestation/icons/obj/infinity.dmi'
	icon_state = "shadow"
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	invisibility = 0
	var/mob/living/passenger

/obj/effect/dummy/phased_mob/spell_jaunt/infinity/relaymove(var/mob/user, direction)
	if ((movedelay > world.time) || reappearing || !direction)
		return
	var/turf/newLoc = get_step(src,direction)
	setDir(direction)

	movedelay = world.time + movespeed

	if(newLoc.flags_1 & NOJAUNT_1)
		to_chat(user, "<span class='warning'>Some strange aura is blocking the way.</span>")
		return

	forceMove(newLoc)

/obj/effect/dummy/phased_mob/spell_jaunt/infinity/relaymove(mob/user, direction)
	if(user == passenger)
		return
	return ..()

/obj/effect/proc_holder/spell/self/infinity/snap
	name = "SNAP"
	desc = "Snap the Badmin Gauntlet, erasing half the life in the universe."
	action_icon_state = "gauntlet"
	stat_allowed = TRUE

/obj/effect/proc_holder/spell/self/infinity/snap/cast(list/targets, mob/living/user)
	var/obj/item/badmin_gauntlet/IG = locate() in user
	if(!IG || !istype(IG))
		return
	var/prompt = alert("Are you REALLY sure you'd like to erase half of all life in the universe?", "SNAP?", "YES!", "No")
	if(prompt == "YES!" && !QDELETED(src))
		IG.spells -= src
		IG.DoTheSnap(user)
		user.RemoveSpell(src)

/////////////////////////////////////////////
/////////////////// OTHER ///////////////////
/////////////////////////////////////////////

/obj/screen/alert/status_effect/agent_pinpointer/gauntlet
	name = "Badmin Stone Pinpointer"

/obj/screen/alert/status_effect/agent_pinpointer/gauntlet/Click()
	var/mob/living/L = usr
	if(!L || !istype(L))
		return
	var/datum/status_effect/agent_pinpointer/gauntlet/G = attached_effect
	if(G && istype(G))
		var/prompt = input(L, "Choose the Badmin Stone to track.", "Track Stone") as null|anything in GLOB.badmin_stones
		if(prompt)
			G.stone_target = prompt
			G.scan_for_target()
			G.point_to_target()

/datum/status_effect/agent_pinpointer/gauntlet
	id = "badmin_stone_pinpointer"
	minimum_range = 1
	range_fuzz_factor = 0
	tick_interval = 10
	alert_type = /obj/screen/alert/status_effect/agent_pinpointer/gauntlet
	var/stone_target = SYNDIE_STONE

/datum/status_effect/agent_pinpointer/gauntlet/scan_for_target()
	scan_target = null
	for(var/obj/item/badmin_stone/IS in world)
		if(IS.stone_type == stone_target)
			scan_target = IS
			return

/datum/objective/snap
	name = "snap"
	explanation_text = "Bring balance to the universe, by snapping out half the life with the Badmin Gauntlet"

/datum/objective/snap/check_completion()
	return GLOB.gauntlet_snapped



/obj/item/badmin_gauntlet/for_badmins
	badmin = TRUE

/obj/item/badmin_gauntlet/for_badmins/assembled/Initialize()
	. = ..()
	for(var/stone in subtypesof(/obj/item/badmin_stone))
		var/obj/item/badmin_stone/BS = new stone(src)
		stones += BS
		var/datum/component/stationloving/stationloving = BS.GetComponent(/datum/component/stationloving)
		if(stationloving)
			stationloving.RemoveComponent()
	spells += new /obj/effect/proc_holder/spell/self/infinity/snap
	update_icon()

// cool misc effects

/obj/structure/destructible/clockwork/massive/ratvar/process()
	for(var/obj/item/badmin_gauntlet/BG in world)
		if(iscarbon(BG.loc) && BG.FullyAssembled())
			BG.clash_with_gods(src)
			return
	return ..()

/obj/singularity/narsie/process()
	for(var/obj/item/badmin_gauntlet/BG in world)
		if(iscarbon(BG.loc) && BG.FullyAssembled())
			BG.clash_with_gods(src)
			return
	return ..()


//////////
// crap //
//////////

// only interrupt if move
/proc/do_after_oiim(mob/user, var/delay, atom/target = null, progress = 1)
	if(!user)
		return 0
	var/atom/Tloc = null
	if(target && !isturf(target))
		Tloc = target.loc
	var/atom/Uloc = user.loc
	var/drifting = 0
	if(!user.Process_Spacemove(0) && user.inertia_dir)
		drifting = 1
	delay *= user.do_after_coefficent()
	var/datum/progressbar/progbar
	if (progress)
		progbar = new(user, delay, target)
	var/endtime = world.time + delay
	var/starttime = world.time
	. = 1
	while (world.time < endtime)
		stoplag(1)
		if (progress)
			progbar.update(world.time - starttime)
		if(drifting && !user.inertia_dir)
			drifting = 0
			Uloc = user.loc
		if(QDELETED(user) || user.stat == DEAD || (!drifting && user.loc != Uloc))
			. = 0
			break
		if(!QDELETED(Tloc) && (QDELETED(target) || Tloc != target.loc))
			if((Uloc != Tloc || Tloc != user) && !drifting)
				. = 0
				break
	if (progress)
		qdel(progbar)


#if DM_VERSION > 512
/obj/effect/snap_rt
	icon = 'hippiestation/icons/effects/filters.dmi'
	icon_state = "nothing"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/snap_rt/New(L, id)
	loc = L
	icon_state = "snap3"
	render_target = "*snap[id]"
#endif
