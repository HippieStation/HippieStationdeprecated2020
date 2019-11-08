/datum/species/scrake
	name = "Scrake"
	id = "scrake"
	limbs_id = "zombie"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,NOBLOOD)
	default_features = list("mcolor" = "FFF", "tail_human" = "None", "ears" = "None", "wings" = "None")
	sexes = 0
	inherent_traits = list(TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_RADIMMUNE,TRAIT_NOBREATH,TRAIT_NOGUNS,TRAIT_PIERCEIMMUNE,TRAIT_SHOCKIMMUNE,TRAIT_VIRUSIMMUNE,TRAIT_SLEEPIMMUNE,TRAIT_PUSHIMMUNE,TRAIT_STUNIMMUNE,TRAIT_DISFIGURED,TRAIT_IGNOREDAMAGESLOWDOWN,TRAIT_NOLIMBDISABLE,TRAIT_NODISMEMBER,TRAIT_NOHUNGER)
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/zombie
	no_equip = list(SLOT_GLOVES, SLOT_SHOES, SLOT_S_STORE, SLOT_BACK, SLOT_WEAR_ID)
	mutanttongue = /obj/item/organ/tongue/zombie
	mutanteyes = /obj/item/organ/eyes/night_vision/zombie
	armor = 20
	coldmod = 0.5
	heatmod = 0.3
	burnmod = 0.3
	stunmod = 0.25
	var/static/list/spooks = list('hippiestation/sound/creatures/ScrakeVoice1.wav','hippiestation/sound/creatures/ScrakeVoice2.wav','hippiestation/sound/creatures/ScrakeVoice3.wav','hippiestation/sound/creatures/ScrakeVoice4.wav','hippiestation/sound/creatures/ScrakeVoice7.wav','hippiestation/sound/creatures/ScrakeVoice8.wav','hippiestation/sound/creatures/ScrakeGiggle.wav')

/datum/species/scrake/spec_life(mob/living/carbon/C)
	. = ..()
	C.a_intent = INTENT_HARM // THE SUFFERING MUST FLOW
	if(prob(6))
		playsound(C, pick(spooks), 50, FALSE, 12)