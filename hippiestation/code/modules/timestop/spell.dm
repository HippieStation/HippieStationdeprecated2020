/obj/effect/proc_holder/spell/self/the_world
	name = "THE WORLD"
	desc = "Stop time across the entire station, for a varianle amount of seconds."
	clothes_req = FALSE
	staff_req = TRUE
	invocation = "ZA WARUDO!" // i'm conflicted between this and "BRING FORTH THE WORLD!"
	invocation_type = "shout"
	action_icon_state = "time"
	charge_max = 2 MINUTES
	var/seconds = 10
	var/does_z = TRUE
	var/timestop_type = /datum/timestop

/obj/effect/proc_holder/spell/self/the_world/cast(list/targets, mob/user)
	if(GLOB.timestop)
		revert_cast()
		return
	var/turf/T = get_turf(user)
	var/the_z_level = user.z
	if(T)
		the_z_level = T.z
	new /obj/effect/temp_visual/the_world(T)
	new timestop_type(user, seconds, does_z ? the_z_level : null)

/obj/effect/proc_holder/spell/self/the_world/universal
	does_z = FALSE

/obj/effect/proc_holder/spell/self/the_world/jotaro
	timestop_type = /datum/timestop/jotaro

/obj/effect/proc_holder/spell/self/the_world/jotaro/universal
	does_z = FALSE

/obj/effect/proc_holder/spell/aimed/checkmate
	name = "CHECKMATE"
	desc = "Throw a large amount of knives at your opponent!"
	invocation = "CHECKMATE!"
	invocation_type = "shout"
	clothes_req = FALSE
	charge_max = 50 SECONDS
	projectile_type = /obj/item/projectile/knife
	projectile_amount = 1
	projectiles_per_fire = 9
	var/projectile_initial_spread_amount = 20
	var/projectile_location_spread_amount = 10

/obj/effect/proc_holder/spell/aimed/checkmate/ready_projectile(obj/item/projectile/P, atom/target, mob/user, iteration)
	var/total_angle = projectile_initial_spread_amount * 2
	var/adjusted_angle = total_angle - ((projectile_initial_spread_amount / projectiles_per_fire) * 0.5)
	var/one_fire_angle = adjusted_angle / projectiles_per_fire
	var/current_angle = iteration * one_fire_angle - (projectile_initial_spread_amount / 2)
	P.pixel_x = rand(-projectile_location_spread_amount, projectile_location_spread_amount)
	P.pixel_y = rand(-projectile_location_spread_amount, projectile_location_spread_amount)
	P.preparePixelProjectile(target, user, null, current_angle)

/obj/item/projectile/knife
	name = "knife"
	icon = 'hippiestation/icons/obj/projectiles.dmi'
	icon_state = "knife"
	damage_type = BRUTE
	damage = 10
	armour_penetration = 100

/obj/effect/temp_visual/the_world
	icon = 'hippiestation/icons/effects/96x96.dmi'
	icon_state = "zawarudo"
	duration = 8
	pixel_x = -32
	pixel_y = -32

/obj/effect/temp_visual/the_world/Initialize()
	. = ..()
	var/matrix/ntransform = matrix(transform)
	ntransform.Scale(10)
	animate(src, transform = ntransform, time = 7.5, easing = EASE_IN|EASE_OUT)
