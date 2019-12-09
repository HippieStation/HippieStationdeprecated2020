//Originally coded for HippieStation by Steamp0rt, shared under the AGPL license.

/obj/item/badmin_stone/syndie
	name = "Syndie Stone"
	desc = "Power, baby. Raw power."
	color = "#ff0130"
	force = 30
	stone_type = SYNDIE_STONE
	ability_text = list("ALL INTENTS: CQC. 30 force!")
	spell_types = list(/obj/effect/proc_holder/spell/self/infinity/regenerate/syndie,
		/obj/effect/proc_holder/spell/self/infinity/syndie_bullcharge,
		/obj/effect/proc_holder/spell/self/infinity/syndie_jump)
	gauntlet_spell_types = list(/obj/effect/proc_holder/spell/self/infinity/shockwave/syndie_stone,
		/obj/effect/proc_holder/spell/self/infinity/armor/syndie)
	var/datum/martial_art/cqc/martial_art

/obj/item/badmin_stone/syndie/Initialize()
	. = ..()
	martial_art = new

/obj/item/badmin_stone/syndie/HelpEvent(atom/target, mob/living/user, proximity_flag)
	if(ishuman(user) && ishuman(target) && proximity_flag)
		martial_art.help_act(user, target)

/obj/item/badmin_stone/syndie/DisarmEvent(atom/target, mob/living/user, proximity_flag)
	if(ishuman(user) && ishuman(target) && proximity_flag)
		martial_art.disarm_act(user, target)

/obj/item/badmin_stone/syndie/HarmEvent(atom/target, mob/living/user, proximity_flag)
	if(ishuman(user) && ishuman(target) && proximity_flag)
		martial_art.harm_act(user, target)

/obj/item/badmin_stone/syndie/GrabEvent(atom/target, mob/living/user, proximity_flag)
	if(ishuman(user) && ishuman(target) && proximity_flag)
		martial_art.grab_act(user, target)

/obj/item/badmin_stone/syndie/GiveAbilities(mob/living/L, gauntlet = FALSE)
	. = ..()
	if(ishuman(L))
		martial_art.teach(L)
	ADD_TRAIT(L, TRAIT_THERMAL_VISION, SYNDIE_STONE_TRAIT)

/obj/item/badmin_stone/syndie/RemoveAbilities(mob/living/L, gauntlet = FALSE)
	. = ..()
	if(ishuman(L))
		martial_art.remove(L)
	REMOVE_TRAIT(L, TRAIT_THERMAL_VISION, SYNDIE_STONE_TRAIT)

/////////////////////////////////////////////
/////////////////// SPELLS //////////////////
/////////////////////////////////////////////

/obj/effect/proc_holder/spell/self/infinity/shockwave/syndie_stone
	name = "Syndie Stone: Shockwave"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "syndie"
	action_icon_state = "stomp"
	range = 8

/obj/effect/proc_holder/spell/self/infinity/regenerate/syndie
	name = "Syndie Stone: Regenerate"
	desc = "Regenerate 5 health per second. Requires you to stand still."
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "syndie"
	default_regen = 5

/obj/effect/proc_holder/spell/self/infinity/syndie_bullcharge
	name = "Syndie Stone: Bull Charge"
	desc = "Imbue yourself with power, and charge forward, smashing through anyone or anything in your way!"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "syndie"
	action_icon_state = "charge"
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

/obj/effect/proc_holder/spell/self/infinity/armor/syndie
	name = "Syndie Stone: Tank Armor"
	desc = "Change your defense focus -- tank melee, tank ballistics, or tank energy."
	action_icon = 'icons/effects/effects.dmi'
	action_icon_state = "shield1"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "syndie"
	charge_max = 15 SECONDS

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
	if(istype(get_area(user), /area/wizard_station))
		to_chat(user, "<span class='warning'>You can't jump here!</span>")
		revert_cast(user)
		return
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
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		C.super_leaping = FALSE
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
	var/super_leaping = FALSE

/mob/living/carbon/ex_act(severity, target, origin)
	if(super_leaping)
		return
	return ..()

/mob/living/carbon/contents_explosion(severity, target)
	if(super_leaping)
		return
	return ..()
	
/mob/living/carbon/prevent_content_explosion()
	return super_leaping || ..()

/mob/living/carbon/Bump(atom/A)
	. = ..()
	if(mario_star || super_mario_star)
		if(isliving(A))
			var/mob/living/L = A
			var/paralyzed
			visible_message("<span class='danger'>[src] rams into [L]!</span>")
			if(super_mario_star)
				paralyzed = L.Paralyze(7.5 SECONDS)
				L.adjustBruteLoss(20)
				heal_overall_damage(12.5, 12.5, 12.5)
			else
				paralyzed = L.Paralyze(5 SECONDS)
				L.adjustBruteLoss(12)
				heal_overall_damage(7.5, 7.5, 7.5)
			if(!paralyzed)
				L.visible_message("<span class='danger'>[L] is thrown back by the sheer force of [src]!</span>")
				L.throw_at(get_edge_target_turf(src, get_dir(src, L)), INFINITY, 5)
