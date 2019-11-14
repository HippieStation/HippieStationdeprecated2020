/obj/item/gun/ballistic/automatic/xcomrifle
	name = "6.7mm rifle"
	desc = "An old Earth classic, used by X-COM Operatives during the First Alien War. It's usefullness died with the development of the laser rifle."
	icon = 'hippiestation/icons/obj/AA2.dmi'
	icon_state = "xcomrifle"
	item_state = "xcomrifle"
	pixel_x = -5
	pixel_y = -5
	fire_sound = 'hippiestation/sound/weapons/shoot.ogg'
	load_sound = 'hippiestation/sound/weapons/reload.ogg'
	mag_type = /obj/item/ammo_box/magazine/xcomammo
	can_suppress = FALSE
	burst_size = 3
	fire_delay = 2
	spread = 5
	w_class = WEIGHT_CLASS_HUGE
	weapon_weight = WEAPON_HEAVY
	lefthand_file = 'hippiestation/icons/mob/inhands/weapons/xcom_lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/weapons/xcom_righthand.dmi'


/obj/item/gun/ballistic/automatic/xcomrifle/update_icon()
    return

/obj/item/ammo_box/magazine/xcomammo
	name = "6.7mm magazine"
	icon = 'hippiestation/icons/obj/AA2.dmi'
	icon_state = "xcomammo"
	ammo_type = /obj/item/ammo_casing/bul67
	caliber = "6.7mm"
	max_ammo = 20


/obj/item/ammo_casing/bul67
	name = "6.7mm bullet casing"
	desc = "A 6.7mm bullet casing."
	caliber = "6.7mm"
	icon = 'hippiestation/icons/obj/ammo/ammo.dmi'
	icon_state = "s-casing"
	projectile_type = /obj/item/projectile/bullet/bul67

/obj/item/projectile/bullet/bul67
	name = "6.7mm bullet"
	damage = 20
	icon = 'hippiestation/icons/obj/AA2.dmi'
	icon_state = "xcombullet"

/obj/item/projectile/bullet/bul67/on_hit(atom/target)
	playsound(target, 'hippiestation/sound/weapons/hit.ogg', 100)

