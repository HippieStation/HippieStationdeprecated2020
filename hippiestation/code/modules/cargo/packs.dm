/datum/supply_pack/misc/crusade
	name = "Crusader Armour Pack"
	cost = 3000
	contains = list(/obj/item/clothing/head/helmet/knight,
					/obj/item/clothing/head/helmet/knight/blue,
					/obj/item/clothing/head/helmet/knight/yellow,
					/obj/item/clothing/head/helmet/knight/red,
					/obj/item/clothing/suit/armor/riot/knight,
					/obj/item/clothing/suit/armor/riot/knight/yellow,
					/obj/item/clothing/suit/armor/riot/knight/blue,
					/obj/item/clothing/suit/armor/riot/knight/red,
					/obj/item/shield/riot/roman,
					/obj/item/shield/riot/roman,
					/obj/item/shield/riot/roman,
					/obj/item/shield/riot/roman)
	crate_name = "Counter holy land invasion crate."

/datum/supply_pack/materials/diamond20
	name = "20 Diamonds"
	cost = 50000
	contains = list(/obj/item/stack/sheet/mineral/diamond/twenty)
	crate_name = "diamonds crate"

/datum/supply_pack/materials/plasma20
	name = "20 Plasma Sheets"
	cost = 6000
	contains = list(/obj/item/stack/sheet/mineral/plasma/twenty)
	crate_name = "plasma sheets crate"

/datum/supply_pack/materials/bananium20
	name = "20 Bananium Sheets"
	cost = 100000
	contains = list(/obj/item/stack/sheet/mineral/bananium/twenty)
	crate_name = "bananium sheets crate"

/datum/supply_pack/materials/titanium20
	name = "20 Titanium Sheets"
	cost = 5000
	contains = list(/obj/item/stack/sheet/mineral/titanium/twenty)
	crate_name = "titanium sheets crate"

/datum/supply_pack/materials/silver20
	name = "20 Silver Sheets"
	cost = 2000
	contains = list(/obj/item/stack/sheet/mineral/silver/twenty)
	crate_name = "silver sheets crate"

/datum/supply_pack/materials/gold20
	name = "20 Gold Sheets"
	cost = 5000
	contains = list(/obj/item/stack/sheet/mineral/gold/twenty)
	crate_name = "gold sheets crate"

/datum/supply_pack/materials/uranium20
	name = "20 Uranium Sheets"
	cost = 8000
	contains = list(/obj/item/stack/sheet/mineral/uranium/twenty)
	crate_name = "uranium sheets crate"

/datum/supply_pack/science/plasma_canister
	name = "Plasma Canister"
	cost = 6000
	access = ACCESS_ATMOSPHERICS
	contains = list(/obj/machinery/portable_atmospherics/canister/toxins)
	crate_name = "plasma canister crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/science/circuitry
	name = "Circuitry Starter Pack Crate"
	desc = "Journey into the mysterious world of Circuitry with this starter pack. Contains a circuit printer, analyzer, debugger and wirer. Power cells not included."
	cost = 1000
	contains = list(/obj/item/integrated_electronics/analyzer,
					/obj/item/integrated_circuit_printer,
					/obj/item/integrated_electronics/debugger,
					/obj/item/integrated_electronics/wirer)
	crate_name = "circuitry starter pack crate"

/datum/supply_pack/emergency/syndicate
	cost = 10000

/datum/supply_pack/science/freon_canister
	name = "Freon Canister"
	cost = 6000
	access_any = list(ACCESS_RD, ACCESS_ATMOSPHERICS)
	contains = list(/obj/machinery/portable_atmospherics/canister/freon)
	crate_name = "freon canister crate"
	crate_type = /obj/structure/closet/crate/secure/science
	dangerous = TRUE

/datum/supply_pack/materials/bz
	cost = 8000

