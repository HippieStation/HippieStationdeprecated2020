/obj/item/reagent_containers/syringe/stimulants/Initialize()
	. = ..()
	new /obj/item/reagent_containers/syringe/nanoboost(loc)
	if(!QDELETED(src))
		qdel(src)

/obj/item/reagent_containers/syringe/nanoboost
	name = "Nanobooster"
	desc = "Contains Nanomachines Son!."
	amount_per_transfer_from_this = 50
	volume = 50
	list_reagents = list(/datum/reagent/medicine/syndicate_nanites = 50)

/obj/item/reagent_containers/syringe/charcoal
	name = "syringe (charcoal)"
	desc = "Contains charcoal."
	list_reagents = list(/datum/reagent/medicine/charcoal = 15)

/obj/item/reagent_containers/syringe/perfluorodecalin
	name = "syringe (perfluorodecalin)"
	desc = "Contains perfluorodecalin."
	list_reagents = list(/datum/reagent/medicine/perfluorodecalin = 15)
