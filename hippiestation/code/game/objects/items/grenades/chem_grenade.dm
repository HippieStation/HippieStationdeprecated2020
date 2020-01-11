#define READY 3

/obj/item/grenade/chem_grenade
	banned_containers = list() // reverts bluespace beaker's nerf


/obj/item/grenade/chem_grenade/Crossed(atom/movable/AM, oldloc)
	for(var/A in wires.assemblies)
		var/obj/item/I = wires.assemblies[A]
		if(istype(I))
			I.Crossed(AM, oldloc)
	return ..()

/obj/item/grenade/chem_grenade/on_found(mob/finder)
	for(var/A in wires.assemblies)
		var/obj/item/assembly/I = wires.assemblies[A]
		if(istype(I))
			I.on_found(finder)

/obj/item/grenade/chem_grenade/saringas
	name = "Sarin gas grenade"
	desc = "Tiger Cooperative military grade nerve gas. WARNING: Ensure internals are active before use, nerve agents are exceptionally lethal regardless of dosage"
	stage = READY

/obj/item/grenade/chem_grenade/saringas/Initialize()
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/large/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/large/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/toxin/sarin, 100)
	B2.reagents.add_reagent(/datum/reagent/toxin/sarin, 100)
	B1.reagents.chem_temp = 1000
	B2.reagents.chem_temp = 1000
	beakers += B1
	beakers += B2

#undef READY
