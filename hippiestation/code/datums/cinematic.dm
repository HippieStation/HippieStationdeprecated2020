/datum/cinematic/thanos
	id = CINEMATIC_THANOS

/datum/cinematic/thanos/content()
	screen.icon = 'hippiestation/icons/effects/station_explosion.dmi'
	flick("intro_thanosnuke",screen)
	sleep(1.5 SECONDS)
	cinematic_sound(sound('hippiestation/sound/effects/SNAP.ogg'))
	sleep(4 SECONDS)
	cinematic_sound(sound('hippiestation/sound/misc/theend.ogg'))
	screen.icon = 'icons/effects/station_explosion.dmi'
	screen.icon_state = "station_intact"
	sleep(30 SECONDS)
	special()
