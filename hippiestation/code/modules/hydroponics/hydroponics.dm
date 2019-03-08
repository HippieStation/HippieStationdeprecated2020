/obj/machinery/hydroponics/applyChemicals(datum/reagents/S, mob/user)
	if(S.has_reagent("mutagen", 50) || S.has_reagent("radium", 100) || S.has_reagent("uranium", 100))
		mutatespecie()
	..()