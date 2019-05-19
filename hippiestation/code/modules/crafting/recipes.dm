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

/datum/crafting_recipe/garrote_handles //Still need to apply some wires to finish it
	name = "Garrote Handles"
	result = /obj/item/garrotehandles
	reqs = list(/obj/item/stack/cable_coil = 15,
				/obj/item/stack/rods = 1,)
	tools = list(/obj/item/weldingtool)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/buttshoes
	name = "butt shoes"
	result = /obj/item/clothing/shoes/buttshoes
	reqs = list(/obj/item/organ/butt = 2,
				/obj/item/clothing/shoes/sneakers = 1)
	tools = list(/obj/item/wirecutters)
	time = 50
	category = CAT_CLOTHING

/datum/crafting_recipe/crossbow_improv
	name = "Improvised Crossbow"
	result = /obj/item/gun/ballistic/crossbow/improv
	reqs = list(/obj/item/stack/rods = 3,
		        /obj/item/stack/cable_coil = 10,
		        /obj/item/weaponcrafting/stock = 1)
	tools = list(/obj/item/weldingtool,
		         /obj/item/screwdriver)
	time = 150
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/reverse_bear_trap
	name = "Reverse Bear trap"
	result = /obj/item/reverse_bear_trap
	reqs = list(/obj/item/restraints/legcuffs/beartrap = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/assembly/timer = 1)
	tools = list(/obj/item/screwdriver)
	time = 150
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/bbat_spiked
	name = "Spiked Bat"
	result = /obj/item/melee/baseball_bat/spiked
	reqs = list(/obj/item/stack/rods = 5,
		        /obj/item/melee/baseball_bat = 1) //no need for a hammer, he just whacks the rod with the bat when it's on the floor or smth, like a nail </autism>
	time = 100
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/woodenmug
	name = "Wooden Mug"
	result = /obj/item/reagent_containers/glass/woodmug
	reqs = list(/obj/item/stack/sheet/mineral/wood = 2)
	time = 20
	category = CAT_PRIMAL

/datum/crafting_recipe/wheelchair
	name = "Wheelchair"
	result = /obj/vehicle/ridden/wheelchair
	reqs = list(/obj/item/stack/sheet/metal = 4,
				/obj/item/stack/rods = 6)
	time = 100
	category = CAT_MISC

/datum/crafting_recipe/bonesword
	name = "Bone Sword"
	result = /obj/item/claymore/bone
	reqs = list(/obj/item/stack/sheet/bone = 3)
	time = 75
	category = CAT_PRIMAL

/datum/crafting_recipe/knifeboxing
	name = "Knife-boxing Gloves"
	result = /obj/item/clothing/gloves/knifeboxing
	reqs = list(/obj/item/clothing/gloves/boxing = 1,
				/obj/item/kitchen/knife = 2)
	time = 100
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/lockermech
	name = "Locker Mech"
	result = /obj/mecha/makeshift
	reqs = list(/obj/item/stack/cable_coil = 20,
				/obj/item/stack/sheet/metal = 10,
				/obj/item/storage/toolbox = 2, // For feet
				/obj/item/tank/internals/oxygen = 1, // For air
				/obj/item/electronics/airlock = 1, //You are stealing the motors from airlocks
				/obj/item/extinguisher = 1, //For bastard pnumatics
				/obj/item/stack/ducttape = 5, //to make it airtight
				/obj/item/flashlight = 1, //For the mech light
				/obj/item/stack/rods = 4, //to mount the equipment
				/obj/item/pipe = 2) //For legs
	tools = list(/obj/item/weldingtool, /obj/item/screwdriver, /obj/item/wirecutters)
	time = 200
	category = CAT_ROBOT

/datum/crafting_recipe/lockermechdrill
	name = "Makeshift exosuit drill"
	result = /obj/item/mecha_parts/mecha_equipment/drill/makeshift
	reqs = list(/obj/item/stack/cable_coil = 5,
				/obj/item/stack/sheet/metal = 2,
				/obj/item/surgicaldrill = 1)
	tools = list(/obj/item/screwdriver)
	time = 50
	category = CAT_ROBOT

/datum/crafting_recipe/lockermechclamp
	name = "Makeshift exosuit clamp"
	result = /obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/makeshift
	reqs = list(/obj/item/stack/cable_coil = 5,
				/obj/item/stack/sheet/metal = 2,
				/obj/item/wirecutters = 1) //Don't ask, its just for the grabby grabby thing
	tools = list(/obj/item/screwdriver)
	time = 50
	category = CAT_ROBOT

/datum/crafting_recipe/watcherproj
	name = "Watcher Projector"
	result = /obj/item/gun/energy/watcherprojector
	reqs = list(/obj/item/stack/sheet/bone = 3,
				/obj/item/stack/ore/diamond = 2,
				/obj/item/stack/sheet/sinew = 2)
	time = 150
	category = CAT_PRIMAL

/datum/crafting_recipe/glasshatchet
	name = "Makeshift glass hatchet"
	result = /obj/item/hatchet/improvised
	reqs = list(/obj/item/stack/ducttape = 4,
				/obj/item/shard = 1,
				/obj/item/wrench = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/crowbar_ghetto
	name = "ghetto crowbar"
	result = /obj/item/crowbar/ghetto
	reqs = list(/obj/item/stack/sheet/metal = 3) //just bang them together
	time = 120
	category = CAT_MISC

/datum/crafting_recipe/wrench_ghetto
	name = "ghetto wrench"
	result = /obj/item/wrench/ghetto
	reqs = list(/obj/item/stack/sheet/metal = 2)
	time = 120
	category = CAT_MISC

/datum/crafting_recipe/wirecutters_ghetto
	name = "ghetto wirecutters"
	result = /obj/item/wirecutters/ghetto
	reqs = list(/obj/item/stack/sheet/metal = 2,
				/obj/item/stack/rods = 2)
	time = 150
	category = CAT_MISC

/datum/crafting_recipe/welder_ghetto
	name = "ghetto welding tool"
	result = /obj/item/weldingtool/ghetto
	reqs = list(/obj/item/tank/internals/emergency_oxygen = 1,
				/obj/item/assembly/igniter = 1)
	time = 160
	category = CAT_MISC

/datum/crafting_recipe/multitool_ghetto
	name = "ghetto multitool"
	result = /obj/item/multitool/ghetto
	reqs = list(/obj/item/radio/headset = 1,
				/obj/item/stack/sheet/metal = 2,
				/obj/item/screwdriver)
	time = 160
	category = CAT_MISC

/datum/crafting_recipe/screwdriver_ghetto
	name = "ghetto screwdriver"
	result = /obj/item/screwdriver/ghetto
	reqs = list(/obj/item/stack/sheet/metal = 2,
				/obj/item/stack/rods = 1)
	time = 120
	category = CAT_MISC
