/obj/structure/mirror/magic/attack_hand(mob/user)
	if(locate(/obj/item/infinity_gauntlet) in user)
		to_chat(user, "<span class='notice'>The badmin gauntlet interferes with the magic mirror. It won't work.</span>")
		return
	return ..()
