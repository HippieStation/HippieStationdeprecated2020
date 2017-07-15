/obj/item/clothing/head/fedora/attack_self(mob/user)
	var/mob/living/carbon/human/H = user
		sleep(10)
		H.adjustBrainLoss(10)
		H.facial_hair_style = "Neckbeard"
	if(user.gender == MALE)
		user.visible_message("<span class='italics'>[user] tips the [src]! It looks like they're trying to be nice to girls.</span>")
		user.say("M'lady.")
	else if(user.gender == FEMALE)
		user.visible_message("<span class='italics'>[user] tips the [src]! It looks like they're trying to be nice to guys.</span>")
		user.say("M'lord.")