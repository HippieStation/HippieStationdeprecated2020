/obj/structure/mirror/magic/attack_hand(mob/living/user)
	if(locate(/obj/item/badmin_gauntlet) in user)
		to_chat(user, "<span class='notice'>The badmin gauntlet interferes with the magic mirror. It won't work.</span>")
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.dna.species.id == "dwarf")
			to_chat(H, "<span class='warning'>You look into the mirror, and...</span>")
			obj_break()
			return
	return ..()