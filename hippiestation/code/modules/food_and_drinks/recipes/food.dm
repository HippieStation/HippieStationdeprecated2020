/datum/chemical_reaction/pizzaification
	name = "Pizzaification"
	id = "pizzaification"
	required_reagents = list(/datum/reagent/consumable/tomatojuice = 10, /datum/reagent/oil = 5, /datum/reagent/consumable/flour = 20, /datum/reagent/sodium = 5)
	required_temp = 450
	mob_react = FALSE

/datum/chemical_reaction/pizzaification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		var/pizza = pick(typesof(/obj/item/reagent_containers/food/snacks/pizza))
		new pizza(location)
