#define DELICIA_SPAM_COOLDOWN 300
#define GONDOLA		(1<<13)

/obj/item/reagent_containers/food/snacks/soup/monkey
	name = "Sopa de Macaco"
	desc = "Monkey soup. A delicacy in Space Brazil."
	icon = 'hippiestation/icons/obj/food/soupsalad.dmi'
	icon_state = "sopademacaco"
	list_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("delicia" = 1)
	foodtype = MEAT | GROSS
	var/next_uma = 0

/obj/item/reagent_containers/food/snacks/soup/monkey/attack(mob/M, mob/user, def_zone)
	if(..())
		if(world.time > next_uma)
			M.say("Uma delicia!", forced = "monkey soup")
			next_uma = world.time + DELICIA_SPAM_COOLDOWN

/obj/item/reagent_containers/food/snacks/soup/gondola
	name = "Sopa de Gondola"
	desc = "Gondola soup. A delicacy from CentComm."
	icon = 'hippiestation/icons/obj/food/soupsalad.dmi'
	icon_state = "sopadegondola"
	list_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/blood = 3)
	tastes = list("hoitoa" = 1)
	foodtype = GONDOLA

/obj/item/reagent_containers/food/snacks/soup/gondola/attack(mob/M, mob/user, def_zone)
	// Nobody escapes the taste of Sopa de Gondola. Uma delicia!
	if(ishuman(M))
		var/mob/living/carbon/human/h = M
		h.dna.species.liked_food |= GONDOLA
		h.dna.species.disliked_food &= ~GONDOLA

	// Gondola feels gud in belly :::::DDDDDD
	if(..())
		M.adjust_disgust(-2)

#undef DELICIA_SPAM_COOLDOWN
