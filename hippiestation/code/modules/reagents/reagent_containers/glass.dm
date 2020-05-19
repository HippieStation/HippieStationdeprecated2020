/obj/item/reagent_containers/glass/beaker/bluespace
	materials = list(MAT_GLASS = 5000, MAT_PLASMA = 3000, MAT_DIAMOND = 1000, MAT_BLUESPACE = 1000) // matches the materials it's made of with the recipe in medical_designs.dm

/obj/item/reagent_containers/glass/beaker/huge
	name = "huge beaker"
	desc = "A very large beaker. Can hold up to 500 units."
	icon_state = "beakerlarge1"
	materials = list(MAT_GLASS=12500)
	volume = 500
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(1,5,10,15,20,25,30,50,100,250,500) //very precise measurements
	w_class = WEIGHT_CLASS_SMALL //it's quite a bit bigger than most beakers

/obj/item/reagent_containers/glass/beaker/huge/Initialize()
	. = ..()
	var/matrix/M = matrix()
	M.Scale(1.1, 1.1)

/obj/item/reagent_containers/glass/beaker/huge/update_icon()
	icon_state = "beakerlarge" // hack to lets us reuse the large beaker reagent fill states
	..()
	icon_state = "beakerlarge1"

/obj/item/reagent_containers/glass/afterattack(obj/target, mob/user, proximity)
	if((!proximity) || !check_allowed_items(target,target_self=1)) return

	else if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

		if(target.is_open_container())
			if(!reagents.total_volume)
				to_chat(user, "<span class='warning'>[src] is empty!</span>")
				return

			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				to_chat(user, "<span class='notice'>[target] is full.</span>")
				return

			var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
			to_chat(user, "<span class='notice'>You transfer [trans] unit\s of the solution to [target].</span>")

		else
			if(reagents.total_volume >= reagents.maximum_volume)
				to_chat(user, "<span class='notice'>[src] is full.</span>")
				return
			if(!target.reagents.total_volume)
				to_chat(user, "<span class='warning'>[target] is empty!</span>")
				return
			else
				var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this)
				to_chat(user, "<span class='notice'>You fill [src] with [trans] unit\s of the contents of [target].</span>")
				return

	else if(target.is_open_container() && target.reagents) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			to_chat(user, "<span class='warning'>[src] is empty!</span>")
			return

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, "<span class='notice'>[target] is full.</span>")
			return


		var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>You transfer [trans] unit\s of the solution to [target].</span>")

	else if(reagents.total_volume)
		if(user.a_intent == INTENT_HARM)
			user.visible_message("<span class='danger'>[user] splashes the contents of [src] onto [target]!</span>", \
								"<span class='notice'>You splash the contents of [src] onto [target].</span>")
			reagents.reaction(target, TOUCH)
			reagents.clear_reagents()

/obj/item/reagent_containers/glass/beaker/random
	name = "Random Beaker"

/obj/item/reagent_containers/glass/beaker/random/Initialize(mapload, vol)
	. = ..()
	var/datum/reagents/R = reagents
	R.add_reagent(get_random_all_reagent_id(), volume, reagtemp = rand(1, 1000))

/proc/get_random_all_reagent_id()	// Returns a random reagent ID including blacklisted ones
	var/static/list/random_reagents = list()
	if(!random_reagents.len)
		for(var/thing in subtypesof(/datum/reagent))
			var/datum/reagent/R = thing
			random_reagents += R
	var/picked_reagent = pick(random_reagents)
	return picked_reagent