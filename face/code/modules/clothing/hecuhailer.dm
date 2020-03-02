// IS NOT READY, DO NOT ENABLE
/obj/item/clothing/mask/gas/face/custom/hecumask // big fuck you to whoever did the sechailer code oh my GOD
	name = "Hazard gas mask"
	desc = "A specalist gas mask with an upgraded'Compli-o-nator 9000' device. Plays whatever you can think of, as long as it's in the unit's memory."
	actions_types = list(/datum/action/item_action/hecuannounce, /datum/action/item_action/announce)
	icon_state = "sechailer"
	item_state = "sechailer"
#ifdef GRU_VOX
#define GRU_DELAY 600

/obj/item/clothing/mask/gas/face/custom/hecumask/ui_action_click(mob/user, action)
	if(istype(action, /datum/action/item_action/hecuannounce))
		announcement_help()
	else
		announcement()

/obj/item/clothing/mask/gas/face/custom/hecumask/verb/announcement_help()

	set name = "Announcement Help"
	set desc = "Display a list of vocal words to announce to the crew."
	set category = "IC"

	if(incapacitated())
		return FALSE

	var/dat = {"
	<font class='bad'>WARNING:</font> Misuse of the announcement system will get you job banned.<BR><BR>
	Here is a list of words you can type into the 'Announcement' button to create sentences to vocally announce to everyone on the same level at you.<BR>
	<UL><LI>You can also click on the word to PREVIEW it.</LI>
	<LI>You can only say 30 words for every announcement.</LI>
	<LI>Do not use punctuation as you would normally, if you want a pause you can use the full stop and comma characters by separating them with spaces, like so: 'Alpha . Test , Bravo'.</LI>
	<LI>Numbers are in word format, e.g. eight, sixty, etc </LI>
	<LI>Sound effects begin with an 's' before the actual word, e.g. scensor</LI>
	<LI>Use Ctrl+F to see if a word exists in the list.</LI></UL><HR>
	"}

	var/index = 0
	for(var/word in GLOB.gru_sounds)
		index++
		dat += "<A href='?src=[REF(src)];say_word=[word]'>[capitalize(word)]</A>"
		if(index != GLOB.gru_sounds.len)
			dat += " / "

	var/datum/browser/popup = new(src, "announce_help", "Announcement Help", 500, 400)
	popup.set_content(dat)
	popup.open()


/obj/item/clothing/mask/gas/face/custom/hecumask/verb/ass()
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

/obj/item/clothing/mask/gas/face/custom/hecumask/proc/announcement()
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
		if(!GLOB.gru_sounds[word])
			incorrect_words += word

	if(incorrect_words.len)
		to_chat(src, "<span class='notice'>These words are not available on the announcement system: [english_list(incorrect_words)].</span>")
		return

	announcing_vox = world.time + GRU_DELAY

	log_game("[key_name(src)] made a vocal announcement with the following message: [message].")

	for(var/word in words)
		play_vox_word(word, src.z, null)


/proc/play_vox_word(word, z_level, mob/only_listener)

	word = lowertext(word)

	if(GLOB.gru_sounds[word])

		var/sound_file = GLOB.gru_sounds[word]
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

#undef GRU_DELAY
#endif
