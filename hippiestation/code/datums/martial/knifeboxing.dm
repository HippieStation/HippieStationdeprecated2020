/datum/martial_art/knifeboxing
	name = "Knife-boxing"

/datum/martial_art/knifeboxing/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	to_chat(A, "<span class='warning'>Can't disarm while knife-boxing!</span>")
	return TRUE

/datum/martial_art/knifeboxing/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	to_chat(A, "<span class='warning'>Can't grab while knife-boxing!</span>")
	return TRUE

/datum/martial_art/knifeboxing/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)

	A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)

	var/atk_verb = pick("left hook","right hook","straight punch")

	var/damage = rand(8, 12) + A.dna.species.punchdamagelow
	if(!damage)
		playsound(D.loc, A.dna.species.miss_sound, 25, 1, -1)
		D.visible_message("<span class='warning'>[A] has attempted to [atk_verb] [D]!</span>", \
			"<span class='userdanger'>[A] has attempted to [atk_verb] [D]!</span>", null, COMBAT_MESSAGE_RANGE)
		log_combat(A, D, "attempted to hit", atk_verb)
		return FALSE

	var/obj/item/bodypart/affecting = D.get_bodypart(ran_zone(A.zone_selected))
	var/armor_block = D.run_armor_check(affecting, "melee")

	playsound(D.loc, A.dna.species.attack_sound, 25, 1, -1)

	D.visible_message("<span class='danger'>[A] has [atk_verb]ed [D]!</span>", \
			"<span class='userdanger'>[A] has [atk_verb]ed [D]!</span>", null, COMBAT_MESSAGE_RANGE)

	D.apply_damage(damage, BRUTE, affecting, armor_block)
	log_combat(A, D, "punched (knifeboxing) ")
	return TRUE

/obj/item/clothing/gloves/knifeboxing
	var/datum/martial_art/knifeboxing/style = new

/obj/item/clothing/gloves/knifeboxing/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	if(slot == SLOT_GLOVES)
		var/mob/living/carbon/human/H = user
		style.teach(H,1)

/obj/item/clothing/gloves/knifeboxing/dropped(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H)
		if(H.get_item_by_slot(SLOT_GLOVES) == src)
			style.remove(H)
