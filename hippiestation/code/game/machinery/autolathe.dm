/obj/item/circuitboard/machine/atmoslathe
	name = "circuit board (Atmos Autolathe)"
	build_path = /obj/machinery/autolathe/atmos
	origin_tech = "engineering=3;programming=2"
	req_components = list(
							/obj/item/stock_parts/matter_bin = 3,
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/stock_parts/console_screen = 1)

/obj/machinery/autolathe
	icon = 'hippiestation/icons/obj/stationobjs.dmi'

/obj/machinery/autolathe/atmos
	name = "atmospheric fabricator"
	desc = "It produces atmospheric related items using metal and glass."
	categories = list("Atmos")
	circuit = /obj/item/circuitboard/machine/atmoslathe
	files = /datum/research/autolathe/atmoslathe
