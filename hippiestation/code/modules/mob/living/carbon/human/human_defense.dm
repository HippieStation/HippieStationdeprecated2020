/mob/living/carbon/human/grabbedby(mob/living/user, supress_message = 0)
	if (checkbuttinspect(user))
		return FALSE
	return ..()

/mob/living/carbon/human/soundbang_act()
	if(status_flags & GODMODE)
		return
	. = ..()

/mob/living/carbon/human/flash_act(intensity = 1, override_blindness_check = 0, affect_silicon = 0, visual = 0, type = /obj/screen/fullscreen/flash)
	if(status_flags & GODMODE)
		return
	. = ..()

//to damage the clothes worn by a mob
/mob/living/carbon/human/damage_clothes(damage_amount, damage_type = BRUTE, damage_flag = 0, def_zone)
	if(status_flags & GODMODE)
		return
	. = ..()

/mob/living/carbon/human/ex_act(severity, target, origin)
	if(status_flags & GODMODE)
		return
	. = ..()

/mob/living/carbon/human/acid_act(acidpwr, acid_volume)
	if(status_flags & GODMODE)
		return
	. = ..()

/mob/living/carbon/human/electrocute_act(shock_damage, source, siemens_coeff = 1, safety = 0, override = 0, tesla_shock = 0, illusion = 0, stun = TRUE)
	if(status_flags & GODMODE)
		return
	. = ..()

/mob/living/carbon/human/singularity_act()
	if(status_flags & GODMODE)
		return
	. = ..()
