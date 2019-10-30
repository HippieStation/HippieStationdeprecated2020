/*

Sorry for doing this, but apparently the Hippie community hates art and new things.
	-Amari

*/

/obj/structure/closet
	icon_hippie = 'hippiestation/icons/obj/closet.dmi'

/obj/structure/closet/update_icon()
	cut_overlays()
	SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)
	if(!opened)
		layer = OBJ_LAYER
		if(icon_door)
			add_overlay("[icon_door]_door")
		else
			add_overlay("[icon_state]_door")
		if(welded)
			add_overlay("welded")
		if(secure && !broken)
			if(locked)
				SSvis_overlays.add_vis_overlay(src, icon, "locked", ABOVE_LIGHTING_LAYER, ABOVE_LIGHTING_PLANE, dir)
			else
				SSvis_overlays.add_vis_overlay(src, icon, "unlocked", ABOVE_LIGHTING_LAYER, ABOVE_LIGHTING_PLANE, dir)
	else
		layer = BELOW_OBJ_LAYER
		if(icon_door_override)
			add_overlay("[icon_door]_open")
		else
			add_overlay("[icon_state]_open")