/datum/chemical_reaction/bone_hurting_juice
	name = "Bone Hurting Juice"
	id = "bone_hurting_juice"
	results = list(/datum/reagent/toxin/bone_hurting_juice = 3)
	required_reagents = list(/datum/reagent/consumable/milk = 1, /datum/reagent/consumable/space_cola = 1, /datum/reagent/carbon = 1) //Milk for calcium, cola because it rots your teeth and carbon because something to do with calcium carbonate.

/datum/chemical_reaction/bleach
	name = "bleach"
	id = "bleach"
	results = list(/datum/reagent/toxin/bleach = 3)
	required_reagents = list(/datum/reagent/space_cleaner = 1, /datum/reagent/sodium = 1, /datum/reagent/chlorine = 1)

/datum/chemical_reaction/isopropyl
	name = "Isopropyl Alcohol"
	id = "isopropyl"
	results = list(/datum/reagent/consumable/ethanol/isopropyl = 5)
	required_catalysts = list(/datum/reagent/aluminium = 1)
	required_reagents = list(/datum/reagent/water = 6, /datum/reagent/carbon = 3)

/datum/chemical_reaction/carbonf
	name = "Carbonic Fluoride"
	id = "carbonf"
	results = list(/datum/reagent/toxin/carbonf = 4)
	required_reagents = list(/datum/reagent/consumable/ethanol = 4, /datum/reagent/fluorine = 2)
	required_temp = 320

/datum/chemical_reaction/aus
	name = "Ausium"
	id = "aus"
	results = list(/datum/reagent/toxin/aus = 6)
	required_reagents = list(/datum/reagent/drug/space_drugs = 4, /datum/reagent/consumable/ethanol = 2, /datum/reagent/lithium = 2)
	required_temp = 430
	centrifuge_recipe = TRUE

/datum/chemical_reaction/impalco
	name = "Impure Superhol"
	id = "impalco"
	results = list(/datum/reagent/consumable/ethanol/impalco = 5)
	required_reagents = list(/datum/reagent/toxin/aus = 2, /datum/reagent/consumable/ethanol = 3, /datum/reagent/drug/methamphetamine = 2)
	pressure_required = 5

/datum/chemical_reaction/alco
	name = "Superhol"
	id = "alco"
	results = list(/datum/reagent/consumable/ethanol/alco = 6, /datum/reagent/consumable/ethanol = 6)
	required_reagents = list(/datum/reagent/consumable/ethanol/impalco = 3, /datum/reagent/consumable/ethanol = 3, /datum/reagent/consumable/ethanol/isopropyl = 3)
	centrifuge_recipe = TRUE

/datum/chemical_reaction/emote
	name = "Emotium"
	id = "emote"
	results = list(/datum/reagent/toxin/emote = 5)
	required_reagents = list(/datum/reagent/medicine/synaptizine = 1, /datum/reagent/consumable/sugar = 2, /datum/reagent/ammonia = 1)
	required_catalysts = list(/datum/reagent/toxin/mutagen = 1)
	centrifuge_recipe = TRUE

/datum/chemical_reaction/over_reactible/bear
	name = "Bearium"
	id = "bear"
	results = list(/datum/reagent/toxin/bear = 4, /datum/reagent/toxin/radgoop = 2)
	required_reagents = list(/datum/reagent/medicine/liquid_life = 2, /datum/reagent/volt = 3, /datum/reagent/medicine/ephedrine = 1)
	required_temp = 460
	bluespace_recipe = TRUE
	can_overheat = TRUE
	overheat_threshold = 1000
	exothermic_gain = 350

/datum/chemical_reaction/methphos
	name = "Methylphosphonyl difluoride"
	id = "methphos"
	results = list(/datum/reagent/toxin/methphos = 4)
	required_reagents = list(/datum/reagent/hydrogen = 3, /datum/reagent/carbon = 1, /datum/reagent/phosphorus = 1, /datum/reagent/oxygen = 1, /datum/reagent/fluorine = 2)
	pressure_required = 26

/datum/chemical_reaction/sarin_a
	name = "Translucent mixture"
	id = "sarina"
	results = list(/datum/reagent/toxin/sarin_a = 3)
	required_reagents = list(/datum/reagent/consumable/ethanol/isopropyl = 3, /datum/reagent/toxin/methphos = 2)

/datum/chemical_reaction/sarin_b
	name = "Dilute sarin"
	id = "sarinb"
	results = list(/datum/reagent/toxin/sarin_b = 2)
	required_temp = 700
	pressure_required = 5
	required_reagents = list(/datum/reagent/toxin/sarin_a = 2)

/datum/chemical_reaction/over_reactible/sarin
	name = "Sarin"
	id = "sarin"
	results = list(/datum/reagent/toxin/sarin = 3)
	can_overheat = TRUE
	can_overpressure = TRUE//hehehe quickest way to get killed as a lunatic chemist
	overheat_threshold = 450
	overpressure_threshold = 100
	centrifuge_recipe = TRUE
	pressure_required = 95
	required_reagents = list(/datum/reagent/toxin/sarin_b = 6)

/datum/chemical_reaction/tabun_pa
	name = "Dimethlymine"
	id = "tabuna"
	results = list(/datum/reagent/toxin/tabun_pa = 4, /datum/reagent/oxygen = 2)
	required_reagents = list(/datum/reagent/sodium = 1, /datum/reagent/water = 3, /datum/reagent/carbon = 2, /datum/reagent/nitrogen = 1)
	required_temp = 420

/datum/chemical_reaction/tabun_pb
	name = "Phosphoryll"
	id = "tabunb"
	results = list(/datum/reagent/toxin/tabun_pb = 1)
	required_reagents = list(/datum/reagent/chlorine = 3, /datum/reagent/phosphorus = 1, /datum/reagent/oxygen = 1)

/datum/chemical_reaction/tabun_pc
	name = "Noxious mixture"
	id = "tabunc"
	results = list(/datum/reagent/toxin/tabun_pc = 2)
	required_reagents = list(/datum/reagent/toxin/tabun_pb = 2, /datum/reagent/toxin/tabun_pa = 2)

/datum/chemical_reaction/tabun
	name = "Tabun"
	id = "tabun"
	results = list(/datum/reagent/toxin/tabun = 1, /datum/reagent/toxin/goop = 9)
	required_reagents = list(/datum/reagent/toxin/tabun_pc = 3)
	centrifuge_recipe = TRUE

/datum/chemical_reaction/impgluco
	name = "Impure Glucosaryll"
	id = "impgluco"
	results = list(/datum/reagent/toxin/impgluco = 1)
	required_temp = 170
	pressure_required = 45
	required_reagents = list(/datum/reagent/consumable/sugar = 3, /datum/reagent/consumable/ethanol/isopropyl = 1, /datum/reagent/consumable/sodiumchloride = 1)

/datum/chemical_reaction/gluco
	name = "Glucosaryll"
	id = "gluco"
	results = list(/datum/reagent/toxin/gluco = 1)
	required_temp = 120
	is_cold_recipe = TRUE
	pressure_required = 85
	required_reagents = list(/datum/reagent/toxin/impgluco = 2, /datum/reagent/cryogenic_fluid = 1)
	centrifuge_recipe = TRUE

/datum/chemical_reaction/over_reactible/screech
	name = "Screechisol"
	id = "screech"
	results = list(/datum/reagent/toxin/screech = 3)
	can_overheat = TRUE
	required_temp = 750
	pressure_required = 30
	overheat_threshold = 775
	required_reagents = list(/datum/reagent/toxin/emote = 3, /datum/reagent/medicine/ephedrine = 1)

/datum/chemical_reaction/stablemutationtoxin
	name = "Stable Mutation Toxin"
	id = "stablemutationtoxin"
	results = list(/datum/reagent/mutationtoxin = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/blood = 1)

/datum/chemical_reaction/lizardmutationtoxin
	name = "Lizard Mutation Toxin"
	id = "lizardmutationtoxin"
	results = list(/datum/reagent/mutationtoxin/lizard = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/uranium/radium = 1)

/datum/chemical_reaction/flymutationtoxin
	name = "Fly Mutation Toxin"
	id = "flymutationtoxin"
	results = list(/datum/reagent/mutationtoxin/fly = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/toxin/mutagen = 1)

/datum/chemical_reaction/jellymutationtoxin
	name = "Imperfect Mutation Toxin"
	id = "jellymutationtoxin"
	results = list(/datum/reagent/mutationtoxin/jelly = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/toxin/slimejelly = 1)

/datum/chemical_reaction/podmutationtoxin
	name = "Pod Mutation Toxin"
	id = "podmutationtoxin"
	results = list(/datum/reagent/mutationtoxin/pod = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/plantnutriment/eznutriment = 1)

/datum/chemical_reaction/golemmutationtoxin
	name = "Golem Mutation Toxin"
	id = "golemmutationtoxin"
	results = list(/datum/reagent/mutationtoxin/golem = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/silver = 1)

/datum/chemical_reaction/abductormutationtoxin
	name = "Abductor Mutation Toxin"
	id = "abductormutationtoxin"
	results = list(/datum/reagent/mutationtoxin/abductor = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/medicine/morphine = 1)

/datum/chemical_reaction/androidmutationtoxin
	name = "Android Mutation Toxin"
	id = "androidmutationtoxin"
	results = list(/datum/reagent/mutationtoxin/android = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/teslium = 1)

/datum/chemical_reaction/skeletonmutationtoxin
	name = "Skeleton Mutation Toxin"
	id = "skeletonmutationtoxin"
	results = list(/datum/reagent/mutationtoxin/skeleton = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/consumable/milk = 1)

/datum/chemical_reaction/zombiemutationtoxin
	name = "Zombie Mutation Toxin"
	id = "zombiemutationtoxin"
	results = list(/datum/reagent/mutationtoxin/zombie = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/toxin = 1)

/datum/chemical_reaction/ashmutationtoxin
	name = "Ash Mutation Toxin"
	id = "ashmutationtoxin"
	results = list(/datum/reagent/mutationtoxin/ash = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/mutationtoxin/lizard = 1, /datum/reagent/ash = 1)

/datum/chemical_reaction/shadowmutationtoxin
	name = "Shadow Mutation Toxin"
	id = "shadowmutationtoxin"
	results = list(/datum/reagent/mutationtoxin/shadow = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/liquid_dark_matter = 1, /datum/reagent/water/holywater = 1)

/datum/chemical_reaction/plasmamutationtoxin
	name = "Plasma Mutation Toxin"
	id = "plasmamutationtoxin"
	results = list(/datum/reagent/mutationtoxin/plasma = 1)
	required_reagents = list(/datum/reagent/unstablemutationtoxin = 1, /datum/reagent/uranium = 1, /datum/reagent/toxin/plasma = 1)
