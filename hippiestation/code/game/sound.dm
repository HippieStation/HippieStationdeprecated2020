/client/playtitlemusic(vol = 85)
	..()
	if(prefs && (prefs.toggles & SOUND_LOBBY))
		to_chat(src, "<i>Now playing:</i> <b>[SSticker.login_music_name]</b>.")