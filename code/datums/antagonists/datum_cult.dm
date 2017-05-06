/datum/antagonist/cult
	var/datum/action/innate/cultcomm/communion = new

/datum/antagonist/cult/Destroy()
	qdel(communion)
	return ..()

/datum/antagonist/cult/proc/add_objectives()
	var/list/target_candidates = list()
	for(var/mob/living/carbon/human/player in GLOB.player_list)
		if(player.mind && !is_convertable_to_cult(player) && (player != owner) && isliving(player))
			target_candidates += player.mind
	if(target_candidates.len == 0)
		message_admins("Cult Sacrifice: Could not find unconvertable target, checking for convertable target.")
		for(var/mob/living/carbon/human/player in GLOB.player_list)
			if(player.mind && (player != owner) && isliving(player))
				target_candidates += player.mind
	if(target_candidates.len > 0)
		GLOB.sac_mind = pick(target_candidates)
		if(!GLOB.sac_mind)
			message_admins("Cult Sacrifice: ERROR -  Null target chosen!")
		else
			var/datum/job/sacjob = SSjob.GetJob(GLOB.sac_mind.assigned_role)
			var/datum/preferences/sacface = GLOB.sac_mind.current.client.prefs
			var/icon/reshape = get_flat_human_icon(null, sacjob, sacface)
			reshape.Shift(SOUTH, 4)
			reshape.Shift(EAST, 1)
			reshape.Crop(7,4,26,31)
			reshape.Crop(-5,-3,26,30)
			GLOB.sac_image = reshape
	else
		message_admins("Cult Sacrifice: Could not find unconvertable or convertable target. WELP!")
		GLOB.sac_complete = TRUE
	SSticker.mode.cult_objectives += "sacrifice"
	SSticker.mode.cult_objectives += "eldergod"
	on_gain()

/datum/antagonist/cult/proc/cult_memorization(datum/mind/cult_mind)
	var/mob/living/current = cult_mind.current
	for(var/obj_count = 1,obj_count <= SSticker.mode.cult_objectives.len,obj_count++)
		var/explanation
		switch(SSticker.mode.cult_objectives[obj_count])
			if("sacrifice")
				if(GLOB.sac_mind)
					explanation = "Sacrifice [GLOB.sac_mind], the [GLOB.sac_mind.assigned_role] via invoking a Sacrifice rune with them on it and three acolytes around it."
				else
					explanation = "The veil has already been weakened here, proceed to the final objective."
			if("eldergod")
				explanation = "Summon Nar-Sie by invoking the rune 'Summon Nar-Sie' with nine acolytes on it. You must do this after sacrificing your target."
		to_chat(current, "<B>Objective #[obj_count]</B>: [explanation]")
		cult_mind.memory += "<B>Objective #[obj_count]</B>: [explanation]<BR>"

/datum/antagonist/cult/can_be_owned(datum/mind/new_owner)
	. = ..()
	if(.)
		. = is_convertable_to_cult(new_owner.current)

/datum/antagonist/cult/on_gain()
	. = ..()
	var/mob/living/current = owner.current
	if(SSticker.mode.cult_objectives.len == 0)
		add_objectives()
		return
	SSticker.mode.cult += owner // Only add after they've been given objectives
	cult_memorization(owner)
	if(jobban_isbanned(current, ROLE_CULTIST) || jobban_isbanned(current, CLUWNEBAN) || jobban_isbanned(current, CATBAN))
		addtimer(CALLBACK(SSticker.mode, /datum/game_mode.proc/replace_jobbaned_player, current, ROLE_CULTIST, ROLE_CULTIST), 0)
	SSticker.mode.update_cult_icons_added(owner)
	current.throw_alert("bloodsense", /obj/screen/alert/bloodsense)
	current.log_message("<font color=#960000>Has been converted to the cult of Nar'Sie!</font>", INDIVIDUAL_ATTACK_LOG)

/datum/antagonist/cult/apply_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/current = owner.current
	if(mob_override)
		current = mob_override
	current.faction |= "cult"
	current.verbs += /mob/living/proc/cult_help
	if(!GLOB.cult_mastered)
		current.verbs += /mob/living/proc/cult_master
	communion.Grant(current)

/datum/antagonist/cult/remove_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/current = owner.current
	if(mob_override)
		current = mob_override
	current.faction -= "cult"
	current.verbs -= /mob/living/proc/cult_help
	communion.Remove(current)
	owner.current.verbs -= /mob/living/proc/cult_master
	for(var/datum/action/innate/cultmast/H in owner.current.actions)
		qdel(H)
	current.clear_alert("bloodsense")

/datum/antagonist/cult/on_removal()
	owner.wipe_memory()
	SSticker.mode.cult -= owner
	SSticker.mode.update_cult_icons_removed(owner)
	to_chat(owner, "<span class='userdanger'>An unfamiliar white light flashes through your mind, cleansing the taint of the Dark One and all your memories as its servant.</span>")
	owner.current.log_message("<font color=#960000>Has renounced the cult of Nar'Sie!</font>", INDIVIDUAL_ATTACK_LOG)
	if(!silent)
		owner.current.visible_message("<span class='big'>[owner] looks like [owner.current.p_they()] just reverted to their old faith!</span>")
	. = ..()