/obj/item/integrated_circuit/reagent/smoke
	name = "smoke generator"
	desc = "Unlike most electronics, creating smoke is completely intentional."
	icon_state = "smoke"
	extended_desc = "This smoke generator creates clouds of smoke on command. It can also hold liquids inside, which will go \
	into the smoke clouds when activated. The reagents are consumed when the smoke is made."
	ext_cooldown = 1
	container_type = OPENCONTAINER
	volume = 100
	complexity = 20
	cooldown_per_use = 1 SECONDS
	inputs = list()
	outputs = list(
		"volume used" = IC_PINTYPE_NUMBER,
		"self reference" = IC_PINTYPE_SELFREF
		)
	activators = list(
		"create smoke" = IC_PINTYPE_PULSE_IN,
		"on smoked" = IC_PINTYPE_PULSE_OUT,
		"push ref" = IC_PINTYPE_PULSE_IN
		)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 20
	var/smoke_radius = 5
	var/notified = FALSE

/obj/item/integrated_circuit/reagent/smoke/on_reagent_change(changetype)
	//reset warning only if we have reagents now
	if(changetype == ADD_REAGENT)
		notified = FALSE
	push_vol()
/obj/item/integrated_circuit/reagent/smoke/do_work(ord)
	switch(ord)
		if(1)
			if(!reagents || (reagents.total_volume < IC_SMOKE_REAGENTS_MINIMUM_UNITS))
				return
			var/location = get_turf(src)
			var/datum/effect_system/smoke_spread/chem/S = new
			S.attach(location)
			playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
			if(S)
				S.set_up(reagents, smoke_radius, location, notified)
				if(!notified)
					notified = TRUE
				S.start()
			reagents.clear_reagents()
			activate_pin(2)
		if(3)
			set_pin_data(IC_OUTPUT, 2, WEAKREF(src))
			push_data()

// - Integrated extinguisher - //
/obj/item/integrated_circuit/reagent/extinguisher
	name = "integrated extinguisher"
	desc = "This circuit sprays any of its contents out like an extinguisher."
	icon_state = "injector"
	extended_desc = "This circuit can hold up to 30 units of any given chemicals. On each use, it sprays these reagents like a fire extinguisher."

	container_type = OPENCONTAINER
	volume = 30

	complexity = 20
	cooldown_per_use = 6 SECONDS
	inputs = list(
		"target X rel" = IC_PINTYPE_NUMBER,
		"target Y rel" = IC_PINTYPE_NUMBER
		)
	outputs = list(
		"volume" = IC_PINTYPE_NUMBER,
		"self reference" = IC_PINTYPE_SELFREF
		)
	activators = list(
		"spray" = IC_PINTYPE_PULSE_IN,
		"on sprayed" = IC_PINTYPE_PULSE_OUT,
		"on fail" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 15
	var/busy = FALSE

/obj/item/integrated_circuit/reagent/extinguisher/Initialize()
	.=..()
	set_pin_data(IC_OUTPUT,2, src)

/obj/item/integrated_circuit/reagent/extinguisher/on_reagent_change(changetype)
	push_vol()

/obj/item/integrated_circuit/reagent/extinguisher/do_work()
	//Check if enough volume
	set_pin_data(IC_OUTPUT, 1, reagents.total_volume)
	if(!reagents || (reagents.total_volume < IC_SMOKE_REAGENTS_MINIMUM_UNITS) || busy)
		push_data()
		activate_pin(3)
		return

	playsound(loc, 'sound/effects/extinguish.ogg', 75, 1, -3)
	//Get the tile on which the water particle spawns
	var/turf/Spawnpoint = get_turf(src)
	if(!Spawnpoint)
		push_data()
		activate_pin(3)
		return

	//Get direction and target turf for each water particle
	var/turf/T = locate(Spawnpoint.x + get_pin_data(IC_INPUT, 1),Spawnpoint.y + get_pin_data(IC_INPUT, 2),Spawnpoint.z)
	if(!T)
		push_data()
		activate_pin(3)
		return
	var/direction = get_dir(Spawnpoint, T)
	var/turf/T1 = get_step(T,turn(direction, 90))
	var/turf/T2 = get_step(T,turn(direction, -90))
	var/list/the_targets = list(T,T1,T2)
	busy = TRUE

	// Create list with particles and their targets
	var/list/water_particles=list()
	for(var/a=0, a<5, a++)
		var/obj/effect/particle_effect/water/W = new /obj/effect/particle_effect/water(get_turf(src))
		water_particles[W] = pick(the_targets)
		var/datum/reagents/R = new/datum/reagents(5)
		W.reagents = R
		R.my_atom = W
		reagents.trans_to(W,1)

	//Make em move dat ass, hun
	addtimer(CALLBACK(src, /obj/item/integrated_circuit/reagent/extinguisher/proc/move_particles, water_particles), 2)

//This whole proc is a loop
/obj/item/integrated_circuit/reagent/extinguisher/proc/move_particles(var/list/particles, var/repetitions=0)
	//Check if there's anything in here first
	if(!particles || particles.len == 0)
		return
	// Second loop: Get all the water particles and make them move to their target
	for(var/obj/effect/particle_effect/water/W in particles)
		var/turf/my_target = particles[W]
		if(!W)
			continue
		step_towards(W,my_target)
		if(!W.reagents)
			continue
		W.reagents.reaction(get_turf(W))
		for(var/A in get_turf(W))
			W.reagents.reaction(A)
		if(W.loc == my_target)
			break
	if(repetitions < 4)
		repetitions++	//Can't have math operations in addtimer(CALLBACK())
		addtimer(CALLBACK(src, /obj/item/integrated_circuit/reagent/extinguisher/proc/move_particles, particles, repetitions), 2)
	else
		push_data()
		activate_pin(2)
		busy = FALSE


// - Drain circuit - //
/obj/item/integrated_circuit/reagent/drain
	name = "chemical drain circuit"
	desc = "This circuit either eliminates reagents by creating a puddle or can suck up chemicals on tiles."
	icon_state = "injector"
	extended_desc = "Set mode to FALSE to eliminate reagents and TRUE to drain."

	container_type = OPENCONTAINER
	volume = 20

	complexity = 10
	inputs = list(
		"mode" = IC_PINTYPE_BOOLEAN
		)
	outputs = list(
		"volume" = IC_PINTYPE_NUMBER,
		"self reference" = IC_PINTYPE_SELFREF
		)
	activators = list(
		"drain" = IC_PINTYPE_PULSE_IN,
		"on drained" = IC_PINTYPE_PULSE_OUT,
		"on fail" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 15


/obj/item/integrated_circuit/reagent/drain/Initialize()
	.=..()
	set_pin_data(IC_OUTPUT,2, src)


/obj/item/integrated_circuit/reagent/drain/do_work()
	if(get_pin_data(IC_OUTPUT, 1, reagents.total_volume))
		if(!reagents || !reagents.total_volume)
			push_data()
			activate_pin(3)
			return
		// Put the reagents on the floortile the assembly is on
		reagents.reaction(get_turf(src))
		reagents.clear_reagents()
		push_data()
		activate_pin(2)
		return

	else
		if(reagents)
			if(reagents.total_volume >= volume)
				push_data()
				activate_pin(3)
				return
		// Favorably, drain it from a chemicals pile, else, try something different
		var/obj/effect/decal/cleanable/drainedchems = locate(/obj/effect/decal/cleanable) in get_turf(src)
		if(!drainedchems || !drainedchems.reagents || drainedchems.reagents.total_volume == 0)
			push_data()
			activate_pin(3)
			return
		drainedchems.reagents.trans_to(src, 30, 0.5)
		if(drainedchems.reagents.total_volume == 0)
			qdel(drainedchems)
	push_data()

// - Beaker Connector - //
/obj/item/integrated_circuit/input/beaker_connector
	category_text = "Reagent"
	cooldown_per_use = 1
	name = "beaker slot"
	desc = "Lets you add a beaker to your assembly and remove it even when the assembly is closed."
	icon_state = "reagent_storage"
	extended_desc = "It can help you extract reagents easier."
	container_type = OPENCONTAINER
	complexity = 4

	inputs = list()
	outputs = list(
		"volume used" = IC_PINTYPE_NUMBER,
		"current beaker" = IC_PINTYPE_REF
		)
	activators = list(
		"on insert" = IC_PINTYPE_PULSE_OUT,
		"on remove" = IC_PINTYPE_PULSE_OUT,
		"push ref" = IC_PINTYPE_PULSE_OUT
		)

	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	can_be_asked_input = TRUE
	demands_object_input = TRUE
	can_input_object_when_closed = TRUE

var/obj/item/reagent_containers/glass/beaker/current_beaker


/obj/item/integrated_circuit/input/beaker_connector/attackby(var/obj/item/reagent_containers/I, var/mob/living/user)
	//Check if it truly is a reagent container
	if(!istype(I,/obj/item/reagent_containers/glass/beaker))
		to_chat(user,"<span class='warning'>The [I.name] doesn't seem to fit in here.</span>")
		return

	//Check if there is no other beaker already inside
	if(current_beaker)
		to_chat(user,"<span class='warning'>There is already a reagent container inside.</span>")
		return

	//The current beaker is the one we just attached, its location is inside the circuit
	current_beaker = I
	user.transferItemToLoc(I,src)
	to_chat(user,"<span class='warning'>You put the [I.name] inside the beaker connector.</span>")

	//Set the pin to a weak reference of the current beaker
	push_vol()
	set_pin_data(IC_OUTPUT, 2, WEAKREF(current_beaker))
	push_data()
	activate_pin(1)
	activate_pin(3)


/obj/item/integrated_circuit/input/beaker_connector/ask_for_input(mob/user)
	attack_self(user)


/obj/item/integrated_circuit/input/beaker_connector/attack_self(mob/user)
	//Check if no beaker attached
	if(!current_beaker)
		to_chat(user, "<span class='notice'>There is currently no beaker attached.</span>")
		return

	//Remove beaker and put in user's hands/location
	to_chat(user, "<span class='notice'>You take [current_beaker] out of the beaker connector.</span>")
	user.put_in_hands(current_beaker)
	current_beaker = null
	//Remove beaker reference
	push_vol()
	set_pin_data(IC_OUTPUT, 2, null)
	push_data()
	activate_pin(2)
	activate_pin(3)


/obj/item/integrated_circuit/input/beaker_connector/proc/push_vol()
	if(!current_beaker)
		set_pin_data(IC_OUTPUT, 1, 0)
	set_pin_data(IC_OUTPUT, 1, current_beaker.reagents.total_volume)
	push_data()


/obj/item/reagent_containers/glass/beaker/on_reagent_change()
	..()
	if(istype(src.loc,/obj/item/integrated_circuit/input/beaker_connector))
		var/obj/item/integrated_circuit/input/beaker_connector/current_circuit = src.loc
		current_circuit.push_vol()
	activate_pin(2)


/obj/item/integrated_circuit/reagent/drain/on_reagent_change(changetype)
	push_vol()
