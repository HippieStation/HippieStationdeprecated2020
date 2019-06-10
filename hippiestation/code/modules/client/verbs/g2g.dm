#define G2G_COOLDOWN 3000

/mob/living
	var/g2g_next = 0

/mob/living/verb/g2g()
	set category = "IC"
	set name = "G2G"
	set desc = "Give your body up to ghosts."

	if(stat == DEAD)
		to_chat("<span class='danger'>You're dead, idiot.</span>")
		return
	if(InCritical())
		to_chat("<span class='danger'>You're nearly dead, idiot.</span>")
		return
	
	if(world.time < g2g_next)
		to_chat(src, "<span class='danger'>You need to wait for [DisplayTimeText(g2g_next-world.time)] to offer again.</span>")
		return
	
	if(is_banned_from(ckey, CATBAN))
		to_chat(src, "<span class='danger'>No getting out of your catban that way!</span>")
		return
	
	if(alert("Are you sure you want to give your body up to ghosts?", "Confirm", "Yes", "No") == "Yes")
		if(world.time < g2g_next)
			to_chat(src, "<span class='danger'>You need to wait for [DisplayTimeText(g2g_next-world.time)] to offer again.</span>")
			return
		g2g_next = world.time + G2G_COOLDOWN
		offer_control(src)

#undef G2G_COOLDOWN
