/obj/item/bikehorn/rubberducky
	attack_verb = list("QUACKED")

/obj/item/bikehorn/rubberducky/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak/rubberducky, 80)

/datum/component/squeak/rubberducky
	datum_outputs = list(/datum/outputs/rubberducky)