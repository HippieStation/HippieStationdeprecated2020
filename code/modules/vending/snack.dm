/obj/machinery/vending/snack
	name = "\improper Getmore Chocolate Corp"
	desc = "A snack machine courtesy of the Getmore Chocolate Corporation, based out of Mars."
	product_slogans = "Try our new nougat bar!;Twice the calories for half the price!"
	product_ads = "The healthiest!;Award-winning chocolate bars!;Mmm! So good!;Oh my god it's so juicy!;Have a snack.;Snacks are good for you!;Have some more Getmore!;Best quality snacks straight from mars.;We love chocolate!;Try our new jerky!"
	icon_state = "snack"
	products = list(/obj/item/reagent_containers/food/snacks/spacetwinkie = 6,
					/obj/item/reagent_containers/food/snacks/cheesiehonkers = 6,
					/obj/item/reagent_containers/food/snacks/candy = 6,
		            /obj/item/reagent_containers/food/snacks/chips = 6,
		            /obj/item/reagent_containers/food/snacks/sosjerky = 6,
					/obj/item/reagent_containers/food/snacks/no_raisin = 6,
					/obj/item/reagent_containers/food/drinks/dry_ramen = 3,
					/obj/item/reagent_containers/food/snacks/energybar = 6)
	contraband = list(/obj/item/reagent_containers/food/snacks/syndicake = 6)
	refill_canister = /obj/item/vending_refill/snack
	canload_access_list = list(ACCESS_KITCHEN)
	default_price = 20
	extra_price = 30
	payment_department = ACCOUNT_SRV
	input_display_header = "Chef's Food Selection"

/obj/item/vending_refill/snack
	machine_name = "Getmore Chocolate Corp"

/obj/machinery/vending/snack/canLoadItem(obj/item/I,mob/user)
	. = FALSE
	if(istype(I,/obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/snacki = I
		if(snacki.junkiness)
			return FALSE
		return TRUE

/obj/machinery/vending/snack/Destroy()
	for(var/obj/item/reagent_containers/food/snacks/S in contents)
		S.forceMove(get_turf(src))
	return ..()

/obj/machinery/vending/snack/proc/food_load(obj/item/reagent_containers/food/snacks/S)
	if(vending_machine_input[S.name])
		vending_machine_input[S.name]++
	else
		vending_machine_input[S.name] = 1
	sortList(vending_machine_input)

/obj/machinery/vending/snack/random
	name = "\improper Random Snackies"
	icon_state = "random_snack"
	desc = "Uh oh!"

/obj/machinery/vending/snack/random/Initialize()
	..()
	var/T = pick(subtypesof(/obj/machinery/vending/snack) - /obj/machinery/vending/snack/random)
	new T(loc)
	return INITIALIZE_HINT_QDEL

/obj/machinery/vending/snack/blue
	icon_state = "snackblue"

/obj/machinery/vending/snack/orange
	icon_state = "snackorange"

/obj/machinery/vending/snack/green
	icon_state = "snackgreen"

/obj/machinery/vending/snack/teal
	icon_state = "snackteal"
