/////actual ammo/////

/obj/item/ammo_casing/caseless/amags
	desc = "A ferromagnetic slug intended to be launched out of a compatible weapon."
	caliber = "mags"
	icon = 'hippiestation/icons/obj/guns/cit_guns.dmi'
	icon_state = "mag-casing-live"
	projectile_type = /obj/item/projectile/bullet/mags

/obj/item/ammo_casing/caseless/anlmags
	desc = "A specialized ferromagnetic slug designed with a less-than-lethal payload."
	caliber = "mags"
	icon = 'hippiestation/icons/obj/guns/cit_guns.dmi'
	icon_state = "mag-casing-live"
	projectile_type = /obj/item/projectile/bullet/nlmags

//////magazines/////

/obj/item/ammo_box/magazine/mmag/small
	name = "magpistol magazine (non-lethal disabler)"
	icon = 'hippiestation/icons/obj/guns/cit_guns.dmi'
	icon_state = "smallmagmag"
	ammo_type = /obj/item/ammo_casing/caseless/anlmags
	caliber = "mags"
	max_ammo = 15
	multiple_sprites = 2

/obj/item/ammo_box/magazine/mmag/small/lethal
	name = "magpistol magazine (lethal)"
	icon = 'hippiestation/icons/obj/guns/cit_guns.dmi'
	icon_state = "smallmagmag"
	ammo_type = /obj/item/ammo_casing/caseless/amags


//END MAGPISTOL
//START MAGRIFLE

///ammo casings///

/obj/item/ammo_casing/caseless/amagm
	desc = "A large ferromagnetic slug intended to be launched out of a compatible weapon."
	caliber = "magm"
	icon = 'hippiestation/icons/obj/guns/cit_guns.dmi'
	icon_state = "mag-casing-live"
	projectile_type = /obj/item/projectile/bullet/magrifle

/obj/item/ammo_casing/caseless/anlmagm
	desc = "A large, specialized ferromagnetic slug designed with a less-than-lethal payload."
	caliber = "magm"
	icon = 'hippiestation/icons/obj/guns/cit_guns.dmi'
	icon_state = "mag-casing-live"
	projectile_type = /obj/item/projectile/bullet/nlmagrifle

///magazines///

/obj/item/ammo_box/magazine/mmag/
	name = "magrifle magazine (non-lethal disabler)"
	icon = 'hippiestation/icons/obj/guns/cit_guns.dmi'
	icon_state = "mediummagmag"
	ammo_type = /obj/item/ammo_casing/caseless/anlmagm
	caliber = "magm"
	max_ammo = 24
	multiple_sprites = 2

/obj/item/ammo_box/magazine/mmag/lethal
	name = "magrifle magazine (lethal)"
	icon = 'hippiestation/icons/obj/guns/cit_guns.dmi'
	icon_state = "mediummagmag"
	ammo_type = /obj/item/ammo_casing/caseless/amagm
	max_ammo = 24


//END MAGRIFLE
//START HYPERBURST

///ammo casings///

/obj/item/ammo_casing/caseless/ahyper
	desc = "A large block of speciallized ferromagnetic material designed to be fired out of the experimental Hyper-Burst Rifle."
	caliber = "hypermag"
	icon = 'hippiestation/icons/obj/guns/cit_guns.dmi'
	icon_state = "hyper-casing-live"
	projectile_type = /obj/item/projectile/bullet/mags/hyper
	pellets = 12
	variance = 40

/obj/item/ammo_casing/caseless/ahyper/inferno
	projectile_type = /obj/item/projectile/bullet/mags/hyper/inferno
	pellets = 1
	variance = 0

///magazines///

/obj/item/ammo_box/magazine/mhyper
	name = "hyper-burst rifle magazine"
	icon = 'hippiestation/icons/obj/guns/cit_guns.dmi'
	icon_state = "hypermag-4"
	ammo_type = /obj/item/ammo_casing/caseless/ahyper
	caliber = "hypermag"
	desc = "A magazine for the Hyper-Burst Rifle. Loaded with a special slug that fragments into 12 smaller shards which can absolutely puncture anything, but has rather short effective range."
	max_ammo = 4

/obj/item/ammo_box/magazine/mhyper/update_icon()
	..()
	icon_state = "hypermag-[ammo_count() ? "4" : "0"]"

/obj/item/ammo_box/magazine/mhyper/inferno
	name = "hyper-burst rifle magazine (inferno)"
	ammo_type = /obj/item/ammo_casing/caseless/ahyper/inferno
	desc = "A magazine for the Hyper-Burst Rifle. Loaded with a special slug that violently reacts with whatever surface it strikes, generating a massive amount of heat and light."


//START VARIANT/RESEARCH AMMO - DO NOT TOUCH THIS PART
///ammo///

/obj/item/ammo_casing/caseless/mag_e
	var/energy_cost = 0

/obj/item/ammo_casing/caseless/mag_e/amagm_e
	desc = "A large ferromagnetic slug intended to be launched out of a compatible weapon."
	caliber = "mag_e"
	icon = 'hippiestation/icons/obj/guns/cit_guns.dmi'
	icon_state = "mag-casing-live"
	projectile_type = /obj/item/projectile/bullet/magrifle
	energy_cost = 200

/obj/item/ammo_casing/caseless/mag_e/anlmagm_e
	desc = "A large, specialized ferromagnetic slug designed with a less-than-lethal payload."
	caliber = "mag_e"
	icon = 'hippiestation/icons/obj/guns/cit_guns.dmi'
	icon_state = "mag-casing-live"
	projectile_type = /obj/item/projectile/bullet/nlmagrifle
	energy_cost = 200

/obj/item/ammo_casing/caseless/mag_e/amags
	desc = "A ferromagnetic slug intended to be launched out of a compatible weapon."
	caliber = "mag_e"
	icon = 'hippiestation/icons/obj/guns/cit_guns.dmi'
	icon_state = "mag-casing-live"
	projectile_type = /obj/item/projectile/bullet/mags
	energy_cost = 125

/obj/item/ammo_casing/caseless/mag_e/anlmags
	desc = "A specialized ferromagnetic slug designed with a less-than-lethal payload."
	caliber = "mag_e"
	icon = 'hippiestation/icons/obj/guns/cit_guns.dmi'
	icon_state = "mag-casing-live"
	projectile_type = /obj/item/projectile/bullet/nlmags
	energy_cost = 125

///magazines///

/obj/item/ammo_box/magazine/mmag_e/
	name = "magrifle magazine (non-lethal disabler)"
	icon = 'hippiestation/icons/obj/guns/cit_guns.dmi'
	icon_state = "mediummagmag"
	ammo_type = /obj/item/ammo_casing/caseless/mag_e/anlmagm_e
	caliber = "mag_e"
	max_ammo = 24
	multiple_sprites = 2

/obj/item/ammo_box/magazine/mmag_e/lethal
	name = "magrifle magazine (lethal)"
	icon = 'hippiestation/icons/obj/guns/cit_guns.dmi'
	icon_state = "mediummagmag"
	ammo_type = /obj/item/ammo_casing/caseless/mag_e/amagm_e
	max_ammo = 24

/obj/item/ammo_box/magazine/mmag_e/small
	name = "magpistol magazine (non-lethal disabler)"
	icon = 'hippiestation/icons/obj/guns/cit_guns.dmi'
	icon_state = "smallmagmag"
	ammo_type = /obj/item/ammo_casing/caseless/mag_e/anlmags
	caliber = "mag_e"
	max_ammo = 16
	multiple_sprites = 2

/obj/item/ammo_box/magazine/mmag_e/small/lethal
	name = "magpistol magazine (lethal)"
	icon = 'hippiestation/icons/obj/guns/cit_guns.dmi'
	icon_state = "smallmagmag"
	ammo_type = /obj/item/ammo_casing/caseless/mag_e/amags
	max_ammo = 16
