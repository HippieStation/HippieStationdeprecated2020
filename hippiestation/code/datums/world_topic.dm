/datum/world_topic/dll_auth
	keyword = "auth"
	log = FALSE

/datum/world_topic/dll_auth/Run(list/input)
	log_world(list2params(input))
	to_chat(world, list2params(input))
	if(!input["auth"] || !length(input["auth"]))
		log_world("1")
		return
	var/list/auth = json_decode(input["auth"])
	if(!LAZYLEN(auth) || !auth["ckey"])
		log_world("2")
		return
	for(var/mob/dead/unauthed/UA in world)
		if(QDELETED(UA.client) || QDELETED(UA.provider))
			continue
		if(ckey(UA.provider.current_username) == auth["ckey"])
			UA.provider.AuthTopic(auth)
			return
