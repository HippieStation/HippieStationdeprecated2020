/datum/objective_item/steal/holotool
	name = "the holotool."
	targetitem = /obj/item/holotool
	difficulty = 5
	excludefromjob = list("Research Director")


/datum/objective_item/steal/functionalai
	excludefromjob = list(ROLE_INFILTRATOR)

/datum/objective_item/steal/kotd
	name = "the nuclear authentication disk"
	targetitem = /obj/item/disk/nuclear

/datum/objective_item/steal/kotd/New()
	special_equipment += /obj/item/pinpointer/nuke
	..()