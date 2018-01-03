#define NERF_FUN_THINGS 160
#define GRUDGECODE_COOLDOWN 50
#define CHANNEL_GODHATESFUN

// rip guyon's code

/obj/item/twohanded/grudgecoder
	name = "grudgecoder"
	desc = "A /tg/station classic."
	force = 5
	icon_state = "grudge-case"
	icon = 'hippiestation/icons/obj/grudgecoder.dmi'
	lefthand_file = 'hippiestation/icons/mob/inhands/equipment/briefcase_lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/equipment/briefcase_righthand.dmi'
	sharpness = IS_SHARP_ACCURATE
	w_class = WEIGHT_CLASS_NORMAL
	var/w_class_on = WEIGHT_CLASS_BULKY
	force_unwielded = 5
	force_wielded = 16
	hitsound = "swing_hit"
	armour_penetration = 35
	attack_verb = list("busses", "hit", "beats")
	light_color = "#FF0000"//red
	wieldsound = 'sound/weapons/resonator_fire.ogg'
	unwieldsound = 'sound/effects/pop.ogg'
	var/grudgecode_guru
	var/grudgecode_reason
	var/grudgecoding = FALSE
	var/can_grudgecode = TRUE
	var/static/grudgecode_time = 0
	var/brightness_on = 4
	var/godhatesfun_list = list('hippiestation/sound/misc/hellmarch.ogg') //leaving it as a list so if anyone wants to add more sounds they can

/obj/item/twohanded/grudgecoder/New()
    ..()
    grudgecode_guru = pick("/tg/station", "Furry Freedom Force", "The Meowfia", "Badminbus")
    grudgecode_reason = pick("they are lame and gay", "of immersion breaking features", "they wore bunnyslippers", "they're not fun, improve not remove")

/obj/item/twohanded/grudgecoder/attack(mob/living/target, mob/living/user)
	if(user.a_intent != INTENT_HELP || user.zone_selected != "head" || !ishuman(target)) //the grudgecode "helps to balance the game"
		return ..()
	if(!can_grudgecode)
		to_chat(user, "<span class='notice'>The others might catch onto your plans. Slow down!</span>")
		return
	if(grudgecoding)
		to_chat(user, "<span class='notice'>You are already nerfing someone.</span>")
		return
	if(!wielded)
		return ..()
	var/list/grudgecode_limbs = list(target.get_bodypart("l_leg"),target.get_bodypart("r_leg"),target.get_bodypart("l_arm"),target.get_bodypart("r_arm") )
	if(grudgecode_limbs.len < 0 || target.stat == DEAD)
		to_chat(user, "There's no point. They're already useless.")
	else
		grudgecoding = TRUE
		can_grudgecode = FALSE
		var/area/A = get_area(src)
		priority_announce("[user] is attempting to nerf [target] at [A.map_name] in the name of [grudgecode_guru] because [grudgecode_reason]!","A new PR has been uploaded by [grudgecode_guru]!", 'sound/misc/notice1.ogg')
		log_admin("[key_name(user)] attempted to grudgecode [key_name(target)] with [src]")
		message_admins("[key_name(user)] is attempting to grudgecode [key_name(target)] with [src]")
		if(!GLOB.godhatesfun_playing && world.time > grudgecode_time)
			var/godhatesfun_chosen = pick(godhatesfun_list)
			var/sound/godhatesfun = new()
			grudgecode_time = world.time + 200 //20 seconds between each
			godhatesfun.file = godhatesfun_chosen
			godhatesfun.channel = CHANNEL_GODHATESFUN
			godhatesfun.frequency = 1
			godhatesfun.wait = 1
			godhatesfun.repeat = 0
			godhatesfun.status = SOUND_STREAM
			godhatesfun.volume = 100
			for(var/mob/M in GLOB.player_list)
				if(M.client.prefs.toggles & SOUND_MIDI)
					var/user_vol = M.client.chatOutput.adminMusicVolume
					if(user_vol)
						godhatesfun.volume = 100 * (user_vol / 100)
					SEND_SOUND(M, godhatesfun)
					godhatesfun.volume = 100
			GLOB.godhatesfun_playing = TRUE
			addtimer(CALLBACK(src, .proc/godhatesfun_end), NERF_FUN_THINGS)
		if(do_after(user,NERF_FUN_THINGS, target = target))
			log_admin("[key_name(user)] grudgecoded [key_name(target)] with [src]")
			message_admins("[key_name(user)] grudgecoded [key_name(target)] with [src]")
			for(var/obj/item/bodypart/B in grudgecode_limbs)
				B.dismember()
				target.adjustBruteLoss(-100)
				target.set_species(/datum/species/tarajan, icon_update=1)
			priority_announce("[user] has nerfed [target] to uselessness in the name of [grudgecode_guru]!","Message from [grudgecode_guru]!", 'sound/misc/notice1.ogg')
			grudgecoding = FALSE
			addtimer(CALLBACK(src, .proc/recharge_grudgecode), GRUDGECODE_COOLDOWN)
		else
			priority_announce("[user] has failed to ruin fun and [target]! They bring shame to [grudgecode_guru]!","Message from [grudgecode_guru]!", 'sound/misc/compiler-failure.ogg')
			grudgecoding = FALSE
			godhatesfun_end()
			addtimer(CALLBACK(src, .proc/recharge_grudgecode), GRUDGECODE_COOLDOWN)


/obj/item/twohanded/grudgecoder/proc/godhatesfun_end()
	for(var/mob/M in GLOB.player_list)
		M.stop_sound_channel(CHANNEL_GODHATESFUN)
	if(GLOB.godhatesfun_playing)
		GLOB.godhatesfun_playing = FALSE

/obj/item/twohanded/grudgecoder/proc/recharge_grudgecode()
	if(!can_grudgecode)
		can_grudgecode = TRUE

/obj/item/twohanded/grudgecoder/suicide_act(mob/living/user)
	var/obj/item/bodypart/head/the_head = user.get_bodypart("head")
	user.visible_message("<span class='suicide'>[user] is turning the [src] to [user.p_their()] neck! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	if(the_head)
		user.say("This station sucks! FOR [grudgecode_guru]!!")
		priority_announce("[user] has committed suicide in the name of [grudgecode_guru]! It seems they couldn't get their way over here.","Message from [grudgecode_guru]!", 'sound/misc/notice1.ogg')
		the_head.dismember()
		return(BRUTELOSS)
	else
		return(BRUTELOSS)

/obj/item/twohanded/grudgecoder/update_icon()
	if(wielded)
		icon_state = "grudge-case-on"
	else
		icon_state = "grudge-case"
	clean_blood()//blood overlays get weird otherwise, because the sprite changes.

/obj/item/twohanded/grudgecoder/wield(mob/living/carbon/M) //Specific wield () hulk checks due to reflection chance for balance issues and switches hitsounds.
	if(M.has_dna())
		if(M.dna.check_mutation(HULK))
			to_chat(M, "<span class='warning'>You are already an enemy of the grudgecoders!</span>")
			return
	..()
	if(wielded)
		sharpness = IS_SHARP
		w_class = w_class_on
		hitsound = 'hippiestation/sound/weapons/blade2.ogg'
		set_light(brightness_on)

/obj/item/twohanded/grudgecoder/unwield() //Specific unwield () to switch hitsounds.
	sharpness = initial(sharpness)
	w_class = initial(w_class)
	..()
	hitsound = "swing_hit"
	set_light(0)


#undef NERF_FUN_THINGS
#undef GRUDGECODE_COOLDOWN
#undef CHANNEL_GODHATESFUN