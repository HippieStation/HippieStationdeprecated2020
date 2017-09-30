//when making a weapon with a special attack or adding a special attack, please add the special vars and proc here for the sake of organisation
/obj/item/kitchen/knife
	special_name = "Artery slash"
	special_desc = "COST: 30 STAMINA. A precision slash targeting an artery, causes extra bleeding."
	actions_types = list(/datum/action/item_action/special_attack)

/obj/item/kitchen/knife/do_special_attack(atom/target, mob/living/carbon/user, proximity_flag, cost = 30)
	..()
	if(ishuman(target) && proximity_flag)
		var/mob/living/carbon/human/H = target
		user.adjustStaminaLoss(cost)
		src.special_attack = FALSE
		H.bleed_rate = min(H.bleed_rate + 10, 10)
		H.blood_volume -= 25

		for(var/turf/T in range(H.loc, 1))
			H.add_splatter_floor(T)
		H.visible_message("<span class='danger'>[user] slashes open one of [H]'s arteries with [src]!</span>", "<span class='userdanger'>[user] slices open one of your arteries with [src]!</span>")
		playsound(H, 'sound/effects/splat.ogg', 50, 1)
	..()

/obj/item/melee/transforming/energy/sword/saber
	special_name = "Lunge"
	special_desc = "COST: 40 STAMINA. Dash forth in a vicious lunge guaranteed to gore an enemy"
	actions_types = list(/datum/action/item_action/special_attack)

/obj/item/melee/transforming/energy/sword/saber/do_special_attack(atom/target, mob/living/carbon/user, proximity_flag, cost = 40)
	..()
	if(!proximity_flag && get_dist(user,target) == 2 && ishuman(target))
		var/mob/living/carbon/human/HT = target
		user.adjustStaminaLoss(cost)
		user.throw_at(target, 1, 10)

		if(do_after(user, 2, target = target))//small window to dodge
			if(src.active && get_dist(user, target) <= 1)
				HT.Stun(15)
				HT.blood_volume -= 15
				var/armor_block = HT.run_armor_check("chest", "melee")
				HT.apply_damage(25, BRUTE, HT.get_bodypart("chest") , armor_block - armour_penetration)
				HT.visible_message("<span class='danger'>[user] lunges sword first at [HT] and impales them with [src]!</span>", "<span class='userdanger'>[user] impales you with the full length of [src]!</span>")
				user.do_attack_animation(target)
				playsound(HT, 'sound/weapons/slice.ogg', 100, 1)

				if(do_after(user, 15, target = target) && get_dist(user, target) <= 1)
					HT.apply_damage(25, BRUTE, HT.get_bodypart("chest"), armor_block - armour_penetration)
					var/obj/item/organ/stomach/S = HT.getorganslot("stomach")
					if(S)
						S.Remove(HT)
						S.forceMove(HT.loc)

					HT.visible_message("<span class='danger'>[user] wrenches [src] out of [HT]!</span>", "<span class='userdanger'>[user] brutally wrenches the [src] out... and your bisected stomach drops to the floor!</span>")
					playsound(HT, 'hippiestation/sound/misc/tear.ogg', 100, 1)
					HT.add_splatter_floor(HT.loc)
					var/obj/effect/decal/cleanable/blood/gibs/G = new(HT.loc)
					G.streak(pick(GLOB.alldirs))
				else
					to_chat(user, "<span class='warning'>You're unable to tear your sword out!</span>")
					user.dropItemToGround(src, TRUE)
					src.forceMove(HT.loc)

			src.special_attack = FALSE
	else
		to_chat(user, "<span class='warning'>You need to be 1 tile away from a human enemy to initiate the attack</span>")
		return FALSE

/obj/item/twohanded/dualsaber
	special_name = "Dance of the Fates"
	special_desc = "COST: 50 STAMINA. Launch into an uncontrollable flurry of attacks slicing up any enemies in range"
	actions_types = list(/datum/action/item_action/special_attack)

/obj/item/twohanded/dualsaber/do_special_attack(atom/target, mob/living/carbon/user, cost = 50)
	..()
	if(wielded)
		user.adjustStaminaLoss(cost)
		user.visible_message("<span class='danger'>[user] begins to flail around wildly!</span>")
		user.confused += 200
		src.special_attack = FALSE
		src.block_chance = 100
		src.flags_1 |= NODROP_1
		src.SpinAnimation(15, 50)
		user.SpinAnimation(15, 50)
		for(var/I in 1 to 60)
			if(do_after(user, 3, target = target))
				if(user.canmove && !isspaceturf(user.loc))
					step(user, pick(GLOB.cardinals))
					for(var/atom/movable/AM in orange(1, user))
						if(prob(50))
							AM.attackby(src, user)

	src.flags_1 &= ~NODROP_1
	user.confused = max(user.confused - 200, 0)

/obj/item/melee/transforming/butterfly
	special_name = "Butt Sever"
	special_desc = "COST: 15 STAMINA. Humiliate any enemy by instantly slicing their butt clean off!"
	actions_types = list(/datum/action/item_action/special_attack)

/obj/item/melee/transforming/butterfly/do_special_attack(atom/target, mob/living/carbon/user, proximity_flag, cost = 15)//no alternative for aliens because their code is cancer
	..()
	if(ishuman(target) && proximity_flag && src.active)
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/butt/B = H.getorganslot("butt")
		if(B)
			user.adjustStaminaLoss(cost)
			B.Remove(H)
			B.forceMove(H.loc)
			H.visible_message("<span class='danger'>In a quick motion [user] slices [H]'s butt clean off with [src]!</span>")
			H.add_splatter_floor(H.loc)
			playsound(H, 'sound/misc/splort.ogg', 50, 1, -1)
		else
			to_chat(user,"<span class='warning'>They have no butt!</span>")

/obj/item/melee/baseball_bat
	special_name = "Head Bash"
	special_desc = "COST: 40 STAMINA. Crush a target's head in, causing brain damage and confusion"
	actions_types = list(/datum/action/item_action/special_attack)

/obj/item/melee/baseball_bat/do_special_attack(atom/target, mob/living/carbon/user, proximity_flag, cost = 40)
	..()
	if(iscarbon(target) && proximity_flag)
		user.adjustStaminaLoss(cost)
		var/mob/living/carbon/C = target
		C.adjustBrainLoss(30)
		C.confused += 25
		var/armor_block = C.run_armor_check("head", "melee")
		C.apply_damage(force, BRUTE, C.get_bodypart("head"), armor_block)
		C.visible_message("<span class='danger'>[user] smashes [C]'s head hard with [src]!</span>", "<span class='userdanger'>[user] smashes your skull in with [src]!</span>")
		user.say("Ey, is somebody keepin' track of my heads batted in?")
		user.do_attack_animation(target)
		playsound(C, src.hitsound, 100, 1, -1)
		src.special_attack = FALSE

/obj/item/melee/baton
	special_name = "Wrath of Zeus"
	special_desc = "COST: 35 STAMINA. Spit on the active end creating vanquishing lightning"
	actions_types = list(/datum/action/item_action/special_attack)

/obj/item/melee/baton/do_special_attack(atom/target, mob/living/carbon/user, cost = 35)
	..()
	if(isliving(user) && src.status == TRUE)
		user.adjustStaminaLoss(cost)
		tesla_zap(user, 4, 10000)
		src.deductcharge(hitcost)
		user.visible_message("<span class='danger'>[user] spits on the active end of [src]!</span>")
		playsound(user, 'sound/magic/lightningbolt.ogg', 100, 1, -1)
		src.special_attack = FALSE


/obj/item/melee/chainofcommand
	special_name = "Ensnare"
	special_desc = "COST: 35 STAMINA. Tie the legs of fleeing criminal scum so they may be brought to justice with greater haste"
	actions_types = list(/datum/action/item_action/special_attack)

/obj/item/melee/chainofcommand/do_special_attack(atom/target, mob/living/carbon/user, proximity_flag, cost = 35)
	..()
	if(!proximity_flag && get_dist(user,target) < 6 && isliving(target))
		var/mob/living/M = target
		user.adjustStaminaLoss(cost)
		user.visible_message("<span class='danger'>[user] flicks [src] towards [M]'s legs!</span>")
		if(do_after(user, 2, target = target))
			M.Knockdown(20)
			M.visible_message("<span class='danger'>[user] starts to reel in [M]!</span>", "<span class='userdanger'>[user]'s [src] ties your legs and trips you as they begin to reel you in!</span>")
			for(var/I in 1 to get_dist(user, M))
				if(do_after(user, 3, target = target))
					step_towards(M, user)
					playsound(M, pick('hippiestation/sound/effects/bodyscrape-01.ogg', 'hippiestation/sound/effects/bodyscrape-02.ogg'), 20, 1, -4)
			src.special_attack = FALSE
