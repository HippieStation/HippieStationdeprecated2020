#define GUILLOTINE_DECAP_MIN_SHARP 7
// karma can suck a big fat schlong

/obj/structure/guillotine/drop_blade(mob/user)
	if(buckled_mobs.len && blade_sharpness)
		var/mob/living/carbon/human/H = buckled_mobs[1]
		if(!H)
			return
		var/obj/item/bodypart/head/head = H.get_bodypart("head")
		if (QDELETED(head))
			return
		playsound(src, 'sound/weapons/bladeslice.ogg', 100, 1)
		if(blade_sharpness >= GUILLOTINE_DECAP_MIN_SHARP || head.brute_dam >= 100)
			if(head.brute_dam < 100 && HAS_TRAIT(H, TRAIT_FAT) && prob(50))
				H.emote("scream"); H.apply_damage(15 * blade_sharpness, BRUTE, head)
				log_combat(user, H, "dropped the blade on", src, " non-fatally")
				visible_message("<span class='warning'>[src] fails to chop [H]'s fat neck off!</span>");
				blade_sharpness--
				return
	return ..()
