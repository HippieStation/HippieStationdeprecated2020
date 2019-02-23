/obj/item/clothing/under/rank/clown/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, /datum/outputs/clownsuit, 50)

/obj/item/clothing/shoes/clown_shoes/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, /datum/outputs/clownstep, 50, ,0)