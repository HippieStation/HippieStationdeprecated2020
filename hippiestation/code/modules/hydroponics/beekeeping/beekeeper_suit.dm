/obj/item/clothing/head/beekeeper_head/syndicate
	name = "beekeeper hat"
	desc = "The mark of your trade."
	alternate_worn_icon = 'hippiestation/icons/mob/head.dmi'
	icon = 'hippiestation/icons/obj/clothing/hats.dmi'
	icon_state = "drbees"
	item_state = "drbees"
	armor = list("melee" = 35, "bullet" = 30, "laser" = 30,"energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50) //standard security helmet

/obj/item/clothing/suit/beekeeper_suit/syndicate
	name = "beekeeper suit"
	desc = "Keeps the little brothers away from your squishy bits and comfortable in a little niche inside the suit."
	alternate_worn_icon = 'hippiestation/icons/mob/suit.dmi'
	icon = 'hippiestation/icons/obj/clothing/suits.dmi'
	icon_state = "drbees"
	item_state = "drbees"
	clothing_flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor = list("melee" = 30, "bullet" = 30, "laser" = 30, "energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50) //decently robust, same as a standard security vest
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	var/beecharges = 1


/obj/item/clothing/suit/beekeeper_suit/syndicate/process(mob/living/carbon/human/user)
	var/delay = 30
	if(world.time > cooldown || beecharges == 10)
		cooldown = world.time + delay
		beecharges = beecharges + 1
		if(beecharges == 1)
			to_chat(user, "<span class ='notice'>You feel the beekeeper suit start to buzz...</span>")
		else
			to_chat(user, "<span class ='notice'>You feel the buzzing in the beekeeper suit intensify...</span>")

/obj/item/clothing/suit/beekeeper_suit/syndicate/attack_self(mob/user)
	if(beecharges == 0)
		to_chat(user, "<span class='warning'>The bees aren't ready!</span>")
		return FALSE
	for(var/beecharges)
		new /mob/living/simple_animal/hostile/poison/bees
		beecharges = 0

	//add timer to increment beecharges each 30 seconds

	//add UI button to spawn number of bees equal to beecharges and set beecharges to 0

	//alternatively add the summon bees spell while wearing the suit?

/*
/obj/item/clothing/suit/beekeeper_suit/syndicate
/obj/item/clothing/head/welding/attack_self(mob/user)







*/