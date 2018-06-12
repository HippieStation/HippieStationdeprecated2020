/datum/martial_art
	var/mob/living/carbon/human/owner = null

/datum/martial_art/basic_hit(mob/living/carbon/human/A,mob/living/carbon/human/D)

	var/damage = rand(A.dna.species.punchdamagelow, A.dna.species.punchdamagehigh)

	var/atk_verb = A.dna.species.attack_verb
	if(D.lying)
		atk_verb = "kick"

	switch(atk_verb)
		if("kick")
			A.do_attack_animation(D, ATTACK_EFFECT_KICK)
		if("slash")
			A.do_attack_animation(D, ATTACK_EFFECT_CLAW)
		if("smash")
			A.do_attack_animation(D, ATTACK_EFFECT_SMASH)
		else
			A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)

	if(D.mind && istype(D.mind.martial_art, /datum/martial_art/monk))
		var/datum/martial_art/monk/M = D.mind.martial_art
		var/defense_roll = M.defense_roll(0)
		if(defense_roll)
			playsound(D.loc, A.dna.species.attack_sound, 25, 1, -1)
			if(defense_roll == 2)
				damage *= 2
				D.visible_message("<span class='danger'>[A] has critically [atk_verb]ed [D]!</span>", \
				"<span class='userdanger'>[A] has critically [atk_verb]ed [D]!</span>", null, COMBAT_MESSAGE_RANGE)
				add_logs(A, D, "critically punched")
			else
				D.visible_message("<span class='danger'>[A] has [atk_verb]ed [D]!</span>", \
				"<span class='userdanger'>[A] has [atk_verb]ed [D]!</span>", null, COMBAT_MESSAGE_RANGE)
				add_logs(A, D, "punched")
			D.apply_damage(damage, BRUTE)
			return TRUE
		else
			playsound(D.loc, A.dna.species.miss_sound, 25, 1, -1)
			D.visible_message("<span class='warning'>[A] has attempted to [atk_verb] [D]!</span>", \
				"<span class='userdanger'>[A] has attempted to [atk_verb] [D]!</span>", null, COMBAT_MESSAGE_RANGE)
			add_logs(A, D, "attempted to [atk_verb]")
			return FALSE

	if(!damage)
		playsound(D.loc, A.dna.species.miss_sound, 25, 1, -1)
		D.visible_message("<span class='warning'>[A] has attempted to [atk_verb] [D]!</span>", \
			"<span class='userdanger'>[A] has attempted to [atk_verb] [D]!</span>", null, COMBAT_MESSAGE_RANGE)
		add_logs(A, D, "attempted to [atk_verb]")
		return FALSE

	var/obj/item/bodypart/affecting = D.get_bodypart(ran_zone(A.zone_selected))
	var/armor_block = D.run_armor_check(affecting, "melee")

	playsound(D.loc, A.dna.species.attack_sound, 25, 1, -1)
	D.visible_message("<span class='danger'>[A] has [atk_verb]ed [D]!</span>", \
			"<span class='userdanger'>[A] has [atk_verb]ed [D]!</span>", null, COMBAT_MESSAGE_RANGE)

	D.apply_damage(damage, BRUTE, affecting, armor_block)

	add_logs(A, D, "punched")

	if((D.stat != DEAD) && damage >= A.dna.species.punchstunthreshold)
		D.visible_message("<span class='danger'>[A] has knocked [D] down!!</span>", \
								"<span class='userdanger'>[A] has knocked [D] down!</span>")
		D.apply_effect(40, EFFECT_KNOCKDOWN, armor_block)
		D.forcesay(GLOB.hit_appends)
	else if(D.lying)
		D.forcesay(GLOB.hit_appends)
	return TRUE


/datum/martial_art/teach(mob/living/carbon/human/H,make_temporary=0)
	if(!istype(H) || !H.mind)
		return FALSE
	if(H.mind.martial_art)
		if(make_temporary)
			if(!H.mind.martial_art.allow_temp_override)
				return FALSE
			store(H.mind.martial_art,H)
		else
			H.mind.martial_art.on_remove(H)
	else if(make_temporary)
		base = H.mind.default_martial_art
	if(help_verb)
		H.verbs += help_verb
	H.mind.martial_art = src
	owner = H
	return TRUE

/datum/martial_art/remove(mob/living/carbon/human/H)
	if(!istype(H) || !H.mind || H.mind.martial_art != src)
		return
	owner = null
	on_remove(H)
	if(base)
		base.teach(H)
	else
		var/datum/martial_art/X = H.mind.default_martial_art
		X.teach(H)