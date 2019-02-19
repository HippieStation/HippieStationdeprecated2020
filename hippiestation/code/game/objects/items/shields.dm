/obj/item/shield/energy/deathsquad
	name = "elite energy combat shield"

/obj/item/shield/energy/deathsquad/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if (active)
		if(!istype(owner.mind.martial_art, /datum/martial_art/elite_cqc))
			owner.visible_message("<span class='warning'>[owner] tries to block [attack_text] with [src], but fails!</span>")
			return FALSE
		if(attack_type == THROWN_PROJECTILE_ATTACK)
			final_block_chance += 30
		if(attack_type == LEAP_ATTACK)
			final_block_chance = 100
			return 1
		if(attack_type == MELEE_ATTACK)
			final_block_chance = 90
		if(attack_type == PROJECTILE_ATTACK)
			final_block_chance = 70
			if(istype(hitby, /obj/item/projectile/bullet/neurotoxin))
				final_block_chance = 100
		SEND_SIGNAL(src, COMSIG_ITEM_HIT_REACT, args)
		if (prob(final_block_chance))
			owner.visible_message("<span class='danger'>[owner] skillfully blocks [attack_text] with [src]!</span>")
			return TRUE
	return FALSE

/obj/item/shield
	block_chance = 0
	var/block_chance_unwielded = 0
	var/block_chance_wielded = 75
	var/wielded = FALSE
	var/can_2hand = TRUE
	var/boost_armor = TRUE

/obj/item/shield/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(attack_type == PROJECTILE_ATTACK)
		to_chat(owner, "<span class='notice'>[src] fails to deflect [attack_text].</span>")
		return FALSE
	if(!is_A_facing_B(owner,hitby))
		return FALSE
	final_block_chance -= damage
	return ..()

/obj/item/shield/proc/unwield(mob/living/carbon/user, show_message = TRUE)
	if(!wielded || !user)
		return
	wielded = FALSE
	if(!isnull(block_chance_unwielded))
		block_chance = block_chance_unwielded
	var/sf = findtext(name," (Wielded)")
	if(sf)
		name = copytext(name,1,sf)
	else //something wrong
		name = "[initial(name)]"
	update_icon()
	if(user.get_item_by_slot(SLOT_BACK) == src)
		user.update_inv_back()
	else
		user.update_inv_hands()
	if(show_message)
		to_chat(user, "<span class='notice'>You are now carrying [src] with one hand.</span>")
	var/obj/item/shield/offhand/O = user.get_inactive_held_item()
	if(O && istype(O))
		O.unwield()
	return

/obj/item/shield/proc/wield(mob/living/carbon/user)
	if(wielded)
		return
	if(ismonkey(user))
		to_chat(user, "<span class='warning'>It's too heavy for you to wield fully.</span>")
		return
	if(user.get_inactive_held_item())
		to_chat(user, "<span class='warning'>You need your other hand to be empty!</span>")
		return
	if(user.get_num_arms() < 2)
		to_chat(user, "<span class='warning'>You don't have enough intact hands.</span>")
		return
	wielded = TRUE
	if(!isnull(block_chance_wielded))
		block_chance = block_chance_wielded
	name = "[name] (Wielded)"
	update_icon()
	to_chat(user, "<span class='notice'>You grab [src] with both hands.</span>")
	var/obj/item/shield/offhand/O = new(user) ////Let's reserve his other hand~
	O.name = "[name] - offhand"
	O.desc = "Your second grip on [src]."
	O.wielded = TRUE
	user.put_in_inactive_hand(O)
	return

/obj/item/shield/dropped(mob/living/user)
	..()
	//handles unwielding a twohanded weapon when dropped as well as clearing up the offhand
	if(!wielded)
		return
	unwield(user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.physiology.armor = H.physiology.armor.setRating(melee = 0, bullet = 0, bomb = 0)

/obj/item/shield/attack_self(mob/user)
	. = ..()
	if(can_2hand)
		if(wielded) //Trying to unwield it
			unwield(user)
		else //Trying to wield it
			wield(user)

/obj/item/shield/equip_to_best_slot(mob/living/carbon/user)
	if(..())
		unwield(user)
		return

/obj/item/shield/equipped(mob/living/user, slot)
	..()
	if(!user.is_holding(src) && wielded)
		unwield(user)
	if(ishuman(user) && boost_armor)
		var/mob/living/carbon/human/H = user
		H.physiology.armor = H.physiology.armor.modifyRating(melee = 15, bullet = 5, bomb = 15)

///////////OFFHAND///////////////
/obj/item/shield/offhand
	name = "offhand"
	icon_state = "offhand"
	w_class = WEIGHT_CLASS_HUGE
	item_flags = ABSTRACT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	boost_armor = FALSE

/obj/item/shield/offhand/Destroy()
	wielded = FALSE
	return ..()

/obj/item/shield/offhand/dropped(mob/living/user, show_message = TRUE) //Only utilized by dismemberment since you can't normally switch to the offhand to drop it.
	var/obj/I = user.get_active_held_item()
	if(I && istype(I, /obj/item/shield))
		var/obj/item/twohanded/thw = I
		thw.unwield(user, show_message)
	if(!QDELETED(src))
		qdel(src)

/obj/item/shield/offhand/unwield()
	if(wielded)//Only delete if we're wielded
		wielded = FALSE
		qdel(src)

/obj/item/shield/offhand/wield()
	if(wielded)//Only delete if we're wielded
		wielded = FALSE
		qdel(src)

/obj/item/shield/offhand/attack_self(mob/living/carbon/user)		//You should never be able to do this in standard use of two handed items. This is a backup for lingering offhands.
	var/obj/item/shield/O = user.get_inactive_held_item()
	if (istype(O) && !istype(O, /obj/item/shield/offhand))		//If you have a proper item in your other hand that the offhand is for, do nothing. This should never happen.
		return
	if (QDELETED(src))
		return

/obj/item/shield/energy
	can_2hand = FALSE
	boost_armor = FALSE

/obj/item/shield/riot/tele/attack_self(mob/living/user)
	can_2hand = active
	if(!active)
		to_chat(user, "<span class='notice'>You must extend [src] before you wield it!</span>")
	..()

/obj/item/shield/riot/tele/AltClick(mob/living/user)
	..()
	update_icon()
	if(wielded)
		unwield(user)
		active = FALSE
		can_2hand = FALSE