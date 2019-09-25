/datum/martial_art
	var/no_guns = FALSE
	var/restraining = FALSE
	var/deflection_chance = 100

/datum/martial_art/teach(mob/living/carbon/human/H, make_temporary = FALSE)
	. = ..()
	if(. && no_guns)
		ADD_TRAIT(H, TRAIT_NOGUNS, ckey(name))

/datum/martial_art/on_remove(mob/living/carbon/human/H)
	. = ..()
	REMOVE_TRAIT(H, TRAIT_NOGUNS, ckey(name))

/datum/martial_art/reset_streak(mob/living/carbon/human/new_target)
	. = ..()
	restraining = FALSE
