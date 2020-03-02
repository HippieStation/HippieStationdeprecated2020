//Original code found in laser_gatling.dm

/obj/item/minigunpack/shotgun
	name = "backpack ammo pack"
	desc = "The massive backpack containing the belt-fed shotgun ammo for the gatling shotgun."
	overheat_max = 120		//Literally will never see this outside of admin or CentCom docks fuckery. Let them have fun with it.
	heat_diffusion = 2
	gun = /obj/item/gun/ballistic/minigun/shotgun

/obj/item/gun/ballistic/minigun/shotgun
	name = "gatling shotgun"
	desc = "A ludicrous gatling shotgun that some madman conjured up."
	burst_size = 3
	fire_sound = 'face/sound/weapons/firearms/gunshot_shotgun_bulldog.ogg'
	mag_type = /obj/item/ammo_box/magazine/internal/minigun/shotgun
	ammo_pack = /obj/item/minigunpack/shotgun
	casing_ejector = TRUE
	item_flags = SLOWS_WHILE_IN_HAND

/obj/item/ammo_box/magazine/internal/minigun/shotgun
	name = "gatling shotgun ammo belt"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	caliber = "12 gauge buckshot"
	max_ammo = 500