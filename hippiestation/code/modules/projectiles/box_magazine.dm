/obj/item/ammo_box/attackby(obj/item/A, mob/user, params, silent = 0, replace_spent = 0)
	var/num_loaded = 0
	if(!can_load(user))
		return
	if(istype(A, /obj/item/ammo_box))
		var/obj/item/ammo_box/AM = A
		for(var/obj/item/ammo_casing/AC in AM.stored_ammo)
			var/did_load = give_round(AC, replace_spent)
			if(did_load)
				AM.stored_ammo -= AC
				num_loaded++
			if(!did_load || !multiload)
				break
	if(istype(A, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/AC = A
		if(give_round(AC, replace_spent))
			user.drop_item()
			AC.forceMove(src)
			num_loaded++

	if(num_loaded)
		if(!silent)
			to_chat(user, "<span class='notice'>You load [num_loaded] shell\s into \the [src]!</span>")
			playsound(user, 'hippiestation/sound/weapons/speedload.ogg', 60, 1)
		A.update_icon()
		update_icon()

	return num_loaded
