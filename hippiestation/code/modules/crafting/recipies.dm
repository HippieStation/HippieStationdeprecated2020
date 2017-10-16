/datum/crafting_recipe/stunprod
	result = /obj/item/melee/baton/cattleprod/hippie_cattleprod

/datum/crafting_recipe/butterfly
	name = "Butterfly Knife"
	result = /obj/item/melee/transforming/butterfly
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/scalpel = 1,
				/obj/item/stack/sheet/plasteel = 6)
	tools = list(/obj/item/weldingtool, /obj/item/screwdriver, /obj/item/wirecutters)
	time = 100
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/IEDStrong
	name = "Stronger IED"
	result = /obj/item/grenade/iedcasing/upgrade
	reqs = list(/datum/reagent/fuel = 100,
				/obj/item/stack/cable_coil = 2,
				/obj/item/device/assembly/igniter = 1,
				/obj/item/reagent_containers/food/drinks/soda_cans = 1)
	parts = list(/obj/item/reagent_containers/food/drinks/soda_cans = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
