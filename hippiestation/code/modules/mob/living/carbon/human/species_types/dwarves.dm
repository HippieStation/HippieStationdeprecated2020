#define DWARF_ALCOHOL_RATE 0.1 // The normal rate is 0.005. For 100 units of the strongest alcohol possible (boozepwr = 100), you'd have 10*100*0.005 = 5, which is too small as a value to operate with.
								// With 0.1, 100 units of the strongest alcohol would refill you completely from 0 to 100, which is perfect.
#define DRUNK_ALERT_TIME_OFFSET 10 SECONDS

// To make dwarven only jumpsuits, add this species' path to the clothing's species_exception list. By default jumpsuits don't fit dwarven since they're big boned
/datum/species/dwarf
	name = "Dwarf"
	id = "dwarf"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,NO_UNDERWEAR)
	default_features = list("mcolor" = "FFF", "wings" = "None")
	use_skintones = 1
	disliked_food = GROSS | RAW
	liked_food = JUNKFOOD | FRIED
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	offset_features = list(OFFSET_UNIFORM = list(0,0), OFFSET_ID = list(0,0), OFFSET_GLOVES = list(0,0), OFFSET_GLASSES = list(0,0), OFFSET_EARS = list(0,0), OFFSET_SHOES = list(0,0), OFFSET_S_STORE = list(0,0), OFFSET_FACEMASK = list(0,-3), OFFSET_HEAD = list(0,-3), OFFSET_HAIR = list(0,-4), OFFSET_FACE = list(0,-3), OFFSET_BELT = list(0,0), OFFSET_BACK = list(0,0), OFFSET_SUIT = list(0,0), OFFSET_NECK = list(0,-3))
	mutantlungs = /obj/item/organ/lungs/dwarven
	mutanttongue = /obj/item/organ/tongue/dwarven
	var/dwarfDrunkness = 100 // A value between 0 and 100.
	var/notDrunkEnoughTime = 0 // World time offset

/datum/species/dwarf/check_roundstart_eligible()
	return FALSE

/datum/species/dwarf/can_equip(obj/item/I, slot, disable_warning, mob/living/carbon/human/H, bypass_equip_delay_self = FALSE)
	if((slot == ITEM_SLOT_ICLOTHING) && !is_type_in_list(src, I.species_exception))
		return FALSE
	return ..()

/datum/species/dwarf/on_species_gain(mob/living/carbon/human/C, datum/species/old_species, pref_load)
	var/dwarf_hair = pick("Bald", "Skinhead", "Dandy Pompadour")
	var/dwarf_beard = pick("Beard (Dwarf)") // you know it'd be cool if this actually worked with more than one beard
	C.hair_style = dwarf_hair
	C.facial_hair_style = dwarf_beard
	C.draw_hippie_parts()
	. = ..()
	C.remove_all_languages()
	C.grant_language(/datum/language/dwarven)

/datum/species/dwarf/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	C.draw_hippie_parts(TRUE)
	. = ..()

/datum/species/dwarf/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(!..())
		if(istype(chem, /datum/reagent/consumable/ethanol))
			var/datum/reagent/consumable/ethanol/theGoodStuff = chem
			var/boozePower = sqrt(theGoodStuff.volume) * theGoodStuff.boozepwr * DWARF_ALCOHOL_RATE
			dwarfDrunkness = CLAMP(dwarfDrunkness + boozePower, 0, 100)
			return TRUE // Don't metabolize alcohol like normal humans do.

/datum/species/dwarf/spec_life(mob/living/carbon/human/H)
	..()
	if(notDrunkEnoughTime < world.time)
		dwarfDrunkness--
		notDrunkEnoughTime = world.time + DRUNK_ALERT_TIME_OFFSET + rand(0, DRUNK_ALERT_TIME_OFFSET/2) // between 10 and 15 seconds
		switch(dwarfDrunkness)
			if(0 to 30) // too low, harmful
				H.adjustBruteLoss(10)
				H.adjustStaminaLoss(80)
				to_chat(H, "<span class='userdanger'>The lack of alcohol hurts you!</span>") // I'm not good with fluff messages, todo: improve
			if(30 to 45)
				to_chat(H, "<span class='danger'>You feel really thirsty. Something's wrong.</span>")
				if(prob(5))
					H.gain_trauma_type(BRAIN_TRAUMA_MILD)
				H.adjustStaminaLoss(60)
			if(45 to 60)
				H.adjustStaminaLoss(40)
				if(prob(30))
					to_chat(H, "<span class='danger'>You could really use a drink right about now.</span>")
			if(60 to 75)
				if(prob(30))
					to_chat(H, "<span class='danger'>You feel quite thirsty. A good beverage wouldn't hurt.</span>")
			// Else nothing happens

/datum/species/dwarf/random_name(gender,unique,lastname)
	return dwarf_name()

#undef DWARF_ALCOHOL_RATE

