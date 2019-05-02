/obj/item/infinity_stone/bluespace
	name = "Bluespace Stone"
	desc = "Stare into the abyss, and the abyss stares back...\nHELP INTENT: Teleport target to safe area"
	icon = 'hippiestation/icons/obj/infinity.dmi'
	icon_state = "bluespace"

/obj/item/infinity_stone/bluespace/HelpEvent(atom/target, mob/living/user, proximity_flag)
	target.visible_message("<span class='danger'>[target] warps away!</span>", "<span class='notice'>We warp [target == user ? "ourselves" : target] to a safe location.</span>")
	var/turf/potential_T = find_safe_turf(extended_safety_checks = TRUE)
	do_teleport(target, potential_T, channel = TELEPORT_CHANNEL_MAGIC)

/obj/item/infinity_stone/bluespace/HarmEvent(atom/target, mob/living/user, proximity_flag)
	if(isliving(target))
		var/turf/to_teleport = get_turf(target)
		user.adjustStaminaLoss(15)
		target.visible_message("<span class='danger'>[target] warps away!</span>", "<span class='notice'>We warp ourselves to our desired location.</span>")
		do_teleport(user, to_teleport, channel = TELEPORT_CHANNEL_MAGIC)

/obj/item/infinity_stone/bluespace/DisarmEvent(atom/target, mob/living/user, proximity_flag)
	if(isliving(target))
		var/mob/living/L = target
		var/obj/O = L.get_active_held_item()
		if(L && L.dropItemToGround(O))
			L.visible_message("<span class='danger'>[L]'s [O] disappears from their hands!</span>'", "<span class='danger'>Our [O] disappears!</span>")
			O.forceMove(get_turf(user))
			user.equip_to_slot(O, SLOT_IN_BACKPACK)

/obj/item/infinity_stone/bluespace/GrabEvent(atom/target, mob/living/user, proximity_flag)
	if(user.incorporeal_move)
		user.incorporeal_move = 0
		user.visible_message("<span class='danger'>[user] becomes tangible again!</span>")
		user.remove_trait(TRAIT_PUSHIMMUNE, BLUESPACE_STONE_TRAIT)
		user.remove_trait(TRAIT_IGNOREDAMAGESLOWDOWN, BLUESPACE_STONE_TRAIT)
		user.remove_trait(TRAIT_STUNIMMUNE, BLUESPACE_STONE_TRAIT)
		user.remove_trait(TRAIT_SLEEPIMMUNE, BLUESPACE_STONE_TRAIT)
		user.remove_trait(TRAIT_PACIFISM, BLUESPACE_STONE_TRAIT)
		user.add_movespeed_modifier(BLUESPACE_STONE_TRAIT, update=TRUE, priority=100, multiplicative_slowdown=-2, blacklisted_movetypes=(FLYING|FLOATING))
		animate(user, alpha = 255, time = 15)
	else
		user.incorporeal_move = INCORPOREAL_MOVE_BASIC
		user.add_trait(TRAIT_PUSHIMMUNE, BLUESPACE_STONE_TRAIT)
		user.add_trait(TRAIT_IGNOREDAMAGESLOWDOWN, BLUESPACE_STONE_TRAIT)
		user.add_trait(TRAIT_STUNIMMUNE, BLUESPACE_STONE_TRAIT)
		user.add_trait(TRAIT_SLEEPIMMUNE, BLUESPACE_STONE_TRAIT)
		user.add_trait(TRAIT_PACIFISM, BLUESPACE_STONE_TRAIT) // just so this doesn;t get abused to fire guns while invincible
		user.remove_movespeed_modifier(BLUESPACE_STONE_TRAIT)
		user.visible_message("<span class='danger'>[user] becomes intangible!</span>")
		animate(user, alpha = 100, time = 15)

/obj/item/infinity_stone/bluespace/dropped(mob/living/user)
	. = ..()
	if(user.incorporeal_move)
		user.incorporeal_move = 0
		user.visible_message("<span class='danger'>[user] becomes tangible again!</span>")
		user.remove_trait(TRAIT_PUSHIMMUNE, BLUESPACE_STONE_TRAIT)
		user.remove_trait(TRAIT_IGNOREDAMAGESLOWDOWN, BLUESPACE_STONE_TRAIT)
		user.remove_trait(TRAIT_STUNIMMUNE, BLUESPACE_STONE_TRAIT)
		user.remove_trait(TRAIT_SLEEPIMMUNE, BLUESPACE_STONE_TRAIT)
		user.remove_trait(TRAIT_PACIFISM, BLUESPACE_STONE_TRAIT)
		user.remove_movespeed_modifier(BLUESPACE_STONE_TRAIT)
		animate(user, alpha = 255, time = 15)
