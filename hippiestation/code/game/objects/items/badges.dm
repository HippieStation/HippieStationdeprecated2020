/* Cards
 * Contains:
 * Various badges
 */
/*
 * Badges: Used to display authority.
 * Can be expanded in the future to give everyone badges, or to even give some kind of function/verbs to the badges.
 * Could also be turned into a steal objective? ""steal a command badge, steal three security badges, etc.
 */
/obj/item/clothing/accessory/badge //I've moved this under accessories so they can be placed on jumpsuits or on the belt slot.
	name = "badge"
	desc = "Does badge things."
	icon = 'hippiestation/icons/obj/badge.dmi'
	slot_flags = ITEM_SLOT_BELT //You can attach this in the belt slot. Ideally ID would go in PDA and be placed in ID slot, and this could be put in belt slot.
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF //IDs are immune to fire and acid, badges should be also.
	force = 3 //weaker than a toy, but it doesn't make sense for it to do no damage.
	throwforce = 3
	attack_verb = list("attacked", "slashed", "stabbed", "sliced")

/obj/item/clothing/accessory/badge/suicide_act(mob/living/carbon/user) //somewhat unique suicide message for fun.
	user.visible_message("<span class='suicide'>[user] begins to stab [user.p_their()] eyes with \the [src]! The responsibility was too much for them! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return BRUTELOSS

/obj/item/clothing/accessory/badge/attack_self(mob/user) //All badges will flash/shine the same way.
	user.visible_message("[user] flashes their shiny badge.", "<span class='notice'>You briefly flash your badge.</span>")


/obj/item/clothing/accessory/badge/attorney
	name = "attorney badge"
	desc = "An attorney badge, showing the authority of space prosecution and defence."
	icon_state = "attorney"
	materials = list(MAT_METAL=1000) // No reason as to why you can't reclaim this for materials.

/obj/item/clothing/accessory/badge/security
	name = "security badge"
	desc = "A security badge, showing the authority of space law."
	icon_state = "security"
	materials = list(MAT_METAL=1000)

/obj/item/clothing/accessory/badge/command
	name = "command badge"
	desc = "One of the elites."
	icon_state = "command"
	materials = list(MAT_GOLD=1000) //Command badges are golden, and obviously worth more.