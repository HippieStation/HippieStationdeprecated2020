/obj/item/guardiancreator
	var/limiteduses = TRUE
	var/killchance = FALSE
	var/useonothers = FALSE
	var/percentchance = 20
	var/cooldown = FALSE
	var/playsound = FALSE
	var/usekey = TRUE
	var/inUse = FALSE
	var/list/holo_black = list(
		/mob/living/simple_animal/revenant,
		/mob/living/simple_animal/hostile/guardian
	)

/obj/item/guardiancreator/attack_self(mob/living/user)
	if(isguardian(user) && !allowguardian)
		to_chat(user, "<span class='holoparasite'>[mob_name] chains are not allowed.</span>")
		return
	var/list/guardians = user.hasparasites()
	if(guardians.len && !allowmultiple)
		to_chat(user, "<span class='holoparasite'>You already have a [mob_name]!</span>")
		return
	if(user.mind && user.mind.has_antag_datum(/datum/antagonist/changeling) && !allowling)
		to_chat(user, "[ling_failure]")
		return
	if(used == TRUE)
		to_chat(user, "[used_message]")
		return
	if(limiteduses == TRUE)
		used = TRUE
	if(killchance == TRUE)
		if(prob(percentchance))
			to_chat(user, "You didn't have enough fighting spirit!")
			user.setToxLoss(100000) //Husks them to stop clone cheeze (not anymore now that it in an event)
			return
	used = TRUE
	to_chat(user, "[use_message]")
	var/list/mob/dead/observer/candidates = pollGhostCandidates("Do you want to play as the [mob_name] of [user.real_name]?", ROLE_PAI, null, FALSE, 100, POLL_IGNORE_HOLOPARASITE)

	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		spawn_guardian(user, C.key)
		if(playsound == TRUE)
			playsound(src.loc, 'hippiestation/sound/misc/standactivated.ogg')
	else
		to_chat(user, "[failure_message]")
		used = FALSE

/obj/item/guardiancreator/attack(mob/M, mob/living/carbon/human/user)
	if(inUse == TRUE)
		return
	if(!M.client)
		return
	to_chat(user, "<span class='notice'>You raise the arrow into the air.</span>")
	user.visible_message("<span class='warning'>[user] prepares to stab [M]!</span>")
	if(do_mob(user,M,50,uninterruptible=0))
		inUse = TRUE
		if(useonothers == TRUE)
			if(isguardian(user) && !allowguardian)
				to_chat(user, "<span class='holoparasite'>[mob_name] chains are not allowed.</span>")
				return
			for(var/bad_mob in holo_black)
				if(istype(M, bad_mob))
					to_chat(user, "<span class='warning'>The arrow rejects the [M]!</span>")
					return

			var/mob/living/L = M
			if(L.mind)
				var/datum/mind/mind = L.mind
				SSblackbox.record_feedback("tally", "stabs", 1, "[mind.key]|[type]")

			for(var/mob/living/simple_animal/hostile/guardian/G in GLOB.alive_mob_list)
				if (G.summoner == L)
					to_chat(L, "You already have a [mob_name]!")
					return
			if(user.mind && user.mind.has_antag_datum(/datum/antagonist/changeling) && !allowling)
				to_chat(user, "[ling_failure]")
				return
			if(used == TRUE)
				to_chat(L, "[used_message]")
				return
			if(limiteduses == TRUE)
				used = TRUE
			if(killchance == TRUE)
				if(prob(percentchance))
					L.visible_message("You didn't have enough fighting spirit!")
					L.setToxLoss(100000) //Husks them to stop clone cheeze (not anymore now that its on mining)
					return
			to_chat(L, "[use_message]")
			var/list/mob/dead/observer/candidates = pollCandidates("Do you want to play as the [mob_name] of [L.real_name]?", "pAI", null, FALSE, 100)
			inUse = FALSE

			if(LAZYLEN(candidates))
				var/mob/dead/observer/C = pick(candidates)
				spawn_guardian(user, C.key)
				if(playsound == TRUE)
					playsound(src.loc, 'hippiestation/sound/misc/standactivated.ogg')
			else
				to_chat(user, "[failure_message]")
				used = FALSE
	else
		return

/obj/item/guardiancreator/standarrow
	name = "Stand Arrow"
	desc = "A mysterious arrow capable of granting great power. Be careful, there is a chance it won't take to you..."
	icon = 'hippiestation/icons/obj/standarrow.dmi'
	icon_state = "standarrowicon"
	item_state = "standarrow"
	slot_flags = SLOT_BELT
	force = 5
	throwforce = 3
	w_class = 3
	attack_verb = list("attacked", "stabbed", "jabbed", "impaled")
	sharpness = IS_SHARP
	theme = "magic"
	mob_name = "Stand"
	use_message = "You stab yourself with the arrow!"
	used_message = "Hang on, how is an arrow used? This shouldn't happen! Submit a bug report!"
	failure_message = "<B>...nothing happened. Maybe you should try again later.</B>"
	limiteduses = FALSE
	playsound = TRUE
	killchance = TRUE
	useonothers = TRUE
	usekey = FALSE
