/datum/crafting_recipe/learned
	category = CAT_LEARNED
	always_availible = FALSE

/datum/crafting_recipe/learned/ushanka
	name = "Ushanka"
	result = /obj/item/clothing/head/ushanka
	reqs = list(/obj/item/stack/sheet/mineral/silver = 1,
				/obj/item/stack/sheet/leather = 3,
				/obj/item/stack/cable_coil = 10)
	time = 30
	tools = list(TOOL_WIRECUTTER)

/datum/crafting_recipe/learned/moistnugget
	name = "Mosin Nagant"
	result = /obj/item/gun/ballistic/rifle/boltaction
	reqs = list(/obj/item/stack/rods = 1,
				/obj/item/stack/sheet/mineral/wood = 5,
				/obj/item/stack/sheet/metal = 10,
				/obj/item/weaponcrafting/receiver = 1)
	time = 60
	tools = list(TOOL_WIRECUTTER, TOOL_WELDER, TOOL_SCREWDRIVER)

/datum/crafting_recipe/learned/bodka
	name = "Vodka"
	result = /obj/item/reagent_containers/food/drinks/bottle/vodka/badminka
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/potato = 4,
				/obj/item/stack/sheet/glass = 1,
				/obj/item/pipe = 1)
	time = 30
	tools = list(TOOL_WELDER, TOOL_WRENCH)

/datum/crafting_recipe/learned/russiansuit
	name = "Soviet Suit"
	result = /obj/item/clothing/under/soviet
	reqs = list(/obj/item/stack/sheet/cloth = 4,
				/obj/item/stack/sheet/metal = 1)
	time = 30
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)

/datum/crafting_recipe/learned/moistclip
	name = "stripper clip (7.62mm)"
	result = /obj/item/ammo_box/a762
	reqs = list(/datum/reagent/blackpowder = 15,
				/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/tile/bronze = 1)
	time = 20
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER, TOOL_WELDER)

/datum/crafting_recipe/learned/beans
	name = "Tin of Beans"
	result = /obj/item/reagent_containers/food/snacks/beans
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/soybeans = 10,
				/obj/item/stack/sheet/metal = 1)
	time = 40
	tools = list(TOOL_WELDER, TOOL_WIRECUTTER)

/datum/crafting_recipe/learned/c4
	name = "C4 Brick"
	result = /obj/item/grenade/plastic/c4
	reqs = list(/obj/item/stack/sheet/plastic = 20,
				/obj/item/stack/rods = 3,
				/datum/reagent/copper = 50,
				/obj/item/stack/sheet/mineral/gold = 5)
	tools = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER)

/datum/crafting_recipe/learned/grenade
	name = "Frag Grenade"
	result = /obj/item/grenade/syndieminibomb/concussion/frag
	reqs = list(/datum/reagent/blackpowder = 50,
				/obj/item/grenade/chem_grenade/large = 1,
				/obj/item/stack/rods = 10,
				/obj/item/stack/sheet/metal = 5)
	tools = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER)

/datum/crafting_recipe/learned/holyhandgrenade
	name = "Holy Hand Grenade"
	result = /obj/item/grenade/chem_grenade/holy
	reqs = list(/datum/reagent/potassium = 200,
				/datum/reagent/water/holywater = 50,
				/obj/item/grenade/chem_grenade/large = 1,
				/obj/item/stack/rods = 10,
				/obj/item/stack/sheet/metal = 5)
	tools = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER)

/datum/crafting_recipe/learned/warcrimegrenade
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

/datum/crafting_recipe/learned/empbomb
	name = "EMP Grenade"
	result = /obj/item/grenade/empgrenade
	reqs = list(/datum/reagent/uranium = 100,
				/datum/reagent/iron = 100,
				/obj/item/grenade/chem_grenade/large = 1,
				/obj/item/stack/rods = 10,
				/obj/item/stack/sheet/metal = 5)
	tools = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER)

/datum/crafting_recipe/learned/paperhouse
	name = "paper house"
	result = /obj/item/storage/paperhouse
	reqs = list(/obj/item/paper = 5)
	tools = list() //don't need tools in origami
	time = 60

/datum/crafting_recipe/learned/fakespellbook
	name = "fake spellbook"
	result = /obj/item/storage/book/fake_spellbook
	reqs = list(/obj/item/paper = 8)
	tools = list()
	time = 70

/datum/crafting_recipe/learned/papersword
	name = "paper sword"
	result = /obj/item/melee/paper_sword
	reqs = list(/obj/item/paper = 3)
	tools = list()
	time = 40

/datum/crafting_recipe/learned/paperstar
	name = "paper throwing star"
	result = /obj/item/throwing_star/paper
	reqs = list(/obj/item/paper = 1)
	tools = list()
	time = 10

/datum/crafting_recipe/learned/papercuffs
	name = "paper handcuffs"
	result = /obj/item/restraints/handcuffs/paper
	reqs = list(/obj/item/paper = 2)
	tools = list()
	time = 15

/datum/crafting_recipe/learned/paperid
	name = "paper identification card"
	result = /obj/item/card/id/paper
	reqs = list(/obj/item/paper = 3)
	tools = list()
	time = 100