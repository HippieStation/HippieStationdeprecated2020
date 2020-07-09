/mob/living
	var/list/alternate_farts
	var/lose_butt = 12
	var/super_fart = 76
	var/super_nova_fart = 12
	var/fart_fly = 12
	var/smug_cd = 0

/proc/spawnfartgas(mob/living/carbon/user, is_super_fart)
	var/turf/fartturf = get_turf(user)
	var/datum/gas_mixture/stank = new
	var/amount
	if(is_super_fart)
		amount = pick(20, 21, 22, 23, 24, 25)
	else
		amount = pick(1, 2, 3, 4, 5)
	ADD_GAS(/datum/gas/miasma, stank.gases)
	stank.gases[/datum/gas/miasma][MOLES] = amount //amount of gas spawned
	stank.temperature = BODYTEMP_NORMAL  //otherwise we have gas below 2.7K which will break our lag generator
	fartturf.assume_air(stank)
	fartturf.air_update_turf()

/datum/emote/living/carbon/fart
	key = "fart"
	key_third_person = "farts"

/datum/emote/living/carbon/fart/run_emote(mob/living/carbon/user, params)
	var/fartsound = 'hippiestation/sound/effects/fart.ogg'
	var/blowass = prob(user.lose_butt) //Used to determine if the person blows his ass off this time, prevents having to use two forloops for the turf mobs.
	var/bloodkind = /obj/effect/decal/cleanable/blood
	message = null
	if(user.stat != CONSCIOUS)
		return
	var/obj/item/organ/butt/B = user.getorgan(/obj/item/organ/butt)
	if(!B)
		to_chat(user, "<span class='warning'>You don't have a butt!</span>")
		return

	spawnfartgas(user, 0)

	for(var/mob/living/M in get_turf(user))
		if(M == user)
			continue
		if(blowass)
			message = "hits <b>[M]</b> in the face with [B]!"
			M.apply_damage(15,"brute","head")
			log_combat(user, M, "had his ass deal damage to")
		else
			message = pick(
				"farts in <b>[M]</b>'s face!",
				"gives <b>[M]</b> the silent but deadly treatment!",
				"rips mad ass in <b>[M]</b>'s mug!",
				"releases the musical fruits of labor onto <b>[M]</b>!",
				"commits an act of butthole bioterror all over <b>[M]</b>!",
				"poots, singing <b>[M]</b>'s eyebrows!",
				"humiliates <b>[M]</b> like never before!",
				"gets real close to <b>[M]</b>'s face and cuts the cheese!")
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
			"<B><font color='red'>f</font><font color='blue'>a</font><font color='red'>r</font><font color='blue'>t</font><font color='red'>s</font></B>",
			"unleashes their unholy rectal vapor!",
			"assblasts gently.",
			"lets out a wet sounding one!",
			"exorcises a <b>ferocious</b> colonic demon!",
			"pledges ass-legience to the flag!",
			"cracks open a tin of beans!",
			"tears themselves a new one!",
			"looses some pure assgas!",
			"displays the most sophisticated type of humor.",
			"strains to get the fart out. Is that <font color='red'>blood</font>?",
			"sighs and farts simultaneously.",
			"expunges a gnarly butt queef!",
			"contributes to the erosion of the ozone layer!",
			"just farts. It's natural, everyone does it.",
			"had one too many tacos this week!",
			"has the phantom shits.",
			"flexes their bunghole.",
			"'s ass sings the song that ends the earth!",
			"had to go and ruin the mood!",
			"unflinchingly farts. True confidence.",
			"shows everyone what they had for breakfast!",
			"farts so loud it startles them!",
			"breaks wind and a nearby wine glass!",
			"<b>finally achieves the perfect fart. All downhill from here.</b>")
	LAZYINITLIST(user.alternate_farts)
	if(LAZYLEN(user.alternate_farts))
		fartsound = pick(user.alternate_farts)
	if(istype(user,/mob/living/carbon/alien))
		bloodkind = /obj/effect/decal/cleanable/xenoblood
	var/obj/item/storage/book/bible/Y = locate() in get_turf(user.loc)
	user.newtonian_move(user.dir)
	if(istype(Y))
		user.Stun(20)
		playsound(Y,'hippiestation/sound/effects/thunder.ogg', 90, 1)
		var/turf/T = get_ranged_target_turf(user, NORTH, 8)
		T.Beam(user, icon_state="lightning[rand(1,12)]", time = 5)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.electrocution_animation(10)
		addtimer(CALLBACK(user, /mob/proc/gib), 10)
	else
		var/datum/component/storage/STR = B.GetComponent(/datum/component/storage)

		if(STR)
			var/list/STR_contents = STR.contents()
			if(STR_contents.len)
				var/obj/item/O = pick(STR_contents)
				if(istype(O, /obj/item/lighter))
					var/obj/item/lighter/G = O
					if(G.lit && user.loc)
						new/obj/effect/hotspot(user.loc)
						playsound(user, fartsound, 100, 1, 5)
				else if(istype(O, /obj/item/weldingtool))
					var/obj/item/weldingtool/J = O
					if(J.welding && user.loc)
						new/obj/effect/hotspot(user.loc)
						playsound(user, fartsound, 100, 1, 5)
				else if(istype(O, /obj/item/bikehorn))
					for(var/obj/item/bikehorn/Q in STR_contents)
						playsound(Q, 'sound/items/bikehorn.ogg', 100, 1, 5)
					message = "<span class='clown'>farts.</span>"
				else if(istype(O, /obj/item/megaphone))
					message = "<span class='reallybig'>farts.</span>"
					playsound(user, 'hippiestation/sound/effects/fartmassive.ogg', 100, 1, 5)
				else
					playsound(user, fartsound, 100, 1, 5)
				if(prob(33))
					STR.remove_from_storage(O, user.loc)
			else
				playsound(user, fartsound, 100, 1, 5)
		if(blowass)
			B.Remove(user)
			B.forceMove(get_turf(user))
			new bloodkind(user.loc)
			user.nutrition = max(user.nutrition - rand(5, 20), NUTRITION_LEVEL_STARVING)
			user.visible_message("<span class='warning'><b>[user]</b> blows their ass off!</span>", "<span class='warning'>Holy shit, your butt flies off in an arc!</span>")
		else
			user.nutrition = max(user.nutrition - rand(2, 10), NUTRITION_LEVEL_STARVING)
		..()
		if(!ishuman(user)) //nonhumans don't have the message appear for some reason
			user.visible_message("<b>[user]</b> [message]")

/datum/emote/living/carbon/human/superfart
	key = "superfart"
	key_third_person = "superfarts"

/datum/emote/living/carbon/human/superfart/run_emote(mob/living/carbon/human/user, params)
	if(!ishuman(user))
		to_chat(user, "<span class='warning'>You lack that ability!</span>")
		return
	var/obj/item/organ/butt/B = user.getorgan(/obj/item/organ/butt)
	if(!B)
		to_chat(user, "<span class='danger'>You don't have a butt!</span>")
		return
	if(B.loose)
		to_chat(user, "<span class='danger'>Your butt's too loose to superfart!</span>")
		return
	B.loose = TRUE // to avoid spamsuperfart
	var/fart_type = 1 //Put this outside probability check just in case. There were cases where superfart did a normal fart.
	if(prob(user.super_fart)) // 76% by default    1: ASSBLAST  2:SUPERNOVA  3: FARTFLY
		fart_type = 1
	else if(prob(user.super_nova_fart)) // 2.89% by default
		fart_type = 2
	else if(prob(user.fart_fly)) // 0.35% by default
		fart_type = 3
	var/obj/item/storage/book/bible/Y = locate() in get_turf(user.loc)
	if(istype(Y))
		user.Stun(20)
		playsound(Y,'hippiestation/sound/effects/thunder.ogg', 90, 1)
		var/turf/T = get_ranged_target_turf(user, NORTH, 8)
		T.Beam(user, icon_state="lightning[rand(1,12)]", time = 5)
		user.electrocution_animation(10)
		addtimer(CALLBACK(user, /mob/proc/gib), 10)
	else
		for(var/i in 1 to 10)
			playsound(user, 'hippiestation/sound/effects/fart.ogg', 100, 1, 5)
			spawnfartgas(user, 0)
			sleep(1)
		playsound(user, 'hippiestation/sound/effects/fartmassive.ogg', 75, 1, 5)
		spawnfartgas(user, 1)
		var/datum/component/storage/STR = B.GetComponent(/datum/component/storage)

		if(STR)
			var/list/STR_contents = STR.contents()
			if(STR_contents.len)
				for(var/obj/item/O in STR_contents)
					STR.remove_from_storage(O, user.loc)
					O.throw_range = 7//will be reset on hit
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
		B.Remove(user)
		B.forceMove(get_turf(user))
		if(B.loose)
			B.loose = FALSE
		new /obj/effect/decal/cleanable/blood(user.loc)
		user.nutrition = max(user.nutrition - 500, NUTRITION_LEVEL_STARVING)
		switch(fart_type)
			if(1)
				for(var/mob/living/M in range(0))
					if(M != user)
						user.visible_message("<span class='warning'><b>[user]</b>'s ass blasts <b>[M]</b> in the face!</span>", "<span class='warning'>You ass blast <b>[M]</b>!</span>")
						M.apply_damage(50,"brute","head")
						log_combat(user, M, "superfarted")

				user.visible_message("<span class='warning'><b>[user]</b> blows their ass off!</span>", "<span class='warning'>Holy shit, your butt flies off in an arc!</span>")
				if(!user.has_gravity())
					var/atom/target = get_edge_target_turf(user, user.dir)
					user.throw_at(target, 1000, 20)
					user.visible_message("<span class='warning'>[user] goes flying off into the distance!</span>", "<span class='warning'>You fly off into the distance!</span>")

			if(2)
				user.visible_message("<span class='warning'><b>[user]</b> rips their ass apart in a massive explosion!</span>", "<span class='warning'>Holy shit, your butt goes supernova!</span>")
				playsound(user, 'hippiestation/sound/effects/superfart.ogg', 75, extrarange = 255, pressure_affected = FALSE)
				explosion(user.loc, 0, 1, 3, adminlog = FALSE, flame_range = 3)
				user.gib()

			if(3)
				var/butt_end
				var/butt_x
				var/butt_y
				var/turf/T = get_turf(user.loc)
				//butt_end = spaceDebrisFinishLoc(user.dir, T.z)
				switch(user.dir)
					if(SOUTH)
						butt_y = world.maxy-(TRANSITIONEDGE+1)
						butt_x = user.x
					if(WEST)
						butt_x = world.maxx-(TRANSITIONEDGE+1)
						butt_y = user.y
					if(NORTH)
						butt_y = (TRANSITIONEDGE+1)
						butt_x = user.x
					else
						butt_x = (TRANSITIONEDGE+1)
						butt_y = user.y
				butt_end =locate(butt_x, butt_y, T.z)

				//ASS BLAST USA
				user.visible_message("<span class='warning'><b>[user]</b> blows their ass off with such force, they explode!</span>", "<span class='warning'>Holy shit, your butt flies off into the galaxy!</span>")
				playsound(user, 'hippiestation/sound/effects/superfart.ogg', 75, extrarange = 255, pressure_affected = FALSE)
				new /obj/effect/immovablerod/butt(user.loc, butt_end)
				user.gib() //can you belive I forgot to put this here?? yeah you need to see the message BEFORE you gib
				priority_announce("What the fuck was that?!", "General Alert")
				qdel(B)

/datum/emote/living/smug
	key = "smug"
	key_third_person = "smugs"
	message = "grins smugly."

/obj/effect/smug
	name = "smug"
	desc = ":smug:"
	icon = 'hippiestation/icons/mob/smug.dmi'
	icon_state = "smug"
	anchored = 1
	pixel_x = -16
	pixel_y = -16

/datum/emote/living/smug/run_emote(mob/living/carbon/user, params)
	if(!ishuman(user))
		return ..()
	var/obj/item/organ/tongue/L = user.getorgan(/obj/item/organ/tongue)
	var/mob/living/carbon/human/H = user
	if(!L)
		to_chat(user, "<span class='warning'>You can't be smug without a tongue!</span>")
		return FALSE // This will tell you that the emote is unusable as well.
	var/bloodkind = /obj/effect/decal/cleanable/blood
	var/toosmug = rand(1,20)
	if(toosmug == 1 || world.time < H.smug_cd)
		user.visible_message("<span class='warning'><b>[H]</b> tries to smugly grin, but bites their tongue off!</span>", "<span class='warning'>Holy shit, you just bit your tongue off!</span>")
		playsound(H, 'sound/effects/snap.ogg', 50, TRUE)
		L.Remove(user)
		L.forceMove(get_turf(H))
		new bloodkind(H.loc)
		return
	H.smug_cd = world.time + 300
	var/obj/effect/smug/S = new(H.loc) // I heard the Goons didn't need this code any more. Oh well!
	S.alpha = 0
	animate(S,transform = matrix(0.5, MATRIX_SCALE), time = 20, alpha = 255, pixel_y = 27, easing = ELASTIC_EASING)
	animate(time = 5, alpha = 0, pixel_y = -16, easing = CIRCULAR_EASING)
	spawn(30) qdel(S)
	return ..()
