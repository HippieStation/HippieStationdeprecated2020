// Voice Changing
/datum/disease/advance/voice_change
	copy_type = /datum/disease/advance

/datum/disease/advance/voice_change/New()
	name = "Epiglottis Mutation"
	symptoms = list(new/datum/symptom/voice_change)
	..()

// Toxin Filter
/datum/disease/advance/heal/toxin	//Put into a heal subclass because then we can sort all future healing diseases if more are made
	copy_type = /datum/disease/advance

/datum/disease/advance/heal/toxin/New()
	name = "Liver Enhancer"
	symptoms = list(new/datum/symptom/heal/toxin)
	..()

// Hallucigen
/datum/disease/advance/hallucigen
	copy_type = /datum/disease/advance

/datum/disease/advance/hallucigen/New()
	name = "Second Sight"
	symptoms = list(new/datum/symptom/hallucigen)
	..()

// Sensory Restoration
/datum/disease/advance/mind_restoration
	copy_type = /datum/disease/advance

/datum/disease/advance/mind_restoration/New()
	name = "Intelligence Booster"
	symptoms = list(new/datum/symptom/mind_restoration)
	..()

// Sensory Destruction
/datum/disease/advance/narcolepsy
	copy_type = /datum/disease/advance

/datum/disease/advance/narcolepsy/New()
	name = "Experimental Insomnia Cure"
	symptoms = list(new/datum/symptom/narcolepsy)
	..()

//Super mega healy thing
/datum/disease/advance/heal/godblood
	name = "Godblood Syndrome"
	mutable = FALSE	//The essence of the gods laughs at your pitiful SCIENCE!
	stage_prob = 10
	bypasses_immunity = TRUE
	disease_flags = CAN_CARRY|CAN_RESIST	//Once you drink this, there's no going back
	symptoms = list(new/datum/symptom/mind_restoration,
					new/datum/symptom/heal/supertoxin,
					new/datum/symptom/heal/superbrute,
					new/datum/symptom/heal/heatresistance,
					new/datum/symptom/heal/dna,
					new/datum/symptom/oxygen
					)