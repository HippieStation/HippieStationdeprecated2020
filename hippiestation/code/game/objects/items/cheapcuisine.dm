/obj/item/cheapcuisine
	name = "Carbonhell's Can of Cheap Cuisine"
	desc = "A one-use miniature microwave that was meant to replace rations on the battlefield, produced by a Space Italian company. \
	It's said that the food they produce is so terrible, it makes all sorts of aliens attack Nanotrasen facilities. Which is, coincidentally, where you happen to be right now."
	force = 5
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	icon_state = "carboncan-off"
	item_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	hitsound = 'sound/weapons/smash.ogg'
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL
	sharpness = IS_BLUNT
	materials = list(MAT_METAL=4000)
	var/datum/looping_sound/microwave/soundloop
	var/selected_food
	var/used = FALSE

	var/list/possibleFood = list(
	"Corn Potato Pizza" = /obj/item/reagent_containers/food/snacks/pizza/cornpotato/carbon,
	"Insta-Jelly" = /obj/item/reagent_containers/food/snacks/soup/amanitajelly/carbon,
	"Hot Dog" = /obj/item/reagent_containers/food/snacks/butterdog/carbon,
	"Ham Disc" = /obj/item/reagent_containers/food/snacks/hamdisc,
	"A Drink" = /obj/item/reagent_containers/food/drinks/carbonhell)

/obj/item/cheapcuisine/Initialize()
	. = ..()
	soundloop = new(list(src), FALSE)

/obj/item/cheapcuisine/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/obj/item/cheapcuisine/attack_self(mob/user)
	if(!used)
		var/choice = input(user, "What would you like to dispense?", "Carbonhell's Can of Cheap Cuisine") as null|anything in possibleFood
		if(used)
			return FALSE
		else
			addtimer(CALLBACK(src, .proc/spawnFood, user, possibleFood[choice]), 50)
			soundloop.start()
			used = TRUE
			icon_state = "carboncan-on"
	else
		to_chat(user, "<span class='notice'>It's already been used!</span>")

/obj/item/cheapcuisine/proc/spawnFood(mob/user, foodtype)
	soundloop.stop()
	if(isnull(foodtype))
		icon_state = "carboncan-off"
		used = FALSE
		return
	user.put_in_hands(new foodtype(get_turf(src)))
	icon_state = "carboncan-open"
	desc = "It's been used already."

// Foods

/obj/item/reagent_containers/food/snacks/pizza/cornpotato/carbon
	name = "cornpotato-pizza"
	desc = "A sanity destroying other thing. Somehow worse than the Cook's."
	icon = 'hippiestation/icons/obj/food/pizzaspaghetti.dmi'
	icon_state = "pizzacornpotato"
	slice_path = /obj/item/reagent_containers/food/snacks/pizzaslice/cornpotato/carbon
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/toxin = 3, /datum/reagent/drug/fartium = 5, /datum/reagent/drug/mushroomhallucinogen = 3)
	bonus_reagents = list(/datum/reagent/drug/methamphetamine = 2.5, /datum/reagent/toxin/histamine = 2)
	tastes = list("pure, unadulterated misery" = 5)
	foodtype = GROSS | TOXIC // none of the food is actually real, it's just gross.

/obj/item/reagent_containers/food/snacks/pizzaslice/cornpotato/carbon
	name = "cornpotato-pizza slice"
	desc = "A slice of a sanity destroying other thing. Somehow worse than the Cook's."
	icon = 'hippiestation/icons/obj/food/pizzaspaghetti.dmi'
	icon_state = "pizzacornpotatoslice"
	filling_color = "#FFA500"
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/vitamin = 0.5, /datum/reagent/toxin = 1.5, /datum/reagent/drug/fartium = 2)
	bonus_reagents = list(/datum/reagent/drug/methamphetamine = 0.5, /datum/reagent/toxin/histamine = 0.5)
	tastes = list("pure, unadulterated misery" = 2)
	foodtype = GROSS | TOXIC

/obj/item/reagent_containers/food/snacks/soup/amanitajelly/carbon
	name = "insta-jelly"
	desc = "The jelly was so corrupted that it ended up gaining sentience."
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 3, /datum/reagent/toxin/amatoxin = 7, /datum/reagent/drug/mushroomhallucinogen = 3) // will KILL you
	bonus_reagents = list(/datum/reagent/toxin/formaldehyde = 3, /datum/reagent/toxin/rotatium = 3, /datum/reagent/toxin/skewium = 3) // who knows what you're gonna get
	tastes = list("death" = 10)
	bitesize = 2
	foodtype = GROSS | TOXIC

/obj/item/reagent_containers/food/snacks/butterdog/carbon
	name = "butterdog"
	desc = "This isn't a hot dog! It smells of heart disease!"
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/toxin/slimejelly = 5, /datum/reagent/drug/mushroomhallucinogen = 3)
	bonus_reagents = list(/datum/reagent/impedrezene = 3, /datum/reagent/toxin/sulfonal = 2) // nerfed but still dangerous
	tastes = list("cardiac arrest" = 10)
	bitesize = 2
	foodtype = GROSS | TOXIC

/obj/item/reagent_containers/food/snacks/butterdog/carbon/ComponentInitialize()
	.=..()
	var/datum/component/comp = GetComponent(/datum/component/slippery)
	qdel(comp)

/obj/item/reagent_containers/food/snacks/hamdisc
	name = "ham disc"
	desc = "The laziest food someone could possibly make, alongside some corn."
	icon = 'hippiestation/icons/obj/food/food.dmi'
	icon_state = "ham_disk"
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/consumable/soymilk = 6)
	tastes = list("laziness" = 2)
	foodtype = GROSS | RAW | MEAT | VEGETABLES

/obj/item/reagent_containers/food/drinks/carbonhell
	name = "spanish vegetable oil"
	desc = "Tastes about as terrible as you'd expect."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "oliveoil"
	list_reagents = list(/datum/reagent/toxin/amanitin = 5, /datum/reagent/consumable/soymilk = 12, /datum/reagent/consumable/ethanol/atomicbomb = 10, /datum/reagent/consumable/ethanol/hearty_punch = 8) //guaranteed to fuck you up, soylent. also surprisingly robust if used before crit
	foodtype = GROSS | ALCOHOL
