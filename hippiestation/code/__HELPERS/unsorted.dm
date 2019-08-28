/atom/GetAllContents(var/T)
	. = ..()
	// Include items in the butt as part of "GetAllContents"
	if (istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		var/obj/item/organ/butt/B = H.getorgan(/obj/item/organ/butt)

		if (B)
			. += B.contents

/proc/IsCatbanned(player_ckey)
	var/client/C = GLOB.directory[player_ckey]
	if(C)
		if(C.country == "Brazil")
			return TRUE
	return is_banned_from(player_ckey, CATBAN)
