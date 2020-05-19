#define HORN_BRAIN_DAMAGE 5

/obj/item/bikehorn/golden/stupidhorn/attack()
	flip_mobs()
	dumbify()
	return ..()

/obj/item/bikehorn/golden/stupidhorn/attack_self(mob/user)
	flip_mobs()
	dumbify()
	..()

/obj/item/bikehorn/golden/stupidhorn/proc/dumbify(mob/living/carbon/M, mob/user)
	var/turf/T = get_turf(src)
	for(M in ohearers(7, T))
		if(ishuman(M) && M.can_hear())
			var/mob/living/carbon/human/H = M
			if(istype(H.ears, /obj/item/clothing/ears/earmuffs))
				continue
		M.adjustBrainLoss(HORN_BRAIN_DAMAGE, 75)
		log_admin("[key_name(user)] dealt brain damage to [key_name(M)] with the Extra annoying bike horn")

#undef HORN_BRAIN_DAMAGE

/obj/item/saxophone
	name = "toy saxophone"
	desc = "Now listen closely."
	icon = 'icons/obj/musician.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/instruments_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/instruments_righthand.dmi'
	icon_state = "saxophone"
	item_state = "saxophone"
	force = 10
	var/last_played = 0
	var/cooldown = 150

/obj/item/saxophone/attack_self(mob/user)
	..()
	if(last_played + cooldown < world.time)
		playsound(src, pick(list('hippiestation/sound/items/sax1.ogg', 'hippiestation/sound/items/sax2.ogg', 'hippiestation/sound/items/sax3.ogg', 'hippiestation/sound/items/sax4.ogg', 'hippiestation/sound/items/sax5.ogg', 'hippiestation/sound/items/sax6.ogg')), 50)
		user.visible_message("<B>[user]</B> lays down a [pick("sexy", "sensuous", "libidinous","spicy","flirtatious","salacious","sizzling","carnal","hedonistic")] riff on [src]!")
		last_played = world.time

/obj/item/guitar
	name = "toy guitar"
	desc = "In the name of..."
	icon = 'icons/obj/musician.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/instruments_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/instruments_righthand.dmi'
	icon_state = "guitar"
	item_state = "guitar"
	force = 10
	var/last_played = 0
	var/cooldown = 180

/obj/item/guitar/attack_self(mob/user)
	..()
	if(last_played + cooldown < world.time)
		playsound(src, pick(list('hippiestation/sound/items/guitar1.ogg', 'hippiestation/sound/items/guitar2.ogg', 'hippiestation/sound/items/guitar3.ogg', 'hippiestation/sound/items/guitar4.ogg', 'hippiestation/sound/items/guitar5.ogg', 'hippiestation/sound/items/guitar6.ogg')), 50)
		user.visible_message("<B>[user]</B> solos a [pick("crazy", "jamming", "rocky", "sexy", "flamboyant", "criminal", "spectacular", "hypnotic", "ROLLING")] riff on [src]!")
		last_played = world.time