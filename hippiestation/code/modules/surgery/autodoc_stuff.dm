/datum/surgery_step/incise/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if (!(NOBLOOD in H.dna.species.species_traits))
			H.bleed_rate += 3
	return TRUE

/datum/surgery_step/clamp_bleeders/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	if(locate(/datum/surgery_step/saw) in surgery.steps)
		target.heal_bodypart_damage(20,0)
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		H.bleed_rate = max( (H.bleed_rate - 3), 0)
	return TRUE

/datum/surgery_step/close/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	if(locate(/datum/surgery_step/saw) in surgery.steps)
		target.heal_bodypart_damage(45,0)
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		H.bleed_rate = max( (H.bleed_rate - 3), 0)
	return TRUE

/datum/surgery_step/saw/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	target.apply_damage(50, BRUTE, "[target_zone]")
	return TRUE

/datum/surgery_step/fix_brain/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	if(target.mind && target.mind.has_antag_datum(/datum/antagonist/brainwashed))
		target.mind.remove_antag_datum(/datum/antagonist/brainwashed)
	target.adjustBrainLoss(-60)
	target.cure_all_traumas(TRAUMA_RESILIENCE_SURGERY)
	return TRUE

/datum/surgery_step/sever_limb/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	if(surgery.operated_bodypart)
		var/obj/item/bodypart/target_limb = surgery.operated_bodypart
		target_limb.drop_limb()
		target_limb.forceMove(get_turf(autodoc))
		autodoc.visible_message("<span class='notice'>\The [autodoc] spits out \the [target_limb]!</span>")
	return TRUE

/datum/surgery_step/heal/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	target.heal_bodypart_damage(brutehealing,burnhealing)
	return TRUE

/datum/surgery_step/extract_implant/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	for(var/obj/item/O in target.implants)
		I = O
		break
	if(I)
		I.removed(target)
		var/obj/item/implantcase/case
		for(var/obj/item/implantcase/ic in autodoc.contents)
			case = ic
			break
		if(!case)
			case = locate(/obj/item/implantcase) in get_turf(target)
		if(case && !case.imp)
			case.imp = I
			I.forceMove(case)
			case.update_icon()
		else
			qdel(I)
	return TRUE

/datum/surgery_step/manipulate_organs/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	for(var/obj/item/organ/O in autodoc.contents)
		if(O.zone == target_zone)
			O.Insert(target)
	return TRUE

/datum/surgery_step/manipulate_organs/autodoc_check(target_zone, obj/machinery/autodoc/autodoc, silent = TRUE, mob/living/carbon/target)
	for(var/obj/item/organ/O in autodoc.contents)
		if(O.zone == target_zone)
			return TRUE
	if(!silent)
		autodoc.say("No valid organs that fit into the [parse_zone(target_zone)] found in internal storage!")
	return FALSE

/datum/surgery_step/remove_fat/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	target.overeatduration = 0 //patient is unfatted
	var/removednutriment = target.nutrition
	target.set_nutrition(NUTRITION_LEVEL_WELL_FED)
	removednutriment -= 450 //whatever was removed goes into the meat
	var/mob/living/carbon/human/H = target
	var/typeofmeat = /obj/item/reagent_containers/food/snacks/meat/slab/human

	if(H.dna && H.dna.species)
		typeofmeat = H.dna.species.meat

	var/obj/item/reagent_containers/food/snacks/meat/slab/human/newmeat = new typeofmeat
	newmeat.name = "fatty meat"
	newmeat.desc = "Extremely fatty tissue taken from a patient."
	newmeat.subjectname = H.real_name
	newmeat.subjectjob = H.job
	newmeat.reagents.add_reagent (/datum/reagent/consumable/nutriment, (removednutriment / 15)) //To balance with nutriment_factor of nutriment
	newmeat.forceMove(get_turf(autodoc))
	autodoc.visible_message("<span class='notice'>\The [autodoc] spits out \the [newmeat]!</span>")
	return TRUE

/datum/surgery_step/replace_limb/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	for(var/obj/item/bodypart/limb in autodoc.contents)
		if(limb.body_zone == target_zone)
			L = limb
			break
	if(L)
		L.replace_limb(target, TRUE)
	return TRUE

/datum/surgery_step/replace_limb/autodoc_check(target_zone, obj/machinery/autodoc/autodoc, silent = TRUE, mob/living/carbon/target)
	for(var/obj/item/bodypart/limb in autodoc.contents)
		if(limb.body_zone == target_zone)
			return TRUE
	if(!silent)
		autodoc.say("No valid bodyparts that fit onto the [parse_zone(target_zone)] found in internal storage!")
	return FALSE

/datum/surgery_step/remove_object/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	if(L)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			for(var/obj/item/I in L.embedded_objects)
				autodoc.visible_message("<span class='notice'>\The [autodoc] spits out \the [I]!</span>")
				I.forceMove(get_turf(autodoc))
				L.embedded_objects -= I
			if(!H.has_embedded_objects())
				H.clear_alert("embeddedobject")
				SEND_SIGNAL(H, COMSIG_CLEAR_MOOD_EVENT, "embedded")
	return TRUE

/datum/surgery_step/add_prosthetic/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	var/obj/item/bodypart/L
	for(var/obj/item/bodypart/limb in autodoc.contents)
		if(limb.body_zone == target_zone)
			L = limb
			break
	if(L)
		L.attach_limb(target)
		if(organ_rejection_dam)
			target.adjustToxLoss(organ_rejection_dam)
	return TRUE

/datum/surgery_step/insert_pill
	ad_repeatable = TRUE

/datum/surgery_step/insert_pill/autodoc_check(target_zone, obj/machinery/autodoc/autodoc, silent = TRUE, mob/living/carbon/target)
	for(var/obj/item/reagent_containers/pill/P in autodoc.contents)
		return TRUE
	if(!silent)
		autodoc.say("No pills found in internal storage!")
	return FALSE

/datum/surgery_step/insert_pill/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	var/obj/item/reagent_containers/pill/pill
	for(var/obj/item/reagent_containers/pill/P in autodoc.contents)
		pill = P
		break
	if(pill)
		pill.forceMove(target)
		var/datum/action/item_action/hands_free/activate_pill/P = new(pill)
		P.button.name = "Activate [pill.name]"
		P.target = pill
		P.Grant(target)
	return TRUE

/datum/surgery_step/fix_eyes/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	target.cure_blind(list(EYE_DAMAGE))
	target.set_blindness(0)
	target.cure_nearsighted(list(EYE_DAMAGE))
	target.blur_eyes(35)	//this will fix itself slowly.
	target.set_eye_damage(0)
	return TRUE

/datum/surgery_step/heal/autodoc_check(target_zone, obj/machinery/autodoc/autodoc, silent, mob/living/carbon/target)
	if(target && !(brutehealing && target.getBruteLoss()) && !(burnhealing && target.getFireLoss()))
		return FALSE
	return TRUE

/datum/surgery_step/revive/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	playsound(get_turf(target), 'sound/magic/lightningbolt.ogg', 50, 1)
	target.adjustOxyLoss(-50, 0)
	target.updatehealth()
	if(target.revive())
		target.visible_message("...[target] wakes up, alive and aware!")
		target.emote("gasp")
		target.adjustBrainLoss(50, 199) //MAD SCIENCE
		return TRUE
	else
		target.visible_message("...[target.p_they()] convulses, then lies still.")
		return FALSE

/datum/surgery_step/pacify/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	target.gain_trauma(/datum/brain_trauma/severe/pacifism, TRAUMA_RESILIENCE_LOBOTOMY)
	return TRUE

/datum/surgery_step/thread_veins/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	new /datum/bioware/threaded_veins(target)
	return TRUE

/datum/surgery_step/splice_nerves/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	new /datum/bioware/spliced_nerves(target)
	return TRUE

/datum/surgery_step/ground_nerves/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	new /datum/bioware/grounded_nerves(target)
	return TRUE

/datum/surgery_step/muscled_veins/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	new /datum/bioware/muscled_veins(target)
	return TRUE

/datum/surgery_step/reinforce_ligaments/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	new /datum/bioware/reinforced_ligaments(target)
	return TRUE

/datum/surgery_step/reshape_ligaments/autodoc_success(mob/living/carbon/target, target_zone, datum/surgery/surgery, obj/machinery/autodoc/autodoc)
	new /datum/bioware/hooked_ligaments(target)
	return TRUE
