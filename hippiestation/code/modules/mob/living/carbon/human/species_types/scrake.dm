/datum/species/scrake
	name = "Scrake"
	id = "scrake"
	limbs_id = "husk"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,NOBLOOD)
	default_features = list("mcolor" = "FFF", "tail_human" = "None", "ears" = "None", "wings" = "None")
	sexes = 0
	inherent_traits = list(TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_RADIMMUNE,TRAIT_NOBREATH,TRAIT_NOGUNS,TRAIT_PIERCEIMMUNE,TRAIT_SHOCKIMMUNE,TRAIT_VIRUSIMMUNE,TRAIT_SLEEPIMMUNE,TRAIT_PUSHIMMUNE,TRAIT_STUNIMMUNE,TRAIT_DISFIGURED,TRAIT_IGNOREDAMAGESLOWDOWN,TRAIT_NOLIMBDISABLE,TRAIT_NODISMEMBER,TRAIT_NOHUNGER)
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/zombie
	no_equip = list(ITEM_SLOT_GLOVES, ITEM_SLOT_FEET, ITEM_SLOT_SUITSTORE, ITEM_SLOT_BACK, ITEM_SLOT_ID)
	mutanttongue = /obj/item/organ/tongue/zombie
	mutanteyes = /obj/item/organ/eyes/night_vision/zombie
	armor = 15
	coldmod = 0.5
	heatmod = 0.4
	burnmod = 0.4
	stunmod = 0.4
	var/static/list/spooks = list('hippiestation/sound/creatures/ScrakeVoice1.ogg','hippiestation/sound/creatures/ScrakeVoice2.ogg','hippiestation/sound/creatures/ScrakeVoice3.ogg','hippiestation/sound/creatures/ScrakeVoice4.ogg','hippiestation/sound/creatures/ScrakeVoice7.ogg','hippiestation/sound/creatures/ScrakeVoice8.ogg','hippiestation/sound/creatures/ScrakeGiggle.ogg','hippiestation/sound/creatures/zombiegrowl1.ogg')
	changesource_flags = MIRROR_BADMIN | WABBAJACK
	deathsound = 'hippiestation/sound/creatures/ZombieDie2.ogg'

/datum/species/scrake/spec_life(mob/living/carbon/C)
	. = ..()
	if(C.stat == DEAD)
		return
	C.a_intent = INTENT_HARM // THE SUFFERING MUST FLOW
	if(prob(6))
		playsound(C, pick(spooks), 50, FALSE, 12)
	if(prob(10))
		playsound(C, 'hippiestation/sound/creatures/SawIdle.ogg', 25, FALSE)
