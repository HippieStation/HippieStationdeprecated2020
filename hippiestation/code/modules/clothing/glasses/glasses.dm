#define COMSIG_THREAT_SCAN_CLICK_CTRL_SHIFT "threat_scan_click_shift_shift"

/obj/item/clothing/glasses/thermal/meson
	name = "optical meson scanner"
	desc = "Used by engineering and mining staff to see basic structural and terrain layouts through walls, regardless of lighting conditions."
	icon_state = "meson"
	item_state = "meson"

/obj/item/clothing/glasses/thermal/meson/examine(mob/user) // newlines the examine
	. = ..()
	. += "Upon closer examination, the goggles appear to check for heat signatures, not the station."

/obj/item/clothing/glasses/hud/threat
	name = "threat marking glasses"
	desc = "An advanced heads-up display which can mark targets as a threat for easy assesment of situations. Ctrl + Shift click a target to mark."
	icon_state = "sun"
	item_state = "sunglasses"
	//hud_type = DATA_HUD_THREAT_SCAN
	var/list/threat_list = list()
	actions_types = list(/datum/action/item_action/clear_threats)

/obj/item/clothing/glasses/hud/threat/equipped(mob/user, slot)
	..()
	if(slot == ITEM_SLOT_EYES)
		RegisterSignal(user, COMSIG_THREAT_SCAN_CLICK_CTRL_SHIFT, .proc/ToggleThreat)

/obj/item/clothing/glasses/hud/threat/dropped(mob/user)
	..()
	UnregisterSignal(user, COMSIG_THREAT_SCAN_CLICK_CTRL_SHIFT)

/obj/item/clothing/glasses/hud/threat/proc/ToggleThreat(mob/living/user, mob/living/carbon/human/H)
	LAZYINITLIST(threat_list)
	if(threat_list.len && (H in threat_list))
		threat_list -= H
		to_chat(user, "<span class='warning'>[H] was removed from the threat scan.</span>")
	else
		if(user != H)
			threat_list |= H
			to_chat(user, "<span class='warning'>[H] was added to the threat scan.</span>")
	H.sec_hud_set_threat_status(user)

/obj/item/clothing/glasses/hud/threat/proc/clear_threats(mob/user)
	if(threat_list && threat_list.len)
		for(var/mob/living/carbon/human/H in threat_list)
			H.sec_hud_set_threat_status(user, TRUE)
		to_chat(user, "<span class='notice'>Cleared all threats.</span>")
		return
	to_chat(user, "<span class='warning'>No threats to clear.</span>")

/obj/item/clothing/glasses/hud/threat/attack_self(mob/user)
	clear_threats(user)

/mob/living/carbon/human/CtrlShiftClick(mob/user)
	..()
	SEND_SIGNAL(user, COMSIG_THREAT_SCAN_CLICK_CTRL_SHIFT, src)

/obj/item/clothing/glasses/hippie/miami
	name = "miami shades"
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand-clothing.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand-clothing.dmi'
	icon_state = "MiamiShades"
	item_state = "MiamiShades"
	darkness_view = 1
	flash_protect = 1
	tint = 1
