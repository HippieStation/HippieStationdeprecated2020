//Originally coded for HippieStation by Steamp0rt, shared under the AGPL license.

/obj/item/badmin_stone/ghost
	name = "Ghost Stone"
	desc = "Salts your food very well."
	color = "#e429f2"
	ability_text = list("HELP INTENT: Transmutate ghosts into a random simplemob.", 
		"DISARM INTENT: Fire a bolt that scales based on how many ghosts orbit you.")
	stone_type = GHOST_STONE
	spell_types = list(/obj/effect/proc_holder/spell/targeted/infinity/cluwne_rise_up,
		/obj/effect/proc_holder/spell/self/infinity/scrying_orb,
		/obj/effect/proc_holder/spell/self/infinity/fortress,
		/obj/effect/proc_holder/spell/targeted/conjure_item/spellpacket/sandmans_dust)
	gauntlet_spell_types = list(/obj/effect/proc_holder/spell/self/infinity/soulscreech,
		/obj/effect/proc_holder/spell/targeted/infinity/chariot)
	var/summon_cooldown = 0
	var/next_pull = 0
	var/list/mob/dead/observer/spirits = list()

/obj/item/badmin_stone/ghost/HelpEvent(atom/target, mob/living/user, proximity_flag)
	if(!isobserver(target))
		to_chat(user, "<span class='notice'>You can only transmutate ghosts!</span>")
		return
	var/mob/dead/observer/O = target
	var/simplemob = pick(/mob/living/simple_animal/hostile/carp,
		/mob/living/simple_animal/hostile/bear,
		/mob/living/simple_animal/hostile/mushroom,
		/mob/living/simple_animal/hostile/retaliate/bat,
		/mob/living/simple_animal/hostile/retaliate/goat,
		/mob/living/simple_animal/parrot,
		/mob/living/simple_animal/pet/dog/corgi,
		/mob/living/simple_animal/crab,
		/mob/living/simple_animal/pet/dog/pug,
		/mob/living/simple_animal/pet/cat,
		/mob/living/simple_animal/mouse,
		/mob/living/simple_animal/chicken,
		/mob/living/simple_animal/cow,
		/mob/living/simple_animal/hostile/lizard,
		/mob/living/simple_animal/pet/fox,
		/mob/living/simple_animal/butterfly,
		/mob/living/simple_animal/pet/cat/cak,
		/mob/living/simple_animal/chick)
	var/mob/living/simple_animal/SA = new simplemob(get_turf(O))
	O.visible_message("<span class='danger'>The ghost of [O] turns into [SA]!</span>")
	SA.ckey = O.ckey
	to_chat(SA, "<span class='userdanger'>[user] is your master. Protect them at all costs.</span>")
	SA.add_memory("<b>[user] is your master. Protect them at all costs</b>")
	qdel(O)


/obj/item/badmin_stone/ghost/DisarmEvent(atom/target, mob/living/user, proximity_flag)
	FireProjectile(/obj/item/projectile/spirit_fist, target, clamp(ghost_check() * 5, 3, 35))
	user.changeNext_move(CLICK_CD_RANGE)

/obj/item/badmin_stone/ghost/GiveAbilities(mob/living/L, gauntlet = FALSE)
	. = ..()
	ADD_TRAIT(L, TRAIT_SIXTHSENSE, GHOST_STONE_TRAIT)
	ADD_TRAIT(L, TRAIT_XRAY_VISION, GHOST_STONE_TRAIT)
	L.see_invisible = SEE_INVISIBLE_OBSERVER
	L.update_sight()

/obj/item/badmin_stone/ghost/RemoveAbilities(mob/living/L, gauntlet = FALSE)
	. = ..()
	REMOVE_TRAIT(L, TRAIT_SIXTHSENSE, GHOST_STONE_TRAIT)
	REMOVE_TRAIT(L, TRAIT_XRAY_VISION, GHOST_STONE_TRAIT)
	L.see_invisible = initial(L.see_invisible)
	L.update_sight()

/obj/item/badmin_stone/ghost/attack_self(mob/user)
	if(summon_cooldown > world.time)
		to_chat(user, "You just recently called out for aid. You don't want to annoy the spirits.")
		return
	to_chat(user, "You call out for aid, attempting to summon spirits to your side.")
	notify_ghosts("[user] is clenching [user.p_their()] [src], calling for your help!",
		enter_link="<a href=?src=[REF(src)];orbit=1>(Click to help)</a>",
		source = user, action=NOTIFY_ORBIT, ignore_key = POLL_IGNORE_SPECTRAL_BLADE)
	summon_cooldown = world.time + 60 SECONDS

/obj/item/badmin_stone/ghost/proc/recursive_orbit_collect(atom/A, list/L)
	for(var/i in A.orbiters?.orbiters)
		if(!isobserver(i) || (i in L))
			continue
		L |= i
		recursive_orbit_collect(i, L)

/obj/item/badmin_stone/ghost/proc/ghost_check()
	var/list/mob/dead/observer/current_spirits = list()
	
	recursive_orbit_collect(src, current_spirits)
	recursive_orbit_collect(loc, current_spirits)
	var/mob/living/L = recursive_loc_check(src, /mob/living)
	if(L)
		recursive_orbit_collect(L, current_spirits)
	
	for(var/i in spirits - current_spirits)
		var/mob/dead/observer/G = i
		G.invisibility = GLOB.observer_default_invisibility

	for(var/i in current_spirits)
		var/mob/dead/observer/G = i
		G.invisibility = 0
	
	spirits = current_spirits
	return length(spirits)

/obj/item/badmin_stone/ghost/process()
	..()
	ghost_check()

/////////////////////////////////////////////
/////////////////// SPELLS //////////////////
/////////////////////////////////////////////

/obj/effect/proc_holder/spell/targeted/infinity/chariot
	name = "Ghost Stone: The Chariot"
	desc = "Open up an unconscious soul to ghosts, ripe for the stealing! They are not loyal to you, however."
	action_icon_state = "chariot"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "ghost"
	charge_max = 200

/obj/effect/proc_holder/spell/targeted/infinity/chariot/InterceptClickOn(mob/living/caller, params, atom/t)
	. = ..()
	if(!.)
		revert_cast()
		return FALSE
	if(!caller.Adjacent(t))
		to_chat(caller, "<span class='notice'>You need to be next to the target!</span>")
		revert_cast()
		return FALSE
	if(!isliving(t))
		to_chat(caller, "<span class='notice'>That doesn't even have a soul.</span>")
		revert_cast()
		return FALSE
	var/mob/living/L = t
	if(L.stat == DEAD)
		to_chat(caller, "<span class='notice'>That's dead, stupid.</span>")
		revert_cast()
		return FALSE
	if(L.stat != UNCONSCIOUS)
		to_chat(caller, "<span class='notice'>That's not unconscious.</span>")
		revert_cast()
		return FALSE
	if(locate(/obj/item/badmin_stone) in L.GetAllContents())
		to_chat(caller, "<span class='notice'>Something stops you from using The Chariot on that...</span>")
		revert_cast()
		return FALSE
	log_game("[L] was kicked out of their body by The Chariot (user: [caller])")
	to_chat(L, "<span class='danger bold'>You feel your very soul detach from your body...</span>")
	to_chat(user, "<span class='notice bold'>You weave [L]'s soul in a way that it's open for the spirits to take...</span>")
	offer_control(L, FALSE)
	Finished()
	return TRUE

/obj/effect/forcefield/heaven
	name = "heaven's wall"
	desc = "You'd need a powerful bluespace artifact to get through."
	var/mob/summoner

/obj/effect/forcefield/heaven/Initialize(mapload, mob/user)
	. = ..()
	summoner = user
	QDEL_IN(src, 450)

/obj/effect/forcefield/heaven/CanPass(atom/movable/mover, turf/target)
	if(mover == summoner)
		return TRUE
	if(locate(/obj/item/badmin_stone/bluespace) in mover)
		return TRUE
	return FALSE

/obj/effect/proc_holder/spell/self/infinity/fortress
	name = "Ghost Stone: Heaven's Fortress"
	desc = "Summon a massive fortress to keep people in, and keep them out."
	action_icon_state = "fortress"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "ghost"
	charge_max = 1200

/obj/effect/proc_holder/spell/self/infinity/fortress/cast(list/targets, mob/user)
	var/fortress = range(5, user) - range(4, user)
	user.visible_message("<span class='danger bold'>[user] summons Heaven's Fortress!</span>")
	for(var/turf/T in fortress)
		new /obj/effect/forcefield/heaven(get_turf(T), user)

/obj/effect/proc_holder/spell/self/infinity/soulscreech
	name = "Ghost Stone: Soulscreech"
	desc = "A loud screech that interacts with people's souls in varying ways."
	action_icon_state = "reeeeee"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "ghost"
	charge_max = 900
	sound = 'hippiestation/sound/effects/horror_scream.ogg'

/obj/effect/proc_holder/spell/self/infinity/soulscreech/cast(list/targets, mob/user)
	. = ..()
	user.visible_message("<span class='danger bold'>[user] lets out a horrifying screech!</span>")
	for(var/mob/living/L in get_hearers_in_view(6, user))
		if(L == user)
			continue
		var/list/effects = list(1, 2, 3)
		var/list/ni_effects = list(4, 5, 6)
		if(!(locate(/obj/item/badmin_stone) in L.GetAllContents()) && !(L.mind && L.mind.has_antag_datum(/datum/antagonist/ert/revenger)))
			effects += ni_effects
		var/effect = pick(effects)
		switch(effect)
			if(1)
				to_chat(L, "<span class='danger'>You feel horrid...</span>")
				L.adjustOxyLoss(30)
				L.cultslurring += 300
				L.Dizzy(300)
			if(2)
				L.throw_at(get_edge_target_turf(L, get_dir(user, L)), 7, 5)
			if(3)
				var/turf/potential_T = find_safe_turf(extended_safety_checks = TRUE)
				if(potential_T)
					do_teleport(L, potential_T, channel = TELEPORT_CHANNEL_BLUESPACE)
			if(4)
				to_chat(L, "<span class='danger'>You feel sick...</span>")
				L.ForceContractDisease(new /datum/disease/vampire)
			if(5)
				L.Stun(40)
				L.petrify(3 MINUTES)
			if(6)
				L.Unconscious(100)

/obj/effect/proc_holder/spell/self/infinity/scrying_orb
	name = "Ghost Stone: Scrying Detachment"
	desc = "Detach your soul from your body, going into the realm of the ghosts."
	action_icon_state = "scrying"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "ghost"

/obj/effect/proc_holder/spell/self/infinity/scrying_orb/cast(list/targets, mob/user)
	. = ..()
	user.visible_message("<span class='notice'>[user] stares into the Ghost Stone, and the Ghost Stone stares back.</span>")
	user.ghostize(TRUE)

/obj/effect/proc_holder/spell/targeted/infinity/cluwne_rise_up
	name = "Ghost Stone: Cluwne Rise"
	desc = "Rise a corpse as a subservient, magical cluwne. You may only have 1 magical cluwne alive."
	action_icon_state = "cluwnerise"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "ghost"
	charge_max = 900
	var/list/cluwnes = list() // one cluwne per user

/obj/effect/proc_holder/spell/targeted/infinity/cluwne_rise_up/InterceptClickOn(mob/living/caller, params, atom/t)
	. = ..()
	if(!.)
		return FALSE
	if(ishuman(t))
		var/mob/living/carbon/human/cluwne = cluwnes[caller]
		if(istype(cluwne) && cluwne && cluwne.stat != DEAD && !cluwne.InFullCritical())
			to_chat(caller, "<span class='danger'>You still have a magical cluwne alive.</span>")
			return FALSE
		var/mob/living/carbon/human/H = t
		if(H.stat != DEAD && !H.InFullCritical())
			to_chat(caller, "<span class='danger'>They aren't dead enough yet.</span>")
			revert_cast()
			return
		H.revive(TRUE, TRUE)
		H.grab_ghost()
		H.cluwneify()
		cluwnes[caller] = H
		if(H.mind)
			H.mind.enslave_mind_to_creator(caller)
		H.add_memory("<b>[caller] is your master. Follow their orders at all costs.</b>")
		H.bloodcrawl = BLOODCRAWL_EAT
		H.bloodcrawl_allow_items = TRUE
		H.AddSpell(new /obj/effect/proc_holder/spell/targeted/turf_teleport/blink/infinity_cluwne)
		H.AddSpell(new /obj/effect/proc_holder/spell/targeted/ethereal_jaunt/shift/infinity_cluwne)
		H.AddSpell(new /obj/effect/proc_holder/spell/bloodcrawl)
		if(locate(/obj/item/badmin_gauntlet) in caller)
			H.add_atom_colour("#FFDF00", FIXED_COLOUR_PRIORITY)
		else
			H.add_atom_colour("#e429f2", FIXED_COLOUR_PRIORITY)
		H.update_atom_colour()
		var/obj/item/kitchen/knife/butcher/BK = new(get_turf(H))
		ADD_TRAIT(BK, TRAIT_NODROP, "ghost_stone_cluwne")
		BK.name = "cluwne's cursed knife"
		H.put_in_hands(BK, TRUE)
		H.visible_message("<span class='danger'>[H] struggles back up, now a cluwne!</span>")
		to_chat(H, "<span class='userdanger'>You are risen from the dead as a cluwne. [caller] is your master. Follow their orders at all costs.</span>")
		Finished()
	else
		revert_cast()

/obj/effect/proc_holder/spell/targeted/conjure_item/spellpacket/sandmans_dust
	name = "Ghost Stone: Sandman's Dust"
	desc = "Gives you dust capable of knocking out most people."
	action_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_icon_state = "sandman"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "ghost"
	invocation = "POCKET SAND"
	invocation_type = "shout"
	charge_max = 200
	item_type = /obj/item/spellpacket/sandman
	clothes_req = FALSE
	human_req = FALSE
	staff_req = FALSE
	antimagic_allowed = TRUE
	sound = 'hippiestation/sound/effects/pocketsand.ogg'

/obj/effect/proc_holder/spell/targeted/turf_teleport/blink/infinity_cluwne
	name = "Cluwne Blink"
	clothes_req = FALSE
	human_req = FALSE
	staff_req = FALSE

/obj/effect/proc_holder/spell/targeted/ethereal_jaunt/shift/infinity_cluwne // un-stuns you so you can move
	name = "Cluwne Jaunt"
	clothes_req = FALSE
	human_req = FALSE
	staff_req = FALSE
	jaunt_duration = 100

/////////////////////////////////////////////
///////////////// OTHER CRAP ////////////////
/////////////////////////////////////////////

/obj/item/spellpacket/sandman
	name = "\improper Sandman's dust"
	desc = "Some weird sand wrapped in cloth."
	icon = 'icons/obj/toy.dmi'
	icon_state = "snappop"
	w_class = WEIGHT_CLASS_TINY

/obj/item/spellpacket/sandman/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!..())
		if(isliving(hit_atom))
			var/mob/living/M = hit_atom
			if(locate(/obj/item/badmin_gauntlet) in M)
				to_chat("<span class='danger'>[src] hits you, and you feel dizzy...</span>")
				M.set_dizziness(75)
				for(var/obj/effect/proc_holder/spell/S in M.mob_spell_list)
					S.charge_counter = 0
					S.start_recharge()
					S.action.UpdateButtonIcon()
			else
				to_chat("<span class='danger'>You're knocked out cold by [src]!</span>")
				M.Unconscious(600)
		qdel(src)

/obj/item/projectile/spirit_fist
	name = "spiritual fist"
	icon_state = "bounty" // kind of looks like a hand
	damage = 3
	damage_type = BRUTE
	nodamage = FALSE
