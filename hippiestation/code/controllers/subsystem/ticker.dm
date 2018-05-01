/datum/controller/subsystem/ticker
	var/login_music_name					// hippie - song name displayed when title theme plays

/datum/controller/subsystem/ticker/Initialize(timeofday)
	..()
	login_music_name = pop(splittext(login_music, "/")) // title name will be last element of the list

/datum/controller/subsystem/ticker/Shutdown()
	if(!round_end_sound)
		round_end_sound = pick(\
		'sound/roundend/newroundsexy.ogg',
		'sound/roundend/apcdestroyed.ogg',
		'sound/roundend/bangindonk.ogg',
		'sound/roundend/leavingtg.ogg',
		'sound/roundend/its_only_game.ogg',
		'sound/roundend/yeehaw.ogg',
		'hippiestation/sound/roundend/disappointed.ogg',
		'hippiestation/sound/roundend/enjoyedyourchaos.ogg',
		'hippiestation/sound/roundend/yamakemesick.ogg',
		'hippiestation/sound/roundend/trapsaregay.ogg',
		'hippiestation/sound/roundend/gayfrogs.ogg',
		'hippiestation/sound/roundend/nitrogen.ogg',
		'hippiestation/sound/roundend/henderson.ogg',
		'hippiestation/sound/roundend/gameoverinsertfourcoinstoplayagain.ogg'\
		)

	world << sound(round_end_sound)
