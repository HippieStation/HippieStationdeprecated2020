/*
 * Gang Boss Pens
 */
/obj/item/pen/gang
	var/cooldown
	var/last_used

/obj/item/pen/gang/New()
	..()
	last_used = world.time

/obj/item/pen/gang/attack(mob/living/M, mob/user, stealth = TRUE)
	if(!istype(M))
		return
	if(!ishuman(M) || !ishuman(user) || M.stat == DEAD)
		return ..()
	var/datum/antagonist/gang/boss/L = user.mind.has_antag_datum(/datum/antagonist/gang/boss)
	if(!L)
		return ..()
	if(!..())
		return
	if(cooldown)
		to_chat(user, "<span class='warning'>[src] needs more time to recharge before it can be used.</span>")
		return
	if(!M.client)
		to_chat(user, "<span class='warning'>A braindead gangster is an useless gangster!</span>")
		return
	var/datum/team/gang/gang = L.gang
	something_that_makes_this_dude_a_gangster()
	cooldown = TRUE
	icon_state = "pen_blink"
	var/cooldown_time = 600+(600*gang.leaders.len)
	addtimer(CALLBACK(src, .proc/cooldown), cooldown_time)

/obj/item/pen/gang/proc/cooldown()
	cooldown = FALSE
	icon_state = "pen"
	var/mob/M = loc
	if(istype(M))
		to_chat(M, "<span class='notice'>[icon2html(src, M)] [src][(loc == M)?(""):(" in your [loc]")] vibrates softly. It is ready to be used again.</span>")