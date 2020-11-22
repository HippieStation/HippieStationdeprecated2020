/obj/item/circuitboard/machine/pressure
	name = "circuit board (Pressurized reaction vessel)"
	build_path = /obj/machinery/chem/pressure
	req_components = list(
							/obj/item/stock_parts/matter_bin = 1,
							/obj/item/stock_parts/capacitor = 2,
							/obj/item/stock_parts/manipulator = 3,
							/obj/item/stack/sheet/glass = 1,
							/obj/item/stock_parts/micro_laser = 2,
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stock_parts/cell = 1)

/obj/item/circuitboard/machine/centrifuge
	name = "circuit board (Centrifuge)"
	build_path = /obj/machinery/chem/centrifuge
	req_components = list(
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/stock_parts/capacitor = 1,
							/obj/item/stock_parts/manipulator = 3,
							/obj/item/stack/sheet/glass = 1,
							/obj/item/stock_parts/micro_laser = 2,
							/obj/item/stock_parts/scanning_module = 2,
							/obj/item/stock_parts/cell = 1)

/obj/item/circuitboard/machine/radioactive
	name = "circuit board (Radioactive molecular reassembler)"
	build_path = /obj/machinery/chem/radioactive
	req_components = list(
							/obj/item/stock_parts/matter_bin = 1,
							/obj/item/stock_parts/capacitor = 5,
							/obj/item/stock_parts/manipulator = 3,
							/obj/item/stack/sheet/glass = 1,
							/obj/item/stock_parts/micro_laser = 3,
							/obj/item/stock_parts/scanning_module = 4,
							/obj/item/stock_parts/cell = 1)

/obj/item/circuitboard/machine/bluespace
	name = "circuit board (Bluespace recombobulator)"
	build_path = /obj/machinery/chem/bluespace
	req_components = list(
							/obj/item/stock_parts/matter_bin = 3,
							/obj/item/stock_parts/capacitor = 10,
							/obj/item/stock_parts/manipulator = 5,
							/obj/item/stack/sheet/glass = 1,
							/obj/item/stock_parts/micro_laser = 5,
							/obj/item/stock_parts/scanning_module = 4,
							/obj/item/stack/ore/bluespace_crystal = 3,//this thing is an utter SHIT to make
							/obj/item/stock_parts/cell = 1)

/obj/item/circuitboard/machine/autodoc
	name = "circuit board (Auto-Doc Mark IX)"
	build_path = /obj/machinery/autodoc
	req_components = list(
							/obj/item/stock_parts/capacitor = 2,
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/stock_parts/micro_laser = 2,
							/obj/item/stock_parts/matter_bin = 1,
							/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/radio_station
	name = "circuit board (Bluespace radio station)"
	build_path = /obj/machinery/radio_station
	req_components = list(
							/obj/item/stock_parts/subspace/amplifier = 1,
							/obj/item/stock_parts/subspace/transmitter = 2,
							/obj/item/stock_parts/cell = 1,
							/obj/item/stock_parts/capacitor = 2,
							/obj/item/stack/sheet/bluespace_crystal = 2,
							/obj/item/instrument/piano_synth = 1
							)

/obj/item/circuitboard/machine/unce_machine
	name = "circuit board (Unce machine)"
	build_path = /obj/machinery/unce_machine
	req_components = list(
							/obj/item/taperecorder = 1
							)

/obj/item/circuitboard/machine/recordburner
	name = "circuit board (Record disk burner)"
	build_path = /obj/machinery/recordburner
	req_components = list(
							/obj/item/stock_parts/micro_laser = 2,
							/obj/item/stock_parts/scanning_module = 1

							)
