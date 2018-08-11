SUBSYSTEM_DEF(tts)
	name = "Text-to-Speech"
	wait = 2
	runlevels = (RUNLEVEL_INIT | RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME )
	var/list/queue           // List of items to process
	var/datum/tts/processing // The item we're currentl processing

/datum/tts
	var/client/owner
	var/text = ""
	var/voice = ""
	var/filename = ""
	var/is_global = FALSE
	var/timeout = 10 // file shouldn't take longer than 1 second to process, delete after this much time has passed

/datum/tts/proc/Initialize()
	. = ..()

/datum/tts/proc/say(client/C, msg, voice = "", is_global = FALSE)
	if (!C)
		return
	if (!msg)
		return
	owner = C
	text = msg
	src.voice = voice
	src.is_global = is_global

	LAZYADD(SStts.queue, src)

/datum/controller/subsystem/tts/Initialize()
	LAZYINITLIST(queue)

	if (!CONFIG_GET(flag/enable_tts))
		can_fire = FALSE
	return ..()

/datum/controller/subsystem/tts/proc/check_queue(client/C)
	if (!C)
		return FALSE

	for (var/datum/tts/T in queue)
		if (T)
			if (T.owner == C)
				return TRUE

	return FALSE

/datum/controller/subsystem/tts/fire(resumed = FALSE)
	if (processing)
		if (!processing.owner)
			message_admins("TTS request has no owner (on check)")
			processing = null
			return

		// file not ready
		if (!fexists(processing.filename))
			if (world.time > processing.timeout)
				message_admins("[processing.owner]'s TTS request timed out!")
				processing = null
			return

		for (var/P in GLOB.player_list)
			var/mob/M = P
			if (!M)
				continue
			var/client/C = M.client
			if (!C)
				continue
			if (C.prefs.toggles & SOUND_MIDI)
				var/turf/origin

				if (processing.is_global)
					origin = M.loc
				else
					origin = processing.owner.mob.loc

				M.playsound_local(origin, processing.filename, 100, 0)

		// delete the file once we play it
		if (fexists(processing.filename))
			fdel(processing.filename)
		processing = null
	else
		// nothing is currently being processed, take first item from the queue
		if (LAZYLEN(queue) > 0)
			processing = popleft(queue)
		else
			return // nothing to process and nothing queued

		if (!processing)
			message_admins("Error picked TTS request")
			return

		if (!processing.owner)
			message_admins("TTS request has no owner (on pick)")
			processing = null
			return
		else
			processing.owner.tts_cooldown = world.time + length(processing.text)

		processing.timeout = processing.timeout + world.time
		var/cmd = "tts_generator/tts_generator.exe"
		cmd = cmd + " --text \"[processing.text]\""

		if (processing.voice)
			cmd = cmd + " --voice \"[processing.voice]\""
		shell(cmd)
		processing.filename = "tts_generator/speech.ogg"

/client
	var/tts_cooldown = 0

/datum/dna
	var/tts_voice = ""

/datum/dna/initialize_dna()
	. = ..()
	var/mob/living/carbon/human/H = holder
	if (istype(H))
		if (H.gender == FEMALE)
			tts_voice = pick("betty", "rita", "ursula", "wendy")
		else
			tts_voice = pick("dennis", "frank", "harry", "kit", "paul")

/datum/dna/transfer_identity(mob/living/carbon/destination)
	..()
	if (!istype(destination))
		return
	destination.dna.tts_voice = tts_voice

/datum/dna/copy_dna(datum/dna/new_dna)
	..()
	new_dna.tts_voice = tts_voice

/mob/living/carbon/human/say(message, datum/language/language = null)
	. = ..()

	if (.)
		var/msg = message
		var/first_char = copytext(message, 1, 2)
		if (first_char == "*" && first_char == ";" && first_char == "." && first_char == ":")
			msg = copytext(msg, 2, length(msg) - 1)

		if (CONFIG_GET(flag/enable_tts) && client)
			var/tts_voice = ""

			if (dna)
				if (dna.tts_voice)
					tts_voice = dna.tts_voice

			if (world.time > client.tts_cooldown && !SStts.check_queue(src))
				var/datum/tts/T = new /datum/tts()
				T.say(client, msg, voice = tts_voice)

/client/proc/play_tts()
	set category = "Fun"
	set name = "Play TTS"
	if(!check_rights(R_SOUNDS))
		return
	if (!CONFIG_GET(flag/enable_tts))
		to_chat(usr, "<span='warning'>Text-to-Speech is not enabled!</span>")
		return

	var/input = input(usr, "Please enter a message to send to the server", "Text to Speech", "")
	if(input)
		var/datum/tts/T = new /datum/tts()
		T.say(src, input, is_global=TRUE)
		
		to_chat(world, "<span class='boldannounce'>An admin used Text-to-Speech: [input]</span>")
		log_admin("[key_name(src)] used Text-to-Speech: [input]")
		message_admins("[key_name_admin(src)] used Text-to-Speech: [input]")

		SSblackbox.record_feedback("tally", "admin_verb", 1, "Play TTS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/add_admin_verbs()
	. = ..()
	if (holder)
		var/rights = holder.rank.rights
		if(rights & R_SOUNDS)
			if(CONFIG_GET(flag/enable_tts))
				verbs += /client/proc/play_tts

/client/remove_admin_verbs()
	. = ..()
	verbs.Remove(/client/proc/play_tts)