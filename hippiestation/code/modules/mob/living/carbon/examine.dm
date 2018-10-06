/mob/living/carbon/proc/hippie_carbon_examine()
	if(!(wear_mask && (wear_mask.flags_inv & HIDEFACE)) && is_thrall(src))
		return "Their features seem unnaturally tight and drawn.\n"
	return ""
