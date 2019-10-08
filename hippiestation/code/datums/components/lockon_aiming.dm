/datum/component/lockon_aiming/proc/onMouseUpdate(object,location,control,params)
	var/mob/M = parent
	if(!istype(M) || !M.client)
		return
	var/datum/position/P = mouse_absolute_datum_map_position_from_client(M.client)
	if(!P)
		return
	var/turf/T = P.return_turf()
	LAZYINITLIST(last_location)
	if(length(last_location) == 3 && last_location[1] == T.x && last_location[2] == T.y && last_location[3] == T.z)
		return			//Same turf, don't bother.
	if(last_location)
		last_location.Cut()
	else
		last_location = list()
	last_location.len = 3
	last_location[1] = T.x
	last_location[2] = T.y
	last_location[3] = T.z
	autolock()

/datum/component/lockon_aiming/Initialize(range, list/typecache, amount, list/immune, datum/callback/when_locked, icon, icon_state, datum/callback/target_callback)
	. = ..()
	if(!.)
		RegisterSignal(parent, COMSIG_MOB_MOUSEENTERED, .proc/onMouseUpdate)
		RegisterSignal(parent, COMSIG_MOB_MOUSEEXITED, .proc/onMouseUpdate)
