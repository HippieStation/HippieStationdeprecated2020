/*

Sorry for doing this, but apparently the Hippie community hates art and new things.
	-Amari

*/

/obj/structure/closet
	icon_hippie = 'hippiestation/icons/obj/closet.dmi'

/obj/structure/closet/update_icon()
	cut_overlays()
	SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)
	luminosity = 0
	if(!opened)
		layer = OBJ_LAYER
		if(icon_door)
			add_overlay("[icon_door]_door")
		else
			add_overlay("[icon_state]_door")
		if(welded)
			add_overlay("welded")
		if(secure && !broken)
			luminosity = 1
			SSvis_overlays.add_vis_overlay(src, icon, "[locked ? "locked" : "unlocked"]", EMISSIVE_LAYER, EMISSIVE_PLANE, dir, alpha)
			if(locked)
				add_overlay("locked")
			else
				add_overlay("unlocked")
	else
		layer = BELOW_OBJ_LAYER
		if(icon_door_override)
			add_overlay("[icon_door]_open")
		else
			add_overlay("[icon_state]_open")