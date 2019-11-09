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

/datum/cinematic/gang
	id = CINEMATIC_GANG

/datum/cinematic/malf/content()
	flick("intro_malf",screen)
	special()
	screen.icon_state = "intro_malf_still"
