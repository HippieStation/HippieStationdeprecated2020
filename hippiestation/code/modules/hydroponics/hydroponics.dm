/obj/machinery/hydroponics/applyChemicals(datum/reagents/S, mob/user)
	if(S.has_reagent(/datum/reagent/toxin/mutagen, 50) || S.has_reagent(/datum/reagent/uranium/radium, 100) || S.has_reagent(/datum/reagent/uranium, 100))
		mutatespecie()
	..()
