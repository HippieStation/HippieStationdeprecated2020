//Engineering Mesons

/obj/item/clothing/glasses/meson/engine
	name = "Engineering Scanner Goggles"
	desc = "Goggles used by engineers. The Meson Scanner mode lets you see basic structural and terrain layouts through walls, regardless of lighting condition. The T-ray Scanner mode lets you see underfloor objects such as cables and pipes."
	icon_state = "trayson-meson"
	actions_types = list(/datum/action/item_action/toggle_mode)
	origin_tech = "materials=3;magnets=3;engineering=3;plasmatech=3"

<<<<<<< HEAD
	var/mode = 0	//0 - regular mesons mode	1 - t-ray mode
	var/range = 1

/obj/item/clothing/glasses/meson/engine/attack_self(mob/user)
	mode = !mode

	if(mode)
		START_PROCESSING(SSobj, src)
=======
	mesons_on = TRUE //if set to FALSE, these goggles work as t-ray scanners.
	var/range = 1

/obj/item/clothing/glasses/meson/engine/toggle_mode(mob/user, voluntary)
	var/turf/T = get_turf(src)
	if(T && T.z == ZLEVEL_MINING && !mesons_on)
		if(picked_excuse)
			to_chat(user, "<span class='warning'>Due to [picked_excuse], the [name] cannot currently be swapped to \[Meson] mode.</span>")
		return
	mesons_on = !mesons_on

	if(!mesons_on)
>>>>>>> f7cb6c8484... Renames a var (#27578)
		vision_flags = 0
		darkness_view = 2
		invis_view = SEE_INVISIBLE_LIVING
		lighting_alpha = null
		to_chat(user, "<span class='notice'>You toggle the goggles' scanning mode to \[T-Ray].</span>")
	else
		STOP_PROCESSING(SSobj, src)
		vision_flags = SEE_TURFS
		darkness_view = 1
		lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
		to_chat(loc, "<span class='notice'>You toggle the goggles' scanning mode to \[Meson].</span>")

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.glasses == src)
			H.update_sight()

	update_icon()
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

/obj/item/clothing/glasses/meson/engine/process()
<<<<<<< HEAD
	if(!mode)
=======
	if(mesons_on)
		var/turf/T = get_turf(src)
		if(T && T.z == ZLEVEL_MINING)
			toggle_mode(loc)
>>>>>>> f7cb6c8484... Renames a var (#27578)
		return

	if(!ishuman(loc))
		return

	var/mob/living/carbon/human/user = loc
	if(user.glasses != src)
		return

	scan()

/obj/item/clothing/glasses/meson/engine/proc/scan()
	for(var/turf/T in range(range, loc))
		for(var/obj/O in T.contents)
			if(O.level != 1)
				continue

			if(O.invisibility == INVISIBILITY_MAXIMUM)
				flick_sonar(O)

/obj/item/clothing/glasses/meson/engine/proc/flick_sonar(obj/pipe)
	if(ismob(loc))
		var/mob/M = loc
		var/image/I = new(loc = get_turf(pipe))
		var/mutable_appearance/MA = new(pipe)
		MA.alpha = 128
		I.appearance = MA
		if(M.client)
			flick_overlay(I, list(M.client), 8)

/obj/item/clothing/glasses/meson/engine/update_icon()
	icon_state = mesons_on ? "trayson-meson" : "trayson-tray"
	if(istype(loc,/mob/living/carbon/human/))
		var/mob/living/carbon/human/user = loc
		if(user.glasses == src)
			user.update_inv_glasses()

/obj/item/clothing/glasses/meson/engine/tray //atmos techs have lived far too long without tray goggles while those damned engineers get their dual-purpose gogles all to themselves
	name = "Optical T-Ray Scanner"
	desc = "Used by engineering staff to see underfloor objects such as cables and pipes."
	icon_state = "trayson-tray_off"
	origin_tech = "materials=3;magnets=2;engineering=2"

<<<<<<< HEAD
	mode = 1
	var/on = 0
=======
	mesons_on = FALSE
	var/on = FALSE
>>>>>>> f7cb6c8484... Renames a var (#27578)
	vision_flags = 0
	darkness_view = 2
	invis_view = SEE_INVISIBLE_LIVING
	range = 2

/obj/item/clothing/glasses/meson/engine/tray/process()
	if(!on)
		return
	..()

/obj/item/clothing/glasses/meson/engine/tray/update_icon()
	icon_state = "trayson-tray[on ? "" : "_off"]"
	if(istype(loc,/mob/living/carbon/human/))
		var/mob/living/carbon/human/user = loc
		if(user.glasses == src)
			user.update_inv_glasses()

/obj/item/clothing/glasses/meson/engine/tray/attack_self(mob/user)
	on = !on

	if(on)
		START_PROCESSING(SSobj, src)
		to_chat(user, "<span class='notice'>You turn the goggles on.</span>")
	else
		STOP_PROCESSING(SSobj, src)
		to_chat(user, "<span class='notice'>You turn the goggles off.</span>")

	update_icon()
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()
