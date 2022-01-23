/obj/item/gun/ballistic/revolver
	fire_sound = 'hippiestation/sound/weapons/gunshot_magnum.ogg'
	load_sound = 'hippiestation/sound/weapons/speedload.ogg'

/obj/item/gun/ballistic/revolver/detective
	fire_sound = 'hippiestation/sound/weapons/gunshot_38special.ogg'
	interact_sound_cooldown = 50
	pickup_sound = 'hippiestation/sound/weapons/mysterious_out.ogg'
	dropped_sound = 'hippiestation/sound/weapons/mysterious_in.ogg'

/obj/item/gun/ballistic/shotgun/doublebarrel
	fire_sound = 'hippiestation/sound/weapons/shotgun_shoot.ogg'

/obj/item/gun/ballistic/revolver/detective/try_play_interact_sound(mob/user)
	if (istype(user.loc, /turf))
		var/turf/T = user.loc
		if (T)
			var/lumcount = T.get_lumcount()

			if (lumcount >= 0.4) // Don't wait to spook people in maint when you pull out your shooter
				..()

/obj/item/gun/ballistic/revolver/CtrlShiftClick(mob/user)
	..()
	var/mob/M = usr
	if (M.is_holding(src))
		src.SpinAnimation(5,1)
		M.visible_message("[M] swings the [src] in their hand! Radical!", "<span class='notice'>You swing the [src] in your hand. Radical!")
	else
		to_chat(M, "<span class='notice'>The [src] needs to be in your hand before you can swing it!")
