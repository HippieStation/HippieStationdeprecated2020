/obj/effect/proc_holder/spell/self/the_world
	name = "THE WORLD"
	desc = "Stop time across the entire station, for a varianle amount of seconds."
	clothes_req = FALSE
	invocation = "ZA WARUDO!" // i'm conflicted between this and "BRING FORTH THE WORLD!"
	invocation_type = "shout"
	action_icon_state = "time"
	charge_max = 1.5 MINUTES
	var/seconds = 10
	var/does_z = TRUE

/obj/effect/proc_holder/spell/self/the_world/cast(list/targets, mob/user)
	if(GLOB.timestop)
		revert_cast()
		return
	new /obj/effect/temp_visual/the_world(get_turf(user))
	new /datum/timestop(user, seconds, does_z ? user.z : null)

/obj/effect/proc_holder/spell/self/the_world/universal
	does_z = FALSE


/obj/effect/temp_visual/the_world
	icon = 'hippiestation/icons/effects/96x96.dmi'
	icon_state = "zawarudo"
	duration = 10
	pixel_x = -32
	pixel_y = -32

/obj/effect/temp_visual/the_world/Initialize()
	. = ..()
	var/matrix/ntransform = matrix(transform)
	ntransform.Scale(10)
	animate(src, transform = ntransform, time = 10, easing = EASE_IN|EASE_OUT)
