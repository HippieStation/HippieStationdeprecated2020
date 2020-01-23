/obj/item/clothing/shoes/hippie/cluwne
	desc = "The prankster's standard-issue clowning shoes. Damn, they're huge!"
	name = "clown shoes"
	icon_state = "cluwne"
	item_state = "cluwne"
	item_color = "cluwne"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	item_flags = DROPDEL
	slowdown = SHOES_SLOWDOWN+1
	var/footstep = 1
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/shoes/clown

/obj/item/clothing/shoes/hippie/cluwne/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/obj/item/clothing/shoes/hippie/cluwne/step_action()
	if(footstep > 1)
		playsound(src, "clownstep", 50, 1)
		footstep = 0
	else
		footstep++

/obj/item/clothing/shoes/hippie/cluwne/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	if(slot == SLOT_SHOES)
		var/mob/living/carbon/human/H = user
		H.dna.add_mutation(CLUWNEMUT)
	return

/obj/item/clothing/shoes/blastco
	name = "BlastCo(tm) rollerskates"
	desc = "A pair of roller skates, syndicate style. Will make you go faster."
	icon_state = "magboots-old1"
	item_state = "magboots-old1"
	slowdown = -1
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/shoes/buttshoes
	desc = "Why?"
	name = "butt shoes"
	alternate_worn_icon = 'hippiestation/icons/mob/feet.dmi'
	icon = 'hippiestation/icons/obj/clothing/shoes.dmi'
	icon_state = "buttshoes"
	item_state = "buttshoes"
	item_color = "buttshoes"

/obj/item/clothing/shoes/buttshoes/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, list('hippiestation/sound/effects/fart.ogg'), 50)

/obj/item/clothing/shoes/jackboots/larp
	name = "guard boots"
	desc = "Combat jackboots with a fancier look. The fur isn't any good for keeping the cold away."
	icon_state = "guardboots"
	item_state = "guardboots"
	icon = 'hippiestation/icons/obj/clothing/shoes.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/feet.dmi'
