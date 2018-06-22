/datum/species/spec_attacked_by(obj/item/I, mob/living/user, obj/item/bodypart/affecting, intent, mob/living/carbon/human/H)
	if(H.checkbuttinsert(I, user))
		return FALSE
	if(user != H)
		if(H.check_shields(I, I.force, "the [I.name]", MELEE_ATTACK, I.armour_penetration))
			return 0
	if(H.check_block())
		H.visible_message("<span class='warning'>[H] blocks [I]!</span>")
		return 0

	var/hit_area
	if(!affecting) //Something went wrong. Maybe the limb is missing?
		affecting = H.bodyparts[1]

	hit_area = affecting.name
	var/def_zone = affecting.body_zone

	var/armor_block = H.run_armor_check(affecting, "melee", "<span class='notice'>Your armor has protected your [hit_area].</span>", "<span class='notice'>Your armor has softened a hit to your [hit_area].</span>",I.armour_penetration)
	armor_block = min(90,armor_block) //cap damage reduction at 90%
	var/Iforce = I.force //to avoid runtimes on the forcesay checks at the bottom. Some items might delete themselves if you drop them. (stunning yourself, ninja swords)

	if(H.mind && H.mind.martial_art && istype(H.mind.martial_art, /datum/martial_art/monk))
		var/datum/martial_art/monk/M = H.mind.martial_art
		var/defense_roll = M.defense_roll(0)
		if(defense_roll)
			var/dmg_to_deal = I.force
			if(defense_roll == 2)
				dmg_to_deal *= 2
				H.send_item_attack_message(I, user, critical = TRUE)
			else
				H.send_item_attack_message(I, user)
			apply_damage(dmg_to_deal, I.damtype, blocked = armor_block)
			if(I.damtype == BRUTE)
				if(prob(33))
					I.add_mob_blood(src)
					var/turf/location = get_turf(src)
					H.add_splatter_floor(location)
					if(get_dist(user, src) <= 1)
						user.add_mob_blood(src)
			return TRUE
		else
			H.visible_message("<span class='danger'>[H] dodges the [I]!</span>",\
			"<span class='userdanger'>[H] dodges the [I]!</span>", null, COMBAT_MESSAGE_RANGE)
			return FALSE
	var/weakness = H.check_weakness(I, user)
	apply_damage(I.force * weakness, I.damtype, def_zone, armor_block, H)

	H.send_item_attack_message(I, user, hit_area)

	if(!I.force)
		return 0 //item force is zero

	//dismemberment
	var/probability = I.get_dismemberment_chance(affecting)
	if(prob(probability) || ((TRAIT_EASYDISMEMBER in species_traits) && prob(2*probability)))
		if(affecting.dismember(I.damtype))
			I.add_mob_blood(H)
			playsound(get_turf(H), I.get_dismember_sound(), 80, 1)

	var/bloody = 0
	if(((I.damtype == BRUTE) && I.force && prob(25 + (I.force * 2))))
		if(affecting.status == BODYPART_ORGANIC)
			I.add_mob_blood(H)	//Make the weapon bloody, not the person.
			if(prob(I.force * 2))	//blood spatter!
				bloody = 1
				var/turf/location = H.loc
				if(istype(location))
					H.add_splatter_floor(location)
				if(get_dist(user, H) <= 1)	//people with TK won't get smeared with blood
					user.add_mob_blood(H)

		switch(hit_area)
			if("head")
				if(H.stat == CONSCIOUS && armor_block < 50)
					if(prob(I.force))
						H.visible_message("<span class='danger'>[H] has been knocked senseless!</span>", \
										"<span class='userdanger'>[H] has been knocked senseless!</span>")
						H.confused = max(H.confused, 20)
						H.adjustBrainLoss(20)
						H.adjust_blurriness(10)
						if(prob(10))
							H.gain_trauma(/datum/brain_trauma/mild/concussion)
					else
						if(!I.is_sharp())
							H.adjustBrainLoss(I.force * 0.2)

					if(!I.is_sharp() && prob(I.force + ((100 - H.health) * 0.5)) && H != user) // rev deconversion through blunt trauma.
						var/datum/antagonist/rev/rev = H.mind.has_antag_datum(/datum/antagonist/rev)
						if(rev)
							rev.remove_revolutionary(FALSE, user)

				if(bloody)	//Apply blood
					if(H.wear_mask)
						H.wear_mask.add_mob_blood(H)
						H.update_inv_wear_mask()
					if(H.head)
						H.head.add_mob_blood(H)
						H.update_inv_head()
					if(H.glasses && prob(33))
						H.glasses.add_mob_blood(H)
						H.update_inv_glasses()

			if("chest")
				if(H.stat == CONSCIOUS && armor_block < 50)
					if(prob(I.force))
						H.visible_message("<span class='danger'>[H] has been knocked down!</span>", \
									"<span class='userdanger'>[H] has been knocked down!</span>")
						H.apply_effect(60, EFFECT_KNOCKDOWN, armor_block)

				if(bloody)
					if(H.wear_suit)
						H.wear_suit.add_mob_blood(H)
						H.update_inv_wear_suit()
					if(H.w_uniform)
						H.w_uniform.add_mob_blood(H)
						H.update_inv_w_uniform()

		if(Iforce > 10 || Iforce >= 5 && prob(33))
			H.forcesay(GLOB.hit_appends)	//forcesay checks stat already.
	return TRUE



/datum/species/harm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(user.has_trait(TRAIT_PACIFISM))
		to_chat(user, "<span class='warning'>You don't want to harm [target]!</span>")
		return FALSE
	if(target.check_block())
		target.visible_message("<span class='warning'>[target] blocks [user]'s attack!</span>")
		return FALSE
	if(attacker_style && attacker_style.harm_act(user,target))
		return TRUE
	if(target.mind && istype(target.mind.martial_art, /datum/martial_art/monk))
		var/datum/martial_art/monk/M = target.mind.martial_art
		var/defense_roll = M.defense_roll(0)
		if(defense_roll)
			var/damage = rand(user.dna.species.punchdamagelow, user.dna.species.punchdamagehigh)
			playsound(target.loc, user.dna.species.attack_sound, 25, 1, -1)
			if(defense_roll == 2)
				damage *= 2
				target.visible_message("<span class='danger'>[user] has critically punched [target]!</span>", \
				"<span class='userdanger'>[user] has critically punched [target]!</span>", null, COMBAT_MESSAGE_RANGE)
				add_logs(user, target, "critically punched")
			else
				target.visible_message("<span class='danger'>[user] has punched [target]!</span>", \
				"<span class='userdanger'>[user] has punched [target]!</span>", null, COMBAT_MESSAGE_RANGE)
				add_logs(user, target, "punched")
			target.apply_damage(damage, BRUTE)
			return TRUE
		else
			playsound(target.loc, user.dna.species.miss_sound, 25, 1, -1)
			target.visible_message("<span class='warning'>[user] has attempted to punch [target], but they dodged it!</span>", \
				"<span class='userdanger'>[user] has attempted to punch [target], but they dodged it!</span>", null, COMBAT_MESSAGE_RANGE)
			add_logs(user, target, "attempted to punch")
		return FALSE
	else

		var/atk_verb = user.dna.species.attack_verb
		if(target.lying)
			atk_verb = "kick"

		switch(atk_verb)
			if("kick")
				user.do_attack_animation(target, ATTACK_EFFECT_KICK)
			if("slash")
				user.do_attack_animation(target, ATTACK_EFFECT_CLAW)
			if("smash")
				user.do_attack_animation(target, ATTACK_EFFECT_SMASH)
			else
				user.do_attack_animation(target, ATTACK_EFFECT_PUNCH)

		var/damage = rand(user.dna.species.punchdamagelow, user.dna.species.punchdamagehigh)

		var/obj/item/bodypart/affecting = target.get_bodypart(ran_zone(user.zone_selected))

		if(!damage || !affecting)
			playsound(target.loc, user.dna.species.miss_sound, 25, 1, -1)
			target.visible_message("<span class='danger'>[user] has attempted to [atk_verb] [target]!</span>",\
			"<span class='userdanger'>[user] has attempted to [atk_verb] [target]!</span>", null, COMBAT_MESSAGE_RANGE)
			return FALSE


		var/armor_block = target.run_armor_check(affecting, "melee")

		playsound(target.loc, user.dna.species.attack_sound, 25, 1, -1)

		target.visible_message("<span class='danger'>[user] has [atk_verb]ed [target]!</span>", \
					"<span class='userdanger'>[user] has [atk_verb]ed [target]!</span>", null, COMBAT_MESSAGE_RANGE)

		if(user.limb_destroyer)
			target.dismembering_strike(user, affecting.body_zone)
		target.apply_damage(damage, BRUTE, affecting, armor_block)
		add_logs(user, target, "punched")
		if((target.stat != DEAD) && damage >= user.dna.species.punchstunthreshold)
			target.visible_message("<span class='danger'>[user] has knocked  [target] down!</span>", \
							"<span class='userdanger'>[user] has knocked [target] down!</span>", null, COMBAT_MESSAGE_RANGE)
			target.apply_effect(80, EFFECT_KNOCKDOWN, armor_block)
			target.forcesay(GLOB.hit_appends)
		else if(target.lying)
			target.forcesay(GLOB.hit_appends)