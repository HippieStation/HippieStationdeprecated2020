/obj/item/teleportation_scroll/teleportscroll(mob/user)
	if(world.time < GLOB.telescroll_time)
		to_chat(user, "<span class='notice bold'>It's too soon to go. You need to wait [DisplayTimeText(GLOB.telescroll_time - world.time)] to go!</span>")
		return
	return ..()
