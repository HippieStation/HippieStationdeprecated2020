/obj/item/weapon/wirerod/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/shard))
		var/obj/item/weapon/twohanded/spear/S = new /obj/item/weapon/twohanded/spear

		remove_item_from_storage(user)
		qdel(I)
		qdel(src)

		user.put_in_hands(S)
		to_chat(user, "<span class='notice'>You fasten the glass shard to the top of the rod with the cable.</span>")

	else if(istype(I, /obj/item/device/assembly/igniter) && !(I.flags & NODROP))
		var/obj/item/weapon/melee/baton/cattleprod/hippie_cattleprod/P = new /obj/item/weapon/melee/baton/cattleprod/hippie_cattleprod

		remove_item_from_storage(user)

		to_chat(user, "<span class='notice'>You fasten [I] to the top of the rod with the cable.</span>")

		qdel(I)
		qdel(src)

		user.put_in_hands(P)
	else
		return ..()