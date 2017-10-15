/obj/machinery/autolathe
	icon = 'hippiestation/icons/obj/stationobjs.dmi'

/obj/machinery/autolathe/atmos
	name = "atmospheric fabricator"
	desc = "It produces atmospheric related items using metal and glass."
	icon_state = "mechfab1"
	default_icon = "mechfab1"
	metalanim = "mechfabo"
	glassanim = "mechfabr"
	making = "mechfab3"
	maintpanel = "mechfabt"
	categories = list("Atmos")
	board = /obj/item/weapon/circuitboard/atmoslathe
	files = /datum/research/autolathe/atmoslathe
