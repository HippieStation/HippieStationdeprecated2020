/obj/item/clothing/under/rank/clown/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak/clownsuit, 50)

/datum/component/squeak/clownsuit
	datum_outputs = list(/datum/outputs/clownsuit)

/obj/item/clothing/shoes/clown_shoes/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak/clownstep, 50, ,0)