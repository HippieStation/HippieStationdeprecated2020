/obj/item/clothing/suit/apron/chef/scrake
	name = "scrake's apron"
	desc = "An apron used to stop getting the gibs of enemies on your skin."
	allowed = list(/obj/item/tank/internals)
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	clothing_flags = THICKMATERIAL | STOPSPRESSUREDAMAGE
	armor = list("melee" = 70, "bullet" = 45, "laser" = 80, "energy" = 45, "bomb" = 75, "bio" = 0, "rad" = 30, "fire" = 80, "acid" = 100)
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF

/obj/item/clothing/suit/apron/chef/scrake/equipped(mob/user, slot)
	if(slot == SLOT_WEAR_SUIT)
		user.add_trait(TRAIT_PUSHIMMUNE, "Scrake")
		item_flags = NODROP
