//does brute damage through armor and bio resistance
/datum/blobstrain/reagent/reactive_spines
	name = "Reactive Spines"
	description = "will do medium brute damage through armor and bio resistance."
	effectdesc = "will also react when attacked with burn or brute damage, attacking everything in melee range."
	analyzerdescdamage = "Does medium brute damage, ignoring armor and bio resistance."
	analyzerdesceffect = "When attacked with burn or brute damage it violently lashes out, attacking everything nearby."
	color = "#9ACD32"
	complementary_color = "#FFA500"
	blobbernaut_message = "stabs"
	message = "The blob stabs you"
	reagent = /datum/reagent/blob/reactive_spines

/datum/blobstrain/reagent/reactive_spines/damage_reaction(obj/structure/blob/B, damage, damage_type, damage_flag)
	if(damage && ((damage_type == BRUTE) || (damage_type == BURN)) && B.obj_integrity - damage > 0) //is there any damage, is it burn or brute, and will we be alive
		if(damage_flag == MELEE)
			B.visible_message("<span class='boldwarning'>The blob retaliates, lashing out!</span>")
		for(var/atom/A in range(1, B))
			A.blob_act(B)
	return ..()

/datum/reagent/blob/reactive_spines
	name = "Reactive Spines"
	taste_description = "rock"
	color = "#9ACD32"

/datum/reagent/blob/reactive_spines/return_mob_expose_reac_volume(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message, touch_protection, mob/camera/blob/overmind)
	if(exposed_mob.stat == DEAD || istype(exposed_mob, /mob/living/simple_animal/hostile/blob))
		return 0 //the dead, and blob mobs, don't cause reactions
	return reac_volume

/datum/reagent/blob/reactive_spines/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message, touch_protection, mob/camera/blob/overmind)
	. = ..()
	reac_volume = return_mob_expose_reac_volume(exposed_mob, methods, reac_volume, show_message, touch_protection, overmind)
	exposed_mob.adjustBruteLoss(reac_volume)
