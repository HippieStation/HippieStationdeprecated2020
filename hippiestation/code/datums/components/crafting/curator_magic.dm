
//**************************************************
//*********************TIER 1***********************
//**************************************************

/datum/crafting_recipe/tier1
	tools = list(/obj/item/tier1)
	always_availible = FALSE
	category = CAT_MAGIC
	subcategory = CAT_TIER1

/datum/crafting_recipe/tier1/obelisk
	name = "mysterious obelisk"
	result = /obj/structure/destructible/obelisk
	reqs = list(/obj/item/organ/brain = 1,
				/obj/item/stack/sheet/plasteel = 5,
				/obj/item/stack/sheet/metal = 100,
				/datum/reagent/blood = 200,
				)
	tools = list()
	time = 150

/datum/crafting_recipe/tier1/doorwand
	name = "crude wand of door creation"
	result = /obj/item/gun/magic/wand/door/shitty
	reqs = list(/obj/item/inscripture = 1,
				/obj/item/electronics/airlock = 3,
				/obj/item/stack/rods = 1,
				)
	time = 70

/datum/crafting_recipe/tier1/upgradescroll
	name = "upgrade scroll"
	result = /obj/item/upgradescroll
	reqs = list(/obj/item/inscripture = 1,
				/obj/item/stack/packageWrap = 1,
				/obj/item/stamp = 1,
				/obj/item/pen = 1,
				/obj/item/stock_parts/manipulator = 1,
				)
	time = 40

/datum/crafting_recipe/tier1/sord
	name = "magic sword"
	result = /obj/item/sord
	reqs = list(/obj/item/inscripture = 1,
				/obj/item/toy/crayon = 1,
				/obj/item/stack/rods = 1,
				/obj/item/stack/ducttape = 1,
				)
	time = 60

/datum/crafting_recipe/tier1/magicsoap
	name = "magical soap"
	result = /obj/item/soap
	reqs = list(/obj/item/inscripture = 1,
				/datum/reagent/water = 50,
				/datum/reagent/space_cleaner = 25
				)
	time = 50

/datum/crafting_recipe/tier1/immortalitytalisman
	name = "Immortality Talisman"
	result = /obj/item/immortality_talisman
	reqs = list(/obj/item/inscripture = 1,
				/obj/item/upgradescroll = 1,
				/obj/item/circuitboard/machine/clonepod = 1,
				/obj/item/organ/heart = 1,
				)
	time = 100

/datum/crafting_recipe/tier1/d100
	name = "one-hundred sided die"
	result = /obj/item/dice/d00
	reqs = list(/obj/item/inscripture = 1,
				/obj/item/dice = 20)
	time = 100

/datum/crafting_recipe/tier1/lazarusinjector
	name = "lazarus injector"
	result = /obj/item/lazarus_injector
	reqs = list(/obj/item/inscripture = 1,
				/datum/reagent/teslium = 20,
				/datum/reagent/blood = 100,
				/obj/item/stock_parts/manipulator = 3
				)
	time = 70

//**************************************************
//*********************TIER 2***********************
//**************************************************

/datum/crafting_recipe/tier2
	tools = list(/obj/item/tier2)
	always_availible = FALSE
	category = CAT_MAGIC
	subcategory = CAT_TIER2

/datum/crafting_recipe/tier2/obelisk
	name = "greater obelisk"
	result = /obj/structure/destructible/obelisktier2
	reqs = list(/obj/item/organ/brain = 1,
				/obj/item/organ/heart = 1,
				/obj/item/organ/butt = 1,
				/obj/item/stack/sheet/plasteel = 10,
				/obj/item/stack/sheet/metal = 75,
				/obj/item/stack/sheet/mineral/silver = 10,
				/obj/item/multitool = 1,
				/obj/item/stock_parts/manipulator = 3,
				/obj/item/stock_parts/cell/high = 1,
				/obj/item/geiger_counter = 1
				)
	tools = list(/obj/item/tier1)
	time = 200

/datum/crafting_recipe/tier2/telecrystal
	name = "one telecrystal"
	result = /obj/item/stack/telecrystal
	reqs = list(/obj/item/inscripture = 1,
				/obj/item/stack/ore/bluespace_crystal = 7)
	time = 30

/datum/crafting_recipe/tier2/shittyrevivewand
	name = "crude wand of healing"
	result = /obj/item/gun/magic/wand/resurrection/shitty
	reqs = list(/obj/item/inscripture = 1,
				/obj/item/lazarus_injector = 1,
				/obj/item/defibrillator/loaded = 1,
				/obj/item/reagent_containers/pill/patch/silver_sulf = 1,
				/obj/item/reagent_containers/pill/patch/styptic = 1,
				/datum/reagent/medicine/charcoal = 30,
				/datum/reagent/medicine/perfluorodecalin = 15,
				)
	time = 100

/datum/crafting_recipe/tier2/shittysafetywand
	name = "crude wand of safety"
	result = /obj/item/gun/magic/wand/safety/shitty
	reqs = list(/obj/item/inscripture = 1,
				/obj/item/immortality_talisman = 1,
				/obj/item/stack/ore/bluespace_crystal = 1,
				/obj/item/stack/rods = 1,
				)
	time = 100

/datum/crafting_recipe/tier2/monstercube
	name = "monster cube"
	result = /obj/item/reagent_containers/food/snacks/monkeycube/monstercube
	reqs = list(/obj/item/inscripture = 1,
				/obj/item/reagent_containers/food/snacks/monkeycube = 1,
				/obj/item/reagent_containers/food/snacks/monkeycube/cowcube = 1,
				/obj/item/reagent_containers/food/snacks/monkeycube/chickencube = 1,
				/datum/reagent/toxin/mutagen = 1
				)
	time = 50

/datum/crafting_recipe/tier2/soulshard
	name = "mysterious old shard"
	result = /obj/item/soulstone/anybody/chaplain
	reqs = list(/obj/item/inscripture = 1,
				/obj/item/shard = 1,
				/datum/reagent/blood = 400,
				)
	time = 50

/datum/crafting_recipe/tier2/spectralblade
	name = "spectral blade"
	result = /obj/item/melee/ghost_sword
	reqs = list(/obj/item/inscripture = 1,
				/obj/item/sord = 1,
				/obj/item/upgradescroll = 1,
				/obj/item/radio = 1,
				/obj/item/stack/sheet/mineral/silver = 1)

	time = 50

/datum/crafting_recipe/tier2/lighteater
	name = "Nightmare's Light Eater"
	result = /obj/item/light_eater
	reqs = list(/obj/item/inscripture = 1,
				/obj/item/nullrod = 1,
				/obj/machinery/light/small = 1,
				/obj/machinery/light = 1,
				/obj/item/flashlight = 1,
				)
	time = 100

//**************************************************
//*********************TIER 3***********************
//**************************************************

/datum/crafting_recipe/tier3
	tools = list(/obj/item/tier3)
	always_availible = FALSE
	category = CAT_MAGIC
	subcategory = CAT_TIER3

/datum/crafting_recipe/tier3/obelisk
	name = "Obelisk of Limitless Wisdom"
	result = /obj/structure/destructible/obelisktier3
	reqs = list(/obj/item/organ/brain = 1,
				/obj/item/organ/heart = 1,
				/obj/item/organ/lungs = 1,
				/obj/item/bodypart/l_arm = 1,
				/obj/item/bodypart/r_arm = 1,
				/obj/item/bodypart/l_leg = 1,
				/obj/item/bodypart/r_leg = 1,
				/obj/item/organ/butt = 1,
				/obj/item/stack/sheet/plasteel = 15,
				/obj/item/stack/sheet/bluespace_crystal = 3,
				/obj/item/stock_parts/manipulator/pico = 5,
				/obj/item/stock_parts/cell/high = 4,
				/obj/item/stock_parts/subspace/amplifier = 1,
				/obj/item/stock_parts/subspace/transmitter = 1,
				)
	tools = list(/obj/item/tier2)
	time = 250

/datum/crafting_recipe/tier3/oneusedieoffate
	name = "one use Die of Fate"
	result = /obj/item/dice/d20/fate/one_use
	reqs = list(/obj/item/inscripture = 1,
				/obj/item/dice/d100 = 1,
				)
	time = 40

/datum/crafting_recipe/tier3/nullrod
	name = "null rod"
	result = /obj/item/nullrod
	reqs = list(/obj/item/melee/ghost_sword = 1,
				/obj/item/upgradescroll = 1,
				/datum/reagent/water/holywater = 100,
				)
	time = 60