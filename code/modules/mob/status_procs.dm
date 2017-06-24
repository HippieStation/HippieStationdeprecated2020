
//Here are the procs used to modify status effects of a mob.
//The effects include: stun, knockdown, unconscious, sleeping, resting, jitteriness, dizziness, ear damage,
// eye damage, eye_blind, eye_blurry, druggy, BLIND disability, and NEARSIGHT disability.

/////////////////////////////////// STUN ////////////////////////////////////

<<<<<<< HEAD
/mob/proc/Stun(amount, updating = 1, ignore_canstun = 0)
	if(status_flags & CANSTUN || ignore_canstun)
		stun = max(max(stun,amount * STUN_TIME_MULTIPLIER),0) //can't go below 0, getting a low amount of stun doesn't lower your current stun
		if(updating)
			update_canmove()
		return TRUE

/mob/proc/SetStun(amount, updating = 1, ignore_canstun = 0) //if you REALLY need to set stun to a set amount without the whole "can't go below current stun"
	if(status_flags & CANSTUN || ignore_canstun)
		stun = max(amount * STUN_TIME_MULTIPLIER,0)
		if(updating)
			update_canmove()
		return TRUE

/mob/proc/AdjustStun(amount, updating = 1, ignore_canstun = 0)
	if(status_flags & CANSTUN || ignore_canstun)
		stun = max(stun + (amount * STUN_TIME_MULTIPLIER),0)
		if(updating)
			update_canmove()
		return TRUE

/////////////////////////////////// KNOCKDOWN ////////////////////////////////////

/mob/proc/Knockdown(amount, updating = 1, ignore_canknockdown = 0)
	if((status_flags & CANKNOCKDOWN) || ignore_canknockdown)
		knockdown = max(max(knockdown,amount * STUN_TIME_MULTIPLIER),0)
		if(updating)
			update_canmove()	//updates lying, canmove and icons
		return TRUE

/mob/proc/SetKnockdown(amount, updating = 1, ignore_canknockdown = 0)
	if(status_flags & CANKNOCKDOWN || ignore_canknockdown)
		knockdown = max(amount * STUN_TIME_MULTIPLIER,0)
		if(updating)
			update_canmove()	//updates lying, canmove and icons
		return TRUE

/mob/proc/AdjustKnockdown(amount, updating = 1, ignore_canknockdown = 0)
	if((status_flags & CANKNOCKDOWN) || ignore_canknockdown)
		knockdown = max(knockdown + (amount * STUN_TIME_MULTIPLIER) ,0)
		if(updating)
			update_canmove()	//updates lying, canmove and icons
		return TRUE

/////////////////////////////////// UNCONSCIOUS ////////////////////////////////////
=======
/mob/proc/IsStun() //non-living mobs shouldn't be stunned
	return FALSE

/////////////////////////////////// KNOCKDOWN ////////////////////////////////////

/mob/proc/IsKnockdown() //non-living mobs shouldn't be knocked down
	return FALSE

/////////////////////////////////// UNCONSCIOUS ////////////////////////////////////

/mob/proc/IsUnconscious() //non-living mobs shouldn't be unconscious
	return FALSE

/mob/living/IsUnconscious() //If we're unconscious
	return has_status_effect(STATUS_EFFECT_UNCONSCIOUS)

/mob/living/proc/AmountUnconscious() //How many deciseconds remain in our unconsciousness
	var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
	if(U)
		if(U.isprocessing)
			return U.duration - world.time
		else
			return U.duration
	return 0

/mob/living/proc/Unconscious(amount, updating = TRUE, ignore_canunconscious = FALSE) //Can't go below remaining duration
	if((status_flags & CANUNCONSCIOUS) || ignore_canunconscious)
		var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
		if(U)
			if(U.isprocessing)
				U.duration = max(world.time + amount, U.duration)
			else
				U.duration = max(amount, U.duration)
		else if(amount > 0)
			U = apply_status_effect(STATUS_EFFECT_UNCONSCIOUS, updating)
			U.duration = amount
		return U
>>>>>>> deae811756... Unconscious and Knockdown are now status effects (#28696)

/mob/living/proc/SetUnconscious(amount, updating = TRUE, ignore_canunconscious = FALSE) //Sets remaining duration
	if((status_flags & CANUNCONSCIOUS) || ignore_canunconscious)
		var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
		if(amount <= 0)
			if(U)
				U.update_canmove = updating
				qdel(U)
		else if(U)
			if(U.isprocessing)
				U.duration = world.time + amount
			else
				U.duration = amount
		else
			U = apply_status_effect(STATUS_EFFECT_UNCONSCIOUS, updating)
			U.duration = amount
		return U

/mob/living/proc/AdjustUnconscious(amount, updating = TRUE, ignore_canunconscious = FALSE) //Adds to remaining duration
	if((status_flags & CANUNCONSCIOUS) || ignore_canunconscious)
		var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
		if(U)
			U.duration += amount
		else if(amount > 0)
			U = apply_status_effect(STATUS_EFFECT_UNCONSCIOUS, updating)
			U.duration = amount
		return U

/////////////////////////////////// SLEEPING ////////////////////////////////////

/mob/living/proc/IsSleeping() //If we're asleep
	return has_status_effect(STATUS_EFFECT_SLEEPING)

/mob/living/proc/AmountSleeping() //How many deciseconds remain in our sleep
	var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
	if(S)
<<<<<<< HEAD
		return world.time - S.duration
=======
		if(S.isprocessing)
			return S.duration - world.time
		else
			return S.duration
>>>>>>> deae811756... Unconscious and Knockdown are now status effects (#28696)
	return 0

/mob/living/proc/Sleeping(amount, updating = TRUE) //Can't go below remaining duration
	var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
	if(S)
		if(S.isprocessing)
			S.duration = max(world.time + amount, S.duration)
		else
			S.duration = max(amount, S.duration)
	else if(amount > 0)
		S = apply_status_effect(STATUS_EFFECT_SLEEPING, updating)
		S.duration = amount
	return S

/mob/living/proc/SetSleeping(amount, updating = TRUE) //Sets remaining duration
	var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
	if(amount <= 0)
		if(S)
			S.update_canmove = updating
			qdel(S)
<<<<<<< HEAD
	else
		S = apply_status_effect(STATUS_EFFECT_SLEEPING)
	if(S)
=======
	else if(S)
		if(S.isprocessing)
			S.duration = world.time + amount
		else
			S.duration = amount
	else
		S = apply_status_effect(STATUS_EFFECT_SLEEPING, updating)
>>>>>>> deae811756... Unconscious and Knockdown are now status effects (#28696)
		S.duration = amount
	return S

/mob/living/proc/AdjustSleeping(amount, updating = TRUE) //Adds to remaining duration
	var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
	if(S)
		S.duration += amount
	else if(amount > 0)
		S = apply_status_effect(STATUS_EFFECT_SLEEPING, updating)
		S.duration = amount
	return S

/////////////////////////////////// RESTING ////////////////////////////////////

/mob/proc/Resting(amount)
	resting = max(max(resting,amount),0)
	update_canmove()

/mob/proc/SetResting(amount)
	resting = max(amount,0)
	update_canmove()

/mob/proc/AdjustResting(amount)
	resting = max(resting + amount,0)
	update_canmove()

/////////////////////////////////// JITTERINESS ////////////////////////////////////

/mob/proc/Jitter(amount)
	jitteriness = max(jitteriness,amount,0)

/////////////////////////////////// DIZZINESS ////////////////////////////////////

/mob/proc/Dizzy(amount)
	dizziness = max(dizziness,amount,0)

/////////////////////////////////// EYE DAMAGE ////////////////////////////////////

/mob/proc/damage_eyes(amount)
	return

/mob/proc/adjust_eye_damage(amount)
	return

/mob/proc/set_eye_damage(amount)
	return

/////////////////////////////////// EYE_BLIND ////////////////////////////////////

/mob/proc/blind_eyes(amount)
	if(amount>0)
		var/old_eye_blind = eye_blind
		eye_blind = max(eye_blind, amount)
		if(!old_eye_blind)
			if(stat == CONSCIOUS)
				throw_alert("blind", /obj/screen/alert/blind)
			overlay_fullscreen("blind", /obj/screen/fullscreen/blind)

/mob/proc/adjust_blindness(amount)
	if(amount>0)
		var/old_eye_blind = eye_blind
		eye_blind += amount
		if(!old_eye_blind)
			if(stat == CONSCIOUS)
				throw_alert("blind", /obj/screen/alert/blind)
			overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
	else if(eye_blind)
		var/blind_minimum = 0
		if(stat != CONSCIOUS || (disabilities & BLIND))
			blind_minimum = 1
		eye_blind = max(eye_blind+amount, blind_minimum)
		if(!eye_blind)
			clear_alert("blind")
			clear_fullscreen("blind")

/mob/proc/set_blindness(amount)
	if(amount>0)
		var/old_eye_blind = eye_blind
		eye_blind = amount
		if(client && !old_eye_blind)
			if(stat == CONSCIOUS)
				throw_alert("blind", /obj/screen/alert/blind)
			overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
	else if(eye_blind)
		var/blind_minimum = 0
		if(stat != CONSCIOUS || (disabilities & BLIND))
			blind_minimum = 1
		eye_blind = blind_minimum
		if(!eye_blind)
			clear_alert("blind")
			clear_fullscreen("blind")

/////////////////////////////////// EYE_BLURRY ////////////////////////////////////

/mob/proc/blur_eyes(amount)
	if(amount>0)
		var/old_eye_blurry = eye_blurry
		eye_blurry = max(amount, eye_blurry)
		if(!old_eye_blurry)
			overlay_fullscreen("blurry", /obj/screen/fullscreen/blurry)

/mob/proc/adjust_blurriness(amount)
	var/old_eye_blurry = eye_blurry
	eye_blurry = max(eye_blurry+amount, 0)
	if(amount>0)
		if(!old_eye_blurry)
			overlay_fullscreen("blurry", /obj/screen/fullscreen/blurry)
	else if(old_eye_blurry && !eye_blurry)
		clear_fullscreen("blurry")

/mob/proc/set_blurriness(amount)
	var/old_eye_blurry = eye_blurry
	eye_blurry = max(amount, 0)
	if(amount>0)
		if(!old_eye_blurry)
			overlay_fullscreen("blurry", /obj/screen/fullscreen/blurry)
	else if(old_eye_blurry)
		clear_fullscreen("blurry")

/////////////////////////////////// DRUGGY ////////////////////////////////////

/mob/proc/adjust_drugginess(amount)
	return

/mob/proc/set_drugginess(amount)
	return

/////////////////////////////////// BLIND DISABILITY ////////////////////////////////////

/mob/proc/cure_blind() //when we want to cure the BLIND disability only.
	return

/mob/proc/become_blind()
	return

/////////////////////////////////// NEARSIGHT DISABILITY ////////////////////////////////////

/mob/proc/cure_nearsighted()
	return

/mob/proc/become_nearsighted()
	return


//////////////////////////////// HUSK DISABILITY ///////////////////////////:

/mob/proc/cure_husk()
	return

/mob/proc/become_husk()
	return







