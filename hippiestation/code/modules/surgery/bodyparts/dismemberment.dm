/obj/item/bodypart/head/drop_limb(special)
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.checknoosedrop()