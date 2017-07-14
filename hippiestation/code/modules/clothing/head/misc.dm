/obj/item/clothing/head/fedora/attack_self(mob/user)
	var/mob/living/carbon/human/H = user
	if(user.gender == MALE)
		user.visible_message("<span class='italics'>[user] tips the [src]! It looks like they're trying to be nice to girls.</span>")
		user.say("M'lady.")
		sleep(10)
		H.facial_hair_style = "Neckbeard"
		H.adjustBrainLoss(10)
	else if(user.gender == FEMALE)
		user.visible_message("<span class='italics'>[user] tips the [src]! It looks like they're trying to be nice to guys.</span>")
		user.say("M'lord.")
		sleep(10)
		H.facial_hair_style = "Neckbeard"
		H.adjustBrainLoss(10 )
	return