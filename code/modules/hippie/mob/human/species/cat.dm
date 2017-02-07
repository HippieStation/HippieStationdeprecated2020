/datum/species/tarajan
	name = "Tarajan"
	id = "tarajan"
	say_mod = "meows"
	default_color = "00FF00"
	species_traits = list(MUTCOLORS,EYECOLOR)
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/meatproduct
	skinned_type = /obj/item/stack/sheet/animalhide/cat
	exotic_bloodtype = "L"
	burnmod = 1.25
	brutemod = 1.25

/datum/species/tarajan/qualifies_for_rank(rank, list/features)
	if(rank in command_positions)
		return 0
	if(rank in security_positions) //This list does not include lawyers.
		return 0
	if(rank in science_positions)
		return 0
	if(rank in medical_positions)
		return 0
	if(rank in engineering_positions)
		return 0
	if(rank == "Quartermaster") //QM is not contained in command_positions but we still want to bar mutants from it.
		return 0
	return 1