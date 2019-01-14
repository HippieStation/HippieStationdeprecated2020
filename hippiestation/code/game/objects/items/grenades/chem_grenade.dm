#define READY 3

/obj/item/grenade/chem_grenade/saringas
	name = "Sarin gas grenade"
	desc = "Tiger Cooperative military grade nerve gas. WARNING: Ensure internals are active before use, nerve agents are exceptionally lethal regardless of dosage"
	stage = READY

/obj/item/grenade/chem_grenade/saringas/Initialize()
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/large/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/large/B2 = new(src)

	B1.reagents.add_reagent("sarin", 100)
	B2.reagents.add_reagent("sarin", 100)
	B1.reagents.chem_temp = 1000
	B2.reagents.chem_temp = 1000
	beakers += B1
	beakers += B2

/obj/item/grenade/chem_grenade/powergame
	name = "Powergamer meme grenade"
	desc = "This will probably end really badly..."
	stage = READY

/obj/item/grenade/chem_grenade/powergame/Initialize()
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/bluespace/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/bluespace/B2 = new(src)

	B1.reagents.add_reagent("blackpowder", 100)
	B1.reagents.add_reagent("sugar", 100)
	B1.reagents.add_reagent("plasma", 40)
	B1.reagents.add_reagent("stable_plasma", 40)
	B1.reagents.add_reagent("sacid", 40)
	B2.reagents.add_reagent("potassium", 100)
	B2.reagents.add_reagent("phosphorus", 140)
	B2.reagents.add_reagent("facid", 50)
	B2.reagents.add_reagent("napalm", 50)
	B1.reagents.chem_temp = 450
	B2.reagents.chem_temp = 450
	beakers += B1
	beakers += B2

#undef READY