/mob/living/carbon/proc/hippie_carbon_examine()
	if(!wear_mask && is_thrall(src))
		return "Their features seem unnaturally tight and drawn.\n"
	return ""
