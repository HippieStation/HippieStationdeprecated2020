/obj/item/grenade/plastic/Initialize()
	. = ..()
	plastic_overlay = mutable_appearance(icon, "[item_state]2", ABOVE_ALL_MOB_LAYER)

/obj/item/grenade/plastic/x4
	can_attach_mob = TRUE // oh no no no no no
	full_damage_on_mobs = TRUE // OHHHHHHHH

