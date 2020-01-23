/obj/item/bodypart/head
	var/obj/item/stack/teeth/teeth = null
	var/list/teeth_list = list() //Teeth are added in carbon/human/New()
	var/max_teeth = 32 //Changed based on teeth type the species spawns with

/obj/item/bodypart/head/New()
	..()
	update_teeth()

/obj/item/bodypart/head/Destroy()
	QDEL_LIST(teeth_list) //order is sensitive, see warning in handle_atom_del() below
	if(teeth)
		QDEL_NULL(teeth)
	return ..()

/obj/item/bodypart/head/proc/update_teeth()
	teeth_list.Cut() //Clear out their mouth of teeth if they had any
	if(teeth)
		QDEL_NULL(teeth)
	teeth = new (owner ? owner.dna.species.teeth_type : /obj/item/stack/teeth/generic)
	teeth.forceMove(src)
	max_teeth = teeth.max_amount //Set max teeth for the head based on teeth spawntype
	teeth.amount = teeth.max_amount
	teeth_list += teeth

/obj/item/bodypart/head/proc/knock_out_teeth(throw_dir, num=32) //Won't support knocking teeth out of a dismembered head or anything like that yet.
	num = CLAMP(num, 1, 32)
	if(teeth_list && teeth_list.len) //We still have teeth
		var/stacks = rand(1,3)
		for(var/curr = 1 to stacks) //Random amount of teeth stacks
			var/obj/item/stack/teeth/teeth = pick(teeth_list)
			if(!teeth || teeth.zero_amount()) return //No teeth left, abort!
			var/drop = round(min(teeth.amount, num)/stacks) //Calculate the amount of teeth in the stack
			var/obj/item/stack/teeth/T = new teeth.type(owner.loc, drop)
			T.copy_evidences(teeth)
			teeth.use(drop)
			var/turf/target = get_turf(owner.loc)
			var/range = rand(2,T.throw_range)
			for(var/i = 1; i < range; i++)
				var/turf/new_turf = get_step(target, throw_dir)
				target = new_turf
				if(new_turf.density)
					break
			T.throw_at(target,T.throw_range,T.throw_speed)
			teeth.zero_amount() //Try to delete the teeth
			return TRUE
	return FALSE

/obj/item/bodypart/head/proc/get_teeth() //returns collective amount of teeth
	var/amt = 0
	if(!teeth_list) teeth_list = list()
	for(var/obj/item/stack/teeth in teeth_list)
		amt += teeth.amount
	return amt

/proc/punchouttooth(var/mob/living/carbon/human/target, var/mob/living/carbon/human/user, var/strength, var/obj/Q)
	if(istype(Q, /obj/item/bodypart/head) && prob(strength * (user.zone_selected == "mouth" ? 3 : 1))) //MUCH higher chance to knock out teeth if you aim for mouth
		var/obj/item/bodypart/head/U = Q
		if(U.knock_out_teeth(get_dir(user, target), round(rand(28, 38) * ((strength*2)/100))))
			target.visible_message("<span class='danger'>[target]'s teeth sail off in an arc!</span>", "<span class='userdanger'>[target]'s teeth sail off in an arc!</span>")

/proc/lisp(message, intensity=100) //Intensity = how hard will the dude be lisped
	message = prob(intensity) ? replacetext(message, "f", "ph") : message
	message = prob(intensity) ? replacetext(message, "t", "ph") : message
	message = prob(intensity) ? replacetext(message, "s", "sh") : message
	message = prob(intensity) ? replacetext(message, "th", "hh") : message
	message = prob(intensity) ? replacetext(message, "ck", "gh") : message
	message = prob(intensity) ? replacetext(message, "c", "gh") : message
	message = prob(intensity) ? replacetext(message, "k", "gh") : message
	return message

/obj/item/proc/tearoutteeth(var/mob/living/carbon/C, var/mob/living/user)
	if(ishuman(C) && user.zone_selected == "mouth")
		var/mob/living/carbon/human/H = C
		var/obj/item/bodypart/head/O = locate() in H.bodyparts
		if(!O || !O.get_teeth())
			to_chat(user, "<span class='notice'>[H] doesn't have any teeth left!</span>")
			return TRUE
		if(user.next_move > world.time)
			user.changeNext_move(50)
			H.visible_message("<span class='danger'>[user] tries to tear off [H]'s tooth with [src]!</span>",
								"<span class='userdanger'>[user] tries to tear off your tooth with [src]!</span>")
			if(do_after(user, 50, target = H))
				if(!O || !O.get_teeth()) return TRUE
				var/obj/item/stack/teeth/E = pick(O.teeth_list)
				if(!E || E.zero_amount()) return TRUE
				var/obj/item/stack/teeth/T = new E.type(H.loc, 1)
				T.copy_evidences(E)
				E.use(1)
				E.zero_amount() //Try to delete the teeth
				log_combat(user, H, "torn out the tooth from", src)
				H.visible_message("<span class='danger'>[user] tears off [H]'s tooth with [src]!</span>",
								"<span class='userdanger'>[user] tears off your tooth with [src]!</span>")
				var/armor = H.run_armor_check(O, "melee")
				H.apply_damage(rand(1,5), BRUTE, O, armor)
				playsound(H, 'hippiestation/sound/misc/tear.ogg', 40, 1, -1) //RIP AND TEAR. RIP AND TEAR.
				H.emote("scream")
			else
				to_chat(user, "<span class='notice'>Your attempt to pull out a teeth fails...</span>")
				user.changeNext_move(0)
			return TRUE
		else
			to_chat(user, "<span class='notice'>You are already trying to pull out a teeth!</span>")
		return TRUE


/mob/living/carbon/human // as far as i know,only humans have teeth
	var/lisp = 0

/mob/living/carbon/human/regenerate_organs()
	..()
	update_teeth()

/mob/living/carbon/human/proc/update_teeth()
	var/obj/item/bodypart/head/U = locate() in bodyparts
	if(istype(U))
		U.update_teeth()

/mob/living/carbon/human/proc/checklisp()
	var/obj/item/bodypart/head/O = locate(/obj/item/bodypart/head) in bodyparts
	if(O)
		if(!O.teeth_list.len || O.get_teeth() <= 0)
			lisp = 100 //No teeth = full lisp power
		else
			lisp = (1 - (O.get_teeth()/O.max_teeth)) * 100 //Less teeth = more lisp
	else
		lisp = 0 //No head = no lisp.
