/datum/round_event/vent_clog/tick()
	if(activeFor % interval == 0)
		var/obj/machinery/atmospherics/components/unary/vent = pick_n_take(vents)
		while(vent && vent.welded)
			vent = pick_n_take(vents)

		if(vent && vent.loc)
			var/datum/reagents/R = new/datum/reagents(50)
			R.my_atom = vent
			R.add_reagent(pick(gunk), 50)

			var/datum/effect_system/smoke_spread/chem/smoke_machine/smoke = new
			smoke.set_up(R, 1, loc = vent)
			playsound(vent.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
			smoke.start()
			qdel(R)

			var/cockroaches = prob(33) ? 3 : 0
			while(cockroaches)
				new /mob/living/simple_animal/cockroach(get_turf(vent))
				cockroaches--