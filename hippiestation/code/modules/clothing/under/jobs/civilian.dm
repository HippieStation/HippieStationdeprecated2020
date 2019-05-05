/obj/item/clothing/under/rank/clown/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak/clownsuit, 50)
	var/datum/component/comp = GetComponent(/datum/component/squeak/bikehorn)
	qdel(comp)

/datum/component/squeak/clownsuit
	datum_outputs = list(/datum/outputs/clownsuit)