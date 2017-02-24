/* Misc. Stuff!!
 * Contains:
 *		Duct Tape
 */

/obj/item/clothing/mask/muzzle/tape
	name = "tape"
	desc = "Taking that off is going to hurt."
	icon_state = "tape"
	item_state = "tape"
	strip_delay = 10
	var/used = 0

/obj/item/clothing/mask/muzzle/tape/attack_hand(mob/user as mob)
	if (!user) return
	if (istype(src.loc, /obj/item/weapon/storage))
		return ..()
	var/mob/living/carbon/human/H = user
	if(loc == user && H.wear_mask == src)
		H << "<span class='userdanger'>Your tape was forcefully removed from your mouth. It's not pleasant.</span>"
		playsound(user, 'sound/items/ducttape2.ogg', 50, 1)
		H.apply_damage(2, BRUTE, "head")
		user.emote("scream")
		user.drop_item()
		used = 1
		qdel(src)
	else
		..()

/obj/item/clothing/mask/muzzle/tape/dropped(mob/user as mob)
	if (!user) return
	if (istype(src.loc, /obj/item/weapon/storage) || used)
		return ..()
	var/mob/living/carbon/human/H = user
	..()
	if(H.wear_mask == src && !src.used)
		H << "<span class='userdanger'>Your tape was forcefully removed from your mouth. It's not pleasant.</span>"
		playsound(user, 'sound/items/ducttape2.ogg', 50, 1)
		H.apply_damage(2, BRUTE, "head")
		user.drop_item()
		user.emote("scream")
		qdel(src)
		// H.wear_mask = null
		// H.unEquip(src, 1)
		// user.update_inv_wear_mask(0)

/obj/item/stack/ducttape
	desc = "It's duct tape. You can use it to tape something... or someone."
	name = "duct tape"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape"
	item_state = "tape"
	amount = 15
	max_amount = 15
	throwforce = 0
	w_class = 2.0
	throw_speed = 3
	throw_range = 7

/obj/item/stack/ducttape/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is taping \his entire face with the [src.name]! It looks like \he's trying to commit suicide.</span>")
	return(OXYLOSS)

//I took out crafting recipies

/obj/item/stack/ducttape/afterattack(atom/W, mob/user as mob, proximity_flag)
	if(!proximity_flag) return //It should only work on adjacent target.
	if(ishuman(W) && (user.zone_selected == "mouth"))
		var/mob/living/carbon/human/H = W
		if( \
				(H.head && H.head.flags & HEADCOVERSMOUTH) || \
				(H.wear_mask && H.wear_mask.flags & MASKCOVERSMOUTH) \
			)
			user << "<span class='danger'>You're going to need to remove that mask/helmet first.</span>"
			return
		playsound(loc, 'sound/items/ducttape1.ogg', 30, 1)
		if(do_mob(user, H, 20) && !H.wear_mask)
			// H.wear_mask = new/obj/item/clothing/mask/muzzle/tape(H)
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/muzzle/tape(H), slot_wear_mask)
			user << "<span class='notice'>You tape [H]'s mouth.</span>"
			playsound(loc, 'sound/items/ducttape1.ogg', 50, 1)
			if(src.use(2) == 0)
				user.drop_item()
				qdel(src)
			add_logs(user, H, "mouth-taped")
		else
			user << "<span class='warning'>You fail to tape [H]'s mouth.</span>"