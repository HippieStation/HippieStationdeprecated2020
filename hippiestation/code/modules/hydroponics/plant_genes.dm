/datum/plant_gene/trait/noreact/on_squash(obj/item/reagent_containers/food/snacks/grown/G, atom/target)
	G.reagents.set_reacting(FALSE)
	G.reagents.handle_reactions()