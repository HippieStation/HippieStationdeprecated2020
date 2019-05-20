/obj/item/infinity_stone/syndie
	name = "Syndie Stone"
	desc = "Power, baby. Raw power."
	color = "#ff0130"
	force = 30
	stone_type = SYNDIE_STONE
	ability_text = list("ALL INTENTS: PLACEHOLDER MARTIAL ART")
	spell_types = list(/obj/effect/proc_holder/spell/self/infinity/regenerate,
		/obj/effect/proc_holder/spell/self/infinity/syndie_bullcharge)
	gauntlet_spell_types = list(/obj/effect/proc_holder/spell/self/infinity/syndie_jump,
		/obj/effect/proc_holder/spell/aoe_turf/repulse/syndie_stone)
	var/datum/martial_art/cqc/martial_art

/obj/item/infinity_stone/syndie/Initialize()
	. = ..()
	martial_art = new

/obj/item/infinity_stone/syndie/HelpEvent(atom/target, mob/living/user, proximity_flag)
	if(ishuman(user) && ishuman(target))
		martial_art.help_act(user, target)

/obj/item/infinity_stone/syndie/DisarmEvent(atom/target, mob/living/user, proximity_flag)
	if(ishuman(user) && ishuman(target))
		martial_art.disarm_act(user, target)

/obj/item/infinity_stone/syndie/HarmEvent(atom/target, mob/living/user, proximity_flag)
	if(ishuman(user) && ishuman(target))
		martial_art.harm_act(user, target)

/obj/item/infinity_stone/syndie/GrabEvent(atom/target, mob/living/user, proximity_flag)
	if(ishuman(user) && ishuman(target))
		martial_art.grab_act(user, target)

/obj/item/infinity_stone/syndie/GiveAbilities(mob/living/L, gauntlet = FALSE)
	. = ..()
	if(ishuman(L))
		martial_art.teach(L)
	ADD_TRAIT(L, TRAIT_THERMAL_VISION, SYNDIE_STONE_TRAIT)

/obj/item/infinity_stone/syndie/RemoveAbilities(mob/living/L, gauntlet = FALSE)
	. = ..()
	if(ishuman(L))
		martial_art.remove(L)
	REMOVE_TRAIT(L, TRAIT_THERMAL_VISION, SYNDIE_STONE_TRAIT)

/////////////////////////////////////////////
/////////////////// SPELLS //////////////////
/////////////////////////////////////////////

/obj/effect/proc_holder/spell/aoe_turf/repulse/syndie_stone
	name = "Syndie Stone: Shockwave"
	desc = "Knock down everyone around down and away from you."
	range = 6
	charge_max = 200
	clothes_req = FALSE
	human_req = FALSE
	staff_req = FALSE
	antimagic_allowed = TRUE
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "syndie"
	invocation_type = "none"

/obj/effect/proc_holder/spell/self/infinity/regenerate
	name = "Syndie Stone: Regenerate"
	desc = "Regenerate 4 health per second. Requires you to stand still."
	action_icon_state = "regenerate"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "syndie"
	stat_allowed = TRUE

/obj/effect/proc_holder/spell/self/infinity/regenerate/cast(list/targets, mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat == DEAD)
			to_chat(L, "<span class='notice'>You can't regenerate out of death.</span>")
			return
		while(do_after(L, 10, FALSE, L))
			L.visible_message("<span class='notice'>[L]'s wounds heal!</span>")
			L.heal_overall_damage(4, 4, 4, null, TRUE)
			if(L.getBruteLoss() + L.getFireLoss() + L.getStaminaLoss() < 1)
				to_chat(user, "<span class='notice'>You are fully healed.</span>")
				return

/obj/effect/proc_holder/spell/self/infinity/syndie_bullcharge
	name = "Syndie Stone: Bull Charge"
	desc = "Imbue yourself with power, and charge forward, smashing through anyone or anything in your way!"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "syndie"
	charge_max = 200
	sound = 'sound/magic/repulse.ogg'

/obj/effect/proc_holder/spell/self/infinity/syndie_bullcharge/cast(list/targets, mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		ADD_TRAIT(C, TRAIT_STUNIMMUNE, YEET_TRAIT)
		ADD_TRAIT(user, TRAIT_IGNORESLOWDOWN, YEET_TRAIT)
		C.mario_star = TRUE
		C.super_mario_star = TRUE
		C.move_force = INFINITY
		user.visible_message("<span class='danger'>[user] charges!</span>")
		addtimer(CALLBACK(src, .proc/done, C), 50)

/obj/effect/proc_holder/spell/self/infinity/syndie_bullcharge/proc/done(mob/living/carbon/user)
	user.mario_star = FALSE
	user.super_mario_star = FALSE
	user.move_force = initial(user.move_force)
	REMOVE_TRAIT(user, TRAIT_STUNIMMUNE, YEET_TRAIT)
	REMOVE_TRAIT(user, TRAIT_IGNORESLOWDOWN, YEET_TRAIT)
	user.visible_message("<span class='danger'>[user] relaxes...</span>")

/obj/effect/proc_holder/spell/self/infinity/syndie_jump
	name = "Syndie Stone: Super Jump"
	desc = "Leap across the station to wherever you'd like!"
	action_icon_state = "jump"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "syndie"
	charge_max = 300

/obj/effect/proc_holder/spell/self/infinity/syndie_jump/revert_cast(mob/user)
	. = ..()
	user.opacity = FALSE
	user.mouse_opacity = FALSE
	user.pixel_y = 0
	user.alpha = 255

// i really hope this never runtimes
/obj/effect/proc_holder/spell/self/infinity/syndie_jump/cast(list/targets, mob/user)
	INVOKE_ASYNC(src, .proc/do_jaunt, user)

/obj/effect/proc_holder/spell/self/infinity/syndie_jump/proc/do_jaunt(mob/living/target)
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
		passenger.Paralyze(75)
	target.visible_message("<span class='danger bold'>[target] slams down from above[passenger ? ", slamming [passenger] down to the floor" : ""]!</span>")
	playsound(target, 'sound/effects/bang.ogg', 50, 1)
	explosion(mobloc, 0, 0, 2, 3)
	target.forceMove(mobloc)
	target.setDir(holder.dir)
	animate(target, pixel_y = 0, alpha = 255, time = 4.5, easing = LINEAR_EASING)
	if(passenger)
		passenger.setDir(holder.dir)
		animate(passenger, pixel_y = 0, alpha = 255, time = 4.5, easing = LINEAR_EASING)
	sleep(4.5)
	target.opacity = initial(target.opacity)
	target.mouse_opacity = initial(target.mouse_opacity)
	if(passenger)
		passenger.opacity = initial(passenger.opacity)
		passenger.mouse_opacity = initial(passenger.mouse_opacity)
	for(var/mob/living/L in mobloc)
		if(L.stat == DEAD || L.InCritical())
			L.visible_message("<span class='danger bold'>[L] is pancaked by [target]'s slam!</span>")
			new /obj/item/reagent_containers/food/snacks/pancakes(mobloc)
			L.gib()
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

/////////////////////////////////////////////
/////////////// SNOWFLAKE CODE //////////////
/////////////////////////////////////////////

/mob/living/carbon
	var/mario_star = FALSE
	var/super_mario_star = FALSE

/mob/living/carbon/Bump(atom/A)
	. = ..()
	if(mario_star || super_mario_star)
		if(isliving(A))
			var/mob/living/L = A
			visible_message("<span class='danger'>[src] rams into [L]!</span>")
			if(super_mario_star)
				L.Paralyze(7.5 SECONDS)
				L.adjustBruteLoss(20)
				heal_overall_damage(12.5, 12.5, 12.5)
			else
				L.Paralyze(5 SECONDS)
				L.adjustBruteLoss(12)
				heal_overall_damage(7.5, 7.5, 7.5)
