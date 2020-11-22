//******************************************
//WHEN ADDING NEW MUSIC, ADD THE MUSIC'S NAME TO _globalvars/lists/objects.dm global_music_list and then scroll down to the switch(music_name) part
//Make sure you put it in alphabetical order and also update the switch(music_file) part at the disk burner's attack_hand proc with whatever music you added
//******************************************

/obj/machinery/radio_station
	name = "bluespace radio station"
	desc = "A specially equipped radio station to broadcast music to every radio in a 6 light-year radius. Comes pre-coded with over 30 songs!"
	icon = 'hippiestation/icons/obj/machines/radio_station.dmi'
	icon_state = "radio_station"
	max_integrity = 150
	anchored = TRUE
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 2
	power_channel = AREA_USAGE_EQUIP
	armor = list("melee" = 20, "bullet" = 20, "laser" = 20, "energy" = 20, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 20)
	circuit = /obj/item/circuitboard/machine/radio_station
	light_color = LIGHT_COLOR_GREEN
	var/music_file = "" //File path to the music's audio file
	var/music_name = "" //This is the name of the song, not the file name. This is what shows up at the top of the music selection.
	var/list/music_list //List of music that can be played. Only the most based songs may be added.
	var/cooldowntime
	var/obj/item/record_disk/R //The record disk that's currently playing music
	var/can_eject_disk = 1
	var/ready_to_delete = 0 //For Destroy()
	var/brightness_on = 1

/obj/machinery/radio_station/Initialize()
	..()
	music_list = GLOB.global_music_list
	update_icon()

/obj/machinery/radio_station/attack_hand(mob/living/user)
	..()
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
	if(R)
		if(can_eject_disk)
			update_icon()
			playsound(src, 'hippiestation/sound/effects/plastic_click.ogg', 100, 0)
			R.forceMove(get_turf(src))
			R = null
			stopRadioMusic()
			return
		else
			to_chat(user, "<span class ='warning'>You must wait to eject the record disk!</span>")
			return

	if(stat & NOPOWER || stat & BROKEN)
		update_icon()
		return
	if(cooldowntime > world.time)
		to_chat(user, "<span class ='warning'>The broadcasting antenna needs time to recharge! It will be ready in [DisplayTimeText(cooldowntime - world.time)].</span>")
		return
	var/cooming = input(user, "Last played music: [music_name]", "Available Music") as null|anything in music_list
	if(cooldowntime > world.time)
		to_chat(user, "<span class ='warning'>The broadcasting antenna needs time to recharge! It will be ready in [DisplayTimeText(cooldowntime - world.time)].</span>")
		return
	music_name = cooming //agghggagaghaghah
	playsound(src, piano_sound, 100, 1)
	switch(music_name)
		if(null)
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
		if("X Gon Give It to Ya - DMX")
			music_file = 'hippiestation/sound/radio_songs/XGonGiveItToYa.ogg'
		if("Great Grey Wolf Sif - Dark Souls")
			music_file = 'hippiestation/sound/radio_songs/GreatGreyWolfSif.ogg'


	playMusicToRadios(user)

/obj/machinery/radio_station/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/record_disk))
		if(cooldowntime > world.time)
			to_chat(user, "<span class ='warning'>The broadcasting antenna needs time to recharge! It will be ready in [DisplayTimeText(cooldowntime - world.time)].</span>")
			return
		if(!R)
			R = I
			I.forceMove(src)
			add_overlay("radio_station_disk")
			playsound(src, 'hippiestation/sound/effects/plastic_click.ogg', 100, 0)
			music_file = R.stored_music
			music_name = "CUSTOM"
			playMusicToRadios(user)
		else
			to_chat(user, "<span class='warning'>There is already a record disk in the [src]!</span>")
			return
	..()

/obj/machinery/radio_station/proc/playMusicToRadios(mob/living/user)
	if(stat & NOPOWER || stat & BROKEN)
		update_icon()
		return
	if(cooldowntime > world.time)
		to_chat(user, "<span class ='warning'>The broadcasting antenna needs time to recharge! It will be ready in [DisplayTimeText(cooldowntime - world.time)].</span>")
		return

	var/store_resistance_flags = resistance_flags
	resistance_flags = INDESTRUCTIBLE	//Need to do this so that it can't be destroyed before the music starts playing.

	can_eject_disk = 0
	cooldowntime = world.time + 1000
	var/i
	for(i = 1; i <= GLOB.radio_list.len; i++) //Calls the playmusic() proc for every radio in the game.
		if(!istype(GLOB.radio_list[i], /obj/item/pda)) //Don't want PDAs playing music. They're in this list for other reasons. See PDA.dm
			GLOB.radio_list[i].playmusic(user, music_file, music_name, 100, src)
	audible_message("<span class='robot'><b>[src]</b> beeps, 'Now broadcasting: <i>[music_name]</i>' </span>")

	resistance_flags = store_resistance_flags

	can_eject_disk = 1
	if(stat & NOPOWER || stat & BROKEN) //Need to check again in case the radio station is destroyed while this proc is in progress
		update_icon()
		stopRadioMusic()
		return


/obj/machinery/radio_station/proc/stopRadioMusic()
	var/i
	for(i = 1; i <= GLOB.radio_list.len; i++) //This time it will stop the music for every radio listening to this radio station.
		if(!istype(GLOB.radio_list[i], /obj/item/pda))
			if(GLOB.radio_list[i].linked_RS == src)
				GLOB.radio_list[i].stopmusic(GLOB.radio_list[i].radio_holder, 3)

/obj/machinery/radio_station/Destroy()
	stopRadioMusic()
	..()

/obj/machinery/radio_station/update_icon()
	..()
	cut_overlays()
	if(!(stat & NOPOWER))
		add_overlay("radio_station_on")
		luminosity = 1
		set_light(brightness_on)
		return
	luminosity = 0
	set_light(0)

/obj/machinery/radio_station/power_change()
	. = ..()
	if(stat & NOPOWER)
		set_light(0)
	else
		set_light(brightness_on)

//tshirt cannon

/*One of the staple powers of an admin is now in the hands of a player.
One can only imagine the chaos this will bring when I get this merged.*/
/obj/item/record_disk
	name = "record disk"
	desc = "A disk for storing music. Dear god."
	icon = 'hippiestation/icons/obj/machines/radio_station.dmi'
	icon_state = "record_disk"
	item_state = "record_disk"
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi'
	force = 5
	throwforce = 16
	throw_speed = 2
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("sliced", "DISKED", "played music to")
	siemens_coefficient = 0 //Means it's insulated
	sharpness = IS_SHARP
	resistance_flags = NONE
	max_integrity = 45
	var/stored_music = "blank" //The music file it will play

/obj/item/record_disk/Initialize()
	..()
	name = "\improper[stored_music] record disk"
	pixel_x = rand(-3, 3)
	pixel_y = rand(-3, 3)

/obj/item/record_disk/throw_impact()
	..()
	src.visible_message("<span class ='warning'>The spinning [src] shatters on impact!</span>")
	Destroy()

/obj/item/record_disk/Destroy()
	playsound(src, 'hippiestation/sound/effects/record_shatter.ogg', 100, 0)
	new /obj/item/record_shard(get_turf(src))
	new /obj/item/record_shard(get_turf(src))
	new /obj/item/record_shard(get_turf(src))
	new /obj/item/record_shard(get_turf(src))
	new /obj/item/record_shard(get_turf(src))
	..()

/obj/item/record_shard
	name = "record disk shard"
	desc = "A broken shard of a record disk. Who knew record disks were so fragile."
	icon = 'hippiestation/icons/obj/machines/radio_station.dmi'
	icon_state = "record_shard1"
	w_class = WEIGHT_CLASS_TINY
	force = 5
	throwforce = 8
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	resistance_flags = ACID_PROOF
	armor = list("melee" = 100, "bullet" = 0, "laser" = 0, "energy" = 100, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 100)
	max_integrity = 40
	sharpness = IS_SHARP

/obj/item/record_shard/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is slitting [user.p_their()] [pick("wrists", "throat")] with the record disk shard! It looks like [user.p_theyre()] trying to commit suicide.</span>")
	return (BRUTELOSS)

/obj/item/record_shard/Initialize()
	. = ..()
	AddComponent(/datum/component/caltrop, force)
	AddComponent(/datum/component/butchering, 150, 65)
	icon_state = "record_shard[rand(1, 5)]"
	pixel_x = rand(-8, 8)
	pixel_y = rand(-8, 8)

/obj/item/record_shard/afterattack(atom/A as mob|obj, mob/user, proximity) //Shamelessly ripped from glass shard code
	. = ..()
	if(!proximity || !(src in user))
		return
	if(isturf(A))
		return
	if(istype(A, /obj/item/storage))
		return
	var/hit_hand = ((user.active_hand_index % 2 == 0) ? "r_" : "l_") + "arm"
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.gloves && !HAS_TRAIT(H, TRAIT_PIERCEIMMUNE)) // golems, etc
			to_chat(H, "<span class='warning'>[src] cuts into your hand!</span>")
			H.apply_damage(force*0.5, BRUTE, hit_hand)
	else if(ismonkey(user))
		var/mob/living/carbon/monkey/M = user
		if(!HAS_TRAIT(M, TRAIT_PIERCEIMMUNE))
			to_chat(M, "<span class='warning'>[src] cuts into your hand!</span>")
			M.apply_damage(force*0.5, BRUTE, hit_hand)

/obj/item/record_shard/Crossed(mob/living/L)
	if(istype(L) && has_gravity(loc))
		if(HAS_TRAIT(L, TRAIT_LIGHT_STEP))
			playsound(loc, 'sound/effects/glass_step.ogg', 30, 1)
		else
			playsound(loc, 'sound/effects/glass_step.ogg', 50, 1)
	return ..()

/obj/machinery/recordburner
	name = "record disk burner"
	desc = "Used to burn music onto blank record discs."
	icon = 'hippiestation/icons/obj/machines/radio_station.dmi'
	icon_state = "disk_burner"
	max_integrity = 100
	anchored = TRUE
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 2
	power_channel = AREA_USAGE_EQUIP
	armor = list("melee" = 20, "bullet" = 20, "laser" = 20, "energy" = 20, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 20)
	circuit = /obj/item/circuitboard/machine/recordburner
	light_color = LIGHT_COLOR_YELLOW
	var/list/music_to_burn
	var/obj/item/record_disk/R //Our stored record disk
	var/inuse = FALSE
	var/list/menu_options = list("EJECT", "Burn pre-coded music", "Burn custom music")
	var/music_file
	var/brightness_on = 1

/obj/machinery/recordburner/Initialize()
	..()
	music_to_burn = GLOB.global_music_list
	update_icon()

/obj/machinery/recordburner/attack_hand(mob/living/user)
	if(stat & NOPOWER || stat & BROKEN)
		update_icon()
		return
	if(!R)
		to_chat(user, "<span class='warning'>There is no record disk inserted!</span>")
		return
	if(inuse)
		to_chat(user, "<span class ='warning'>A disk is currently being burned!</span>")
		return
	var/choice = input(user, "Choose an option", "[src] menu") as null|anything in menu_options
	if(inuse)
		to_chat(user, "<span class ='warning'>A disk is currently being burned!</span>")
		return
	switch(choice)
		if(null)
			return
		if("EJECT")
			playsound(src, 'hippiestation/sound/effects/disk_tray.ogg', 100, 0)
			visible_message(src, "<span class ='notice'>[user] ejects the [R] from the [src]!</span>")
			R.forceMove(get_turf(src))
			R = null
		if("Burn pre-coded music")
			music_file = input(user, "Choose a pre-coded song", "[src] menu") as null|anything in music_to_burn
			if(inuse)
				to_chat(user, "<span class ='warning'>A disk is currently being burned!</span>")
				return
			switch(music_file)
				if(null)
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
				if("X Gon Give It to Ya - DMX")
					music_file = 'hippiestation/sound/radio_songs/XGonGiveItToYa.ogg'
				if("Great Grey Wolf Sif - Dark Souls")
					music_file = 'hippiestation/sound/radio_songs/GreatGreyWolfSif.ogg'

			diskProcess()
		if("Burn custom music")
			music_file = input(user, "Choose a custom file!") as null|sound
			if(music_file == null)
				return
			if(inuse)
				to_chat(user, "<span class ='warning'>A disk is currently being burned!</span>")
				return
			diskProcess()

/obj/machinery/recordburner/attackby(obj/item/I, mob/user)
	if(stat & NOPOWER || stat & BROKEN)
		update_icon()
		return
	if(istype(I, /obj/item/record_disk))
		if(!R)
			R = I
			I.forceMove(src)
			playsound(src, 'hippiestation/sound/effects/disk_tray.ogg', 100, 0)
			visible_message(src, "<span class='notice'>[user] loads the [R] into the [src].</span>")
			return
		else
			to_chat(user, "<span class ='warning'>There is already a record disk loaded into the [src]!</span>")
			return
	..()

/obj/machinery/recordburner/update_icon()
	..()
	cut_overlays()
	if(!(stat & NOPOWER))
		add_overlay("disk_burner_on")
		luminosity = 1
		set_light(brightness_on)
		return
	luminosity = 0
	set_light(0)

/obj/machinery/radio_station/power_change()
	. = ..()
	if(stat & NOPOWER)
		set_light(0)
	else
		set_light(brightness_on)

/obj/machinery/recordburner/auto_use_power()
	..()
	update_icon()

/obj/machinery/recordburner/proc/diskProcess()
	addtimer(CALLBACK(src, .proc/burnDisk), 40)
	inuse = TRUE

/obj/machinery/recordburner/proc/burnDisk()
	R.stored_music = music_file
	R.name = "\improper[R.stored_music] record disk"
	playsound(src, 'sound/machines/ping.ogg', 50, 1)
	inuse = FALSE