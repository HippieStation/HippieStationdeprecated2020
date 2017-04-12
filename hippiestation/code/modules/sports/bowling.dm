/obj/item/clothing/shoes/hippie/bowling
	name = "bowling shoes"
	icon_state = "bowlingshoes"
	desc = "Made for use in only the finest bowling alleys."
	permeability_coefficient = 0.01
	flags = NOSLIP
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF
	body_parts_covered = FEET
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0, fire = 100, acid = 100)
	slowdown = -1

/obj/item/clothing/under/hippie/bowling
	name = "bowling jersey"
	desc = "The latest in kingpin fashion."
	icon_state = "bowlinguniform"
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF
	body_parts_covered = CHEST|GROIN|LEGS
	flags = THICKMATERIAL | STOPSPRESSUREDMAGE
	armor = list(melee = 70, bullet = 60, laser = 80, energy = 60, bomb = 75, bio = 30, rad = 50, fire = 100, acid = 100)
	can_adjust = FALSE
	var/next_bowl = 1

/obj/item/weapon/twohanded/bowling
	name = "bowling ball"
	icon = 'icons/hippie/obj/sports.dmi'
	icon_state = "bowling_ball"
	desc = "A heavy, round device used to knock pins (or people) down."
	force_unwielded = 3
	force_wielded = 6
	w_class = 3.0
	throwforce = 0
	throw_range = 1
	throw_speed = 1
	var/pro_wielded = FALSE

/obj/item/weapon/twohanded/bowling/New()
	color = pick("white","green","yellow","purple")
	..()

/obj/item/weapon/twohanded/bowling/attack_self(mob/living/carbon/human/user)
	if(wielded) //Trying to unwield it
		unwield(user)
		unspin()
		if(user.w_uniform && istype(user.w_uniform, /obj/item/clothing/under/bowling))
			var/obj/item/clothing/under/bowling/bowling = user.w_uniform
			bowling.next_bowl = (world.time - 1) //SO that you don't have to wait a cooldown if you unwield it.
		return
	else //Trying to wield it
		if(user.w_uniform && istype(user.w_uniform, /obj/item/clothing/under/bowling))
			var/obj/item/clothing/under/bowling/bowling = user.w_uniform
			if(bowling.next_bowl >= world.time)
				to_chat(user, "<span class='warning'>Your coach always said that you need to wait at least a second between bowls!</span>")
				unspin()
			else
				wield(user)
				if(!wielded)
					return
				bowling.next_bowl = (world.time + 10)
				unlimitedthrow = TRUE
				pro_wielded = TRUE
		else
			user << "<span class='warning'>You don't have the skills to wield such an amazing weapon!</span>"
			unspin()
			return

/obj/item/weapon/twohanded/bowling/throw_at(atom/target, range, speed, mob/thrower, spin=FALSE, diagonals_first = FALSE, datum/callback/callback)
	if(pro_wielded) //Only pros can wield a bowling ball
		icon_state = "bowling_ball_spin"
		playsound(src,'hippiestation/sound/effects/bowl.ogg',40,0)
	. = ..(target, range, speed, thrower, FALSE, diagonals_first, callback)

/obj/item/weapon/twohanded/bowling/throw_impact(atom/hit_atom)
	if(!ishuman(hit_atom))//if the ball hits a nonhuman
		unspin()
		return ..()
	var/mob/living/carbon/human/H = hit_atom
	if(pro_wielded)
		visible_message("<span class='danger'>\The expertly-bowled [src] knocks over [H] like a bowling pin!</span>")
		H.adjust_blurriness(6)
		H.adjustStaminaLoss(30)
		H.Weaken(8)
		H.adjustBruteLoss(25)
		playsound(src,'hippiestation/sound/effects/bowlhit.ogg',60,0)
		unspin()
		return
	else //Caught and not spinning or something else weird.
		unspin()
		return ..()

/obj/item/weapon/twohanded/bowling/proc/unspin()
	icon_state = "bowling_ball"
	unlimitedthrow = FALSE
	pro_wielded = FALSE
	qdel(src)