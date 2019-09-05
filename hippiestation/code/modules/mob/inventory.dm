/mob/living/proc/unequip_all_items(force = FALSE) //like unequip_everything but don't drop items in hands and have option to force it
	var/list/items = list()
	items |= get_equipped_items(TRUE)
	for(var/I in items)
		dropItemToGround(I, force)