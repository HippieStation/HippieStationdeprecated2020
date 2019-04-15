/datum/controller/subsystem/ticker
	var/login_music_name					// hippie - song name displayed when title theme plays

/datum/controller/subsystem/ticker/Initialize(timeofday)
	. = ..()
	login_music_name = pop(splittext(login_music, "/")) // title name will be last element of the list

/datum/controller/subsystem/ticker/Shutdown()
	gather_newscaster() //called here so we ensure the log is created even upon admin reboot
	save_admin_data()
	update_everything_flag_in_db()
	if(!round_end_sound)
		round_end_sound = pick(\
		'sound/roundend/newroundsexy.ogg',
		'sound/roundend/apcdestroyed.ogg',
		'sound/roundend/bangindonk.ogg',
		'sound/roundend/its_only_game.ogg',
		'sound/roundend/yeehaw.ogg',
		'hippiestation/sound/roundend/disappointment.ogg',
		'hippiestation/sound/roundend/kleiner.ogg',
		'hippiestation/sound/roundend/cat_bois.ogg',
		'hippiestation/sound/roundend/hitinthemelon.ogg',
		'hippiestation/sound/roundend/gayfrogs.ogg',
		'hippiestation/sound/roundend/nitrogen.ogg',
		'hippiestation/sound/roundend/gameoveryeah.ogg',
		'hippiestation/sound/roundend/gameoverinsertfourcoinstoplayagain.ogg',
		'hippiestation/sound/roundend/reasonsunknown.ogg',
		'hippiestation/sound/roundend/Horn2.ogg',
		'hippiestation/sound/roundend/Metal_Gear_Solid_2_Game_Over_theme.ogg',
		'hippiestation/sound/roundend/The_Price_is_Right_losing_horn.ogg',
		'hippiestation/sound/roundend/Anyone_want_to_RP_with_a_dead_body.ogg',
		'hippiestation/sound/roundend/DEESScohnect.ogg',
		'hippiestation/sound/roundend/wellberightback.ogg',
		'hippiestation/sound/roundend/ugh.ogg',
		'hippiestation/sound/roundend/shitistrash.ogg',
		'hippiestation/sound/roundend/ohshit.ogg',
		'hippiestation/sound/roundend/ohno.ogg',
		'hippiestation/sound/roundend/jontron.ogg',
		'hippiestation/sound/roundend/barney.ogg',
		'hippiestation/sound/roundend/moon.ogg',
		'hippiestation/sound/roundend/Wasted.ogg'\
		)

	SEND_SOUND(world, sound(round_end_sound))
	text2file(login_music, "data/last_round_lobby_music.txt")
