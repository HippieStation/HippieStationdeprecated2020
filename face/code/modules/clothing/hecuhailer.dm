/obj/item/clothing/mask/gas/face/custom/hecumask
	name = "Hazard gas mask"
	desc = "A specalist gas mask with an upgraded'Compli-o-nator 9000' device. Plays whatever you can think of, as long as it's in the unit's memory."
	actions_types = list(/datum/action/item_action/halt, /datum/action/item_action/adjust)
	icon_state = "sechailer"
	item_state = "sechailer"
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_inv = HIDEFACIALHAIR|HIDEFACE
	w_class = WEIGHT_CLASS_SMALL
	visor_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	visor_flags_inv = HIDEFACE
	flags_cover = MASKCOVERSMOUTH
	visor_flags_cover = MASKCOVERSMOUTH
	var/aggressiveness = 2
	var/cooldown_special
	var/recent_uses = 0
	var/broken_hailer = 0
	var/safety = TRUE


/obj/item/clothing/mask/gas/sechailer/verb/ass()
	set category = "Object"
	set name = "Announcement"
	set src in usr
	if(!isliving(usr))
		return
	if(!can_use(usr))
		return
	if(broken_hailer)
		to_chat(usr, "<span class='warning'>\The [src]'s hailing system is broken.</span>")
		return


	var/static/announcing_vox = 0 // Stores the time of the last announcement
	if(announcing_vox > world.time)
		to_chat(src, "<span class='notice'>Please wait [DisplayTimeText(announcing_vox - world.time)].</span>")
		return

	var/message = input(src, "Please keep in mind this is the Half life 1 GRUNT VOX. You'll have to experiment to see what sticks.", "Announcement", src.last_announcement) as text

	last_announcement = message

	if(!message || announcing_vox > world.time)
		return

	if(incapacitated())
		return


	var/list/words = splittext(trim(message), " ")
	var/list/incorrect_words = list()

	if(words.len > 30)
		words.len = 30

	for(var/word in words)
		word = lowertext(trim(word))
		if(!word)
			words -= word
			continue
		if(!GLOB.vox_sounds[word])
			incorrect_words += word

	if(incorrect_words.len)
		to_chat(src, "<span class='notice'>These words are not available on the announcement system: [english_list(incorrect_words)].</span>")
		return

	announcing_vox = world.time + VOX_DELAY

	log_game("[key_name(src)] made a vocal announcement with the following message: [message].")

	for(var/word in words)
		play_vox_word(word, src.z, null)


/proc/play_vox_word(word, z_level, mob/only_listener)

	word = lowertext(word)

	if(GLOB.vox_sounds[word])

		var/sound_file = GLOB.vox_sounds[word]
		var/sound/voice = sound(sound_file, wait = 1, channel = CHANNEL_VOX)
		voice.status = SOUND_STREAM

 		// If there is no single listener, broadcast to everyone in the same z level
		if(!only_listener)
			// Play voice for all mobs in the z level
			for(var/mob/M in GLOB.player_list)
				if(M.client && M.can_hear() && (M.client.prefs.hippie_toggles & SOUND_VOX)) // hippie -- make AI VOX it's own setting
					var/turf/T = get_turf(M)
					if(T.z == z_level)
						SEND_SOUND(M, voice)
		else
			SEND_SOUND(only_listener, voice)
		return 1
	return 0



		usr.audible_message("[usr]'s Compli-o-Nator: <font color='red' size='4'><b>[message]</b></font>")
		playsound(src.loc, "sound/voice/complionator/[phrase_sound].ogg", 100, 0, 4)
		cooldown = world.time
		cooldown_special = world.time
