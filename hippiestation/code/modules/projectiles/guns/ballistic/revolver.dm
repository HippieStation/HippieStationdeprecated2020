/obj/item/weapon/gun/ballistic/revolver
	fire_sound = 'hippiestation/sound/weapons/gunshot_magnum.ogg'

/obj/item/weapon/gun/ballistic/revolver/attackby(obj/item/A, mob/user, params)
	. = ..()
	if(.)
		return
	var/num_loaded = magazine.attackby(A, user, params, 1)
	if(num_loaded)
		to_chat(user, "<span class='notice'>You load [num_loaded] shell\s into \the [src].</span>")
		playsound(user, 'hippiestation/sound/weapons/speedload.ogg', 60, 1)
		A.update_icon()
		update_icon()
		chamber_round(0)
