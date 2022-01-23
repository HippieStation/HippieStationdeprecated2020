// nah
/datum/design/a357
	materials = list(MAT_METAL = 60000)

/datum/design/m1911ammo
	name = "M1911 Magazine"
	id = "1911ammo"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 30000, MAT_GLASS = 1000)
	build_path = /obj/item/ammo_box/magazine/m45
	category = list("hacked", "Security")

/datum/design/g17ammo
	name = "Glock 17 Magazine"
	id = "g17ammo"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 30000, MAT_GLASS = 1000)
	build_path = /obj/item/ammo_box/magazine/g17
	category = list("hacked", "Security")

/datum/design/record_disk
	name = "Record Disk"
	id = "record_disk"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 10, MAT_GLASS = 80)
	build_path = /obj/item/record_disk
	category = list("initial", "Misc")