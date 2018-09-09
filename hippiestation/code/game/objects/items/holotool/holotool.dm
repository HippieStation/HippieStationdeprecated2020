

/obj/item/holotool
	name = "experimental holotool"
	desc = "A highly experimental holographic tool projector."
	icon = 'hippiestation/icons/obj/holotool.dmi'
	icon_state = "holotool"
	slot_flags = SLOT_BELT
	usesound = 'sound/items/pshoom.ogg'
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi'
	actions_types = list(/datum/action/item_action/change_tool, /datum/action/item_action/change_ht_color)
	resistance_flags = FIRE_PROOF | ACID_PROOF

	var/datum/holotool_mode/current_tool
	var/list/available_modes
	var/list/mode_names
	var/list/radial_modes
	var/current_color = "#48D1CC" //mediumturquoise

	var/menu_open = FALSE
	var/datum/radial_menu/menu = new

/obj/item/holotool/examine(mob/user)
	..()
	to_chat(user, "<span class='notice'>It is currently set to [current_tool ? current_tool.name : "'off'"] mode.</span>")
	to_chat(user, "<span class='notice'>Ctrl+Click it to open the radial menu!</span>")

/obj/item/holotool/ui_action_click(mob/user, datum/action/action)
	if(istype(action, /datum/action/item_action/change_tool))
		update_listing()
		var/datum/holotool_mode/chosen = input("Choose tool settings", "Tool", null, null) as null|anything in available_modes
		switch_tool(chosen)
	else
		var/C = input(user, "Select Color", "Select color", "#48D1CC") as null|color
		if(!C || QDELETED(src))
			return
		current_color = C
	update_icon()
	action.UpdateButtonIcon()
	user.regenerate_icons()

/obj/item/holotool/proc/switch_tool(var/datum/holotool_mode/mode)
	if(!mode || !istype(mode))
		return
	if(current_tool)
		current_tool.on_unset(src)
	current_tool = mode
	current_tool.on_set(src)
	playsound(loc, 'sound/items/rped.ogg', get_clamped_volume(), 1, -1)
	update_icon()
	action.UpdateButtonIcon()
	user.regenerate_icons()

/obj/item/holotool/proc/update_listing()
	LAZYCLEARLIST(available_modes)
	LAZYCLEARLIST(radial_modes)
	LAZYCLEARLIST(mode_names)
	for(var/A in subtypesof(/datum/holotool_mode))
		var/datum/holotool_mode/M = new A
		if(M.can_be_used(src))
			LAZYADD(available_modes, M)
			LAZYSET(mode_names, M.name, M)
			LAZYSET(radial_modes, M.name, image(icon = icon, icon_state = M.name))
			var/image/I = radial_modes[M.name]
			I.color = current_color
		else
			qdel(M)

/obj/item/holotool/update_icon()
	cut_overlays()
	if(current_tool)
		var/mutable_appearance/holo_item = mutable_appearance(icon, current_tool.name)
		holo_item.color = current_color
		item_state = current_tool.name
		add_overlay(holo_item)
		set_light(3, null, current_color)
	else
		item_state = "holotool"
		icon_state = "holotool"
		set_light(0)

	for(var/datum/action/A in actions)
		A.UpdateButtonIcon()

/obj/item/holotool/CtrlClick(mob/user)
	update_listing()
	menu = new
	qdel(menu.close_button)
	if(!menu_open)
		menu_open = TRUE
		menu.anchor = user
		menu.check_screen_border(user)
		menu.set_choices(radial_modes)
		menu.show_to(user)
		menu.wait()
		if(menu)
			var/new_tool = LAZYACCESS(mode_names, menu.selected_choice)
			if(new_tool)
				switch_tool(new_tool)
		QDEL_NULL(menu)
		menu_open = FALSE


/obj/item/holotool/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	to_chat(user, "<span class='danger'>ZZT- ILLEGAL BLUEPRINT UNLOCKED- CONTACT !#$@^%$# NANOTRASEN SUPPORT-@*%$^%!</span>")
	do_sparks(5, 0, src)
	obj_flags |= EMAGGED


// Spawn in RD closet
/obj/structure/closet/secure_closet/RD/PopulateContents()
	. = ..()
	new /obj/item/holotool(src)
