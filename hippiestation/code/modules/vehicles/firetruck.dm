#define MOVE 1
#define REAGENTS_PER_EFFECT 5

/obj/vehicle/sealed/firetruck // spray those motherfuckers, boy
	name = "firetruck"
	icon_state = "engineering_pod"
	desc = "Atmos techs primary backup, this truck is loaded with a reagent pump, normally loaded with firefighting foam, to handle big fires and such. It can also accept water."
	movedelay = 3 // You have a LOT of water, can't be too fast too
	container_type = OPENCONTAINER
	var/obj/item/water_cannon_controls/controls
	var/is_spraying = FALSE
	var/num_of_effects = 3
	var/datum/effect_system/water_cannon/water_cannon
	var/list/whitelist = list("water", "firefighting_foam")

/obj/vehicle/sealed/firetruck/Initialize()
	. = ..()
	create_reagents(REAGENTS_PER_EFFECT*1000)
	reagents.add_reagent("firefighting_foam", REAGENTS_PER_EFFECT*1000)
	controls = new(src,src)
	water_cannon = new
	water_cannon.attach(src)

/obj/vehicle/sealed/firetruck/Destroy()
	qdel(controls)
	qdel(water_cannon)
	..()

/obj/vehicle/sealed/firetruck/on_reagent_change(changetype)
	..()
	if(changetype != ADD_REAGENT)
		return
	if(obj_flags & EMAGGED) // emags remove the whitelist, cfl3 cannons when
		return
	var/bad_reagent = FALSE
	for(var/r in reagents.reagent_list)
		var/datum/reagent/R = r
		if(!(R.id in whitelist))
			reagents.del_reagent(R.id)
			bad_reagent = TRUE
	if(bad_reagent)
		visible_message("<span class='danger'>An illegal reagent has been detected in the internal tank and successfully purged.</span>")

/obj/vehicle/sealed/firetruck/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	to_chat(user, "<span class='danger'>You critically damage the dangerous reagents purge module's valve!</span>")

/obj/vehicle/sealed/firetruck/proc/shoot_reagents(mob/user, atom/target)
	if(reagents.total_volume)
		water_cannon.set_up(n = num_of_effects, loca = src, reagent_datum = reagents, the_target = target)
		water_cannon.start()

/obj/vehicle/sealed/firetruck/proc/spawn_water_cannon(mob/user)
	if(!user.is_holding(controls)) // I didn't expect this to be so nicely readable
		if(!user.put_in_hands(controls))
			to_chat(user, "<span class='danger'>Your hands are full!</span>")
			reset_controls_loc() // put_in_hands drops them on the floor on fail. This resets their location properly
			return
		to_chat(user, "<span class='notice'>The controls are in your hands now. Click or keep clicking on the turfs to shoot the cannon at them.")
		return
	to_chat(user, "<span class='danger'>You already have the controls in your hands!</span>")

/obj/vehicle/sealed/firetruck/proc/reset_controls_loc()
	if(controls.loc != src)
		controls.forceMove(src)

/obj/vehicle/sealed/firetruck/after_remove_occupant(mob/M)
	..()
	reset_controls_loc()

/obj/vehicle/sealed/firetruck/generate_actions()
	. = ..()
	initialize_controller_action_type(/datum/action/vehicle/sealed/firetruck, VEHICLE_CONTROL_DRIVE)

/obj/vehicle/sealed/firetruck/AllowClick()
	return TRUE

// Actions

/datum/action/vehicle/sealed/firetruck
	name = "Start Water Cannon"
	desc = "Pick the water cannon controls"
	button_icon_state = "tobemade"

/datum/action/vehicle/sealed/firetruck/Trigger()
	if(..() && istype(vehicle_entered_target, /obj/vehicle/sealed/firetruck))
		var/obj/vehicle/sealed/firetruck/F = vehicle_entered_target
		F.spawn_water_cannon(owner)

// Water cannon objects

/obj/item/water_cannon_controls
	name = "water cannon controls"
	desc = "Control the firetruck water cannon with this. Be careful."
	icon = 'icons/obj/device.dmi'
	icon_state = "hand_tele"
	item_flags = NODROP | ABSTRACT
	var/obj/vehicle/sealed/firetruck/firetruck

/obj/item/water_cannon_controls/Initialize(mapload, obj/vehicle/sealed/the_firetruck)
	. = ..()
	firetruck = the_firetruck

/obj/item/water_cannon_controls/CanItemAutoclick()
	return TRUE

/obj/item/water_cannon_controls/afterattack(atom/targeted_atom, mob/user, flag, params)
	. = ..()
	if(QDELETED(firetruck) || QDELETED(src))
		return
	if(!firetruck)
		qdel(src)
		return
	firetruck.shoot_reagents(user, targeted_atom)

// Effect.
/datum/effect_system/water_cannon
	number = 5
	effect_type = /obj/effect/particle_effect/water_cannon
	var/atom/target
	var/datum/reagents/reagents

/datum/effect_system/water_cannon/set_up(n = 3, c = FALSE, loca, reagent_datum, atom/the_target)
	..()
	reagents = reagent_datum // synced reagents with its holder, or something else if needed in future.
	target = the_target

/datum/effect_system/water_cannon/start()
	generate_effect(number) // start the first effect immediately

/datum/effect_system/water_cannon/generate_effect(ntimes)
	if(reagents && reagents.total_volume && ntimes)
		make_n_move(ntimes)

/datum/effect_system/water_cannon/proc/make_n_move(ntimes)
	location = get_turf(holder)
	var/obj/effect/particle_effect/water_cannon/E = new effect_type(location)
	E.color = mix_color_from_reagents(reagents.reagent_list)
	total_effects++
	ntimes--
	reagents.trans_to(E, REAGENTS_PER_EFFECT)
	do_move(E, target)
	addtimer(CALLBACK(src, .proc/generate_effect, ntimes), MOVE)

/datum/effect_system/water_cannon/proc/do_move(obj/effect/particle_effect/water_cannon/E, atom/target) // cache the target, it may change otherwise
	if(get_turf(E) != get_turf(target))
		if(step_towards(E, target))
			addtimer(CALLBACK(src, .proc/do_move, E, target), MOVE)
			return
	E.apply_reagents(get_turf(E))
	total_effects--
	qdel(E) // we reached our target.

/obj/effect/particle_effect/water_cannon
	name = "water"
	icon = 'icons/effects/beam.dmi'
	icon_state = "3-full"
	layer = FLY_LAYER

/obj/effect/particle_effect/water_cannon/Initialize()
	. = ..()
	create_reagents(REAGENTS_PER_EFFECT)

/obj/effect/particle_effect/water_cannon/proc/apply_reagents(atom/movable/M)
	reagents.reaction(M, TOUCH)
	if(isturf(M))
		for(var/atom/A in M)
			if(A == src || A.invisibility)
				continue
			reagents.reaction(A, TOUCH)
	else
		reagents.reaction(M, TOUCH)

/obj/effect/particle_effect/water_cannon/Move(turf/newloc)
	if(newloc.density)
		return 0
	for(var/i in newloc)
		var/atom/A = i
		if(A.density)
			apply_reagents(A)
	. = ..()
