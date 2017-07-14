

/obj/item/clothing/head/fedora
	name = "fedora"
	icon_state = "fedora"
	item_state = "fedora"
	armor = list(melee = 25, bullet = 5, laser = 25, energy = 10, bomb = 0, bio = 0, rad = 0, fire = 30, acid = 50)
	desc = "A really cool hat if you're a mobster. A really lame hat if you're not."
	dynamic_hair_suffix = "+detective"
	pockets = /obj/item/weapon/storage/internal/pocket/small

/obj/item/clothing/head/fedora/suicide_act(mob/user)
	if(user.gender == FEMALE)
		return 0
	var/mob/living/carbon/human/H = user
	user.visible_message("<span class='suicide'>[user] is donning [src]! It looks like they're trying to be nice to girls.</span>")
	user.say("M'lady.")
	sleep(10)
	H.facial_hair_style = "Neckbeard"
	return(BRUTELOSS)

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