/obj/item/card/id
	var/mining_points = 0 //For redeeming at mining equipment vendors

/obj/item/card/id/examine(mob/user)
	. = ..()
	. += "There's [mining_points] mining equipment redemption point\s loaded onto this card."
