/mob/living/carbon/proc/hippie_carbon_examine(mob/user)
	if(!(wear_mask && (wear_mask.flags_inv & HIDEFACE)) && is_thrall(src))
		. += "Their features seem unnaturally tight and drawn.\n"
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H != src  && istype(H.glasses, /obj/item/clothing/glasses/hud/threat))
			. += "<span class='info'><a href='?src=[REF(src)];threat=1'>\[View secret items\]</a></span>"
