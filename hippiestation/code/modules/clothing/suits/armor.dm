/obj/item/clothing/suit/armor/vest
	var/obj/item/grenade/explosive = null

/obj/item/clothing/suit/armor/vest/examine(mob/user)
	..()
	if(explosive)
		to_chat(user, "<span class='notice'>Looks like there is a payload attached. It is an [explosive].</span>")
	else
		return

/obj/item/clothing/suit/armor/vest/CheckParts(list/parts_list)
	var/obj/item/clothing/suit/armor/vest/V = locate() in parts_list
	if(V)
		if(V.explosive)
			V.explosive.forceMove(get_turf(src))
			V.explosive = null
		parts_list -= V
		qdel(V)
	..()
	var/obj/item/grenade/G = locate() in contents
	if(G)
		explosive = G
		name = "suicide bomb vest"
		desc = "A makeshift bomb vest with a [G] attached as a payload."
	update_icon()

/obj/item/clothing/suit/armor/vest/proc/Trigger(var/mob/living/carbon/human/H)
	if(H.wear_suit == src)
		if(H.stat == DEAD)
			H.visible_message("<span class='danger'>A beep emits from [H]'s vest. It's going to explode!")
			playsound(loc, 'hippiestation/sound/effects/bombvest_beep.ogg', 50, 1)
			addtimer(CALLBACK(explosive, /obj/item/grenade.proc/prime, 10))
			qdel(src)

