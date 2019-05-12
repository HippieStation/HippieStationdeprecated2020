/obj/item/infinity_stone/syndie
	name = "Syndie Stone"
	desc = "Power, baby. Raw power."
	color = "#ff0130"
	force = 30
	stone_type = SYNDIE_STONE
	ability_text = list("ALL INTENTS: PLACEHOLDER MARTIAL ART")
	gauntlet_spell_types = list(/obj/effect/proc_holder/spell/aoe_turf/repulse/syndie_stone)
	spell_types = list(/obj/effect/proc_holder/spell/self/infinity/regenerate,
		/obj/effect/proc_holder/spell/self/infinity/epulse)
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

/obj/item/infinity_stone/syndie/RemoveAbilities(mob/living/L, gauntlet = FALSE)
	. = ..()
	if(ishuman(L))
		martial_art.remove(L)

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
	invocation_type = "none"

/obj/effect/proc_holder/spell/self/infinity/regenerate
	name = "Syndie Stone: Regenerate"
	desc = "Regenerate 4 health per second. Requires you to stand still."
	action_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_icon_state = "regenerate"
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

/obj/effect/proc_holder/spell/self/infinity/epulse
	name = "Syndie Stone: Energy Pulse"
	desc = "Release a pulse of energy, knocking back anyone in front of you."
	action_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_icon_state = "epulse"
	range = 3
	sound = 'sound/magic/repulse.ogg'

/obj/effect/proc_holder/spell/self/infinity/epulse/cast(list/targets, mob/user)
	var/direction = user.dir
	var/front = get_step(get_turf(user), direction)
	user.visible_message("<span class='danger'>[user] unleashes an energy wave!<span>")
	for (var/i = 0; i < range; i++)
		for(var/turf/T in GetAdjacents(front, direction))
			new /obj/effect/temp_visual/dir_setting/firing_effect/magic(T)
			for(var/atom/movable/AM in T)
				if(AM == user || AM.anchored)
					continue
				if(isliving(AM))
					var/mob/living/M = AM
					M.Paralyze(7.5 SECONDS)
					M.adjustBruteLoss(5)
					to_chat(M, "<span class='userdanger'>You're slammed into the floor by the energy wave!</span>")
				var/atom/target = get_edge_target_turf(AM, direction)
				new /obj/effect/temp_visual/gravpush(get_turf(AM), get_dir(user, AM))
				AM.throw_at(target, 5, 5, user)
		front = get_step(front, direction)

/obj/effect/proc_holder/spell/self/infinity/epulse/proc/GetAdjacents(turf/T, direction)
	return list(T, get_step(T, turn(direction, 90)), get_step(T, turn(direction, 270)))
