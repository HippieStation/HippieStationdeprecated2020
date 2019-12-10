/mob
	var/nextsoundemote = 1

/datum/emote/living/scream
	message = "screams!"
	message_mime = "acts out a scream."
	only_forced_audio = FALSE
	vary = TRUE
	default_keybind = "CtrlS"

/datum/emote/living/scream/get_sound(mob/living/user)
	LAZYINITLIST(user.alternate_screams)
	if(LAZYLEN(user.alternate_screams))
		return pick(user.alternate_screams)
	if(ismonkey(user))
		return 'hippiestation/sound/voice/scream_monkey.ogg'
	if(istype(user, /mob/living/simple_animal/hostile/gorilla))
		return 'sound/creatures/gorilla.ogg'
	if(ishuman(user))
		user.adjustOxyLoss(user.scream_oxyloss)
		if(is_species(user, /datum/species/android) || is_species(user, /datum/species/synth) || is_species(user, /datum/species/ipc))
			return 'hippiestation/sound/voice/scream_silicon.ogg'
		if(is_species(user, /datum/species/lizard))
			return 'hippiestation/sound/voice/scream_lizard.ogg'
		if(is_species(user, /datum/species/skeleton))
			return 'hippiestation/sound/voice/scream_skeleton.ogg'
		if (is_species(user, /datum/species/fly) || is_species(user, /datum/species/moth))
			return 'hippiestation/sound/voice/scream_moth.ogg'
		if (is_species(user, /datum/species/bird))
			return 'hippiestation/sound/voice/caw.ogg'
		if (is_species(user, /datum/species/human/felinid/tarajan))
			return 'hippiestation/sound/voice/cat.ogg'
		if(user.gender == FEMALE)
			return pick('hippiestation/sound/voice/scream_f1.ogg', 'hippiestation/sound/voice/scream_f2.ogg')
		else
			return pick('hippiestation/sound/voice/scream_m1.ogg', 'hippiestation/sound/voice/scream_m2.ogg')
	if(isalien(user))
		return 'sound/voice/hiss6.ogg'
	if(issilicon(user))
		return 'hippiestation/sound/voice/scream_silicon.ogg'

/datum/emote/living/scream/run_emote(mob/living/user, params)
	if(user.nextsoundemote >= world.time)
		return FALSE
	. = ..()
	if (!.)
		return FALSE
	var/miming = user.mind ? user.mind.miming : 0
	if(!user.is_muzzled() && !miming)
		if(ishuman(user))
			user.adjustOxyLoss(user.scream_oxyloss)
		user.nextsoundemote = world.time + 7
		if(iscyborg(user))
			var/mob/living/silicon/robot/S = user
			if(S.cell.charge < 20)
				to_chat(S, "<span class='warning'>Scream module deactivated. Please recharge.</span>")
				return
			S.cell.use(200)

/datum/emote/living/burp/run_emote(mob/living/user, params)
	if(user.nextsoundemote >= world.time)
		return FALSE
	. = ..()
	if (!.)
		return FALSE
	user.nextsoundemote = world.time + 7

/datum/emote/living/burp/get_sound(mob/living/user)
	LAZYINITLIST(user.burp_sounds)
	if (LAZYLEN(user.burp_sounds))
		return pick(user.burp_sounds)

/datum/emote/living/cough/run_emote(mob/living/user, params)
	if(user.nextsoundemote >= world.time)
		return FALSE
	. = ..()
	if (!.)
		return FALSE
	if(ishuman(user))
		user.nextsoundemote = world.time + 7
		user.adjustOxyLoss(5)

/datum/emote/living/cough/get_sound(mob/living/user)
	if(user.gender == FEMALE)
		return pick('hippiestation/sound/voice/cough_f1.ogg', 'hippiestation/sound/voice/cough_f2.ogg', 'hippiestation/sound/voice/cough_f3.ogg')
	else
		return pick('hippiestation/sound/voice/cough1.ogg', 'hippiestation/sound/voice/cough2.ogg', 'hippiestation/sound/voice/cough3.ogg', 'hippiestation/sound/voice/cough4.ogg')

/datum/emote/living/snap
	key = "snap"
	key_third_person = "snaps"
	message = "snaps."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/snap/run_emote(mob/living/user, params)
	if(user.nextsoundemote >= world.time)
		return FALSE
	. = ..()
	if (!.)
		return FALSE
	user.nextsoundemote = world.time + 7

/datum/emote/living/snap/get_sound(mob/living/user)
	return 'hippiestation/sound/voice/snap.ogg'

/datum/emote/living/snap2
	key = "snap2"
	key_third_person = "snaps twice"
	message = "snaps twice."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/snap2/run_emote(mob/living/user, params)
	if(user.nextsoundemote >= world.time)
		return FALSE
	. = ..()
	if (!.)
		return FALSE
	user.nextsoundemote = world.time + 7

/datum/emote/living/snap2/get_sound(mob/living/user)
	return 'hippiestation/sound/voice/snap2.ogg'

/datum/emote/living/snap3
	key = "snap3"
	key_third_person = "snaps thrice"
	message = "snaps thrice."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/snap3/run_emote(mob/living/user, params)
	if(user.nextsoundemote >= world.time)
		return FALSE
	. = ..()
	if (!.)
		return FALSE
	user.nextsoundemote = world.time + 7

/datum/emote/living/snap3/get_sound(mob/living/user)
	return 'hippiestation/sound/voice/snap3.ogg'
