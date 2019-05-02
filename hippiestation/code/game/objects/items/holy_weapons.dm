/obj/item/nullrod/Initialize()
	. = ..()
	var/datum/component/comp = GetComponent(/datum/component/anti_magic)
	qdel(comp)

/obj/item/nullrod/godhand/Initialize()
	. = ..()
	remove_trait(TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)

/obj/item/nullrod/chainsaw/Initialize()
	. = ..()
	remove_trait(TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)

/obj/item/nullrod/armblade/Initialize()
	. = ..()
	remove_trait(TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)
