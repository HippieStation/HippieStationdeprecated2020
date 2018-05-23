/obj/item/wirerod/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/shard))
		var/obj/item/twohanded/spear/S = new /obj/item/twohanded/spear

		remove_item_from_storage(user)
		qdel(I)
		qdel(src)

		user.put_in_hands(S)
		to_chat(user, "<span class='notice'>You fasten the glass shard to the top of the rod with the cable.</span>")

	else if(istype(I, /obj/item/assembly/igniter) && !(I.flags_1 & NODROP_1))
		var/obj/item/melee/baton/cattleprod/hippie_cattleprod/P = new /obj/item/melee/baton/cattleprod/hippie_cattleprod

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
	flags_1 = NODROP_1 | ABSTRACT_1 | DROPDEL_1
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