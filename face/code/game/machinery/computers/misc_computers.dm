//Subtype of the CentCom ferry so that an assistant who breaks in can't go to CentCom with a meteor gun (admins have to allow the shuttle to move when requested). Original code in ferry.dm

/obj/machinery/computer/shuttle/ferry/request/merchant
	name = "Merchant's Freighter Shuttle Console"
	desc = "Used to control the merchant's freighter."
	circuit = /obj/item/circuitboard/computer/ferry/request/merchant
	shuttleId = "merchant"
	possible_destinations = "merchant_home;merchant_away"