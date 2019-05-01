/obj/item/infinity_stone/bluespace
	name = "Bluespace Stone"
	desc = "Stare into the abyss, and the abyss stares back..."
	ability_types = list(/datum/action/infinity/warp)

/datum/action/infinity/warp
	name = "Bluespace Stone: Warp"
	desc = "Warp to a safe location in an instant."

/datum/action/infinity/warp/Trigger()
	owner.visible_message("<span class='danger'>[owner] warps away!</span>", "<span class='notice'>We warp to a safe location.</span>")
	var/turf/potential_T = find_safe_turf(extended_safety_checks = TRUE)
	do_teleport(owner, potential_T, channel = TELEPORT_CHANNEL_MAGIC)
