/* 
GOOD NIGHT SWEET PRINCE

#define PROGRESSBAR_HEIGHT 6

/datum/progressbar/New(mob/User, goal_number, atom/target)
	. = ..()
	bar.pixel_y = 0 // animate
	bar.alpha = 0
	animate(bar, pixel_y = 32 + (PROGRESSBAR_HEIGHT * (listindex - 1)), alpha = 255, time = 5, easing = SINE_EASING)

/datum/progressbar/shiftDown()
	..()
	bar.pixel_y = 32 + (PROGRESSBAR_HEIGHT * (listindex - 1))
	var/disttotravel = 32 + (PROGRESSBAR_HEIGHT * (listindex - 1)) - PROGRESSBAR_HEIGHT
	animate(bar, pixel_y = disttotravel, time = 5, easing = SINE_EASING)

/datum/progressbar/proc/remove_from_client()
	if (client)
		client.images -= bar

#undef PROGRESSBAR_HEIGHT 
*/
