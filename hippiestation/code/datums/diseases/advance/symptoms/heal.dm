/datum/symptom/heal/starlight
	level = 0

/datum/symptom/heal/chem
	level = 0

/datum/symptom/heal/metabolism
	level = 0

/datum/symptom/heal/darkness
	level = 0

/datum/symptom/heal/coma
	stealth = 0
	resistance = 2
	stage_speed = -2
	transmittable = -2
	level = 8

/datum/symptom/heal/water
	level = 0

/datum/symptom/heal/plasma
	stealth = 0
	resistance = 3
	stage_speed = -2
	transmittable = -2
	level = 6

/datum/symptom/heal/radiation
	level = 0

/datum/symptom/oldcode/heal/
	name = "Toxic Filter"
	desc = ""
	stealth = 1
	resistance = -2
	stage_speed = -2
	transmittable = -2
	level = 4
	threshold_desc = ""

/datum/symptom/oldcode/heal/Activate(datum/disease/advance/A)
	..()
	 //100% chance to activate for slow but consistent healing
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(4, 5)
			Heal(M, A)
	return

/datum/symptom/oldcode/heal/proc/Heal(mob/living/M, datum/disease/advance/A)
	var/heal_amt = 0.5
	M.adjustToxLoss(-heal_amt)
	return 1

/datum/symptom/oldcode/heal/plus
	name = "Apoptoxin filter"
	desc = ""
	stealth = 0
	resistance = -2
	stage_speed = -2
	transmittable = -2
	level = 6
	threshold_desc = ""

/datum/symptom/oldcode/heal/plus/Heal(mob/living/M, datum/disease/advance/A)
	var/heal_amt = 1
	M.adjustToxLoss(-heal_amt)
	return 1

/datum/symptom/oldcode/heal/brute
	name = "Regeneration"
	desc = ""
	stealth = 1
	resistance = -2
	stage_speed = -2
	transmittable = -2
	level = 4
	threshold_desc = ""

/datum/symptom/oldcode/heal/brute/Heal(mob/living/carbon/M, datum/disease/advance/A)
	var/heal_amt = 1

	var/list/parts = M.get_damaged_bodyparts(1,1) //1,1 because it needs inputs.

	if(!parts.len)
		return

	for(var/obj/item/bodypart/L in parts)
		if(L.heal_damage(heal_amt/parts.len, 0))
			M.update_damage_overlays()

	return 1

/datum/symptom/oldcode/heal/brute/plus
	name = "Flesh Mending"
	desc = ""
	stealth = 0
	resistance = 0
	stage_speed = -2
	transmittable = -2
	level = 6
	threshold_desc = ""

/datum/symptom/oldcode/heal/brute/plus/Heal(mob/living/carbon/M, datum/disease/advance/A)
	var/heal_amt = 2

	var/list/parts = M.get_damaged_bodyparts(1,1) //1,1 because it needs inputs.

	if(M.getCloneLoss() > 0)
		M.adjustCloneLoss(-1)
		M.take_bodypart_damage(0, 1) //Deals BURN damage, which is not cured by this symptom

	if(!parts.len)
		return

	for(var/obj/item/bodypart/L in parts)
		if(L.heal_damage(heal_amt/parts.len, 0))
			M.update_damage_overlays()

	return 1

/datum/symptom/oldcode/heal/burn
	name = "Tissue Regrowth"
	desc = ""
	stealth = 1
	resistance = -2
	stage_speed = -2
	transmittable = -2
	level = 6
	threshold_desc = ""

/datum/symptom/oldcode/heal/burn/Heal(mob/living/carbon/M, datum/disease/advance/A)
	var/heal_amt = 1

	var/list/parts = M.get_damaged_bodyparts(1,1) //1,1 because it needs inputs.

	if(!parts.len)
		return

	for(var/obj/item/bodypart/L in parts)
		if(L.heal_damage(0, heal_amt/parts.len))
			M.update_damage_overlays()

	return 1

/datum/symptom/oldcode/heal/burn/plus
	name = "Heat Resistance"
	desc = ""
	stealth = 0
	resistance = 0
	stage_speed = -2
	transmittable = -2
	level = 4
	threshold_desc = ""

/datum/symptom/oldcode/heal/burn/plus/Heal(mob/living/carbon/M, datum/disease/advance/A)
	var/heal_amt = 2

	var/list/parts = M.get_damaged_bodyparts(1,1) //1,1 because it needs inputs.

	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (10 * heal_amt * TEMPERATURE_DAMAGE_COEFFICIENT))
	else if(M.bodytemperature < 311)
		M.bodytemperature = min(310, M.bodytemperature + (10 * heal_amt * TEMPERATURE_DAMAGE_COEFFICIENT))

	if(!parts.len)
		return

	for(var/obj/item/bodypart/L in parts)
		if(L.heal_damage(0, heal_amt/parts.len))
			M.update_damage_overlays()

	return 1

/datum/symptom/oldcode/heal/dna
	name = "Deoxyribonucleic Acid Restoration"
	desc = ""
	stealth = -1
	resistance = -1
	stage_speed = 0
	transmittable = -1
	level = 5
	threshold_desc = ""

/datum/symptom/heal/dna/Heal(mob/living/carbon/M, datum/disease/advance/A)
	var/amt_healed = 1
	M.adjustBrainLoss(-amt_healed)
	//Non-power mutations, excluding race, so the virus does not force monkey -> human transformations.
	var/list/unclean_mutations = (GLOB.not_good_mutations|GLOB.bad_mutations) - GLOB.mutations_list[RACEMUT]
	M.dna.remove_mutation_group(unclean_mutations)
	M.radiation = max(M.radiation - (2 * amt_healed), 0)
	return 1

