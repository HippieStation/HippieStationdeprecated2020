/obj/item/gun/ballistic/a3/gatling
	name = "SG-7 Gatling Gun"
	icon = 'icons/obj/guns/minigun.dmi'
	icon_state = "minigun_spin"
	automatic = TRUE
	spread = 20
	mag_type = /obj/item/ammo_box/magazine/internal/a3_gatling

/obj/item/ammo_box/magazine/internal/a3_gatling
	ammo_type = /obj/item/ammo_casing/a3_gatling
	caliber = "gatling"
	max_ammo = 35

/obj/item/ammo_casing/a3_gatling
	projectile_type = /obj/item/projectile/bullet/a3

/obj/item/projectile/bullet/a3
	name = "gatling bullet"
	damage = 18
