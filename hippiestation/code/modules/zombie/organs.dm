/obj/item/organ/zombie_infection/process()
	if(!owner)
		return
	if(!(src in owner.internal_organs))
		Remove(owner)
	if (causes_damage && !iszombie(owner) && owner.stat != DEAD)
		owner.adjustToxLoss(1)
		if (prob(10))
			to_chat(owner, "<span class='danger'>You feel sick...</span>")
	if(timer_id)
		return
	if(owner.suiciding)
		return
	if(owner.stat != DEAD && !converts_living)
		return
	if(!owner.getorgan(/obj/item/organ/brain))
		return
	var/revive_time = rand(revive_time_min, revive_time_max)
	if(!iszombie(owner))
		to_chat(owner, "<span class='cultlarge'>You can feel your heart stopping, but something isn't right... \
		life has not abandoned your broken form. You can only feel a deep and immutable hunger that \
		not even death can stop, you will rise again!</span>")
		to_chat(owner ,"<span class='big bold'> Do not seek to be cured, do not help any non-zombies in any way, and do not harm your zombie brethren. You are a creature of hunger and violence. </span>")
		owner.grant_language(/datum/language/aphasia)
		owner.remove_language(/datum/language/common)
	to_chat(owner ,"<span class='big bold'>You will revive in [DisplayTimeText(revive_time)]. </span>")
	var/flags = TIMER_STOPPABLE
	timer_id = addtimer(CALLBACK(src, .proc/zombify), revive_time, flags)