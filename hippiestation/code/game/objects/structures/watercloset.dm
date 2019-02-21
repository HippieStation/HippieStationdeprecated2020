/obj/item/bikehorn/rubberducky
	attack_verb = list("QUACKED")

/obj/item/bikehorn/rubberducky/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, /datum/outputs/rubberducky, 80)
