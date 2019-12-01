/datum/round_event_control/scrake
	name = "Scrake attack"
	typepath = /datum/round_event/ghost_role/scrake
	max_occurrences = 1

/datum/round_event/ghost_role/scrake
	role_name = "Scrake zombie"
	minimum_required = 1

/datum/round_event/ghost_role/scrake/spawn_role()
	var/list/candidates = get_candidates(ROLE_OPERATIVE, null, ROLE_OPERATIVE)
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS

	var/mob/dead/selected = pick_n_take(candidates)

	var/list/spawn_locs = list()
	for(var/L in GLOB.xeno_spawn)
		spawn_locs += L
	if(!spawn_locs.len)
		return MAP_ERROR

	var/mob/living/carbon/human/S = new(pick(spawn_locs))
	var/datum/mind/Mind = new /datum/mind(selected.key)
	Mind.assigned_role = "Scrake"
	Mind.special_role = "Scrake"
	Mind.active = TRUE
	Mind.transfer_to(S)
	S.equipOutfit(/datum/outfit/scrake)
	spawned_mobs += S
	message_admins("[ADMIN_LOOKUPFLW(S)] has been made into scrake by an event.")
	log_game("[key_name(S)] was spawned as a scrake by an event.")
	return SUCCESSFUL_SPAWN