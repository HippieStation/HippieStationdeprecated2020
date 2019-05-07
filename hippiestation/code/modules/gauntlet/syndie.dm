/obj/item/infinity_stone/syndie
	name = "Syndie Stone"
	desc = "Power, baby. Raw power."
	color = "#ff0130"
	stone_type = SYNDIE_STONE
	ability_text = list("ALL INTENTS: PLACEHOLDER MARTIAL ART")
	spell_types = list(/obj/effect/proc_holder/spell/aoe_turf/repulse/syndie_stone,
		/obj/effect/proc_holder/spell/self/infinity/regenerate)
	var/datum/martial_art/elite_cqc/martial_art

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

/obj/item/infinity_stone/syndie/GiveAbilities(mob/living/L, only_extra = FALSE)
	. = ..()
	if(ishuman(L))
		martial_art.teach(L)

/obj/item/infinity_stone/syndie/RemoveAbilities(mob/living/L, only_extra = FALSE)
	. = ..()
	if(ishuman(L))
		martial_art.remove(L)
	if(L.move_force >= INFINITY)
		L.visible_message("<span class='danger'>[L] relaxes a bit.</span>", "<span class='notice'>We exit immovable mode.</span>")
		L.move_force = initial(L.move_force)

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
	desc = "Regenerate 10 health every 5 seconds. Requires you to stand still."
	action_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_icon_state = "regenerate"

/obj/effect/proc_holder/spell/self/infinity/regenerate/cast(list/targets, mob/user)
	if(isliving(user))
		var/mob/living/L = user
		while(do_after(L, 50, FALSE, L))
			L.visible_message("<span class='notice'>[L]'s wounds heal!</span>")
			L.heal_overall_damage(10, 10, 10, null, TRUE)
			if(L.getBruteLoss() + L.getFireLoss() + L.getStaminaLoss() < 1)
				to_chat(user, "<span class='notice'>You are fully healed.</span>")
				return
