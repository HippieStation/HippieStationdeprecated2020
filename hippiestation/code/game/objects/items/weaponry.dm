/obj/item/wirerod/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/shard))
		var/obj/item/twohanded/spear/S = new /obj/item/twohanded/spear

		remove_item_from_storage(user)
		qdel(I)
		qdel(src)

		user.put_in_hands(S)
		to_chat(user, "<span class='notice'>You fasten the glass shard to the top of the rod with the cable.</span>")

	else if(istype(I, /obj/item/device/assembly/igniter) && !(I.flags_1 & NODROP_1))
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

/obj/item/syndicate/godhand
	name = "God's Wrath"
	desc = "A particularly vengeful god has granted this chaplain its own power."
	icon_state = "disintegrateblue"
	item_state = "disintegrateblue"
	lefthand_file = "hippiestation/icons/mob/inhands/lefthand"
	righthand_file = "hippiestation/icons/mob/inhands/righthand"
	force = 40
	throw_speed = 3
	throw_range = 14
	throwforce = 180//What the fuck?
	w_class = WEIGHT_CLASS_HUGE
	flags_1 = ABSTRACT_1 | NODROP_1 | DROPDEL_1
	HITSOUND = 'sound/magic/clockwork/ratvar_attack.ogg'
	damtype = BURN
	attack_verb = list("destroyed", "decimated", "wrecked", "punished", "judged")