// - wire connector - //
/obj/item/integrated_circuit/power/transmitter/wire_connector
	name = "wire connector"
	desc = "Connects to a wire and allows to read the power, charge it or charge itself from the wire's power."
	extended_desc = "This circuit will automatically attempt to locate and connect to wires on the floor beneath it when pulsed. \
						You <b>must</b> set a target before connecting. It can also transfer energy up to 2kJ from the assembly  \
						to a wire and backwards if negative values are set for energy transfer."
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	inputs = list(
			"charge" = IC_PINTYPE_NUMBER
			)
	activators = list(
			"toggle connection" = IC_PINTYPE_PULSE_IN,
			"transfer power" = IC_PINTYPE_PULSE_IN,
			"on connected" = IC_PINTYPE_PULSE_OUT,
			"on connection failed" = IC_PINTYPE_PULSE_OUT,
			"on disconnected" = IC_PINTYPE_PULSE_OUT
			)
	outputs = list(
			"connected cable" = IC_PINTYPE_REF,
			"powernet power" = IC_PINTYPE_NUMBER,
			"powernet load" = IC_PINTYPE_NUMBER
			)
	complexity = 35
	power_draw_per_use = 100
	amount_to_move = 0

	var/obj/structure/cable/connected_cable

/obj/item/integrated_circuit/power/transmitter/wire_connector/Initialize()
	START_PROCESSING(SSobj, src)
	. = ..()

//Does wire things
/obj/item/integrated_circuit/power/transmitter/wire_connector/process()
	update_cable()
	push_data()

//If the assembly containing this is moved from the tile the wire is in, the connection breaks
/obj/item/integrated_circuit/power/transmitter/wire_connector/ext_moved()
	if(connected_cable)
		if(get_dist(get_object(), connected_cable) > 0)
			// The connected cable is removed
			connected_cable = null
			set_pin_data(IC_OUTPUT, 1, null)
			push_data()
			activate_pin(5)


/obj/item/integrated_circuit/power/transmitter/wire_connector/on_data_written()
	var/charge_num = get_pin_data(IC_INPUT, 1)
	//In case someone sets that pin to null
	if(!charge_num)
		amount_to_move = 0
		return

	amount_to_move = CLAMP(charge_num,-2000, 2000)

/obj/item/integrated_circuit/power/transmitter/wire_connector/do_work(var/n)
	if(n == 1)
		// If there is a connection, disconnect
		if(connected_cable)
			connected_cable = null
			set_pin_data(IC_OUTPUT, 1, null)
			push_data()
			activate_pin(5)
			return
	
		var/obj/structure/cable/foundcable = locate(/obj/structure/cable) in get_turf(src)
		// If no connector can't connect
		if(!foundcable || foundcable.invisibility != 0)
			set_pin_data(IC_OUTPUT, 1, null)
			push_data()
			activate_pin(4)
			return
		connected_cable = foundcable
		update_cable()
		push_data()
		activate_pin(3)
		return


	if(!connected_cable)
		return

	if(!assembly)
		return

	//No charge transfer, no need to syphon tickrates with scripts
	if(!amount_to_move || amount_to_move == 0)
		return

	//Second clamp: set the number between what the battery and powernet allows
	var//obj/item/stock_parts/cell/battery = assembly.battery
	amount_to_move = CLAMP(amount_to_move, -min(connected_cable.powernet.avail,battery.maxcharge - battery.charge), battery.charge)

	connected_cable.powernet.avail += amount_to_move
	battery.charge -= amount_to_move

/obj/item/integrated_circuit/power/transmitter/wire_connector/proc/update_cable()
	if(get_dist(get_object(), connected_cable) > 0)
		connected_cable = null

	if(!connected_cable || connected_cable.invisibility != 0)
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, null)
		set_pin_data(IC_OUTPUT, 3, null)
		return

	var/datum/powernet/analyzed_net = connected_cable.powernet
	set_pin_data(IC_OUTPUT, 1, WEAKREF(connected_cable))
	set_pin_data(IC_OUTPUT, 2, analyzed_net.viewavail)
	set_pin_data(IC_OUTPUT, 3, analyzed_net.viewload)
