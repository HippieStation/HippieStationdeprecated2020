/datum/mind
	var/no_cloning_at_all = FALSE

/datum/mind/transfer_to(mob/new_character, var/force_key_move = 0)
	if(!QDELETED(current) && !(/mob/living/proc/guardian_comm in new_character.verbs))
		current.verbs -= /mob/living/proc/guardian_comm
		current.verbs -= /mob/living/proc/guardian_recall
		current.verbs -= /mob/living/proc/guardian_reset
	. = ..()
	if(current && current.stat != DEAD)
		var/has_stando = FALSE
		for(var/mob/living/simple_animal/hostile/guardian/jojo in GLOB.parasites)
			if(jojo.summoner == src)
				has_stando = TRUE
				jojo.forceMove(current)
				jojo.revive()
				jojo.RegisterSignal(current, COMSIG_MOVABLE_MOVED, /mob/living/simple_animal/hostile/guardian.proc/OnMoved)
				var/mob/gost = jojo.grab_ghost(TRUE)
				if(gost)
					jojo.ckey = gost.ckey
				to_chat(jojo, "<span class='notice'>You manifest into existence, as your master's soul appears in a new body!</span>")
		if(has_stando)
			current.verbs += /mob/living/proc/guardian_comm
			current.verbs += /mob/living/proc/guardian_recall
			current.verbs += /mob/living/proc/guardian_reset
