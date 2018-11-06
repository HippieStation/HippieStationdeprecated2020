//Makes absorb require a dead person.

/obj/effect/proc_holder/changeling/absorbDNA/sting_action(mob/user)
	var/mob/living/carbon/human/target = user.pulling
	if(target.stat != DEAD)
		to_chat(user, "<span class ='notice'>We cannot absorb a currently living creature. Kill them first.</span>")
		return
	. = ..()
