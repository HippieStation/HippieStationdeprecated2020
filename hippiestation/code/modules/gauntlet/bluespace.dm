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
	var/turf/to_teleport = get_turf(target)
	user.adjustStaminaLoss(15)
	target.visible_message("<span class='danger'>[target] warps away!</span>", "<span class='notice'>We warp ourselves to our desired location.</span>")
	do_teleport(user, to_teleport, channel = TELEPORT_CHANNEL_MAGIC)
