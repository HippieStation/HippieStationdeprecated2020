/obj/item/seeds/berry/glow/Initialize()
	. = ..()
	var/datum/plant_gene/trait/noreact/T = new
	if(prob(10))
		genes += T
	else
		qdel(T)

/obj/item/reagent_containers/food/snacks/grown/berries/poison
	distill_reagent = /datum/reagent/consumable/ethanol/devilskiss

/obj/item/reagent_containers/food/snacks/grown/berries/death
	distill_reagent = /datum/reagent/consumable/ethanol/devilskiss/lilithskiss

/obj/item/reagent_containers/food/snacks/grown/berries/glow
	distill_reagent = /datum/reagent/consumable/ethanol/gin/wasteland