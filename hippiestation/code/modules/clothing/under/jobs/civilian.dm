/obj/item/clothing/under/rank/clown/Initialize()
	. = ..()
	// remove any previous squeak components from tg so we can use our own
	var/list/squeaks = GetComponents(/datum/component/squeak)
	for(var/datum/component/c in squeaks)
		c.RemoveComponent()
	AddComponent(/datum/component/squeak/clown)