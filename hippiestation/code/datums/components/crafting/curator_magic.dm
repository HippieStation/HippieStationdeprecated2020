
//**************************************************
//*********************TIER 1***********************
//**************************************************

/datum/crafting_recipe/tier1
	tools = list(/obj/item/screwdriver/obelisk)
	always_availible = FALSE
	category = CAT_MAGIC
	subcategory = CAT_TIER1

/datum/crafting_recipe/tier1/obelisk
	name = "mysterious obelisk"
	result = /obj/structure/destructible/obelisk
	reqs = list(/obj/item/paper = 1)
	tools = list()
	time = 150

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
				/datum/reagent/space_cleaner = 25,
				/obj/item/clothing/shoes = 1,
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
				/obj/item/dice = 20,)
	time = 100

/datum/crafting_recipe/tier1/lazarusinjector
	name = "lazarus injector"
	result = /obj/item/lazarus_injector
	reqs = list(/obj/item/inscripture = 1,
				/datum/reagent/teslium = 20,
				/datum/reagent/blood = 100,
				/obj/item/stock_parts/manipulator = 3
				)

//**************************************************
//*********************TIER 2***********************
//**************************************************

/datum/crafting_recipe/tier2
	tools = list(/obj/item/screwdriver/obelisk/tier2)
	always_availible = FALSE
	category = CAT_MAGIC
	subcategory = CAT_TIER2

/datum/crafting_recipe/tier2/obelisk
	name = "greater obelisk"
	result = /obj/structure/destructible/obelisktier2
	reqs = list(/obj/item/paper = 1)
	tools = list(/obj/item/screwdriver/obelisk)
	time = 200

/datum/crafting_recipe/tier2/telecrystal
	name = "one telecrystal"
	result = /obj/item/stack/telecrystal
	reqs = list(/obj/item/inscripture = 1,
				/obj/item/stack/ore/bluespace_crystal = 7,)
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
				/obj/item/reagent_containers/food/snacks/meat/slab/corgi = 1,
				/obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/lizard = 1,
				/obj/item/reagent_containers/food/snacks/meat/slab/human = 1,
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
				/obj/item/stack/sheet/mineral/silver = 1,)

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