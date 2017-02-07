/obj/structure/reagent_dispensers/water_cooler/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/paper))
		if(!user.drop_item())
			return
		qdel(I)
		paper_cups++
		return

	if (istype(I, /obj/item/weapon/wrench))
		if (!anchored && !isinspace())
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			user << "<span class='notice'> You begin to tighten \the [src] to the floor...</span>"
			if (do_after(user, 20, target = src))
				user.visible_message( \
					"[user] tightens \the [src]'s casters.", \
					"<span class='notice'>You tighten \the [src]'s casters. Anchoring it down.</span>", \
					"<span class='italics'>You hear ratchet.</span>")
				anchored = 1
		else if(anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			user << "<span class='notice'> You begin to loosen \the [src]'s casters...</span>"
			if (do_after(user, 40, target = src))
				user.visible_message( \
					"[user] loosens \the [src]'s casters.", \
					"<span class='notice'>You loosen \the [src]. Now it can be pulled somewhere else.</span>", \
					"<span class='italics'>You hear ratchet.</span>")
				anchored = 0
	else
		..()

//honkcooler
/obj/structure/reagent_dispensers/water_cooler/clown
	name = "Honk-Cooler"
	desc = "A machine filled with the clown's thick juice! NICE!"
	icon = 'code/modules/hippie/icons/obj/vending.dmi'
	icon_state = "honk_cooler"
	reagent_id = "banana"
