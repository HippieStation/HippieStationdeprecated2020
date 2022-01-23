/datum/round_event_control/vent_clog
	weight = 0
	max_occurrences = 0

/datum/round_event_control/vent_clog/threatening
	weight = 0
	max_occurrences = 0

/datum/round_event_control/vent_clog/catastrophic
	weight = 0
	max_occurrences = 0


/datum/round_event_control/vent_clog/chaos
	name = "Clogged Vents: Chaos edition"
	typepath = /datum/round_event/vent_clog/chaos

/datum/round_event/vent_clog/chaos
	reagentsAmount = 100
	var/list/dangerChems = list(/datum/reagent/cryogenic_fluid, /datum/reagent/impvolt, /datum/reagent/emit, /datum/reagent/superboom, /datum/reagent/sparky, /datum/reagent/dizinc, /datum/reagent/hexamine,
							/datum/reagent/oxyplas, /datum/reagent/proto, /datum/reagent/arclumin, /datum/reagent/nitroglycerin, /datum/reagent/clf3, /datum/reagent/sorium, /datum/reagent/liquid_dark_matter,
							/datum/reagent/blackpowder, /datum/reagent/flash_powder, /datum/reagent/sonic_powder, /datum/reagent/phlogiston, /datum/reagent/napalm, /datum/reagent/teslium, /datum/reagent/bluespace)

/datum/round_event/vent_clog/chaos/announce()
	priority_announce("The scrubbers network is experiencing an unexpected surge of dangerous chemicals. Immediate temporary abandonment of the station is advised.", "Atmospherics alert")

/datum/round_event/vent_clog/chaos/start()
	for(var/obj/machinery/atmospherics/components/unary/vent in vents)
		if(vent && vent.loc)
			var/datum/reagents/R = new/datum/reagents(100)
			R.my_atom = vent
			R.add_reagent(pick(pick(subtypesof(/datum/reagent/toxin)), pick(subtypesof(/datum/reagent/drug)), pick(dangerChems)), reagentsAmount)

			var/datum/effect_system/foam_spread/foam = new
			foam.set_up(40, get_turf(vent), R)
			foam.start()
		CHECK_TICK