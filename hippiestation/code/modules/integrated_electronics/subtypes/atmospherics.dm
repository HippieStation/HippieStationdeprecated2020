#define SOURCE_TO_TARGET 0
#define TARGET_TO_SOURCE 1
#define MAX_TARGET_PRESSURE (ONE_ATMOSPHERE*25)
#define PUMP_EFFICIENCY 0.6
#define TANK_FAILURE_PRESSURE (ONE_ATMOSPHERE*25)

/obj/item/integrated_circuit/atmospherics
	category_text = "Atmospherics"
	cooldown_per_use = 2 SECONDS
	outputs = list(
		"self reference" = IC_PINTYPE_REF,
		"pressure" = IC_PINTYPE_NUMBER
			) 
	var/datum/gas_mixture/air_contents
	var/volume = 2 //Pretty small, I know

/obj/item/integrated_circuit/atmospherics/Initialize()
	air_contents = new(volume)
	..()

/obj/item/integrated_circuit/atmospherics/return_air()
	return air_contents

//Check if the gas container is adjacent and of the right type
/obj/item/integrated_circuit/atmospherics/proc/check_gassource(atom/gasholder)
	if(!gasholder)
		return FALSE
	if(!gasholder.Adjacent(get_object()))
		return FALSE
	if(!istype(gasholder, /obj/item/tank) && !istype(gasholder, /obj/machinery/portable_atmospherics) && !istype(gasholder, /obj/item/integrated_circuit/atmospherics))
		return FALSE
	return TRUE

//Needed in circuits where source and target types differ
/obj/item/integrated_circuit/atmospherics/proc/check_gastarget(atom/gasholder)
	return check_gassource(gasholder)


// - gas pump - // **Works**
/obj/item/integrated_circuit/atmospherics/pump
	name = "gas pump"
	desc = "Somehow moves gases between two tanks, canisters, and other gas containers."
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	complexity = 5
	size = 3
	inputs = list(
			"source" = IC_PINTYPE_REF,
			"target" = IC_PINTYPE_REF,
			"target pressure" = IC_PINTYPE_NUMBER
			)
	activators = list(
			"transfer" = IC_PINTYPE_PULSE_IN,
			"on transfer" = IC_PINTYPE_PULSE_OUT
			)
	var/direction = SOURCE_TO_TARGET
	var/target_pressure = ONE_ATMOSPHERE
	power_draw_per_use = 20

/obj/item/integrated_circuit/atmospherics/pump/Initialize()
	air_contents = new(volume)
	extended_desc += " Use negative pressure to move air from target to source. \
					Note that only part of the gas is moved on each transfer, \
					so multiple activations will be necessary to achieve target pressure. \
					The pressure limit for circuit pumps is [round(MAX_TARGET_PRESSURE)] kPa."
	. = ..()

// This proc gets the direction of the gas flow depending on its value, by calling update target 
/obj/item/integrated_circuit/atmospherics/pump/on_data_written()
	var/amt = get_pin_data(IC_INPUT, 3)
	update_target(amt)

/obj/item/integrated_circuit/atmospherics/pump/proc/update_target(new_amount)
	if(!isnum(new_amount))
		new_amount = 0
	// See in which direction the gas moves
	if(new_amount < 0)
		direction = TARGET_TO_SOURCE
	else
		direction = SOURCE_TO_TARGET
	target_pressure = min(round(MAX_TARGET_PRESSURE),abs(new_amount))

/obj/item/integrated_circuit/atmospherics/pump/do_work()
	var/obj/source = get_pin_data_as_type(IC_INPUT, 1, /obj)
	var/obj/target = get_pin_data_as_type(IC_INPUT, 2, /obj)
	perform_magic(source, target)
	activate_pin(2)

/obj/item/integrated_circuit/atmospherics/pump/proc/perform_magic(atom/source, atom/target)
	//Check if both atoms are of the right type: atmos circuits/gas tanks/canisters. If one is the same, use the circuit var
	if(!check_gassource(source))
		source = src

	if(!check_gastarget(target))
		target = src

	// If both are the same, this whole proc would do nothing and just waste performance
	if(source == target)
		return

	var/datum/gas_mixture/source_air = source.return_air()
	var/datum/gas_mixture/target_air = target.return_air()

	if(!source_air || !target_air)
		return

	// Swapping both source and target
	if(direction == TARGET_TO_SOURCE)
		var/temp = source_air
		source_air = target_air
		target_air = temp

	// If what you are pumping is empty, use the circuit's storage
	if(source_air.total_moles() <= 0)
		source_air = air_contents

	// Move gas from one place to another
	move_gas(source_air, target_air)
	air_update_turf()

/obj/item/integrated_circuit/atmospherics/pump/proc/move_gas(datum/gas_mixture/source_air, datum/gas_mixture/target_air)
	// No moles = nothing to pump
	if(source_air.total_moles() <= 0)
		return

	// Negative Kelvin temperatures should never happen and if they do, normalize them 
	if(source_air.temperature < TCMB)
		source_air.temperature = TCMB
	
	var/pressure_delta = target_pressure - target_air.return_pressure()
	if(pressure_delta > 0.1)
		var/transfer_moles = (pressure_delta*target_air.volume/(source_air.temperature * R_IDEAL_GAS_EQUATION))*PUMP_EFFICIENCY
		var/datum/gas_mixture/removed = source_air.remove(transfer_moles)
		target_air.merge(removed)


// - volume pump - // **Works**
/obj/item/integrated_circuit/atmospherics/pump/volume
	name = "volume pump"
	desc = "Moves gases between two tanks, canisters, and other gas containers by using their volume, up to 200 L/s."
	extended_desc = " Use negative volume to move air from target to source. Note that only part of the gas is moved on each transfer. Unlike the gas pump, this one keeps pumping even further to pressures of 9000 pKa and it is not advised to use it on tank circuits."

	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	complexity = 5
	size = 3
	inputs = list(
			"source" = IC_PINTYPE_REF,
			"target" = IC_PINTYPE_REF,
			"transfer volume" = IC_PINTYPE_NUMBER
			)
	activators = list(
			"transfer" = IC_PINTYPE_PULSE_IN,
			"on transfer" = IC_PINTYPE_PULSE_OUT
			)
	direction = SOURCE_TO_TARGET
	var/transfer_rate = MAX_TRANSFER_RATE
	power_draw_per_use = 20

/obj/item/integrated_circuit/atmospherics/pump/volume/update_target(new_amount)
	if(!isnum(new_amount))
		new_amount = 0
	// See in which direction the gas moves
	if(new_amount < 0)
		direction = TARGET_TO_SOURCE
	else
		direction = SOURCE_TO_TARGET
	target_pressure = min(200,abs(new_amount))

/obj/item/integrated_circuit/atmospherics/pump/volume/move_gas(datum/gas_mixture/source_air, datum/gas_mixture/target_air)
	// No moles = nothing to pump
	if(source_air.total_moles() <= 0)
		return

	// Negative Kelvin temperatures should never happen and if they do, normalize them 
	if(source_air.temperature < TCMB)
		source_air.temperature = TCMB

	if((source_air.return_pressure() < 0.01) || (target_air.return_pressure() > 9000))
		return

	var/transfer_ratio = transfer_rate/source_air.volume

	var/datum/gas_mixture/removed = source_air.remove_ratio(transfer_ratio)

	target_air.merge(removed)


// - gas vent - // **works**
/obj/item/integrated_circuit/atmospherics/pump/vent
	name = "gas vent"
	extended_desc = "Use negative volume to move air from target to environment. Note that only part of the gas is moved on each transfer. Unlike the gas pump, this one keeps pumping even further to pressures of 9000 pKa and it is not advised to use it on tank circuits."
	desc = "Moves gases between the environment and adjacent gas containers."
	inputs = list(
			"container" = IC_PINTYPE_REF,
			"target pressure" = IC_PINTYPE_NUMBER
			)

/obj/item/integrated_circuit/atmospherics/pump/vent/on_data_written()
	var/amt = get_pin_data(IC_INPUT, 2)
	update_target(amt)

/obj/item/integrated_circuit/atmospherics/pump/vent/do_work()
	var/turf/source = get_turf(src)
	var/obj/target = get_pin_data_as_type(IC_INPUT, 1, /obj)
	perform_magic(source, target)
	activate_pin(2)

/obj/item/integrated_circuit/atmospherics/pump/vent/check_gastarget(atom/gasholder)
	if(!gasholder)
		return FALSE
	if(!gasholder.Adjacent(get_object()))
		return FALSE
	if(!istype(gasholder, /obj/item/tank) && !istype(gasholder, /obj/machinery/portable_atmospherics) && !istype(gasholder, /obj/item/integrated_circuit/atmospherics))
		return FALSE
	return TRUE


/obj/item/integrated_circuit/atmospherics/pump/vent/check_gassource(atom/target)
	if(!target)
		return FALSE
	if(!istype(target, /turf))
		return FALSE
	return TRUE


//CHECKED AND **UNTESTED**
// - integrated connector - //
/obj/item/integrated_circuit/atmospherics/connector
	name = "integrated connector"
	desc = "Creates an airtight seal with standard connectors found on the floor, \
		 	allowing the assembly to exchange gases with a pipe network."
	extended_desc = "This circuit will automatically attempt to locate and connect to ports on the floor beneath it when activated. \
					You <b>must</b> set a target before connecting."
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	complexity = 2
	size = 6
	inputs = list(
			"target" = IC_PINTYPE_REF
			)
	activators = list(
			"toggle connection" = IC_PINTYPE_PULSE_IN,
			"on connected" = IC_PINTYPE_PULSE_OUT,
			"on connection failed" = IC_PINTYPE_PULSE_OUT,
			"on disconnected" = IC_PINTYPE_PULSE_OUT
			)
	var/obj/machinery/atmospherics/components/unary/portables_connector/connector

//If the assembly containing this is moved from the tile the connector pipe is in, the connection breaks
/obj/item/integrated_circuit/atmospherics/connector/ext_moved()
	if(connector)
		if(get_dist(get_object(), connector) > 0)
			connector.connected_device = null
			connector = null
			activate_pin(4)

//If the target is a gas tank/atmos circuit/canister and next to it, returns its air contents, else returns its own
/obj/item/integrated_circuit/atmospherics/connector/portableConnectorReturnAir()
	var/obj/target = get_pin_data_as_type(IC_INPUT, 1, /obj)
	if(check_gassource(target))
		return target.return_air()
	else
		return return_air()

/obj/item/integrated_circuit/atmospherics/connector/do_work()
	// If there is a connection, disconnect
	if(connector)
		connector.connected_device = null
		connector = null
		activate_pin(4)
		return

	var/obj/machinery/atmospherics/components/unary/portables_connector/PC = locate() in get_turf(src)
	// If no connector can't connect
	if(!PC)
		activate_pin(3)
		return
	connector = PC
	connector.connected_device = src
	activate_pin(2)


// - gas filter - // **works**
/obj/item/integrated_circuit/atmospherics/pump/filter
	name = "gas filter"
	desc = "Filters one gas out of a mixture."
	complexity = 20
	size = 5
	spawn_flags = IC_SPAWN_RESEARCH
	inputs = list(
			"source" = IC_PINTYPE_REF,
			"filtered output" = IC_PINTYPE_REF,
			"contaminants output" = IC_PINTYPE_REF,
			"wanted gases" = IC_PINTYPE_LIST,
			"target pressure" = IC_PINTYPE_NUMBER
			)
	power_draw_per_use = 30

/obj/item/integrated_circuit/atmospherics/pump/filter/on_data_written()
	var/amt = get_pin_data(IC_INPUT, 5)
	target_pressure = CLAMP(amt, 0, MAX_TARGET_PRESSURE)

/obj/item/integrated_circuit/atmospherics/pump/filter/do_work()
	activate_pin(2)
	var/obj/source = get_pin_data_as_type(IC_INPUT, 1, /obj)
	var/obj/filtered = get_pin_data_as_type(IC_INPUT, 2, /obj)
	var/obj/contaminants = get_pin_data_as_type(IC_INPUT, 3, /obj)

	var/wanted = get_pin_data(IC_INPUT, 4)

	// If there is no filtered output, this whole thing makes no sense
	if(!check_gassource(filtered))
		return

	var/datum/gas_mixture/filtered_air = filtered.return_air()
	if(!filtered_air)
		return

	// If no source is set, the source is possibly this circuit's content
	if(!check_gassource(source))
		source = src
	var/datum/gas_mixture/source_air = source.return_air()

	//No source air: source is this circuit
	if(!source_air)
		source_air = air_contents

	// If no filtering tank is set, filter through itself
	if(!check_gassource(contaminants))
		contaminants = src
	var/datum/gas_mixture/contaminated_air = contaminants.return_air()

	//If there is no gas mixture datum for unfiltered, pump the contaminants back into the circuit
	if(!contaminated_air)
		contaminated_air = air_contents

	var/pressure_delta = target_pressure - contaminated_air.return_pressure()
	var/transfer_moles

	//Negative Kelvins are an anomaly and should be normalized if encountered
	if(source_air.temperature < TCMB)
		source_air.temperature = TCMB

	transfer_moles = (pressure_delta*contaminated_air.volume/(source_air.temperature * R_IDEAL_GAS_EQUATION))*PUMP_EFFICIENCY

	//If there is nothing to transfer, just return
	if(transfer_moles <= 0)
		return

	//This is the var that holds the currently filtered part of the gas
	var/datum/gas_mixture/removed = source_air.remove(transfer_moles)
	if(!removed)
		return

	//This is the gas that will be moved from source to filtered
	var/datum/gas_mixture/filtered_out = new

	for(var/filtered_gas in removed.gases)
		//Get the name of the gas and see if it is in the list
		if(removed.gases[filtered_gas][GAS_META][META_GAS_NAME] in wanted)
			//The gas that is put in all the filtered out gases
			filtered_out.temperature = removed.temperature
			filtered_out.add_gas(filtered_gas)
			filtered_out.gases[filtered_gas][MOLES] = removed.gases[filtered_gas][MOLES]

			//The filtered out gas is entirely removed from the currently filtered gases
			removed.gases[filtered_gas][MOLES] = 0
			removed.garbage_collect()

	//Check if the pressure is high enough to put stuff in filtered, or else just put it back in the source
	var/datum/gas_mixture/target = (filtered_air.return_pressure() < target_pressure ? filtered_air : source_air)
	target.merge(filtered_out)
	contaminated_air.merge(removed)

/obj/item/integrated_circuit/atmospherics/pump/filter/Initialize()
	air_contents = new(volume)
	. = ..()
	extended_desc = "Remember to properly spell and capitalize the filtered gas name. \
					Note that only part of the gas is moved on each transfer, \
					so multiple activations will be necessary to achieve target pressure. \
					The pressure limit for circuit pumps is [round(MAX_TARGET_PRESSURE)] kPa."


// - gas mixer - // **working**
/obj/item/integrated_circuit/atmospherics/pump/mixer
	name = "gas mixer"
	desc = "Mixes 2 different types of gases."
	complexity = 20
	size = 5
	spawn_flags = IC_SPAWN_RESEARCH
	inputs = list(
			"first source" = IC_PINTYPE_REF,
			"second source" = IC_PINTYPE_REF,
			"output" = IC_PINTYPE_REF,
			"first source percentage" = IC_PINTYPE_NUMBER,
			"target pressure" = IC_PINTYPE_NUMBER
			)
	power_draw_per_use = 30

/obj/item/integrated_circuit/atmospherics/pump/mixer/do_work()
	activate_pin(2)
	var/obj/source_1 = get_pin_data(IC_INPUT, 1)
	var/obj/source_2 = get_pin_data(IC_INPUT, 2)
	var/obj/gas_output = get_pin_data(IC_INPUT, 3)
	if(!check_gassource(source_1))
		source_1 = src

	if(!check_gassource(source_2))
		source_2 = src

	if(!check_gassource(gas_output))
		gas_output = src

	if(source_1 == gas_output || source_2 == gas_output)
		return

	var/datum/gas_mixture/source_1_gases = source_1.return_air()
	var/datum/gas_mixture/source_2_gases = source_2.return_air()
	var/datum/gas_mixture/output_gases = gas_output.return_air()

	if(!source_1_gases || !source_2_gases || !output_gases)
		return

	if(source_1_gases.return_pressure() <=0 || source_2_gases.return_pressure() <=0)
		return

	//This calculates how much should be sent
	var/gas_percentage = round(max(min(get_pin_data(IC_INPUT, 4),100),0) / 100)

	var/transfer_moles = get_pin_data(IC_INPUT, 5) * (source_1_gases.return_pressure() * gas_percentage +  source_2_gases.return_pressure() * (1 - gas_percentage)) / (output_gases.return_pressure()) * output_gases.volume/ (R_IDEAL_GAS_EQUATION * max(output_gases.temperature,TCMB)) * PUMP_EFFICIENCY

	if(transfer_moles <= 0)
		return

	var/datum/gas_mixture/mix = source_1_gases.remove(transfer_moles * gas_percentage)
	output_gases.merge(mix)
	mix = source_2_gases.remove(transfer_moles * (1-gas_percentage))
	output_gases.merge(mix)


// - integrated tank - // **working**
/obj/item/integrated_circuit/atmospherics/tank
	name = "integrated tank"
	desc = "A small tank for the storage of gases."
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	size = 4
	activators = list(
			"push ref" = IC_PINTYPE_PULSE_IN
			)
	volume = 3 //emergency tank sized
	var/broken = FALSE

/obj/item/integrated_circuit/atmospherics/tank/Initialize()
	air_contents = new(volume)
	START_PROCESSING(SSobj, src)
	extended_desc = "Take care not to pressurize it above [round(TANK_FAILURE_PRESSURE)] kPa, or else it will break."
	. = ..()

/obj/item/integrated_circuit/atmospherics/tank/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/integrated_circuit/atmospherics/tank/do_work()
	set_pin_data(IC_OUTPUT, 1, WEAKREF(src))
	push_data()

/obj/item/integrated_circuit/atmospherics/tank/process()
	var/tank_pressure = air_contents.return_pressure()
	set_pin_data(IC_OUTPUT, 2, tank_pressure)
	push_data()

	//Check if tank broken
	if(!broken && tank_pressure > TANK_FAILURE_PRESSURE)
		broken = TRUE
		to_chat(view(0),"<span class='notice'>The [src.name] ruptures, releasing its gases!</span>")
	if(broken)
		release()

/obj/item/integrated_circuit/atmospherics/tank/proc/release()
	if(air_contents.total_moles() > 0)
		playsound(src.loc, 'sound/effects/spray.ogg', 10, 1, -3)
		var/datum/gas_mixture/expelled_gas = air_contents.remove(air_contents.total_moles())
		var/turf/current_turf = get_turf(src)
		var/datum/gas_mixture/exterior_gas
		if(!current_turf)
			return

		exterior_gas = current_turf.return_air()
		exterior_gas.merge(expelled_gas)


// - large integrated tank - // **working**
/obj/item/integrated_circuit/atmospherics/tank/large
	name = "large integrated tank"
	desc = "A less small tank for the storage of gases."
	volume = 9
	size = 12
	spawn_flags = IC_SPAWN_RESEARCH


// - freezer tank - // **working**
/obj/item/integrated_circuit/atmospherics/tank/freezer
	name = "freezer tank"
	desc = "Cools the gas it contains to a preset temperature."
	volume = 6
	size = 8
	inputs = list(
		"target temperature" = IC_PINTYPE_NUMBER,
		"on" = IC_PINTYPE_BOOLEAN
		)
	inputs_default = list("1" = 300)
	spawn_flags = IC_SPAWN_RESEARCH
	var/temperature = 293.15
	var/heater_coefficient = 0.1

/obj/item/integrated_circuit/atmospherics/tank/freezer/on_data_written()
	temperature = max(73.15,min(293.15,get_pin_data(IC_INPUT, 1)))
	if(get_pin_data(IC_INPUT, 2))
		power_draw_idle = 30
	else
		power_draw_idle = 0

/obj/item/integrated_circuit/atmospherics/tank/freezer/process()
	var/tank_pressure = air_contents.return_pressure()
	set_pin_data(IC_OUTPUT, 2, tank_pressure)
	push_data()

	//Cool the tank if the power is on and the temp is above
	if(!power_draw_idle || air_contents.temperature < temperature)
		return

	air_contents.temperature = max(73.15,air_contents.temperature - (air_contents.temperature - temperature) * heater_coefficient)


// - heater tank - // **working**
/obj/item/integrated_circuit/atmospherics/tank/freezer/heater
	name = "heater tank"
	desc = "Heats the gas it contains to a preset temperature."
	volume = 6
	size = 8
	inputs = list(
		"target temperature" = IC_PINTYPE_NUMBER,
		"on" = IC_PINTYPE_BOOLEAN
		)
	spawn_flags = IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/atmospherics/tank/freezer/heater/on_data_written()
	temperature = max(293.15,min(573.15,get_pin_data(IC_INPUT, 1)))
	if(get_pin_data(IC_INPUT, 2))
		power_draw_idle = 30
	else
		power_draw_idle = 0

/obj/item/integrated_circuit/atmospherics/tank/freezer/heater/process()
	var/tank_pressure = air_contents.return_pressure()
	set_pin_data(IC_OUTPUT, 2, tank_pressure)
	push_data()

	//Heat the tank if the power is on or its temperature is below what is set
	if(!power_draw_idle || air_contents.temperature > temperature)
		return

	air_contents.temperature = min(573.15,air_contents.temperature + (temperature - air_contents.temperature) * heater_coefficient)


// - atmospheric cooler - // **working**
/obj/item/integrated_circuit/atmospherics/cooler
	name = "atmospheric cooler circuit"
	desc = "Cools the air around it."
	volume = 6
	size = 13
	spawn_flags = IC_SPAWN_RESEARCH
	inputs = list(
		"target temperature" = IC_PINTYPE_NUMBER,
		"on" = IC_PINTYPE_BOOLEAN
		)
	var/temperature = 293.15
	var/heater_coefficient = 0.1

/obj/item/integrated_circuit/atmospherics/cooler/Initialize()
	air_contents = new(volume)
	START_PROCESSING(SSobj, src)
	. = ..()

/obj/item/integrated_circuit/atmospherics/cooler/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/integrated_circuit/atmospherics/cooler/on_data_written()
	temperature = max(243.15,min(293.15,get_pin_data(IC_INPUT, 1)))
	if(get_pin_data(IC_INPUT, 2))
		power_draw_idle = 30
	else
		power_draw_idle = 0

/obj/item/integrated_circuit/atmospherics/cooler/process()
	set_pin_data(IC_OUTPUT, 2, air_contents.return_pressure())
	push_data()


	//Get the turf you're on and its gas mixture
	var/turf/current_turf = get_turf(src)
	if(!current_turf)
		return

	var/datum/gas_mixture/turf_air = current_turf.return_air()
	if(!power_draw_idle || turf_air.temperature < temperature)
		return

	//Cool the gas
	turf_air.temperature = max(243.15,turf_air.temperature - (turf_air.temperature - temperature) * heater_coefficient)


// - atmospheric heater - // **working**
/obj/item/integrated_circuit/atmospherics/cooler/heater
	name = "atmospheric heater circuit"
	desc = "Heats the air around it."

/obj/item/integrated_circuit/atmospherics/cooler/heater/on_data_written()
	temperature = max(293.15,min(323.15,get_pin_data(IC_INPUT, 1)))
	if(get_pin_data(IC_INPUT, 2))
		power_draw_idle = 30
	else
		power_draw_idle = 0

/obj/item/integrated_circuit/atmospherics/cooler/heater/process()
	set_pin_data(IC_OUTPUT, 2, air_contents.return_pressure())
	push_data()

	//Get the turf and its air mixture
	var/turf/current_turf = get_turf(src)
	if(!current_turf)
		return

	var/datum/gas_mixture/turf_air = current_turf.return_air()
	if(!power_draw_idle || turf_air.temperature > temperature)
		return

	//Heat the gas
	turf_air.temperature = min(323.15,turf_air.temperature + (temperature - turf_air.temperature) * heater_coefficient)


#undef SOURCE_TO_TARGET
#undef TARGET_TO_SOURCE
#undef MAX_TARGET_PRESSURE
#undef PUMP_EFFICIENCY
#undef TANK_FAILURE_PRESSURE
