/obj/item/wirerod/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/shard))
		var/obj/item/twohanded/spear/S = new(src.loc)

		remove_item_from_storage(user)
		qdel(I)
		qdel(src)

		user.put_in_hands(S)
		to_chat(user, "<span class='notice'>You fasten the glass shard to the top of the rod with the cable.</span>")

	else if(istype(I, /obj/item/assembly/igniter) && !HAS_TRAIT(src, TRAIT_NODROP))
		var/obj/item/melee/baton/cattleprod/hippie_cattleprod/P = new(src.loc)

		remove_item_from_storage(user)

		to_chat(user, "<span class='notice'>You fasten [I] to the top of the rod with the cable.</span>")

		qdel(I)
		qdel(src)

		user.put_in_hands(P)
	else
		return ..()

/obj/item/sord/attack(mob/living/M, mob/living/user)
	if(prob(10))
		M.adjustBruteLoss(1)
		visible_message("<span class='greenannounce'>[user] has scored a critical hit on [M]!</span>")
		playsound(src, 'sound/arcade/mana.ogg', 50, 1)
	..()

/obj/item/banhammer/syndicate
	desc = "A banhammer. Upon closer inspection, it appears to have a red tag around its handle."
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	icon_state = "toyhammertagged"
	throwforce = 20
	force = 20
	armour_penetration = 100 //Target will be downed in 5 hits before they know what happened.

/obj/item/banhammer/syndicate/attack(mob/M, mob/user)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(prob(0.1) && H.can_heartattack() && !H.undergoing_cardiac_arrest())
			H.set_heartattack(TRUE)
			if(H.stat == CONSCIOUS)
				H.visible_message("<span class='userdanger'>[H] clutches at [H.p_their()] chest as if [H.p_their()] heart stopped!</span>")

/obj/item/mounted_energy_chainsaw
	name = "mounted energy chainsaw"
	desc = "An energy chainsaw that has replaced your arm."
	icon_state = "chainsaw_on"
	item_state = "mounted_chainsaw"
	lefthand_file = 'icons/mob/inhands/weapons/chainsaw_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/chainsaw_righthand.dmi'
	item_flags = ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	force = 60
	block_chance = 50
	armour_penetration = 15
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	sharpness = IS_SHARP
	attack_verb = list("sawed", "shred", "rended", "gutted", "eviscerated")

/obj/item/mounted_energy_chainsaw/attack(mob/living/M, mob/living/user)
	playsound(src, pick('hippiestation/sound/weapons/echainsawhit1.ogg','hippiestation/sound/weapons/echainsawhit2.ogg'))
	..()

/obj/item/mounted_energy_chainsaw/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/obj/item/staff // to make sure people don't get confused
	desc = "Apparently a staff used by the wizard. Doesn't shoot anything."
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/staff/Initialize()
	. = ..()
	AddComponent(/datum/component/spell_catalyst)

/obj/item/melee/flyswatter
	force = 2
	throwforce = 2
	attack_verb = list("swatted", "smacked", "slapped", "whacked") // if it seems too suggestive may remove, this isnt an ERP item

/obj/item/pimpstick
	name = "pimp stick"
	desc = "A gold-rimmed cane, with a gleaming diamond set at the top. Great for bashing in kneecaps."
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	icon_state = "pimpstick"
	item_state = "pimpstick"
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi'
	force = 10
	throwforce = 7
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("pimped", "smacked", "disciplined", "busted", "capped", "decked")
	resistance_flags = FIRE_PROOF

/obj/item/pimpstick/suicide_act(mob/user)
		user.visible_message("<span class='suicide'>[user] is hitting [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to discipline [user.p_them()]self for being a mark-ass trick.</span>")
		return (BRUTELOSS)

/obj/item/melee/baseball_bat
	icon_hippie = 'hippiestation/icons/obj/items_and_weapons.dmi'
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi'

/obj/item/melee/baseball_bat/ablative
	desc = "A smooth metal club used in baseball to hit the ball. Or to purify your adversaries."
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	icon_state = "hippie_bbat_metal"
	item_state = "hippie_bbat_metal"
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi'

/obj/item/melee/baseball_bat/spiked
	name = "spiked baseball bat"
	desc = "A wooden baseball bat with metal spikes crudely attached."
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	icon_state = "hippie_bbat_spike"
	item_state = "hippie_bbat_spike"
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi'
	force = 15 //for reference, normal bat has 10
	throwforce = 15 // its got spikes sticking out of it - pre rebase comment :D
	armour_penetration = 10

/obj/item/claymore/bone
	name = "bone sword"
	desc = "Strike fear into the heart of any enemy with this real goliath bone sword. This gorgeous but deadly weapon comes with a razor sharp battle ready blade that is complemented by a masterfully carved bone hilt."
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	icon_state = "bonesword"
	item_state = "bonesword"
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi'
//	slot_flags = null commented due to making the swords absolutely useless in practice as you cant even transport them around and for fuckin 16 force its weak af considering it's made from goliath bones
	force = 16
	throwforce = 10
	block_chance = 10

/obj/item/hatchet/improvised
	name = "glass hatchet"
	desc = "A makeshift hand axe with a crude blade of broken glass."
	icon = 'hippiestation/icons/obj/weapons.dmi'
	icon_state = "glasshatchet"
	item_state = "glasshatchet"
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi'

/obj/item/brick
	name = "brick"
	desc = "A brick, prefered break-in tool in many planets."
	icon = 'hippiestation/icons/obj/weapons.dmi'
	icon_state = "brick"
	item_state = "brick"
	force = 12 // decent weapon
	throwforce = 15 // good throw
	attack_verb = list("bricked")
	hitsound = 'hippiestation/sound/effects/brick.ogg'
	var/durability = 5

/obj/item/brick/Initialize()
	. = ..()
	if(prob(0.5))
		name = "brown brick"
		desc = "<font color = #835C3B>I understand why all the kids are playing this game these days. It's because they like to build brown bricks with Minecrap. I also like to build brown bricks with Minecrap. It's the most fun you can possibly have.</font>"
		icon_state = "brownbrick"
		item_state = "brownbrick"
		force = 15
		throwforce = 20
		durability = INFINITY

/obj/item/brick/attack(mob/living/target, mob/living/user)
	..()
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(!istype(M.head, /obj/item/clothing/head/helmet) && user.zone_selected == BODY_ZONE_HEAD)
			if(prob(1) && M.stat != DEAD)
				M.emote("scream")
				M.visible_message("<span class='danger'>[user] knocks out [M] with [src]!</span>", \
								"<span class='userdanger'>[user] knocks out [M] with [src]!</span>")
				M.AdjustUnconscious(60)
				M.adjustBrainLoss(5)

/obj/item/brick/throw_impact(atom/hit_atom)
	. = ..()
	if(!.)
		if(istype(hit_atom, /obj/structure/window) && durability)
			var/obj/structure/window/W = hit_atom
			W.take_damage(throwforce*10, BRUTE, "melee", 0)
			durability -= 1

		if(ishuman(hit_atom))
			var/mob/living/carbon/human/H = hit_atom
			if(prob(10) && !istype(H.head, /obj/item/clothing/head/helmet) && durability) // I couldnt figure out how to make it check if it's hitting the head so I just made it check for helmet, sry bby
				H.apply_damage(throwforce, BRUTE, BODY_ZONE_HEAD) // double damage
				H.visible_message("<span class='danger'>[H] falls unconscious as [H.p_theyre()] hit by [src]!</span>", \
								"<span class='userdanger'>You suddenly black out as you're hit by [src]!</span>")
				H.AdjustUnconscious(80)
				H.adjustBrainLoss(10)
				playsound(src, 'hippiestation/sound/effects/ZUBALAWA.ogg', 50, 0)
				durability -= 1

/obj/item/switchblade/civilian
	desc = "A cheap spring-loaded knife. A small tag on the side of the blade spells out 'Made in Space China'."

/obj/item/switchblade/civilian/attack_self(mob/user)
	extended = !extended
	playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, 1)
	if(extended)
		force = 10
		w_class = WEIGHT_CLASS_NORMAL
		throwforce = 15
		icon_state = "switchblade_ext"
		attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
		hitsound = 'sound/weapons/bladeslice.ogg'
		sharpness = IS_SHARP
	else
		force = 3
		w_class = WEIGHT_CLASS_SMALL
		throwforce = 5
		icon_state = "switchblade"
		attack_verb = list("stubbed", "poked")
		hitsound = 'sound/weapons/genhit.ogg'
		sharpness = IS_BLUNT

/obj/item/switchblade/civilian/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	..()
	user.changeNext_move(CLICK_CD_CLICK_ABILITY)

/obj/item/switchblade/middleground
	desc = "A spring-loaded retractable knife. This one seems to be <b>almost</b> as good as the original design."

/obj/item/switchblade/middleground/attack_self(mob/user)
	extended = !extended
	playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, 1)
	if(extended)
		force = 15
		w_class = WEIGHT_CLASS_NORMAL
		throwforce = 20
		icon_state = "switchblade_ext"
		attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
		hitsound = 'sound/weapons/bladeslice.ogg'
		sharpness = IS_SHARP
	else
		force = 3
		w_class = WEIGHT_CLASS_SMALL
		throwforce = 5
		icon_state = "switchblade"
		attack_verb = list("stubbed", "poked")
		hitsound = 'sound/weapons/genhit.ogg'
		sharpness = IS_BLUNT

/obj/item/switchblade/middleground/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	..()
	user.changeNext_move(CLICK_CD_CLICK_ABILITY)

/obj/item/melee/stake
	name = "wooden stake"
	desc = "A sharpened piece of wood that is a staple in vampire hunting for some reason."
	icon = 'hippiestation/icons/obj/weapons.dmi'
	icon_state = "stake"
	force = 10
	throwforce = 15 //15 + 2 (WEIGHT_CLASS_SMALL) * 3 (EMBEDDED_IMPACT_PAIN_MULTIPLIER) = 21 damage if it embeds
	throw_speed = 4
	embedding = list("embedded_pain_multiplier" = 3, "embed_chance" = 25, "embedded_fall_chance" = 25)
	w_class = WEIGHT_CLASS_SMALL
	sharpness = IS_SHARP
	resistance_flags = FLAMMABLE


// boomerangs

/obj/item/boomerang
	name = "boomerang"
	desc = "Return to sender!"
	icon = 'hippiestation/icons/obj/weapons.dmi'
	icon_state = "boomerang"
	item_state = "boomerang"
	force = 6
	throwforce = 12
	attack_verb = list("hits","knocks","decks")
	throw_speed = 3
	throw_range = 8
	slot_flags = ITEM_SLOT_BELT
	var/mob/living/carbon/sender //Person who threw the boomerang
	var/ignore_martial_arts = 0
	var/catch_failed = 0
	var/catch_chance = 40
	var/return_delay = 4
	var/throw_sound = 'hippiestation/sound/effects/swoosh1.ogg'

/obj/item/boomerang/throw_impact(atom/hit_atom)
	if(!istype(src, /obj/item/boomerang/repeat)) //Checking for repeaterang is shitcode but it works
		if(istype(thrownby, /mob/living/carbon)) //All of this basically makes the boomerang come back to you when someone fails to catch it.
			sender = thrownby
		if(istype(hit_atom, /mob/living/carbon) && hit_atom != sender)
			var/mob/living/carbon/M = hit_atom
			if(M.can_catch_item(0))
				if(!prob(catch_chance))
					if(!M.mind.martial_art || !ignore_martial_arts)	//Martial artists have fast reflexes, so they can easily catch it.
						M.throw_mode_off()
						catch_failed = 1
		..()
		if(catch_failed)
			var/mob/living/carbon/M = hit_atom
			M.throw_mode_on()
			catch_fail_effect(M) //Apply what happens when the person fails to catch the boomerang
			catch_failed = 0
		if(thrownby != null && !istype(src.loc, /mob/living)) //This timer makes the boomerang come back
			addtimer(CALLBACK(src, /obj/item/boomerang/throw_at,sender,throw_range + 2,throw_speed - 2,null,TRUE), return_delay) //boomerang gets thrown back to you

	else //repeaterang logic code below
		var/obj/item/boomerang/repeat/R = src
		if(istype(thrownby, /mob/living/carbon))
			R.returning_to_sender = 0
			sender = thrownby

		if(istype(hit_atom, /turf/open))
			if(R.send_turf == null)
				R.send_turf = get_turf(src)
		else
			R.return_turf = null
			R.send_turf = null
			thrownby = null

		if(!R.switch_turf)
			thrownby = R.return_turf
			R.switch_turf = 1
		else if(R.switch_turf)
			thrownby = R.send_turf
			R.switch_turf = 0
		if(!istype(get_turf(src), /turf/open))
			R.return_turf = null
			R.send_turf = null
			thrownby = null



		if(istype(hit_atom, /mob/living/carbon) && hit_atom != sender)
			var/mob/living/carbon/M = hit_atom
			if(M.can_catch_item(0))
				if(!prob(catch_chance))
					if(!M.mind.martial_art || !ignore_martial_arts)
						M.throw_mode_off()
						catch_failed = 1

		..()
		if(R.returning_to_sender && hit_atom != sender) //If it hits anything on the way back to your person, everything must be null again
			R.returning_to_sender = 0
			thrownby = null
			R.return_turf = null
			R.send_turf = null
			return

		if(catch_failed)
			var/mob/living/carbon/M = hit_atom
			M.throw_mode_on()
			catch_fail_effect(M)
			catch_failed = 0
		if(thrownby != null && !istype(src.loc, /mob/living))
			addtimer(CALLBACK(src, /obj/item/boomerang/throw_at,thrownby,throw_range + 2,throw_speed - 2,null,TRUE), R.return_delay)
			return
		else if(sender != null && !istype(src.loc, /mob/living))
			if(hit_atom != sender) //If you get hit by your own repeaterang, it won't send it back to you since you're already hit.
				addtimer(CALLBACK(src, /obj/item/boomerang/throw_at,sender,throw_range + 2,throw_speed - 2,null,TRUE), R.return_delay)
				R.returning_to_sender = 1
			thrownby = null
			R.return_turf = null
			R.send_turf = null


/obj/item/boomerang/throw_at()
	..()
	src.SpinAnimation(10, 0)
	playsound(src, throw_sound,50,0)

/obj/item/boomerang/proc/catch_fail_effect(mob/user) //what does the boomerang do when someone else fails to catch it?
	to_chat(user, "<span class='warning'>Your hand misses the fast moving [src].")

/obj/item/boomerang/repeat
	name = "repeaterang"
	desc = "Reinforced with titanium to handle the esoteric physical properties of liquid dark matter; the repeaterang is capable of infinite flight within a small radius when accelerated to the velocity of a standard boomerang."
	icon = 'hippiestation/icons/obj/weapons.dmi'
	icon_state = "repeaterang"
	item_state = "repeaterang"
	force = 10
	throwforce = 18
	attack_verb = list("slices", "attacked", "tore", "cut",)
	hitsound = 'hippiestation/sound/effects/steelcut.ogg'
	sharpness = IS_SHARP
	embedding = list("embed_chance" = 0)
	return_delay = 1
	var/turf/return_turf = null
	var/turf/send_turf = null
	var/switch_turf = 0
	var/returning_to_sender = 0

/obj/item/boomerang/repeat/throw_at()
	if(return_turf == null)
		return_turf = get_turf(src)
	..()

/obj/item/boomerang/delimbing
	var/delimb_chance = 10

/obj/item/boomerang/delimbing/chainsaw
	name ="chainerang"
	desc = "Utilizing a bluespace engine oiled by the product of a yet to be discovered lavaland creature to drive its plastitanium supercarbide cutting chain in speeds in excess of ~250000 RPM, this vicious boomerang is capable of cutting flesh as though it were tenderloin."
	icon = 'hippiestation/icons/obj/weapons.dmi'
	icon_state = "chainerang"
	item_state = "chainerang"
	force = 18
	throwforce = 24
	attack_verb = list("slices", "attacked", "torn", "cut",)
	hitsound = 'sound/weapons/chainsawhit.ogg'
	throw_sound = 'hippiestation/sound/weapons/echainsawon.ogg'
	sharpness = IS_SHARP
	throw_range = 14
	embedding = list("embed_chance" = 0)
	catch_chance = 0
	delimb_chance = 15

/obj/item/boomerang/delimbing/chainsaw/catch_fail_effect(mob/living/carbon/user)
	var/obj/item/bodypart/affecting = user.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
	affecting.dismember()
	to_chat(user, "<span class='userdanger'>You try to catch the [src] but it chops your arm off instead!")
	src.visible_message("<span class='boldwarning'>[user] tried to catch the [src] and got their arm chopped off!")

/obj/item/boomerang/delimbing/throw_impact(atom/hit_atom)
	var/list/parts=list()
	if(iscarbon(hit_atom))
		var/mob/living/carbon/C=hit_atom
		if(!(C.in_throw_mode))
			for(var/X in C.bodyparts)
				var/obj/item/bodypart/BP=X
				if(BP.body_part != HEAD && BP.body_part != CHEST)
					if(BP.dismemberable)
						parts += BP
	..()
	if(parts)
		if(!parts.len)
			return FALSE
		var/mob/living/carbon/C = hit_atom
		var/obj/item/bodypart/BP=pick(parts)
		if(prob(delimb_chance))
			BP.dismember()
			playsound(C,pick(hitsound), 50, 0)

/obj/item/boomerang/butterang
	name = "butterang"
	desc = "Return to sender! It appears to be 3 asses crudely duct taped together."
	icon = 'hippiestation/icons/obj/weapons.dmi'
	icon_state = "butterang"
	item_state = "butterang"
	attack_verb = list("smacks", "attacked", "asses",)
	hitsound = 'hippiestation/sound/effects/fart.ogg'
	throw_sound = 'hippiestation/sound/weapons/fartswoosh.ogg'
	embedding = list("embed_chance" = 0)
	throw_speed = 2.5
	var/anti_abuse_counter = 30 //prevent miasma spawning abuse
	var/fart_message = 1

/obj/item/boomerang/butterang/throw_impact()
	..()
	if(anti_abuse_counter > 1)
		spawnfartgas(src)
		spawnfartgas(src)
		anti_abuse_counter--
	else if(fart_message)
		src.visible_message("<span class='boldwarning'>The [src] tries to produce gas, but there is nothing left!")
		fart_message = 0

/obj/item/boomerang/riot
	name = "riot boomerang"
	desc = "Return to sender! A riot variant of the boomerang for quick, non-lethal takedowns. Includes improved aerodynamic fins for long distance returns."
	icon_state = "riot"
	hitsound = 'hippiestation/sound/weapons/armstrong_punch.ogg'
	throwforce = 3
	catch_chance = 20
	throw_range = 14
	var/stamina_damage = 23

/obj/item/boomerang/riot/throw_impact(atom/hit_atom)
	..()
	if(istype(hit_atom, /mob/living))
		var/mob/living/M = hit_atom
		if(src.loc != M)
			M.adjustStaminaLoss(stamina_damage)

/obj/item/boomerang/riot/catch_fail_effect(mob/living/user) //You try and catch the riot boomerang, you get dunked
	user.Knockdown(50)
	user.apply_damage(damage = 5, damagetype = BRUTE, def_zone = BODY_ZONE_HEAD)
	playsound(src, 'hippiestation/sound/effects/bonk.ogg', 100, 0)
	to_chat(user, "<span class='danger'>You attempt to catch the [src], but you whiff and it hits you on the head!")
	src.visible_message("<span class='boldwarning'>[user] is hit on the head by the [src]!")

//
