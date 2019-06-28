/mob/living/carbon/human
	var/times_disarmed = 0
	var/disarm_cooldown = 0

/datum/species
	var/hurt_sound_cd = 0
	attack_sound = 'hippiestation/sound/weapons/punch1.ogg'
	miss_sound = 'hippiestation/sound/weapons/punchmiss.ogg'

/datum/species/proc/queue_hurt_sound(mob/living/carbon/human/H)
	if (hurt_sound_cd > world.time)
		return

	if (H.stat)
		return

	if (H.is_muzzled())
		return

	if (H.mind)
		if (H.mind.miming)
			return

	hurt_sound_cd = world.time + 30
	addtimer(CALLBACK(src, .proc/play_hurt_sound, H), 5)


/datum/species/proc/play_hurt_sound(mob/living/carbon/human/H)
	// The sound frequency is set to 11,025 and I want to vary it by 25% both ways
	playsound(H, "male_hurt", 75, 1, frequency = rand(11025*0.75, 11025*1.25))

/datum/species/proc/disarm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(target.check_block())
		target.visible_message("<span class='warning'>[target] blocks [user]'s disarm attempt!</span>")
		return 0
	if(attacker_style && attacker_style.disarm_act(user,target))
		return 1
	else
		user.do_attack_animation(target, ATTACK_EFFECT_DISARM)

		// does the vars n stuff
		target.times_disarmed += 1
		target.disarm_cooldown = world.time + 20
		if(world.time >= target.disarm_cooldown || target.stat || target.IsUnconscious() || target.IsParalyzed())
			target.times_disarmed = 0
			target.disarm_cooldown = 0

		if(target.w_uniform)
			target.w_uniform.add_fingerprint(user)
		var/randomized_zone = ran_zone(user.zone_selected)
		SEND_SIGNAL(target, COMSIG_HUMAN_DISARM_HIT, user, user.zone_selected)
		var/obj/item/bodypart/affecting = target.get_bodypart(randomized_zone)

		// The actual disarm part

		if(target.times_disarmed >= 3)
			playsound(target, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			target.visible_message("<span class='danger'>[user] has pushed [target]!</span>",
				"<span class='userdanger'>[user] has pushed [target]!</span>", null, COMBAT_MESSAGE_RANGE)
			target.apply_effect(20, EFFECT_PARALYZE, target.run_armor_check(affecting, "melee", "Your armor prevents your fall!", "Your armor softens your fall!"))
			target.forcesay(GLOB.hit_appends)
			target.times_disarmed = 0
			target.disarm_cooldown = 0
			log_combat(user, target, "pushed over")
			return

		if(target.times_disarmed == 2)
			var/obj/item/I = null
			I = target.get_active_held_item()
			if(target.dropItemToGround(I))
				target.visible_message("<span class='danger'>[user] has disarmed [target]!</span>", \
					"<span class='userdanger'>[user] has disarmed [target]!</span>", null, COMBAT_MESSAGE_RANGE)
			else
				I = null
			playsound(target, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			log_combat(user, target, "disarmed", "[I ? " removing \the [I]" : ""]")
			return
		if(target.pulling)
			playsound(target, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
			target.visible_message("<span class='warning'>[user] has broken [target]'s grip on [target.pulling]!</span>")
			target.stop_pulling()
			return
		playsound(target, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
		target.visible_message("<span class='danger'>[user] attempted to disarm [target]!</span>", \
						"<span class='userdanger'>[user] attempted to disarm [target]!</span>", null, COMBAT_MESSAGE_RANGE)
		log_combat(user, target, "attempted to disarm")
