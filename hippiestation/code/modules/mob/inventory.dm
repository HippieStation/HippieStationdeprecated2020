/mob/living/proc/unequip_all_items(force = FALSE) //like unequip_everything but don't drop items in hands and have option to force it
	var/list/items = list()
	items |= get_equipped_items(TRUE)
	for(var/I in items)
		dropItemToGround(I, force)

/mob/living/quick_equip()
	var/obj/item/I = get_active_held_item()
	if (I)
		if(equip_to_appropriate_slot(I))
			update_inv_hands()
			return
		else
			if(I.equip_delay_self)
				return
		if(active_storage && active_storage.parent && SEND_SIGNAL(active_storage.parent, COMSIG_TRY_STORAGE_INSERT, I, src))
			return
		var/list/obj/item/possible = list(get_inactive_held_item(), get_item_by_slot(SLOT_BELT), get_item_by_slot(SLOT_GENERC_DEXTROUS_STORAGE), get_item_by_slot(SLOT_BACK))
		for(var/i in possible)
			if(!i)
				continue
			var/obj/item/store = i
			if(SEND_SIGNAL(store, COMSIG_TRY_STORAGE_INSERT, I, src))
				return
		for(var/obj/item/inv in get_equipped_items())
			if(I.slot_flags == inv.slot_flags)
				if(putItemFromInventoryInHandIfPossible(inv, get_inactive_hand_index()))
					I.equip_to_best_slot(src)
					return
	..()
