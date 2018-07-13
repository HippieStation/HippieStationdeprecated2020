/obj/item/clothing/head/beekeeper_head/syndicate
	name = "beekeeper hat"
	desc = "The mark of your trade."
	icon = 'hippiestation/icons/obj/clothing/hats.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/head.dmi'
	icon_state = "drbees"
	item_state = "drbees"
	armor = list("melee" = 35, "bullet" = 30, "laser" = 30,"energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50) //standard security helmet
	clothing_flags = THICKMATERIAL


/obj/item/clothing/suit/beekeeper_suit/syndicate
	name = "beekeeper suit"
	desc = "Keeps the little brothers away from your squishy bits."
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

	//add timer to increment beecharges each 30 seconds

	//add UI button to spawn number of bees equal to beecharges and set beecharges to 0

	//alternatively add the summon bees spell while wearing the suit?

/*
/obj/item/clothing/suit/beekeeper_suit/syndicate








*/