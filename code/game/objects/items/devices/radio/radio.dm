/obj/item/radio
	icon = 'icons/obj/radio.dmi'
	name = "station bounced radio"
	icon_state = "walkietalkie"
	item_state = "walkietalkie"
	desc = "A basic handheld radio that communicates with local telecommunication networks."
	dog_fashion = /datum/dog_fashion/back

	flags_1 = CONDUCT_1 | HEAR_1
	slot_flags = ITEM_SLOT_BELT
	throw_speed = 3
	throw_range = 7
	w_class = WEIGHT_CLASS_SMALL
	materials = list(MAT_METAL=75, MAT_GLASS=25)
	obj_flags = USES_TGUI

	var/on = TRUE
	var/frequency = FREQ_COMMON
	var/canhear_range = 3  // The range around the radio in which mobs can hear what it receives.
	var/emped = 0  // Tracks the number of EMPs currently stacked.

	var/broadcasting = FALSE  // Whether the radio will transmit dialogue it hears nearby.
	var/listening = TRUE  // Whether the radio is currently receiving.
	var/prison_radio = FALSE  // If true, the transmit wire starts cut.
	var/unscrewed = FALSE  // Whether wires are accessible. Toggleable by screwdrivering.
	var/freerange = FALSE  // If true, the radio has access to the full spectrum.
	var/subspace_transmission = FALSE  // If true, the radio transmits and receives on subspace exclusively.
	var/subspace_switchable = FALSE  // If true, subspace_transmission can be toggled at will.
	var/freqlock = FALSE  // Frequency lock to stop the user from untuning specialist radios.
	var/use_command = FALSE  // If true, broadcasts will be large and BOLD.
	var/command = FALSE  // If true, use_command can be toggled at will.

	// Encryption key handling
	var/obj/item/encryptionkey/keyslot
	var/translate_binary = FALSE  // If true, can hear the special binary channel.
	var/independent = FALSE  // If true, can say/hear on the special CentCom channel.
	var/syndie = FALSE  // If true, hears all well-known channels automatically, and can say/hear on the Syndicate channel.
	var/list/channels = list()  // Map from name (see communications.dm) to on/off. First entry is current department (:h).
	var/list/secure_radio_connections

	var/const/FREQ_LISTENING = 1
	//FREQ_BROADCASTING = 2

	//Hippie
	var/music_channel = null //The sound channel the music is playing on.
	var/radio_music_file = "" //The file path to the music's audio file
	var/music_toggle = 1 //Toggles whether music will play or not.
	var/music_name = "" //Used to display the name of currently playing music.
	var/music_playing = FALSE
	var/radio_station = null //The radio station that is broadcasting to this radio

/obj/item/radio/suicide_act(mob/living/user)
	user.visible_message("<span class='suicide'>[user] starts bouncing [src] off [user.p_their()] head! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return BRUTELOSS

/obj/item/radio/proc/set_frequency(new_frequency)
	SEND_SIGNAL(src, COMSIG_RADIO_NEW_FREQUENCY, args)
	remove_radio(src, frequency)
	frequency = add_radio(src, new_frequency)

/obj/item/radio/proc/recalculateChannels()
	channels = list()
	translate_binary = FALSE
	syndie = FALSE
	independent = FALSE

	if(keyslot)
		for(var/ch_name in keyslot.channels)
			if(!(ch_name in channels))
				channels[ch_name] = keyslot.channels[ch_name]

		if(keyslot.translate_binary)
			translate_binary = TRUE
		if(keyslot.syndie)
			syndie = TRUE
		if(keyslot.independent)
			independent = TRUE

	for(var/ch_name in channels)
		secure_radio_connections[ch_name] = add_radio(src, GLOB.radiochannels[ch_name])

/obj/item/radio/proc/make_syndie() // Turns normal radios into Syndicate radios!
	qdel(keyslot)
	keyslot = new /obj/item/encryptionkey/syndicate
	syndie = 1
	recalculateChannels()

/obj/item/radio/Destroy()
	remove_radio_all(src) //Just to be sure
	QDEL_NULL(wires)
	QDEL_NULL(keyslot)
	GLOB.radio_list -= src //Hippie. Removes from global radio list
	return ..()

/obj/item/radio/Initialize()
	if(!istype(src, /obj/item/radio/intercom)) //Intercoms playing music is useless
		GLOB.radio_list += src //Hippie. Adds the radio to the global radio list for usage in radio_station.dm

	wires = new /datum/wires/radio(src)
	if(prison_radio)
		wires.cut(WIRE_TX) // OH GOD WHY
	secure_radio_connections = new
	. = ..()
	frequency = sanitize_frequency(frequency, freerange)
	set_frequency(frequency)

	for(var/ch_name in channels)
		secure_radio_connections[ch_name] = add_radio(src, GLOB.radiochannels[ch_name])

/obj/item/radio/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/empprotection, EMP_PROTECT_WIRES)

/obj/item/radio/interact(mob/user)
	if(unscrewed && !isAI(user))
		wires.interact(user)
		add_fingerprint(user)
	else
		..()

/obj/item/radio/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, \
										datum/tgui/master_ui = null, datum/ui_state/state = GLOB.inventory_state)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		var/ui_width = 360
		var/ui_height = 106
		if(subspace_transmission)
			if (channels.len > 0)
				ui_height += 6 + channels.len * 21
			else
				ui_height += 24
		ui = new(user, src, ui_key, "radio", name, ui_width, ui_height, master_ui, state)
		ui.open()

/obj/item/radio/ui_data(mob/user)
	var/list/data = list()

	data["broadcasting"] = broadcasting
	data["listening"] = listening
	data["frequency"] = frequency
	data["minFrequency"] = freerange ? MIN_FREE_FREQ : MIN_FREQ
	data["maxFrequency"] = freerange ? MAX_FREE_FREQ : MAX_FREQ
	data["freqlock"] = freqlock
	data["channels"] = list()
	for(var/channel in channels)
		data["channels"][channel] = channels[channel] & FREQ_LISTENING
	data["command"] = command
	data["useCommand"] = use_command
	data["subspace"] = subspace_transmission
	data["subspaceSwitchable"] = subspace_switchable
	data["headset"] = istype(src, /obj/item/radio/headset)

	return data

/obj/item/radio/ui_act(action, params, datum/tgui/ui)
	if(..())
		return
	switch(action)
		if("frequency")
			if(freqlock)
				return
			var/tune = params["tune"]
			var/adjust = text2num(params["adjust"])
			if(tune == "input")
				var/min = format_frequency(freerange ? MIN_FREE_FREQ : MIN_FREQ)
				var/max = format_frequency(freerange ? MAX_FREE_FREQ : MAX_FREQ)
				tune = input("Tune frequency ([min]-[max]):", name, format_frequency(frequency)) as null|num
				if(!isnull(tune) && !..())
					if (tune < MIN_FREE_FREQ && tune <= MAX_FREE_FREQ / 10)
						// allow typing 144.7 to get 1447
						tune *= 10
					. = TRUE
			else if(adjust)
				tune = frequency + adjust * 10
				. = TRUE
			else if(text2num(tune) != null)
				tune = tune * 10
				. = TRUE
			if(.)
				set_frequency(sanitize_frequency(tune, freerange))
		if("listen")
			listening = !listening
			. = TRUE
		if("broadcast")
			broadcasting = !broadcasting
			. = TRUE
		if("channel")
			var/channel = params["channel"]
			if(!(channel in channels))
				return
			if(channels[channel] & FREQ_LISTENING)
				channels[channel] &= ~FREQ_LISTENING
			else
				channels[channel] |= FREQ_LISTENING
			. = TRUE
		if("command")
			use_command = !use_command
			. = TRUE
		if("subspace")
			if(subspace_switchable)
				subspace_transmission = !subspace_transmission
				if(!subspace_transmission)
					channels = list()
				else
					recalculateChannels()
				. = TRUE

/obj/item/radio/talk_into(atom/movable/M, message, channel, list/spans, datum/language/language)
	if(!spans)
		spans = list(M.speech_span)
	if(!language)
		language = M.get_default_language()
	INVOKE_ASYNC(src, .proc/talk_into_impl, M, message, channel, spans.Copy(), language)
	return ITALICS | REDUCE_RANGE

/obj/item/radio/proc/talk_into_impl(atom/movable/M, message, channel, list/spans, datum/language/language)
	if(!on)
		return // the device has to be on
	if(!M || !message)
		return
	if(wires.is_cut(WIRE_TX))  // Permacell and otherwise tampered-with radios
		return
	if(!M.IsVocal())
		return

	if(use_command)
		spans |= SPAN_COMMAND

	/*
	Roughly speaking, radios attempt to make a subspace transmission (which
	is received, processed, and rebroadcast by the telecomms satellite) and
	if that fails, they send a mundane radio transmission.

	Headsets cannot send/receive mundane transmissions, only subspace.
	Syndicate radios can hear transmissions on all well-known frequencies.
	CentCom radios can hear the CentCom frequency no matter what.
	*/

	// From the channel, determine the frequency and get a reference to it.
	var/freq
	if(channel && channels && channels.len > 0)
		if(channel == MODE_DEPARTMENT)
			channel = channels[1]
		freq = secure_radio_connections[channel]
		if (!channels[channel]) // if the channel is turned off, don't broadcast
			return
	else
		freq = frequency
		channel = null

	// Nearby active jammers prevent the message from transmitting
	var/turf/position = get_turf(src)
	for(var/obj/item/jammer/jammer in GLOB.active_jammers)
		var/turf/jammer_turf = get_turf(jammer)
		if(position.z == jammer_turf.z && (get_dist(position, jammer_turf) <= jammer.range))
			return

	// Determine the identity information which will be attached to the signal.
	var/atom/movable/virtualspeaker/speaker = new(null, M, src)

	// Construct the signal
	var/datum/signal/subspace/vocal/signal = new(src, freq, speaker, language, message, spans)

	// Independent radios, on the CentCom frequency, reach all independent radios
	if (independent && (freq == FREQ_CENTCOM || freq == FREQ_CTF_RED || freq == FREQ_CTF_BLUE))
		signal.data["compression"] = 0
		signal.transmission_method = TRANSMISSION_SUPERSPACE
		signal.levels = list(0)  // reaches all Z-levels
		signal.broadcast()
		return

	// All radios make an attempt to use the subspace system first
	signal.send_to_receivers()

	// If the radio is subspace-only, that's all it can do
	if (subspace_transmission)
		return

	// Non-subspace radios will check in a couple of seconds, and if the signal
	// was never received, send a mundane broadcast (no headsets).
	addtimer(CALLBACK(src, .proc/backup_transmission, signal), 20)

/obj/item/radio/proc/backup_transmission(datum/signal/subspace/vocal/signal)
	var/turf/T = get_turf(src)
	if (signal.data["done"] && (T.z in signal.levels))
		return

	// Okay, the signal was never processed, send a mundane broadcast.
	signal.data["compression"] = 0
	signal.transmission_method = TRANSMISSION_RADIO
	signal.levels = list(T.z)
	signal.broadcast()

/obj/item/radio/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode)
	. = ..()
	if(radio_freq || !broadcasting || get_dist(src, speaker) > canhear_range)
		return

	if(message_mode == MODE_WHISPER || message_mode == MODE_WHISPER_CRIT)
		// radios don't pick up whispers very well
		raw_message = stars(raw_message)
	else if(message_mode == MODE_L_HAND || message_mode == MODE_R_HAND)
		// try to avoid being heard double
		if (loc == speaker && ismob(speaker))
			var/mob/M = speaker
			var/idx = M.get_held_index_of_item(src)
			// left hands are odd slots
			if (idx && (idx % 2) == (message_mode == MODE_L_HAND))
				return

	talk_into(speaker, raw_message, , spans, language=message_language)

// Checks if this radio can receive on the given frequency.
/obj/item/radio/proc/can_receive(freq, level)
	// deny checks
	if (!on || !listening || wires.is_cut(WIRE_RX))
		return FALSE
	if (freq == FREQ_SYNDICATE && !syndie)
		return FALSE
	if (freq == FREQ_CENTCOM)
		return independent  // hard-ignores the z-level check
	if (!(0 in level))
		var/turf/position = get_turf(src)
		if(!position || !(position.z in level))
			return FALSE

	// allow checks: are we listening on that frequency?
	if (freq == frequency)
		return TRUE
	for(var/ch_name in channels)
		if(channels[ch_name] & FREQ_LISTENING)
			//the GLOB.radiochannels list is located in communications.dm
			if(GLOB.radiochannels[ch_name] == text2num(freq) || syndie)
				return TRUE
	return FALSE


/obj/item/radio/examine(mob/user)
	. = ..()
	if (frequency && in_range(src, user))
		. += "<span class='notice'>It is set to broadcast over the [frequency/10] frequency.</span>"
	if (unscrewed)
		. += "<span class='notice'>It can be attached and modified.</span>"
	else
		. += "<span class='notice'>It cannot be modified or attached.</span>"
	. += "<span class='info'>Harm intent + alt-click to toggle music."
	if(music_toggle)
		. += "<span class ='notice'>Its music player is currently toggled <b>ON</b>.</span>"
	else
		. += "<span class ='notice'>Its music player is currently toggled <b>OFF</b>.</span>"
	if(item_flags & IN_INVENTORY)
		if(music_toggle)
			if(istype(src, /obj/item/radio/headset))
				if(item_action_slot_check(ITEM_SLOT_EARS, user))
					. += "<span class ='notice'>Currently playing: [music_name] </span>"
			else
				. += "<span class ='notice'>Currently playing: [music_name] </span>"

/obj/item/radio/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)
	if(W.tool_behaviour == TOOL_SCREWDRIVER)
		unscrewed = !unscrewed
		if(unscrewed)
			to_chat(user, "<span class='notice'>The radio can now be attached and modified!</span>")
		else
			to_chat(user, "<span class='notice'>The radio can no longer be modified or attached!</span>")
	else
		return ..()

/obj/item/radio/emp_act(severity, mob/user)
	. = ..()
	if (. & EMP_PROTECT_SELF)
		return
	emped++ //There's been an EMP; better count it
	var/curremp = emped //Remember which EMP this was
	if (listening && ismob(loc))	// if the radio is turned on and on someone's person they notice
		to_chat(loc, "<span class='warning'>\The [src] overloads.</span>")
	broadcasting = FALSE
	listening = FALSE
	music_toggle = 0 //Hippie
	for (var/ch_name in channels)
		channels[ch_name] = 0
	on = FALSE
	stopmusic(user) //Hippie
	spawn(200)
		if(emped == curremp) //Don't fix it if it's been EMP'd again
			emped = 0
			if (!istype(src, /obj/item/radio/intercom)) // intercoms will turn back on on their own
				on = TRUE

/obj/item/radio/AltClick(mob/living/user) //Hippie
	..()
	if(!istype(user) || !Adjacent(user) || user.incapacitated())
		return
	if(user.a_intent == INTENT_HARM)
		if(music_toggle)
			music_toggle = 0
			stopmusic(user, 2)
			to_chat(user, "<span class ='notice'>[src]'s music player is now <b>OFF</b>. </span>")
		else
			music_toggle = 1
			to_chat(user, "<span class ='notice'>[src]'s music player is now <b>ON</b>. </span>")
		return


//Hippie start
/obj/item/radio/proc/playmusic(mob/living/user, music_filepath, channel_number, name_of_music, music_volume, obj/machinery/radio_station/radio_station_thats_playing_music) //Plays music at src using the filepath to the audio file. This proc is directly working with the radio station at radio_station.dm
	radio_music_file = music_filepath
	music_channel = channel_number
	music_name = name_of_music
	if(istype(src.loc, /mob/living))
		user = src.loc
		if(music_toggle == 1) //Music player is on
			if(istype(src, /obj/item/radio/headset))
				if(user.get_item_by_slot(ITEM_SLOT_EARS) == src) //only want headsets to play music if they're equipped
					stopmusic(user) //stop the previously playing song to make way for the new one
					sleep(10)
					user << sound(music_filepath, 0, 0, music_channel, music_volume) //plays the music to the user
					radio_station = radio_station_thats_playing_music
					music_playing = TRUE
					to_chat(user, "<span class='robot'><b>[src]</b> beeps into your ears, 'Now playing: [music_name]' </span>")
					radio_station_thats_playing_music.channel_number += 1 //This is required because each headset needs to have its own channel that music is playing on so that the music can be stopped without stopping other sounds.
					if(radio_station_thats_playing_music.channel_number > 1000)
						radio_station_thats_playing_music.channel_number = 1
			else if(item_flags & IN_INVENTORY) //If radio is in inventory
				stopmusic(user)
				sleep(10)
				user << sound(music_filepath, 0, 0, music_channel, music_volume)
				radio_station = radio_station_thats_playing_music
				music_playing = TRUE
				to_chat(user, "<span class='robot'><b>[src]</b> beeps into your ears, 'Now playing: [music_name]' </span>")
				radio_station_thats_playing_music.channel_number += 1 //This is required because each headset needs to have its own channel that music is playing on so that the music can be stopped without stopping other sounds.
				if(radio_station_thats_playing_music.channel_number > 1000)
					radio_station_thats_playing_music.channel_number = 1

/obj/item/radio/proc/stopmusic(mob/living/user, music_turnoff_message_type)
	if(music_playing)
		user << sound(null, channel = music_channel)
		user << sound('hippiestation/sound/effects/hitmarker.ogg', 0, 0, music_channel, 50)
		music_playing = FALSE
		music_name = ""
		switch(music_turnoff_message_type)
			if(1)
				audible_message("<span class='robot'><b>[src]</b> beeps, '[src] removed, turning off music.' </span>")
			if(2)
				audible_message("<span class='robot'><b>[src]</b> beeps, 'Music toggled off.' </span>")
			if(3)
				audible_message("<span class='robot'><b>[src]</b> beeps, 'Signal interrupted.' </span>")
		music_playing = FALSE

/obj/item/radio/dropped(mob/user)
	..()
	stopmusic(user, 1)

/obj/item/radio/doStrip(mob/user)
	..()
	stopmusic(user, 1)

//Hippie end

///////////////////////////////
//////////Borg Radios//////////
///////////////////////////////
//Giving borgs their own radio to have some more room to work with -Sieve

/obj/item/radio/borg
	name = "cyborg radio"
	subspace_switchable = TRUE
	dog_fashion = null

/obj/item/radio/borg/Initialize(mapload)
	. = ..()

/obj/item/radio/borg/syndicate
	syndie = 1
	keyslot = new /obj/item/encryptionkey/syndicate

/obj/item/radio/borg/syndicate/Initialize()
	. = ..()
	set_frequency(FREQ_SYNDICATE)

/obj/item/radio/borg/attackby(obj/item/W, mob/user, params)

	if(W.tool_behaviour == TOOL_SCREWDRIVER)
		if(keyslot)
			for(var/ch_name in channels)
				SSradio.remove_object(src, GLOB.radiochannels[ch_name])
				secure_radio_connections[ch_name] = null


			if(keyslot)
				var/turf/T = get_turf(user)
				if(T)
					keyslot.forceMove(T)
					keyslot = null

			recalculateChannels()
			to_chat(user, "<span class='notice'>You pop out the encryption key in the radio.</span>")

		else
			to_chat(user, "<span class='warning'>This radio doesn't have any encryption keys!</span>")

	else if(istype(W, /obj/item/encryptionkey/))
		if(keyslot)
			to_chat(user, "<span class='warning'>The radio can't hold another key!</span>")
			return

		if(!keyslot)
			if(!user.transferItemToLoc(W, src))
				return
			keyslot = W

		recalculateChannels()


/obj/item/radio/off	// Station bounced radios, their only difference is spawning with the speakers off, this was made to help the lag.
	listening = 0			// And it's nice to have a subtype too for future features.
	dog_fashion = /datum/dog_fashion/back