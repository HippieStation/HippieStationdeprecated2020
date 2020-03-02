/obj/vehicle/ridden/scooter/skateboard/unicycle
	name = "Clown's Unicycle"
	desc = "The clowns new favorite way to get around the station after he got his licence revoked."
	icon = 'face/icons/obj/uni.dmi'
	icon_state = "uni"
	density = FALSE

/obj/vehicle/ridden/scooter/skateboard/unicycle/Initialize()
	. = ..()
	var/datum/component/riding/D = LoadComponent(/datum/component/riding)
	D.set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(0, 5), TEXT_SOUTH = list(0, 5), TEXT_EAST = list(0, 5), TEXT_WEST = list( 0, 5)))
	D.vehicle_move_delay = 0 // RIDE FAST
	D.set_vehicle_dir_layer(SOUTH, ABOVE_MOB_LAYER)
	D.set_vehicle_dir_layer(NORTH, OBJ_LAYER)
	D.set_vehicle_dir_layer(EAST, OBJ_LAYER)
	D.set_vehicle_dir_layer(WEST, OBJ_LAYER)