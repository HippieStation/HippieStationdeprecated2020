/obj/item/a3
	name = "A3 Powered Suit"
	icon = 'hippiestation/icons/obj/Exopack.dmi'
	alternate_worn_icon = 'hippiestation/icons/obj/Exopack.dmi'
	icon_state = "exopack"
	item_state = "exopack"
	worn_x_dimension = 25
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = FIRE_PROOF | ACID_PROOF | UNACIDABLE | FREEZE_PROOF | LAVA_PROOF
	actions_types = list(/datum/action/item_action/aaa)
	var/list/guns = list(
		"beam_rifle" = /obj/item/gun/energy/beam_rifle/railgun
	)
	var/list/gun_overlays = list()
	var/overlay_sprite
	var/lights_color = "#990000"
	var/mutable_appearance/lights_pulse
	var/mutable_appearance/lights
	var/mutable_appearance/lights_fade
	var/mutable_appearance/lights_off

/obj/item/a3/Initialize()
	. = ..()
	lights_pulse = mutable_appearance(icon, "lights_pulse", BACK_LAYER)
	//lights_pulse.pixel_x = -16
	lights = mutable_appearance(icon, "lights", BACK_LAYER)
	//lights.pixel_x = -16
	lights_fade = mutable_appearance(icon, "lights_fade", BACK_LAYER)
	//lights_fade.pixel_x = -16
	lights_off = mutable_appearance(icon, "lights_off", BACK_LAYER)
	//lights_off.pixel_x = -16
	var/list/G = guns.Copy()
	guns.Cut()
	for(var/sprite in G)
		var/gun = G[sprite]
		var/obj/item/gun/AG = new gun(src)
		AG.resistance_flags |= INDESTRUCTIBLE | FIRE_PROOF | LAVA_PROOF | UNACIDABLE
		ADD_TRAIT(AG, TRAIT_NODROP, A3_TRAIT)
		RegisterSignal(AG, COMSIG_ITEM_DROPPED, .proc/recover_item)
		guns[sprite] = AG
		var/mutable_appearance/MA = mutable_appearance(icon, sprite, BACK_LAYER)
		MA.pixel_x = 3
		MA.pixel_y = -1
		gun_overlays[sprite] = MA

/obj/item/a3/equipped(mob/user, slot)
	. = ..()
	if(slot == SLOT_BACK)
		ADD_TRAIT(src, TRAIT_NODROP, A3_TRAIT)
		update_mob_overlays(user)

/obj/item/a3/dropped(mob/user)
	. = ..()
	cut_mob_overlays(user)
	REMOVE_TRAIT(src, TRAIT_NODROP, A3_TRAIT)

/obj/item/a3/ui_action_click(mob/user, var/datum/action/A)
	if(istype(A, /datum/action/item_action/aaa))
		overlay_sprite = null
		update_mob_overlays(user)
		for(var/sprite in guns)
			var/obj/item/gun/I = guns[sprite]
			if(user.is_holding(I))
				I.forceMove(src)
				user.visible_message("<span class='notice'>\The [I] retracts back into \the [src].</span>")
		var/list/choice_list = list()
		for(var/P in guns)
			choice_list[P] = image(guns[P])
		var/choice = show_radial_menu(user, user, choice_list)
		if(choice)
			var/obj/item/gun = guns[choice]
			if(!user.put_in_hands(gun))
				to_chat(user, "<span class='warning'>Your hands are full!</span?")
				return
			user.swap_hand(user.get_held_index_of_item(gun))
			user.visible_message("<span class='notice'>\The [gun] extends from \the [src]!</span>")
			if(gun_overlays[choice])
				overlay_sprite = choice
			update_mob_overlays(user)
	else
		return ..()

/obj/item/a3/proc/cut_mob_overlays(mob/living/L)
	for(var/MA in gun_overlays)
		L.cut_overlay(gun_overlays[MA])
	L.cut_overlay(lights_fade)
	L.cut_overlay(lights)
	L.cut_overlay(lights_off)
	L.cut_overlay(lights_pulse)

/obj/item/a3/proc/update_mob_overlays(mob/living/L)
	cut_mob_overlays(L)
	if(overlay_sprite)
		L.add_overlay(gun_overlays[overlay_sprite])
	//lights_pulse.color = lights_color
	//L.add_overlay(lights_pulse)

/obj/item/a3/item_action_slot_check(slot, mob/user)
	if(slot == user.getBackSlot())
		return TRUE

/obj/item/a3/proc/recover_item(obj/item/source)
	if(source.loc == src)
		return
	if(guns[overlay_sprite] == source)
		overlay_sprite = null
	source.forceMove(src)
	if(isliving(loc))
		update_mob_overlays(loc)
