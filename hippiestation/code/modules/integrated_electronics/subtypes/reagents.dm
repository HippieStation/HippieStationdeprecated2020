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
		"self reference" = IC_PINTYPE_REF
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