/obj/item/slime_scanner/afterattack(atom/target, mob/living/user, flag, params)
	if(flag)
		return
	if(user.stat || user.eye_blind)
		return
	if (!isslime(target))
		to_chat(user, "<span class='warning'>This device can only scan slimes!</span>")
		return
	var/mob/living/simple_animal/slime/T = target
	to_chat(user, "Slime scan results:")
	to_chat(user, "[T.colour] [T.is_adult ? "adult" : "baby"] slime")
	to_chat(user, "Nutrition: [T.nutrition]/[T.get_max_nutrition()]")
	if (T.nutrition < T.get_starve_nutrition())
		to_chat(user, "<span class='warning'>Warning: slime is starving!</span>")
	else if (T.nutrition < T.get_hunger_nutrition())
		to_chat(user, "<span class='warning'>Warning: slime is hungry</span>")
	to_chat(user, "Electric change strength: [T.powerlevel]")
	to_chat(user, "Health: [round(T.health/T.maxHealth,0.01)*100]")
	if (T.slime_mutation[4] == T.colour)
		to_chat(user, "This slime does not evolve any further.")
	else
		if (T.slime_mutation[3] == T.slime_mutation[4])
			if (T.slime_mutation[2] == T.slime_mutation[1])
				to_chat(user, "Possible mutation: [T.slime_mutation[3]]")
				to_chat(user, "Genetic destability: [T.mutation_chance/2] % chance of mutation on splitting")
			else
				to_chat(user, "Possible mutations: [T.slime_mutation[1]], [T.slime_mutation[2]], [T.slime_mutation[3]] (x2)")
				to_chat(user, "Genetic destability: [T.mutation_chance] % chance of mutation on splitting")
		else
			to_chat(user, "Possible mutations: [T.slime_mutation[1]], [T.slime_mutation[2]], [T.slime_mutation[3]], [T.slime_mutation[4]]")
			to_chat(user, "Genetic destability: [T.mutation_chance] % chance of mutation on splitting")
	if (T.cores > 1)
		to_chat(user, "Anomalious slime core amount detected")
	to_chat(user, "Growth progress: [T.amount_grown]/[SLIME_EVOLUTION_THRESHOLD]")

/obj/item/sequence_scanner/gene_scan(mob/living/carbon/C, mob/living/user)
	if(!iscarbon(C) || !C.has_dna())
		return
	to_chat(user, "<span class='notice'>[C.name]'s potential mutations.")
	for(var/A in C.dna.mutation_index)
		var/datum/mutation/human/HM = GET_INITIALIZED_MUTATION(A)
		var/mut_name
		if(A in discovered)
			mut_name = "[HM.name] ([HM.alias])"
		else
			mut_name = HM.alias
		var/temp = GET_GENE_STRING(HM.type, C.dna)
		var/display
		for(var/i in 0 to length(temp) / DNA_MUTATION_BLOCKS-1)
			if(i)
				display += "-"
			display += copytext(temp, 1 + i*DNA_MUTATION_BLOCKS, DNA_MUTATION_BLOCKS*(1+i) + 1)
		to_chat(user, "<span class='boldnotice'>- [mut_name] > [display]</span>")

/obj/item/t_scanner
	tool_behaviour = TOOL_TRAY

/obj/item/t_scanner/adv_mining_scanner
	tool_behaviour = null