/datum/design/forge//this should ONLY be used for items with a reagent_type var and assign_properties proc, if you use it in any other manner I will shout at you
	build_type = REAGENT_FORGE


/datum/design/forge/forged_dagger
	name = "Custom Dagger"
	id = "fdagger"
	materials = list(/datum/material/reagent = 2000)
	build_path = /obj/item/forged/melee/dagger
	category = list("initial", "Weaponry")

/datum/design/forge/forged_sword
	name = "Custom Sword"
	id = "fsword"
	materials = list(/datum/material/reagent = 6000)
	build_path = /obj/item/forged/melee/sword
	category = list("initial", "Weaponry")

/datum/design/forge/forged_greatsword
	name = "Custom Greatsword"
	id = "fgsword"
	materials = list(/datum/material/reagent = 8000)
	build_path = /obj/item/twohanded/forged/greatsword
	category = list("initial", "Weaponry")

/datum/design/forge/forged_mace
	name = "Custom Mace"
	id = "fmace"
	materials = list(/datum/material/reagent = 6500)
	build_path = /obj/item/forged/melee/mace
	category = list("initial", "Weaponry")

/datum/design/forge/forged_warhammer
	name = "Custom Warhammer"
	id = "fwhammer"
	materials = list(/datum/material/reagent = 10000)
	build_path = /obj/item/twohanded/forged/warhammer
	category = list("initial", "Weaponry")

/datum/design/forge/forged_bullet
	name = "Custom Bullet"
	id = "fbullet"
	materials = list(/datum/material/reagent = 1000)
	build_path = /obj/item/ammo_casing/forged
	category = list("initial", "Weaponry")
