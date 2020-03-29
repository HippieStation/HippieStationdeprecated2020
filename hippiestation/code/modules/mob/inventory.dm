/mob/living/proc/unequip_all_items(force = FALSE) //like unequip_everything but don't drop items in hands and have option to force it
	var/list/items = list()
	items |= get_equipped_items(TRUE)
	for(var/I in items)
		dropItemToGround(I, force)

/mob/living/quick_equip()
	var/obj/item/I = get_active_held_item()
	if (I)
		if(!equip_to_appropriate_slot(I))
			for(var/obj/item/inv in get_equipped_items())
				if(I.slot_flags & inv.slot_flags)
					if(putItemFromInventoryInHandIfPossible(inv, get_inactive_hand_index()))
						I.equip_to_best_slot(src)
						return
		else
			update_inv_hands()
