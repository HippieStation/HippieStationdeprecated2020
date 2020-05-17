/obj/machinery/porta_turret/syndicate/shuttle
	stun_projectile = /obj/item/projectile/bullet/syndicate_turret
	lethal_projectile = /obj/item/projectile/bullet/syndicate_turret

/obj/machinery/porta_turret/thrower //because adminbus
	installation = null
	always_up = TRUE
	use_power = NO_POWER_USE
	has_cover = FALSE
	scan_range = 9
	shot_delay = 3
	var/thrown_object = /obj/item/shard
	var/throwing_sound = 'sound/weapons/gunshot.ogg'
	var/toss_range = 9
	var/toss_speed = 4
	icon_state = "syndie_off"
	base_icon_state = "syndie"
	faction = list(ROLE_SYNDICATE)
	desc = "A ballistic auto-throwing turret."

/obj/machinery/porta_turret/thrower/Initialize()
	. = ..()
	STOP_PROCESSING(SSmachines, src)
	START_PROCESSING(SSprocessing, src) //this lasts 20 minutes, so SSfastprocess isn't needed.

/obj/machinery/porta_turret/thrower/setup()
	return

/obj/machinery/porta_turret/thrower/assess_perp(mob/living/carbon/human/perp)
	return 10 //Thrower turrets, like syndi turrets, shoot everything not in their faction

/obj/machinery/porta_turret/thrower/target(atom/movable/target)
	if(target)
		setDir(get_dir(base, target))//even if you can't shoot, follow the target
		shootAt(target)
		return TRUE

/obj/machinery/porta_turret/thrower/shootAt(atom/movable/target)
	if(!raised) //the turret has to be raised in order to fire - makes sense, right?
		return

	if(!thrown_object)
		return

	if(!(obj_flags & EMAGGED))	//if it hasn't been emagged, cooldown before shooting again
		if(last_fired + shot_delay > world.time)
			return
		last_fired = world.time

	var/turf/T = get_turf(src)
	var/turf/U = get_turf(target)
	if(!istype(T) || !istype(U))
		return

	//Wall turrets will try to find adjacent empty turf to shoot from to cover full arc
	if(T.density)
		if(wall_turret_direction)
			var/turf/closer = get_step(T,wall_turret_direction)
			if(istype(closer) && !is_blocked_turf(closer) && T.Adjacent(closer))
				T = closer
		else
			var/target_dir = get_dir(T,target)
			for(var/d in list(0,-45,45))
				var/turf/closer = get_step(T,turn(target_dir,d))
				if(istype(closer) && !is_blocked_turf(closer) && T.Adjacent(closer))
					T = closer
					break

	update_icon()
	var/atom/movable/A
	use_power(reqpower)
	A = new thrown_object(T)
	playsound(loc, throwing_sound, 75, TRUE)

	//Shooting Code:
	A.throw_at(target, toss_range, toss_speed) //very fast
	return A

/obj/machinery/porta_turret/shocker //kind of like command and conquer
	installation = null
	always_up = TRUE
	use_power = NO_POWER_USE
	has_cover = FALSE
	scan_range = 9
	shot_delay = 20
	var/shock_power = 100000
	icon = 'icons/obj/tesla_engine/tesla_coil.dmi'
	icon_state = "coil1"
	faction = list(ROLE_SYNDICATE)
	desc = "A shock turret"

/obj/machinery/porta_turret/shocker/Initialize()
	. = ..()
	flags_1 |= TESLA_IGNORE_1 // just so they don't shock themselves
	STOP_PROCESSING(SSmachines, src)
	START_PROCESSING(SSprocessing, src) //this lasts 20 minutes, so SSfastprocess isn't needed.


/obj/machinery/porta_turret/shocker/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/empprotection, EMP_PROTECT_SELF | EMP_PROTECT_WIRES)

/obj/machinery/porta_turret/shocker/setup()
	return

/obj/machinery/porta_turret/shocker/update_icon()
	return

/obj/machinery/porta_turret/shocker/assess_perp(mob/living/carbon/human/perp)
	return 10 //Thrower turrets, like syndi turrets, shoot everything not in their faction

/obj/machinery/porta_turret/shocker/tryToShootAt(list/atom/movable/targets)
	if(targets.len)	//pop the turret up if it's not already up.
		if(shocktargets(targets))
			return TRUE

/obj/machinery/porta_turret/shocker/proc/shocktargets(list/atom/movable/targets)
	if(!raised) //the turret has to be raised in order to fire - makes sense, right?
		return

	if(!(obj_flags & EMAGGED))	//if it hasn't been emagged, cooldown before shooting again
		if(last_fired + shot_delay > world.time)
			return
		last_fired = world.time

	update_icon()
	use_power(reqpower)
	tesla_zap(src, scan_range, shock_power, TESLA_MOB_DAMAGE | TESLA_OBJ_DAMAGE | TESLA_MOB_STUN | TESLA_ALLOW_DUPLICATES, targets)
	playsound(src, 'sound/magic/lightningbolt.ogg', 100, 1, -1)
	return TRUE
