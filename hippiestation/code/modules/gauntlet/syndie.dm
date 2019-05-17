/obj/item/infinity_stone/syndie
	name = "Syndie Stone"
	desc = "Power, baby. Raw power."
	color = "#ff0130"
	force = 30
	stone_type = SYNDIE_STONE
	ability_text = list("ALL INTENTS: PLACEHOLDER MARTIAL ART")
	gauntlet_spell_types = list(/obj/effect/proc_holder/spell/aoe_turf/repulse/syndie_stone)
	spell_types = list(/obj/effect/proc_holder/spell/self/infinity/regenerate,
		/obj/effect/proc_holder/spell/self/infinity/syndie_bullcharge)
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

/obj/effect/proc_holder/spell/self/infinity/syndie_bullcharge
	name = "Syndie Stone: Bull Charge"
	desc = "Imbue yourself with power, and charge forward, smashing through anyone or anything in your way!"
	charge_max = 200
	sound = 'sound/magic/repulse.ogg'

/obj/effect/proc_holder/spell/self/infinity/syndie_bullcharge/cast(list/targets, mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		ADD_TRAIT(C, TRAIT_STUNIMMUNE, YEET_TRAIT)
		C.mario_star = TRUE
		C.super_mario_star = TRUE
		C.move_force = INFINITY
		addtimer(CALLBACK(src, .proc/done, C), 50)

/obj/effect/proc_holder/spell/self/infinity/syndie_bullcharge/proc/done(mob/living/carbon/user)
	user.mario_star = FALSE
	user.super_mario_star = FALSE
	user.move_force = initial(user.move_force)
	REMOVE_TRAIT(user, TRAIT_STUNIMMUNE, YEET_TRAIT)

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
			else
				L.Paralyze(5 SECONDS)
				L.adjustBruteLoss(12)
