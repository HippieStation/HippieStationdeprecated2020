/* This is currently only supported for monkeys */
/mob/living/proc/hippie_equip_mob_with_items(rand_int)
	return

/mob/living/resist_grab(moving_resist)
	if(pulledby.grab_state)
		if(prob(30) && pulledby.grab_state != GRAB_KILL)
			visible_message("<span class='danger'>[src] has broken free of [pulledby]'s grip!</span>")
			add_logs(pulledby, src, "broke grab")
			pulledby.stop_pulling()
			return FALSE
		if(moving_resist && client) //we resisted by trying to move
			client.move_delay = world.time + 20
	else
		pulledby.stop_pulling()

/mob/living/proc/canGhost()
	return TRUE

/mob/living/proc/canSuccumb()
	return TRUE

//Updates canmove, lying and icons. Could perhaps do with a rename but I can't think of anything to describe it.
//Robots, animals and brains have their own version so don't worry about them
/mob/living/update_canmove()
	var/ko = IsKnockdown() || IsUnconscious() || (stat && (stat != SOFT_CRIT || pulledby)) || (status_flags & FAKEDEATH)
	var/move_and_fall = stat == SOFT_CRIT && !pulledby
	var/chokehold = pulledby && pulledby.grab_state >= GRAB_KILL
	var/buckle_lying = !(buckled && !buckled.buckle_lying)
	var/has_legs = get_num_legs()
	var/has_arms = get_num_arms()
	var/ignore_legs = get_leg_ignore()
	if(ko || resting || move_and_fall || IsStun() || chokehold)
		drop_all_held_items()
		unset_machine()
		if(pulling)
			stop_pulling()
	else if(has_legs || ignore_legs)
		lying = 0
	if(buckled)
		lying = 90*buckle_lying
	else if (pinned_to)
		lying = 0
	else if(!lying)
		if(resting)
			fall()
		else if(ko || move_and_fall || (!has_legs && !ignore_legs) || chokehold)
			fall(forced = 1)
	canmove = !(ko || resting || IsStun() || IsFrozen() || chokehold || buckled || (!has_legs && !ignore_legs && !has_arms) || pinned_to)
	density = !lying
	if(lying)
		if(layer == initial(layer)) //to avoid special cases like hiding larvas.
			layer = LYING_MOB_LAYER //so mob lying always appear behind standing mobs
	else
		if(layer == LYING_MOB_LAYER)
			layer = initial(layer)
	update_transform()
	if(!lying && lying_prev)
		if(client)
			client.move_delay = world.time + movement_delay()
	lying_prev = lying
	return canmove

/mob/living/proc/do_pindown(atom/A, tog=1)
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/direction = get_dir(src, A)
	switch(direction)
		if(NORTH)
			pixel_y_diff = 8
		if(SOUTH)
			pixel_y_diff = -8
		if(EAST)
			pixel_x_diff = 8
		if(WEST)
			pixel_x_diff = -8
		if(NORTHEAST)
			pixel_x_diff = 8
			pixel_y_diff = 8
		if(NORTHWEST)
			pixel_x_diff = -8
			pixel_y_diff = 8
		if(SOUTHEAST)
			pixel_x_diff = 8
			pixel_y_diff = -8
		if(SOUTHWEST)
			pixel_x_diff = -8
			pixel_y_diff = -8
	if(tog==1)
		animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
	else
		animate(src, pixel_x = initial(pixel_x), pixel_y = initial(pixel_y), time = 2)
		floating = 0 // If we were without gravity, the bouncing animation got stopped, so we make sure we restart the bouncing after the next movement.


//Called when we bump onto a mob
/mob/living/MobCollide(mob/M)
	//Even if we don't push/swap places, we "touched" them, so spread fire
	spreadFire(M)
	//Also diseases
	for(var/thing in viruses)
		var/datum/disease/D = thing
		if(D.spread_flags & VIRUS_SPREAD_CONTACT_SKIN)
			M.ContactContractDisease(D)

	for(var/thing in M.viruses)
		var/datum/disease/D = thing
		if(D.spread_flags & VIRUS_SPREAD_CONTACT_SKIN)
			ContactContractDisease(D)

	if(now_pushing)
		return TRUE

	// Can't move with pinned people
	if (pinned_to || M.pinned_to)
		return TRUE	

	//Should stop you pushing a restrained person out of the way
	if(isliving(M))
		var/mob/living/L = M
		if(L.pulledby && L.pulledby != src && L.restrained())
			if(!(world.time % 5))
				to_chat(src, "<span class='warning'>[L] is restrained, you cannot push past.</span>")
			return 1

		if(L.pulling)
			if(ismob(L.pulling))
				var/mob/P = L.pulling
				if(P.restrained())
					if(!(world.time % 5))
						to_chat(src, "<span class='warning'>[L] is restraining [P], you cannot push past.</span>")
					return 1

	if(moving_diagonally)//no mob swap during diagonal moves.
		return 1

	if(!M.buckled && !M.has_buckled_mobs())
		var/mob_swap
		//the puller can always swap with its victim if on grab intent
		if(M.pulledby == src && a_intent == INTENT_GRAB)
			mob_swap = 1
		//restrained people act if they were on 'help' intent to prevent a person being pulled from being separated from their puller
		else if((M.restrained() || M.a_intent == INTENT_HELP) && (restrained() || a_intent == INTENT_HELP))
			mob_swap = 1

		if(mob_swap)
			//switch our position with M
			if(loc && !loc.Adjacent(M.loc))
				return 1
			now_pushing = 1
			var/oldloc = loc
			var/oldMloc = M.loc


			var/M_passmob = (M.pass_flags & PASSMOB) // we give PASSMOB to both mobs to avoid bumping other mobs during swap.
			var/src_passmob = (pass_flags & PASSMOB)
			M.pass_flags |= PASSMOB
			pass_flags |= PASSMOB

			var/move_failed = FALSE
			if(!M.Move(oldloc) || !Move(oldMloc))
				M.forceMove(oldMloc)
				forceMove(oldloc)
				move_failed = TRUE
			if(!src_passmob)
				pass_flags &= ~PASSMOB
			if(!M_passmob)
				M.pass_flags &= ~PASSMOB

			now_pushing = 0

			if(!move_failed)
				return 1

	//okay, so we didn't switch. but should we push?
	//not if he's not CANPUSH of course
	if(!(M.status_flags & CANPUSH))
		return 1
	//anti-riot equipment is also anti-push
	for(var/obj/item/I in M.held_items)
		if(!istype(M, /obj/item/clothing))
			if(prob(I.block_chance*2))
				return 1
