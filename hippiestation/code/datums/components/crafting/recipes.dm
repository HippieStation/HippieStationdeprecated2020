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

/datum/crafting_recipe/m1911
	name = "M1911"
	result = /obj/item/gun/ballistic/automatic/pistol/m1911
	reqs = list(/obj/item/stack/sheet/plasteel = 5,
				/obj/item/weaponcrafting/receiver = 1,
				/obj/item/stack/packageWrap = 10,
				/obj/item/stack/sheet/plastic = 10)
	tools = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	time = 200
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/shitglock
	name = "Glock 16"
	result = /obj/item/gun/ballistic/automatic/pistol/g17/improvised
	reqs = list(/obj/item/reagent_containers/food/drinks/soda_cans = 1,
				/obj/item/stack/sheet/metal = 20,
				/obj/item/stack/cable_coil = 20,
				/obj/item/pipe = 5,
				/obj/item/stack/ducttape = 5,
				/obj/item/stack/packageWrap = 10)
	tools = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	time = 70
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

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

/datum/crafting_recipe/makeshiftlasrifle
	name = "makeshift laser rifle"
	result = /obj/item/gun/energy/laser/makeshiftlasrifle
	reqs = list(/obj/item/stack/cable_coil = 15,
				/obj/item/weaponcrafting/stock = 1,
				/obj/item/pipe = 1,
				/obj/item/light/bulb = 1,
				/obj/item/stock_parts/cell = 1)
	tools = list(/obj/item/screwdriver)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/triplethreat
	name = "Triple-Barrel Shotgun"
	result = /obj/item/gun/ballistic/shotgun/triplebarrel
	reqs = list(/obj/item/pipe = 1,
				/obj/item/gun/ballistic/shotgun/doublebarrel =1,
				/obj/item/stack/sheet/metal = 10,
				/obj/item/stack/wrapping_paper = 5)
	time = 50
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_CROWBAR)
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/ushanka
	name = "Ushanka"
	result = /obj/item/clothing/head/ushanka
	reqs = list(/obj/item/stack/sheet/mineral/silver = 1,
				/obj/item/stack/sheet/leather = 3,
				/obj/item/stack/cable_coil = 10)
	time = 30
	tools = list(TOOL_WIRECUTTER)
	category = CAT_CLOTHING
	always_availible = FALSE

/datum/crafting_recipe/moistnugget
	name = "Mosin Nagant"
	result = /obj/item/gun/ballistic/rifle/boltaction
	reqs = list(/obj/item/stack/rods = 1,
				/obj/item/stack/sheet/mineral/wood = 5,
				/obj/item/stack/sheet/metal = 10,
				/obj/item/weaponcrafting/receiver = 1)
	time = 60
	tools = list(TOOL_WIRECUTTER, TOOL_WELDER, TOOL_SCREWDRIVER)
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

/datum/crafting_recipe/bodka
	name = "Vodka"
	result = /obj/item/reagent_containers/food/drinks/bottle/vodka/badminka
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/potato = 4,
				/obj/item/stack/sheet/glass = 1,
				/obj/item/pipe = 1)
	time = 30
	tools = list(TOOL_WELDER, TOOL_WRENCH)
	category = CAT_FOOD
	always_availible = FALSE

/datum/crafting_recipe/russiansuit
	name = "Soviet Suit"
	result = /obj/item/clothing/under/soviet
	reqs = list(/obj/item/stack/sheet/cloth = 4,
				/obj/item/stack/sheet/metal = 1)
	time = 30
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	category = CAT_CLOTHING
	always_availible = FALSE

/datum/crafting_recipe/moistclip
	name = "stripper clip (7.62mm)"
	result = /obj/item/ammo_box/a762
	reqs = list(/datum/reagent/blackpowder = 15,
				/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/tile/bronze = 1)
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER, TOOL_WELDER)
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO
	always_availible = FALSE

/datum/crafting_recipe/beans
	name = "Tin of Beans"
	result = /obj/item/reagent_containers/food/snacks/beans
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/soybeans = 10,
				/obj/item/stack/sheet/metal = 1)
	time = 40
	tools = list(TOOL_WELDER, TOOL_WIRECUTTER)
	category = CAT_FOOD
	always_availible = FALSE

/datum/crafting_recipe/c4
	name = "C4 Brick"
	result = /obj/item/grenade/plastic/c4
	reqs = list(/obj/item/stack/sheet/plastic = 20,
				/obj/item/stack/rods = 3,
				/datum/reagent/copper = 50,
				/obj/item/stack/sheet/mineral/gold = 5)
	tools = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER)
	always_availible = FALSE
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/grenade
	name = "Frag Grenade"
	result = /obj/item/grenade/syndieminibomb/concussion/frag
	reqs = list(/datum/reagent/blackpowder = 50,
				/obj/item/grenade/chem_grenade/large = 1,
				/obj/item/stack/rods = 10,
				/obj/item/stack/sheet/metal = 5)
	tools = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER)
	always_availible = FALSE
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
				
/datum/crafting_recipe/holyhandgrenade
	name = "Holy Hand Grenade"
	result = /obj/item/grenade/chem_grenade/holy
	reqs = list(/datum/reagent/potassium = 200,
				/datum/reagent/water/holywater = 50,
				/obj/item/grenade/chem_grenade/large = 1,
				/obj/item/stack/rods = 10,
				/obj/item/stack/sheet/metal = 5)
	tools = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER)
	always_availible = FALSE
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/warcrimegrenade
	name = "Biological Warfare Grenade"
	result = /obj/item/grenade/chem_grenade/tuberculosis
	reqs = list(/obj/item/reagent_containers/glass/beaker/bluespace/ = 2,
				/datum/reagent/blood = 200,
				/datum/reagent/phosphorus = 100,
				/datum/reagent/consumable/sugar = 100,
				/datum/reagent/potassium = 100,
				/datum/reagent/uranium = 60,
				/datum/reagent/plantnutriment/eznutriment = 50,
				/obj/item/grenade/chem_grenade/large = 1,
				/obj/item/stack/rods = 10,
				/obj/item/stack/sheet/metal = 5)
	tools = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER)
	always_availible = FALSE
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/empbomb
	name = "EMP Grenade"
	result = /obj/item/grenade/empgrenade
	reqs = list(/datum/reagent/uranium = 100,
				/datum/reagent/iron = 100,
				/obj/item/grenade/chem_grenade/large = 1,
				/obj/item/stack/rods = 10,
				/obj/item/stack/sheet/metal = 5)
	tools = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER)
	always_availible = FALSE
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
