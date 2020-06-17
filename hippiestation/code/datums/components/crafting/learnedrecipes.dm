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


//Trapping

/datum/crafting_recipe/learned/beartrap
	name = "bear trap"
	result = /obj/item/restraints/legcuffs/beartrap
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/rods = 3,
				/obj/item/shard = 5,
				/obj/item/stack/ducttape = 1,
				)
	tools = list(TOOL_WELDER)
	time = 40

/datum/crafting_recipe/learned/mousetrap
	name = "mouse trap"
	result = /obj/item/assembly/mousetrap
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1,
				/obj/item/stack/rods = 1,
				)
	tools = list(TOOL_SCREWDRIVER)
	time = 10

/datum/crafting_recipe/learned/dummymine //using this as a copy/paste base for the other mines
	name = "dummy mine"
	result = /obj/item/mine
	reqs = list(/obj/item/stack/sheet/metal = 10,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/rods = 5,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/assembly/igniter = 1,
				)
	tools = list(TOOL_WIRECUTTER, TOOL_SCREWDRIVER, TOOL_MULTITOOL)
	time = 50

/datum/crafting_recipe/learned/explosivemine
	name = "explosive mine"
	result = /obj/item/mine/explosive
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/rods = 5,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/assembly/igniter = 1,
				/datum/reagent/blackpowder = 100,
				/datum/reagent/fuel = 100
				)
	tools = list(TOOL_WIRECUTTER, TOOL_SCREWDRIVER, TOOL_MULTITOOL)
	time = 100

/datum/crafting_recipe/learned/plasmamine
	name = "plasma-fire mine"
	result = /obj/item/mine/gas/plasma
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/rods = 5,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/assembly/igniter = 1,
				/datum/reagent/thermite = 50,
				/obj/item/stack/sheet/mineral/plasma = 10,
				)
	tools = list(TOOL_WIRECUTTER, TOOL_SCREWDRIVER, TOOL_MULTITOOL)
	time = 100

/datum/crafting_recipe/learned/honkmine
	name = "HONK mine"
	result = /obj/item/mine/sound
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/rods = 5,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/assembly/igniter = 1,
				/obj/item/taperecorder = 1,
				)
	tools = list(TOOL_WIRECUTTER, TOOL_SCREWDRIVER, TOOL_MULTITOOL, /obj/item/bikehorn)
	time = 50

/datum/crafting_recipe/learned/bwoinkmine
	name = "bwoink mine"
	result = /obj/item/mine/sound/bwoink
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/rods = 5,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/assembly/igniter = 1,
				/obj/item/taperecorder = 1,
				)
	tools = list(TOOL_WIRECUTTER, TOOL_SCREWDRIVER, TOOL_MULTITOOL, /obj/item/banhammer)
	time = 50


//Instruments

/datum/crafting_recipe/learned/musicalbikehorn
	name = "gilded bike horn"
	result = /obj/item/instrument/bikehorn
	reqs = list(/obj/item/bikehorn/golden = 1,
				)
	tools = list(/obj/item/bikehorn/airhorn, /obj/item/bikehorn)
	time = 30

/datum/crafting_recipe/learned/toysaxophone
	name = "toy saxophone"
	result = /obj/item/saxophone
	reqs = list(/obj/item/instrument/saxophone = 1,
				/obj/item/taperecorder = 1,
				/obj/item/stack/ducttape = 1,
				)
	tools = list(TOOL_SCREWDRIVER)
	time = 40

/datum/crafting_recipe/learned/toyguitar
	name = "toy guitar"
	result = /obj/item/guitar
	reqs = list(/obj/item/instrument/guitar = 1,
				/obj/item/instrument/eguitar = 1,
				/obj/item/taperecorder = 1,
				/obj/item/stack/ducttape = 1,
				)
	tools = list(TOOL_SCREWDRIVER)
	time = 40

/datum/crafting_recipe/learned/vuvuzela
	name = "vuvuzela"
	result = /obj/item/paradoxical_vuvuzela
	reqs = list(/obj/item/instrument/accordion = 1,
				/obj/item/instrument/bikehorn = 1,
				/obj/item/instrument/eguitar = 1,
				/obj/item/instrument/glockenspiel = 1,
				/obj/item/instrument/guitar = 1,
				/obj/item/instrument/harmonica = 1,
				/obj/item/instrument/piano_synth = 1,
				/obj/item/instrument/recorder = 1,
				/obj/item/instrument/saxophone = 1,
				/obj/item/instrument/trombone = 1,
				/obj/item/instrument/trumpet = 1,
				/obj/item/instrument/violin = 1,
				/obj/item/stack/ducttape = 1,
				)
	tools = list(/obj/item/bikehorn)
	parts = list(/obj/item/instrument/accordion = 1,
				/obj/item/instrument/bikehorn = 1,
				/obj/item/instrument/eguitar = 1,
				/obj/item/instrument/glockenspiel = 1,
				/obj/item/instrument/guitar = 1,
				/obj/item/instrument/harmonica = 1,
				/obj/item/instrument/piano_synth = 1,
				/obj/item/instrument/recorder = 1,
				/obj/item/instrument/saxophone = 1,
				/obj/item/instrument/trombone = 1,
				/obj/item/instrument/trumpet = 1,
				/obj/item/instrument/violin = 1,
				)
	time = 150


//Healthy working environment

/datum/crafting_recipe/learned/poster
	name = "official poster"
	result = /obj/item/poster/random_official
	reqs = list(/obj/item/paper = 6,
				/obj/item/stack/staples = 4,
				)
	tools = list(/obj/item/staplegun)
	time = 25

/datum/crafting_recipe/learned/pottedplant
	name = "potted plant"
	result = /obj/item/twohanded/required/kirbyplants/random
	reqs = list(/obj/item/reagent_containers/glass/bucket = 1,
				/obj/item/seeds/tower = 1,
				/datum/reagent/water = 25,
				)
	tools = list(/obj/item/cultivator)
	time = 40

/datum/crafting_recipe/learned/statuebust
	name = "statue bust"
	result = /obj/item/statuebust/hippocratic
	reqs = list(/obj/item/stack/sheet/mineral/sandstone = 5)
	tools = list()
	time = 30


//Stargazing

/datum/crafting_recipe/learned/binoculars
	name = "binoculars"
	result = /obj/item/twohanded/binoculars
	reqs = list(/obj/item/stack/sheet/glass = 2,
				/obj/item/stack/sheet/plasteel = 2,
				/obj/item/stack/rods = 6,
				)
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	time = 40

/datum/crafting_recipe/learned/superbinoculars
	name = "super binoculars"
	result = /obj/item/twohanded/binoculars/super
	reqs = list(/obj/item/twohanded/binoculars = 1,
				/obj/item/stack/sheet/mineral/titanium = 2,
				/obj/item/stack/sheet/mineral/silver = 1,
				/obj/item/stack/sheet/glass = 2,
				)
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	time = 40


//Audio

/datum/crafting_recipe/learned/taperecorder
	name = "tape recorder"
	result = /obj/item/taperecorder/empty
	reqs = list(/obj/item/stack/sheet/plastic = 5,
				/obj/item/stack/sheet/glass = 1,
				/obj/item/stack/cable_coil = 5,
				)
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER, TOOL_MULTITOOL)
	time = 40

/datum/crafting_recipe/learned/recordtape
	name = "record tape"
	result = /obj/item/tape
	reqs = list(/obj/item/paper = 2,
				/obj/item/stack/sheet/plastic = 2,
				)
	tools = list(TOOL_SCREWDRIVER, /obj/item/staplegun)
	time = 20


//Gang book stuff

/datum/crafting_recipe/learned/blingshoes
	name = "bling bling shoes"
	result = /obj/item/clothing/shoes/gang
	reqs = list (/obj/item/stack/sheet/mineral/gold = 1,
				/obj/item/clothing/shoes = 1,
				)
	tools = list()
	time = 30

/datum/crafting_recipe/learned/switchblade
	name = "switchblade"
	result = /obj/item/switchblade/middleground
	reqs = list(/obj/item/kitchen/knife = 1,
				/obj/item/stack/rods = 2,
				)
	tools = list(TOOL_WIRECUTTER, TOOL_SCREWDRIVER)
	time = 40

/datum/crafting_recipe/learned/spraycan
	name = "spray can"
	result = /obj/item/toy/crayon/spraycan
	reqs = list(/datum/reagent/water = 30,
				/datum/reagent/consumable/cooking_oil = 20,
				/obj/item/toy/crayon = 1,
				/obj/item/reagent_containers/spray = 1,
				)
	tools = list()
	time = 25

/datum/crafting_recipe/learned/contrabandposter
	name = "no respect for authority poster"
	result = /obj/item/poster/random_contraband
	reqs = list(/obj/item/paper = 6,
				/obj/item/stack/staples = 4,
				)
	tools = list(/obj/item/staplegun)
	time = 25

/datum/crafting_recipe/learned/implantbreaker
	name = "illegal improvised implant breaker"
	result = /obj/item/implanter/breaker
	reqs = list(/datum/reagent/toxin/acid = 19,
				/datum/reagent/iron = 10,
				/obj/item/reagent_containers/syringe = 1,
				/obj/item/stack/cable_coil = 2,
				/obj/item/stack/sheet/plasteel = 1,
				)
	tools = list()
	time = 50

/datum/crafting_recipe/learned/redjumpsuit
	name = "Blood gangster clothing"
	result = /obj/item/clothing/under/color/red/gang
	reqs = list(/obj/item/clothing/under = 1)
	tools = list()
	time = 10

/datum/crafting_recipe/learned/bluejumpsuit
	name = "Crip gangster clothing"
	result = /obj/item/clothing/under/color/blue/gang
	reqs = list(/obj/item/clothing/under = 1)
	tools = list()
	time = 10

/datum/crafting_recipe/learned/godfathersuit
	name = "Godfather suit"
	result = /obj/item/clothing/under/suit_jacket/burgundy/gang
	reqs = list(/obj/item/clothing/under = 1)
	tools = list()
	time = 10

/datum/crafting_recipe/learned/mafiososuit
	name = "Mafioso suit"
	result = /obj/item/clothing/under/suit_jacket/really_black/gang
	reqs = list(/obj/item/clothing/under = 1)
	tools = list()
	time = 10


//Vampire hunting book

/datum/crafting_recipe/learned/witchhunterhat
	name = "vampire hunting hat"
	result = /obj/item/clothing/head/helmet/chaplain/witchunter_hat
	reqs = list(/obj/item/stack/sheet/cloth = 5,
				/obj/item/stack/pipe_cleaner_coil = 4,
				)
	tools = list(TOOL_WIRECUTTER)
	time = 30

/datum/crafting_recipe/learned/woodenstake
	name = "wooden stake"
	result = /obj/item/melee/stake
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1)
	tools = list(/obj/item/kitchen/knife)
	time = 60


//Illegal weapons book

/datum/crafting_recipe/learned/ballisticcrossbow
	name = "ballistic crossbow"
	result = /obj/item/gun/ballistic/crossbow
	reqs = list(/obj/item/gun/ballistic/crossbow/improv = 1,
				/obj/item/stack/sheet/plasteel = 5,
				/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/rods = 3,
				/obj/item/stack/cable_coil = 3,
				)
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER, TOOL_WELDER)
	time = 80

/datum/crafting_recipe/learned/hookspear
	name = "hook spear"
	result = /obj/item/twohanded/spear/hook
	reqs = list(/obj/item/stack/sheet/mineral/wood = 4,
				/obj/item/stack/sheet/plasteel = 1,
				/obj/item/stack/rods = 1,
				)
	tools = list(TOOL_SCREWDRIVER)
	time = 40

/datum/crafting_recipe/learned/edagger
	name = "energy dagger"
	result = /obj/item/pen/edagger
	reqs = list(/obj/item/pen = 1,
				/obj/item/stack/telecrystal = 1,
				/obj/item/stack/cable_coil = 1,
				/obj/item/stock_parts/capacitor = 1,
				)
	tools = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL)
	time = 25
