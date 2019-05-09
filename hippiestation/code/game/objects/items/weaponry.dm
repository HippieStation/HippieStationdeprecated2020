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
	.=..()
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
