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