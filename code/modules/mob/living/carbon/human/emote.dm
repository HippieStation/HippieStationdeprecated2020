/datum/emote/living/carbon/human
	mob_type_allowed_typecache = list(/mob/living/carbon/human)

/datum/emote/living/carbon/human/cry
	key = "cry"
	key_third_person = "cries"
	message = "cries."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/dab
	key = "dab"
	key_third_person = "dabs"
	message = "hits a sick dab!"
	restraint_check = TRUE

/datum/emote/living/carbon/human/eyebrow
	key = "eyebrow"
	message = "raises an eyebrow."

/datum/emote/living/carbon/human/grumble
	key = "grumble"
	key_third_person = "grumbles"
	message = "grumbles!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/fart
	key = "fart"
	key_third_person = "farts"
	var/fartsound
	var/bloodkind

/datum/emote/living/carbon/human/fart/run_emote(mob/user, params)
	message = null
	if(user.stat != CONSCIOUS)
		return
	var/obj/item/organ/internal/butt/B = user.getorgan(/obj/item/organ/internal/butt)
	if(!B)
		user << "\red You don't have a butt!"
		return
	var/lose_butt = prob(12)
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
		if(ishuman(user) || ismonkey(user))
			fartsound = 'sound/misc/fart.ogg'
			bloodkind = /obj/effect/decal/cleanable/blood
		else //must be an alien. The check for aliens doesn't work so there has to be a check for human and monkey instead
			fartsound = 'sound/misc/alienfart.ogg'
			bloodkind = /obj/effect/decal/cleanable/xenoblood
		var/obj/item/weapon/storage/internal/pocket/butt/theinv = B.inv
		if(theinv.contents.len)
			var/obj/item/O = pick(theinv.contents)
			if(istype(O, /obj/item/weapon/lighter))
				var/obj/item/weapon/lighter/G = O
				if(G.lit && user.loc)
					new/obj/effect/hotspot(user.loc)
					playsound(user, fartsound, 50, 1, 5)
			else if(istype(O, /obj/item/weapon/weldingtool))
				var/obj/item/weapon/weldingtool/J = O
				if(J.welding == 1 && user.loc)
					new/obj/effect/hotspot(user.loc)
					playsound(user, fartsound, 50, 1, 5)
			else if(istype(O, /obj/item/weapon/bikehorn))
				for(var/obj/item/weapon/bikehorn/Q in theinv.contents)
					playsound(Q, Q.honksound, 50, 1, 5)
				message = "<span class='clown'>farts.</span>"
			else if(istype(O, /obj/item/device/megaphone))
				message = "<span class='reallybig'>farts.</span>"
				playsound(user, 'sound/misc/fartmassive.ogg', 75, 1, 5)
			else
				playsound(user, fartsound, 50, 1, 5)
			if(prob(33))
				theinv.remove_from_storage(O, user.loc)
		else
			playsound(user, fartsound, 50, 1, 5)
		sleep(1)
		if(lose_butt)
			for(var/obj/item/I in theinv.contents)
				theinv.remove_from_storage(I, user.loc)
			B.loc = get_turf(user)
			B.Remove(user)
			new bloodkind(user.loc)
			user.nutrition -= rand(5, 20)
			user.visible_message("\red <b>[user]</b> blows their ass off!", "\red Holy shit, your butt flies off in an arc!")
		else
			user.nutrition -= rand(2, 10)
		..()
		if(!ishuman(user)) //nonhumans don't have the message appear for some reason
			user.visible_message("<b>[user]</b> [message]")

/datum/emote/living/carbon/human/superfart
	key = "superfart"
	key_third_person = "superfarts"

/datum/emote/living/carbon/human/superfart/run_emote(mob/user, params)
	if(!ishuman(user))
		user << "<span class='warning'>You lack that ability!</span>"
		return
	var/obj/item/organ/internal/butt/B = user.getorgan(/obj/item/organ/internal/butt)
	if(!B)
		user << "<span class='danger'>You don't have a butt!</span>"
		return
	if(B.loose)
		user << "<span class='danger'>Your butt's too loose to superfart!</span>"
		return
	B.loose = 1 // to avoid spamsuperfart
	var/fart_type = 1 //Put this outside probability check just in case. There were cases where superfart did a normal fart.
	if(prob(76)) // 76%     1: ASSBLAST  2:SUPERNOVA  3: FARTFLY
		fart_type = 1
	else if(prob(12)) // 3%
		fart_type = 2
	else if(prob(12)) // 0.4%
		if(user.loc && user.loc.z == 1)
			fart_type = 3
		else
			fart_type = 2
	spawn(0)
		spawn(1)
			var/obj/item/weapon/storage/book/bible/Y = locate() in get_turf(user)
			if(Y)
				var/image/img = image(icon = 'icons/effects/224x224.dmi', icon_state = "lightning")
				img.pixel_x = -world.icon_size*3
				img.pixel_y = -world.icon_size
				flick_overlay_static(img, Y, 10)
				playsound(Y,'sound/effects/thunder.ogg', 90, 1)
				spawn(10)
					user.gib()
		sleep(4)
		for(var/i in 1 to 10)
			playsound(user, 'sound/misc/fart.ogg', 50, 1, 5)
			sleep(1)
		playsound(user, 'sound/misc/fartmassive.ogg', 75, 1, 5)
		var/obj/item/weapon/storage/internal/pocket/butt/theinv = B.inv
		if(theinv.contents.len)
			for(var/obj/item/O in theinv.contents)
				theinv.remove_from_storage(O, user.loc)
				O.throw_range = 7//will be reset on hit
				O.assthrown = 1
				var/turf/target = get_turf(O)
				var/range = 7
				var/turf/new_turf
				var/new_dir
				switch(user.dir)
					if(1)
						new_dir = 2
					if(2)
						new_dir = 1
					if(4)
						new_dir = 8
					if(8)
						new_dir = 4
				for(var/i = 1; i < range; i++)
					new_turf = get_step(target, new_dir)
					target = new_turf
					if(new_turf.density)
						break
				O.throw_at(target,range,O.throw_speed)
				O.assthrown = 0 // so you can't just unembed it and throw it for insta embeds
		B.Remove(user)
		B.forceMove(get_turf(user))
		if(B.loose) B.loose = 0
		new /obj/effect/decal/cleanable/blood(user.loc)
		user.nutrition -= 500
		switch(fart_type)
			if(1)
				for(var/mob/living/M in range(0))
					if(M != user)
						user.visible_message("\red <b>[user]</b>'s ass blasts <b>[M]</b> in the face!", "\red You ass blast <b>[M]</b>!")
						M.apply_damage(50,"brute","head")

				user.visible_message("\red <b>[user]</b> blows their ass off!", "\red Holy shit, your butt flies off in an arc!")

			if(2)
				user.visible_message("\red <b>[user]</b> rips their ass apart in a massive explosion!", "\red Holy shit, your butt goes supernova!")
				explosion(user.loc, 0, 1, 3, adminlog = 0, flame_range = 3)
				user.gib()

			if(3)
				var/endy = 0
				var/endx = 0

				switch(user.dir)
					if(NORTH)
						endy = 8
						endx = user.loc.x
					if(EAST)
						endy = user.loc.y
						endx = 8
					if(SOUTH)
						endy = 247
						endx = user.loc.x
					else
						endy = user.loc.y
						endx = 247

				//ASS BLAST USA
				user.visible_message("\red <b>[user]</b> blows their ass off with such force, they explode!", "\red Holy shit, your butt flies off into the galaxy!")
				user.gib() //can you belive I forgot to put this here?? yeah you need to see the message BEFORE you gib
				new /obj/effect/immovablerod/butt(B.loc, locate(endx, endy, 1))
				priority_announce("What the fuck was that?!", "General Alert")
				qdel(B)

/datum/emote/living/carbon/human/handshake
	key = "handshake"
	message = "shakes their own hands."
	message_param = "shakes hands with %t."
	restraint_check = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/hug
	key = "hug"
	key_third_person = "hugs"
	message = "hugs themself."
	message_param = "hugs %t."
	restraint_check = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/mumble
	key = "mumble"
	key_third_person = "mumbles"
	message = "mumbles!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/pale
	key = "pale"
	message = "goes pale for a second."

/datum/emote/living/carbon/human/raise
	key = "raise"
	key_third_person = "raises"
	message = "raises a hand."
	restraint_check = TRUE

/datum/emote/living/carbon/human/salute
	key = "salute"
	key_third_person = "salutes"
	message = "salutes."
	message_param = "salutes to %t."
	restraint_check = TRUE

/datum/emote/living/carbon/human/shrug
	key = "shrug"
	key_third_person = "shrugs"
	message = "shrugs."

/datum/emote/living/carbon/human/wag
	key = "wag"
	key_third_person = "wags"
	message = "wags their tail."

/datum/emote/living/carbon/human/wag/run_emote(mob/user, params)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(.)
		H.startTailWag()
	else
		H.endTailWag()

/datum/emote/living/carbon/human/wag/can_run_emote(mob/user)
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = user
	if(H.dna && H.dna.species && (("tail_lizard" in H.dna.species.mutant_bodyparts) || (H.dna.features["tail_human"] != "None")))
		return TRUE

/datum/emote/living/carbon/human/wag/select_message_type(mob/user)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(("waggingtail_lizard" in H.dna.species.mutant_bodyparts) || ("waggingtail_human" in H.dna.species.mutant_bodyparts))
		. = null

/datum/emote/living/carbon/human/wing
	key = "wing"
	key_third_person = "wings"
	message = "their wings."

/datum/emote/living/carbon/human/wing/run_emote(mob/user, params)
	. = ..()
	if(.)
		var/mob/living/carbon/human/H = user
		if(findtext(select_message_type(user), "open"))
			H.OpenWings()
		else
			H.CloseWings()

/datum/emote/living/carbon/human/wing/select_message_type(mob/user)
	. = ..()
	var/mob/living/carbon/human/H = user
	if("wings" in H.dna.species.mutant_bodyparts)
		. = "opens " + message
	else
		. = "closes " + message

/datum/emote/living/carbon/human/wing/can_run_emote(mob/user)
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = user
	if(H.dna && H.dna.species && (H.dna.features["wings"] != "None"))
		return TRUE

//Don't know where else to put this, it's basically an emote
/mob/living/carbon/human/proc/startTailWag()
	if(!dna || !dna.species)
		return
	if("tail_lizard" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "tail_lizard"
		dna.species.mutant_bodyparts -= "spines"
		dna.species.mutant_bodyparts |= "waggingtail_lizard"
		dna.species.mutant_bodyparts |= "waggingspines"
	if("tail_human" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "tail_human"
		dna.species.mutant_bodyparts |= "waggingtail_human"
	update_body()


/mob/living/carbon/human/proc/endTailWag()
	if(!dna || !dna.species)
		return
	if("waggingtail_lizard" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "waggingtail_lizard"
		dna.species.mutant_bodyparts -= "waggingspines"
		dna.species.mutant_bodyparts |= "tail_lizard"
		dna.species.mutant_bodyparts |= "spines"
	if("waggingtail_human" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "waggingtail_human"
		dna.species.mutant_bodyparts |= "tail_human"
	update_body()

/mob/living/carbon/human/proc/OpenWings()
	if(!dna || !dna.species)
		return
	if("wings" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "wings"
		dna.species.mutant_bodyparts |= "wingsopen"
	update_body()

/mob/living/carbon/human/proc/CloseWings()
	if(!dna || !dna.species)
		return
	if("wingsopen" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "wingsopen"
		dna.species.mutant_bodyparts |= "wings"
	update_body()

//Ayy lmao
