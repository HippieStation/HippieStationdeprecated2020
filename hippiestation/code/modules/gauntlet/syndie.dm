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

/obj/effect/proc_holder/spell/self/infinity/syndie_bullcharge
	name = "Syndie Stone: Bull Charge"
	desc = "Imbue yourself with power, and charge forward, smashing through anyone or any wall in your way!"
	charge_max = 200
	sound = 'sound/magic/repulse.ogg'

/obj/effect/proc_holder/spell/self/infinity/syndie_bullcharge/cast(list/targets, mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		ADD_TRAIT(C, TRAIT_STUNIMMUNE, YEET_TRAIT)
		C.yeet = TRUE
		C.super_yeet = TRUE
		C.throw_at(get_edge_target_turf(C, C.dir), 9, 4, spin = FALSE)

/////////////////////////////////////////////
/////////////// SNOWFLAKE CODE //////////////
/////////////////////////////////////////////

/mob/living/carbon
	var/yeet = FALSE
	var/super_yeet = FALSE

/mob/living/carbon/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(yeet || super_yeet)
		if(super_yeet && isclosedturf(hit_atom))
			var/turf/closed/T = hit_atom
			visible_message("<span class='danger'>[src] slams into [T]!</span>")
			T.ScrapeAway()
		else if(isliving(hit_atom))
			var/mob/living/L = hit_atom
			visible_message("<span class='danger'>[src] slams into [L]!</span>")
			if(super_yeet)
				L.Paralyze(7.5 SECONDS)
				L.adjustBruteLoss(20)
			else
				L.Paralyze(5 SECONDS)
				L.adjustBruteLoss(12)
		else if(isobj(hit_atom))
			var/obj/O = hit_atom
			visible_message("<span class='danger'>[src] slams into [O], and crushes it!</span>")
			O.take_damage(INFINITY)
		REMOVE_TRAIT(src, TRAIT_STUNIMMUNE, YEET_TRAIT)
		yeet = FALSE
		super_yeet = FALSE
