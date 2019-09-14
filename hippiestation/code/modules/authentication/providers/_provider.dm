/datum/auth_provider
	var/id
	var/current_username
	var/logging_in = FALSE
	var/login_flags = NONE
	var/auth_attempts = 0
	var/next_login = 0
	var/is_global = FALSE
	var/list/config = list()
	var/mob/dead/unauthed/linked_unauth

/datum/auth_provider/New(mob/dead/unauthed/unauth, global_instance)
	..()
	if(global_instance)
		is_global = TRUE
		var/list/cfg = CONFIG_GET(keyed_list/auth_var)
		for(var/key in cfg)
			log_world("Loaded provider variable '[key]' = '[cfg[key]]'!")
			config[key] = cfg[key]
	else
		if(QDELETED(unauth) || !istype(unauth))
			qdel(src)
			return
		linked_unauth = unauth

/datum/auth_provider/can_vv_get(var_name)
	return var_name != NAMEOF(src, config) && ..()

/datum/auth_provider/Destroy()
	STOP_PROCESSING(SSauth, src)
	return ..()

/datum/auth_provider/proc/LoginMenu()
	return ""

/datum/auth_provider/proc/Update()

/datum/auth_provider/proc/Setup()

/datum/auth_provider/proc/AuthStatus(user)
	return FALSE

/datum/auth_provider/proc/AuthTopic(list/input)
