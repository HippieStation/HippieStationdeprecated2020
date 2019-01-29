/obj/item/seeds/berry/glow
	genes = list(/datum/plant_gene/trait/glow/berry, /datum/plant_gene/trait/repeated_harvest)

/obj/item/seeds/berry/glow/Initialize()
	if(prob(5))
		LAZYADD(genes, /datum/plant_gene/trait/noreact)

