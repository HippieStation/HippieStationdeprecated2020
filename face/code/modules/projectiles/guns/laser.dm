// melon blunderbus, first time messing with ballistic code so let's see what goes down

/obj/item/ammo_box/magazine/internal/shot/blunderbuss
	name = "blunderbus internal magazine"
	ammo_type = /obj/item/seeds/watermelon
	max_ammo = 1

/obj/item/gun/ballistic/shotgun/blunderbus
	name = "Melon Blunderbus"
	desc = "A modified, terrible weapon. It fires watermelons with devestating effect."
	fire_sound = 'face/sound/weapons/firearms/fire_melon.ogg'
	icon_state = "dshotgun"
	item_state = "shotgun"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM
	force = 10
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BACK
	mag_type = /obj/item/ammo_box/magazine/internal/shot/blunderbuss
	rack_sound_volume = 0



/obj/item/projectile/bullet/reusable/blunderbus
	name = "Watermelon"
	desc = "In the melon!!"
	icon_state = "lollipop_1"
	ammo_type = /obj/item/seeds/watermelon

/obj/item/projectile/bullet/reusable/blunderbus/Initialize()
	. = ..()
	new ammo_type(src)
	var/mutable_appearance/head = mutable_appearance('icons/obj/projectiles.dmi', "lollipop_2")
	add_overlay(head)

/obj/item/projectile/bullet/reusable/blunderbus/handle_drop()
	if(!dropped)
		var/turf/T = get_turf(src)
		new ammo_type(T)
		dropped = TRUE
