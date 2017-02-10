/datum/emote/living/carbon/monkey
	mob_type_allowed_typecache = list(/mob/living/carbon/monkey)

/datum/emote/living/carbon/monkey/fart
	key = "fart"
	key_third_person = "farts"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/monkey/fart/run_emote(mob/user, params)
	message = null
	if(user.stat != CONSCIOUS)
		return
	var/obj/item/organ/internal/butt/B = user.getorgan(/obj/item/organ/internal/butt)
	if(!B)
		user << "\red You don't have a butt!"
		return
	var/lose_butt = prob(22)
	for(var/mob/living/M in get_turf(user))
		if(M == user)
			continue
		if(lose_butt)
			message = "hits <b>[M]</b> in the face with [B]!"
			M.apply_damage(15,"brute","head")
		else
			message = "farts in <b>[M]</b>'s face!"
	if(!message)
		message = pick(
			"rears up and lets loose a fart of tremendous magnitude!",
			"farts!",
			"toots.",
			"harvests methane from uranus at mach 3!",
			"assists global warming!",
			"farts and waves their hand dismissively.",
			"farts and pretends nothing happened.",
			"is a <b>farting</b> motherfucker!",
			"<B><font color='red'>f</font><font color='blue'>a</font><font color='red'>r</font><font color='blue'>t</font><font color='red'>s</font></B>")
	spawn(0)
		var/obj/item/weapon/storage/book/bible/Y = locate() in get_turf(user.loc)
		if(istype(Y))
			playsound(Y,'sound/effects/thunder.ogg', 90, 1)
			spawn(10)
				user.gib()
		playsound(user, 'sound/misc/fart.ogg', 50, 1, 5)
		sleep(1)
		if(lose_butt)
			B.Remove(user)
			B.loc = get_turf(user)
			new /obj/effect/decal/cleanable/blood(user.loc)
			user.visible_message("\red <b>[user]</b> blows their ass off!", "\red Holy shit, your butt flies off in an arc!")
	..()