//Crafting
/obj/item/garrotehandles
	name = "garrote handles"
	desc = "Two handles for a garrote to be made. Needs cable to finish it."
	icon_state = "garrothandles"
	// item_state = "rods"
	icon = 'hippiestation/icons/obj/garrote.dmi'
	w_class = 2
	materials = list(MAT_METAL=1000)

/obj/item/garrotehandles/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/R = I
		if (R.use(20))
			var/obj/item/garrote/W = new /obj/item/garrote
			if(!remove_item_from_storage(user))
				user.temporarilyRemoveItemFromInventory(src)
			W.item_color = I.item_color
			W.update_icon()
			user.put_in_hands(W)
			user << "<span class='notice'>You attach the cable to the handles and pull on them tightly, creating a garrote.</span>"
			qdel(src)
		else
			user << "<span class='warning'>You need 20 cables to make a garrote!</span>"
			return

//Wepon
/obj/item/garrote
	name = "garrote"
	desc = "Extremely robust for stealth takedowns and rapid chokeholds."
	w_class = 2
	icon = 'hippiestation/icons/obj/garrote.dmi'
	icon_state = "garrot"
	item_color = ""
	var/garroting = 0
	var/next_garrot = 0

/obj/item/garrote/New()
	..()
	update_icon()

/obj/item/garrote/Destroy()
	SSobj.processing.Remove(src)
	..()

/obj/item/garrote/update_icon()
	if (!item_color)
		item_color = pick("red", "yellow", "blue", "green")
	icon_state = "garrot[garroting ? "_w" : ""][item_color ? "_[item_color]" : ""]"

/obj/item/garrote/attack_self(mob/user)
	if(garroting)
		user << "<span class='notice'>You release the garrote on your victim.</span>" //Not the grab, though. Only the garrote.
		garroting = 0
		SSobj.processing.Remove(src)
		update_icon()
		return
	if(world.time <= next_garrot) return

	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(!user.pulling || !iscarbon(user.pulling))
			to_chat(user, "<span class='warning'>You must be grabbing someone to garrote them!</span>")
			return

		var/mob/living/M = user.pulling
		M.LAssailant = user
		playsound(C.loc, 'hippiestation/sound/weapons/grapple.ogg', 40, 1, -4)
		playsound(C.loc, 'sound/weapons/cablecuff.ogg', 15, 1, -5)
		garroting = 1
		update_icon()
		SSobj.processing.Add(src)
		next_garrot = world.time + 10
		user.visible_message(
			"<span class='danger'>[user] has grabbed \the [user.pulling] with \the [src]!</span>",\
			"<span class='danger'>You grab \the [user.pulling] with \the [src]!</span>",\
			"You hear some struggling and muffled cries of surprise")

/obj/item/garrote/afterattack(atom/A, mob/living/user as mob, proximity, click_parameters)
	if(!proximity) return
	if(iscarbon(A))
		var/mob/living/carbon/C = A
		if(user != C)
			if(C.zone_selected != "mouth" && C.zone_selected != "eyes" && C.zone_selected != "head")
				user << "<span class='notice'>You must target head for garroting to work!</span>"
				return
			if(!garroting)
				add_logs(user, C, "garroted")
				user.grab_state = GRAB_PASSIVE
				C.grippedby(user) //Autograb. The trick is to switch to grab intent and reinforce it for quick chokehold.
				// N E V E R  autograb into Aggressive. Passive autograb is good enough.
				// G.state = GRAB_AGGRESSIVE
				// G.icon_state = "reinforce1"
				C.LAssailant = user
				playsound(C.loc, 'hippiestation/sound/weapons/grapple.ogg', 40, 1, -4)
				playsound(C.loc, 'sound/weapons/cablecuff.ogg', 15, 1, -5)
				garroting = 1
				update_icon()
				SSobj.processing.Add(src)
				next_garrot = world.time + 10
				user.visible_message(
					"<span class='danger'>[user] has grabbed \the [C] with \the [src]!</span>",\
					"<span class='danger'>You grab \the [C] with \the [src]!</span>",\
					"You hear some struggling and muffled cries of surprise")
			else
				user << "<span class='notice'>You're already garroting someone!</span>"
	return

/obj/item/garrote/process()
	if(iscarbon(loc))
		var/mob/living/carbon/C = loc
		if(!C.is_holding(src)) //THE GARROTE IS NOT IN HANDS, ABORT
			garroting = 0
			SSobj.processing.Remove(src)
			update_icon()
			return
		if(!C.pulling || !iscarbon(C.pulling))
			garroting = 0
			SSobj.processing.Remove(src)
			update_icon()
			return
		var/mob/living/M = C.pulling
		if(ishuman(C.pulling))
			var/mob/living/carbon/human/H = C.pulling
			if(H.is_mouth_covered())
				garroting = 0
				SSobj.processing.Remove(src)
				update_icon()
				return
			H.forcesay(list("-hrk!", "-hrgh!", "-urgh!", "-kh!", "-hrnk!"))
		if(C.grab_state >= GRAB_NECK) //Only do oxyloss if in neck grab to prevent passive grab choking or something.
			if(C.grab_state >= GRAB_KILL)
				M.adjustOxyLoss(3) //Stack the chokes with additional oxyloss for quicker death
			else
				if(prob(40))
					M.stuttering = max(M.stuttering, 3) //It will hamper your voice, being choked and all.
					M.losebreath = min(M.losebreath + 2, 3) //Tell the game we're choking them
	else
		garroting = 0
		SSobj.processing.Remove(src)
		update_icon()

