/obj/item/gun/ballistic/automatic/c20r
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'

/obj/item/gun/ballistic/automatic/l6_saw
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'

/obj/item/gun/ballistic/automatic/sniper_rifle
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'

/obj/item/gun/ballistic/automatic/l6_saw/attack_self(mob/living/user)
	if(!internal_magazine && magazine)
		if(!cover_open)
			to_chat(user, "<span class='warning'>[src]'s cover is closed! Open it before trying to remove the magazine!</span>")
			return
		eject_magazine(user)
		return
	if (recent_rack > world.time)
		return
	recent_rack = world.time + rack_delay
	rack(user)
