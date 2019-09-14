/datum/world_topic/dll_auth
	keyword = "auth"
	log = FALSE

/datum/world_topic/dll_auth/Run(list/input)
	if(!input["auth"] || !length(input["auth"]))
		return
	var/list/auth = json_decode(input["auth"])
	if(!LAZYLEN(auth) || !auth["ckey"])
		return
	for(var/mob/dead/unauthed/UA in world)
		if(QDELETED(UA.client) || QDELETED(UA.provider))
			continue
		if(ckey(UA.provider.current_username) == auth["ckey"])
			UA.provider.AuthTopic(auth)
			return
