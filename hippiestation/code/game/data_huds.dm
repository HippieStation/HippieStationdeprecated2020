
/mob/living/carbon/human/proc/sec_hud_set_threat_status(mob/living/carbon/human/user, clear = FALSE)
	var/list/hud_images = list()
	var/image/holder_threat
	holder_threat = image('icons/mob/hud.dmi', src, "hudalert-red", HUD_LAYER)
	holder_threat.appearance_flags = RESET_COLOR|RESET_TRANSFORM
	var/icon/I = icon(icon, icon_state, dir)
	holder_threat.pixel_y = I.Height() - world.icon_size
	hud_images += holder_threat
	stored_hud_images += hud_images
	if(istype(user.glasses, /obj/item/clothing/glasses/hud/threat))
		var/obj/item/clothing/glasses/hud/threat/scanner = user.glasses
		if(clear)
			scanner.threat_list -= src
		if(src in scanner.threat_list)
			user.client.images += hud_images
		else
			user.client.images -= stored_hud_images
