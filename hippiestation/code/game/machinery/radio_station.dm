/obj/machinery/radio_station
	name = "bluespace radio station"
	desc = "A specially equipped radio station to broadcast music to every radio in a 6 light-year radius. Comes pre-coded with over 30 songs!"
	icon = 'hippiestation/icons/obj/machines/radio_station.dmi'
	icon_state = "radio_station"
	max_integrity = 200
	anchored = TRUE
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 2
	armor = list("melee" = 20, "bullet" = 20, "laser" = 20, "energy" = 20, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 20)
	circuit = /obj/item/circuitboard/machine/radio_station
	layer = ABOVE_OBJ_LAYER
	var/music_file = "" //File path to the music's audio file
	var/music_name = "" //This is the name of the song, not the file name. This is what shows up at the top of the music selection.
	var/music_list = list(
							"Ace of La Boots - Streets of Rogue",
							"Aftermath 2 (Siegius) - Waterflame",
							"Amish Paradise - Weird Al",
							"Asian People Song - Z-FLO",
							"Ayy lmao - NegusOfBrazil",
							"Brass Monkey - Bestie Boys",
							"Carribean Queen - Billy Ocean",
							"Chow Mein - Mafia 2",
							"Clown",
							"Crank That - Soulja Boy",
							"Dark Skies - Castle Crashers",
							"Divine Power - Army of Ages",
							"Doom Theme - DOOM",
							"Dschinghis Khan - Moskau",
							"El Muslimeen - Muslims",
							"Eye of the Spider - Itsoo1",
							"Fabulous Secret Powers - SLACKCiRCUS",
							"Gangnam Style",
							"Ghost Whip - LEGO Ninjago: Masters of Spinjitzu",
							"Ice Ice Baby - Vanilla Ice",
							"Jelly Fish Jam - Spongebob Squarepants",
							"Listy Colon - Scribblenauts Unlimited",
							"MACHO MADNESS FOREVER - Mike Diva",
							"Mr. Snortobeat - STBlackST",
							"Muffin Song - asdfmovie",
							"Nations of the World Song - Animaniacs",
							"Pickle Rick - Yuri Wong",
							"Poopsy Slime Surprise",
							"Silverfish Swing - Slamacow",
							"Slipsand Galaxy - Super Mario Galaxy 2",
							"Space Station 13",
							"You Are a Pirate - Lazytown"
							) //List of music that can be played. Only the most based songs may be added.
	var/channel_number = 1
	var/cooldowntime
	var/inuse = FALSE

/obj/machinery/radio_station/attack_hand(mob/living/user)
	. = ..()
	var/piano_sound = pick(
							'sound/instruments/piano/Ab2.ogg',
							'sound/instruments/piano/Ab3.ogg',
							'sound/instruments/piano/Ab4.ogg',
							'sound/instruments/piano/Ab5.ogg',
							'sound/instruments/piano/Ab6.ogg',
							'sound/instruments/piano/Ab7.ogg',
							'sound/instruments/piano/Ab8.ogg',

							'sound/instruments/piano/An1.ogg',
							'sound/instruments/piano/An2.ogg',
							'sound/instruments/piano/An3.ogg',
							'sound/instruments/piano/An4.ogg',
							'sound/instruments/piano/An5.ogg',
							'sound/instruments/piano/An6.ogg',
							'sound/instruments/piano/An7.ogg',
							'sound/instruments/piano/An8.ogg',

							'sound/instruments/piano/Bb1.ogg',
							'sound/instruments/piano/Bb2.ogg',
							'sound/instruments/piano/Bb3.ogg',
							'sound/instruments/piano/Bb4.ogg',
							'sound/instruments/piano/Bb5.ogg',
							'sound/instruments/piano/Bb6.ogg',
							'sound/instruments/piano/Bb7.ogg',
							'sound/instruments/piano/Bb8.ogg',

							'sound/instruments/piano/Bn1.ogg',
							'sound/instruments/piano/Bn2.ogg',
							'sound/instruments/piano/Bn3.ogg',
							'sound/instruments/piano/Bn4.ogg',
							'sound/instruments/piano/Bn5.ogg',
							'sound/instruments/piano/Bn6.ogg',
							'sound/instruments/piano/Bn7.ogg',
							'sound/instruments/piano/Bn8.ogg',

							'sound/instruments/piano/Cn2.ogg',
							'sound/instruments/piano/Cn3.ogg',
							'sound/instruments/piano/Cn4.ogg',
							'sound/instruments/piano/Cn5.ogg',
							'sound/instruments/piano/Cn6.ogg',
							'sound/instruments/piano/Cn7.ogg',
							'sound/instruments/piano/Cn8.ogg',
							'sound/instruments/piano/Cn9.ogg',

							'sound/instruments/piano/Db2.ogg',
							'sound/instruments/piano/Db3.ogg',
							'sound/instruments/piano/Db4.ogg',
							'sound/instruments/piano/Db5.ogg',
							'sound/instruments/piano/Db6.ogg',
							'sound/instruments/piano/Db7.ogg',
							'sound/instruments/piano/Db8.ogg',

							'sound/instruments/piano/Dn2.ogg',
							'sound/instruments/piano/Dn3.ogg',
							'sound/instruments/piano/Dn4.ogg',
							'sound/instruments/piano/Dn5.ogg',
							'sound/instruments/piano/Dn6.ogg',
							'sound/instruments/piano/Dn7.ogg',
							'sound/instruments/piano/Dn8.ogg',

							'sound/instruments/piano/Eb2.ogg',
							'sound/instruments/piano/Eb3.ogg',
							'sound/instruments/piano/Eb4.ogg',
							'sound/instruments/piano/Eb5.ogg',
							'sound/instruments/piano/Eb6.ogg',
							'sound/instruments/piano/Eb7.ogg',
							'sound/instruments/piano/Eb8.ogg',

							'sound/instruments/piano/En2.ogg',
							'sound/instruments/piano/En3.ogg',
							'sound/instruments/piano/En4.ogg',
							'sound/instruments/piano/En5.ogg',
							'sound/instruments/piano/En6.ogg',
							'sound/instruments/piano/En7.ogg',
							'sound/instruments/piano/En8.ogg',

							'sound/instruments/piano/Fn2.ogg',
							'sound/instruments/piano/Fn3.ogg',
							'sound/instruments/piano/Fn4.ogg',
							'sound/instruments/piano/Fn5.ogg',
							'sound/instruments/piano/Fn6.ogg',
							'sound/instruments/piano/Fn7.ogg',
							'sound/instruments/piano/Fn8.ogg',

							'sound/instruments/piano/Gb2.ogg',
							'sound/instruments/piano/Gb3.ogg',
							'sound/instruments/piano/Gb4.ogg',
							'sound/instruments/piano/Gb5.ogg',
							'sound/instruments/piano/Gb6.ogg',
							'sound/instruments/piano/Gb7.ogg',
							'sound/instruments/piano/Gb8.ogg',

							'sound/instruments/piano/Gn2.ogg',
							'sound/instruments/piano/Gn3.ogg',
							'sound/instruments/piano/Gn4.ogg',
							'sound/instruments/piano/Gn5.ogg',
							'sound/instruments/piano/Gn6.ogg',
							'sound/instruments/piano/Gn7.ogg',
							'sound/instruments/piano/Gn8.ogg')
	playsound(src, piano_sound, 100, 1)
	if(stat & NOPOWER || stat & BROKEN)
		update_icon()
		return
	if(cooldowntime > world.time)
		to_chat(user, "<span class ='warning'>The broadcasting antenna needs time to recharge! It will be ready in [DisplayTimeText(cooldowntime - world.time)].</span>")
		return
	if(inuse)
		to_chat(user, "<span class = 'warning'>The [src] is currently in use!</span>")
		return
	inuse = TRUE
	var/cooming = input(user, "Last played music: [music_name]", "Available Music") as null|anything in music_list
	music_name = cooming //agghggagaghaghah
	playsound(src, piano_sound, 100, 1)
	switch(music_name)
		if(null)
			inuse = FALSE
			return
		if("Amish Paradise - Weird Al")
			music_file = 'hippiestation/sound/radio_songs/AmishParadise.ogg'
		if("Fabulous Secret Powers - SLACKCiRCUS")
			music_file = 'hippiestation/sound/radio_songs/AndISayHey.ogg'
		if("Divine Power - Army of Ages")
			music_file = 'hippiestation/sound/radio_songs/AoADivinePower.ogg'
		if("Asian People Song - Z-FLO")
			music_file = 'hippiestation/sound/radio_songs/AsianPeopleSong.ogg'
		if("Ayy lmao - NegusOfBrazil")
			music_file = 'hippiestation/sound/radio_songs/AyyLmao.ogg'
		if("Brass Monkey - Bestie Boys")
			music_file = 'hippiestation/sound/radio_songs/BrassMonkey.ogg'
		if("Clown")
			music_file = 'hippiestation/sound/radio_songs/Clown.ogg'
		if("Crank That - Soulja Boy")
			music_file = 'hippiestation/sound/radio_songs/CrankThat.ogg'
		if("Dark Skies - Castle Crashers")
			music_file = 'hippiestation/sound/radio_songs/DarkSkies.ogg'
		if("Doom Theme - DOOM")
			music_file = 'hippiestation/sound/radio_songs/DoomTheme.ogg'
		if("Ice Ice Baby - Vanilla Ice")
			music_file = 'hippiestation/sound/radio_songs/IceIceBaby.ogg'
		if("Jelly Fish Jam - Spongebob Squarepants")
			music_file = 'hippiestation/sound/radio_songs/JellyfishJam.ogg'
		if("MACHO MADNESS FOREVER - Mike Diva")
			music_file = 'hippiestation/sound/radio_songs/MACHOMADNESS.ogg'
		if("Chow Mein - Mafia 2")
			music_file = 'hippiestation/sound/radio_songs/Mafia2ChowMein.ogg'
		if("Mr. Snortobeat - STBlackST")
			music_file = 'hippiestation/sound/radio_songs/MrSnortobeat.ogg'
		if("Muffin Song - asdfmovie")
			music_file = 'hippiestation/sound/radio_songs/MuffinSong.ogg'
		if("El Muslimeen - Muslims")
			music_file = 'hippiestation/sound/radio_songs/Muslimeen.ogg'
		if("Nations of the World Song - Animaniacs")
			music_file = 'hippiestation/sound/radio_songs/NationsOfTheWorld.ogg'
		if("Carribean Queen - Billy Ocean")
			music_file = 'hippiestation/sound/radio_songs/NoMoreLoveOnTheRun.ogg'
		if("Pickle Rick - Yuri Wong")
			music_file = 'hippiestation/sound/radio_songs/PickleRick.ogg'
		if("Poopsy Slime Surprise")
			music_file = 'hippiestation/sound/radio_songs/PoopsySlimeSurprise.ogg'
		if("Aftermath 2 (Siegius) - Waterflame")
			music_file = 'hippiestation/sound/radio_songs/SiegiusAftermath2.ogg'
		if("Silverfish Swing - Slamacow")
			music_file = 'hippiestation/sound/radio_songs/SlamacowSilverfishSwing.ogg'
		if("Space Station 13")
			music_file = 'hippiestation/sound/radio_songs/TrueSS13Theme.ogg'
		if("Listy Colon - Scribblenauts Unlimited")
			music_file = 'hippiestation/sound/radio_songs/ListyColon.ogg'
		if("Ace of La Boots - Streets of Rogue")
			music_file = 'hippiestation/sound/radio_songs/AceOfLaBoots.ogg'
		if("Dschinghis Khan - Moskau")
			music_file = 'hippiestation/sound/radio_songs/Moskau.ogg'
		if("Gangnam Style")
			music_file = 'hippiestation/sound/radio_songs/GangnamStyle.ogg'
		if("Ghost Whip - LEGO Ninjago: Masters of Spinjitzu")
			music_file = 'hippiestation/sound/radio_songs/GhostWhip.ogg'
		if("You Are a Pirate - Lazytown")
			music_file = 'hippiestation/sound/radio_songs/YouAreAPirate.ogg'
		if("Eye of the Spider - Itsoo1")
			music_file = 'hippiestation/sound/radio_songs/EyeOfTheSpider.ogg'
		if("Slipsand Galaxy - Super Mario Galaxy 2")
			music_file = 'hippiestation/sound/radio_songs/SlipsandGalaxy.ogg'

	inuse = FALSE
	var/i
	for(i = 1; i <= GLOB.radio_list.len; i++) //Calls the playmusic() proc for every radio in the game.
		GLOB.radio_list[i].playmusic(user, music_file, channel_number, music_name, 100, src)

	audible_message("<span class='robot'><b>[src]</b> beeps, 'Now broadcasting: [music_name]' </span>")
	cooldowntime = world.time + 600

/obj/machinery/radio_station/Destroy()
	. = ..()
	var/i
	for(i = 1; i <= GLOB.radio_list.len; i++) //This time it will stop the music for every radio listening to this radio station.
		if(GLOB.radio_list[i].radio_station == src)
			GLOB.radio_list[i].stopmusic(GLOB.radio_list[i].loc, 3)

//Make music requester

//Add emag function to the radio station
//Make ipod as traitor item
//Records to be played in PDAs

/obj/machinery/recordburner
	name = "Record disc burner"
	desc = "Used to burn music onto blank record discs."
	icon = 'hippiestation/icons/obj/machines/radio_station.dmi'
	icon_state = "radio_station"
	max_integrity = 200
	anchored = TRUE
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 2
	armor = list("melee" = 20, "bullet" = 20, "laser" = 20, "energy" = 20, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 20)