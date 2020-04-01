/*
/datum/design/gauss_rifle
	name = "Gauss Rifle"
	desc = "A seriously powerful rifle with an electromagnetic acceleration core, capable of blowing limbs off."
	id = "gaussrifle"
	build_type = PROTOLATHE
	materials = list(MAT_SILVER = 8000, MAT_URANIUM = 8000, MAT_GLASS = 12000, MAT_METAL = 12000, MAT_GOLD = 10000)
	build_path = /obj/item/gun/energy/gauss
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY
*/

/datum/design/xcomammo
	id = "xcomammo"
	build_type = PROTOLATHE
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY
	build_path = /obj/item/ammo_box/magazine/xcomammo
	materials = list(MAT_METAL = 8000, MAT_PLASMA = 1500)
	name = "6.7mm magazine"
	desc = "Perfect for mass rushes of squaddies and rookies."

/datum/design/xcomrifle
	id = "xcomrifle"
	build_type = PROTOLATHE
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY
	build_path = /obj/item/gun/ballistic/automatic/xcomrifle
	materials = list(MAT_METAL = 20000, MAT_TITANIUM = 1000, MAT_PLASMA = 4000, MAT_PLASTIC = 500)
	name = "6.7mm rifle"
	desc = "An old Earth classic, used by X-COM Operatives during the First Alien War. It's usefullness died with the development of the laser rifle."
