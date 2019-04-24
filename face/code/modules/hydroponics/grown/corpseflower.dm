// A very special plant, deserving it's own file.

/obj/item/seeds/corpseflower
	name = "pack of corpse flower seeds"
	desc = "These seeds grow into a corpse thats really smelly."
	icon_state = "seed-corpseflower"
	species = "corpseflower"
	plantname = "Corpse Flower"
	product = /obj/item/reagent_containers/food/snacks/grown/corpseflower
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/plant_type/weed_hardy)
	lifespan = 20
	endurance = 10
	yield = 4
	growthstages = 6
	rarity = 30
	var/list/mutations = list()
	reagents_add = list("charcoal" = 0.04, "nutriment" = 0.02, "blood" = 0.01)

/obj/item/seeds/corpseflower/Copy()
	var/obj/item/seeds/corpseflower/S = ..()
	S.mutations = mutations.Copy()
	return S

/obj/item/seeds/corpseflower/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] swallows the pack of corpse flower seeds! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	plant(user)
	return (BRUTELOSS)

/obj/item/seeds/corpseflower/proc/plant(mob/user)
	if(isspaceturf(user.loc))
		return
	if(!isturf(user.loc))
		to_chat(user, "<span class='warning'>You need more space to plant [src].</span>")
		return FALSE
	if(locate(/obj/structure) in user.loc)
		to_chat(user, "<span class='warning'>There is too much blocking your path to plant [src].</span>")
		return FALSE
	to_chat(user, "<span class='notice'>You plant [src].</span>")
	message_admins("Corpse Flower planted by [ADMIN_LOOKUPFLW(user)] at [ADMIN_VERBOSEJMP(user)]")
	investigate_log("was planted by [key_name(user)] at [AREACOORD(user)]", INVESTIGATE_BOTANY)
	new /datum/spacevine_controller(get_turf(user), mutations, potency, production)
	qdel(src)

/obj/item/seeds/corpseflower/attack_self(mob/user)
	user.visible_message("<span class='danger'>[user] begins throwing seeds on the ground...</span>")
	if(do_after(user, 50, needhand = TRUE, target = user.drop_location(), progress = TRUE))
		plant(user)
		to_chat(user, "<span class='notice'>You plant the corpse flower. You monster.</span>")

/obj/item/seeds/corpseflower/get_analyzer_text()
	var/text = ..()
	var/text_string = ""
	for(var/datum/spacevine_mutation/SM in mutations)
		text_string += "[(text_string == "") ? "" : ", "][SM.name]"
	text += "\n- Plant Mutations: [(text_string == "") ? "None" : text_string]"
	return text

/obj/item/seeds/corpseflower/on_chem_reaction(datum/reagents/S)
	var/list/temp_mut_list = list()

	if(S.has_reagent("sterilizine", 5))
		for(var/datum/spacevine_mutation/SM in mutations)
			if(SM.quality == NEGATIVE)
				temp_mut_list += SM
		if(prob(20) && temp_mut_list.len)
			mutations.Remove(pick(temp_mut_list))
		temp_mut_list.Cut()

	if(S.has_reagent("welding_fuel", 5))
		for(var/datum/spacevine_mutation/SM in mutations)
			if(SM.quality == POSITIVE)
				temp_mut_list += SM
		if(prob(20) && temp_mut_list.len)
			mutations.Remove(pick(temp_mut_list))
		temp_mut_list.Cut()

	if(S.has_reagent("phenol", 5))
		for(var/datum/spacevine_mutation/SM in mutations)
			if(SM.quality == MINOR_NEGATIVE)
				temp_mut_list += SM
		if(prob(20) && temp_mut_list.len)
			mutations.Remove(pick(temp_mut_list))
		temp_mut_list.Cut()

	if(S.has_reagent("blood", 15))
		adjust_production(rand(15, -5))

	if(S.has_reagent("amatoxin", 5))
		adjust_production(rand(5, -15))

	if(S.has_reagent("plasma", 5))
		adjust_potency(rand(5, -15))

	if(S.has_reagent("holywater", 10))
		adjust_potency(rand(15, -5))


/obj/item/reagent_containers/food/snacks/grown/corpseflower
	seed = /obj/item/seeds/corpseflower
	name = "corpseflower"
	desc = "<I>Amorphophallus titanum</I>: An invasive species that is exactly like a dead corpse."
	icon_state = "corpseflower"
	filling_color = "#6B8E23"
	bitesize_mod = 2
	foodtype = VEGETABLES | GROSS
	tastes = list("corpse" = 1)
	wine_power = 20
