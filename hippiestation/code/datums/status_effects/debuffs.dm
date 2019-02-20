/datum/status_effect/incapacitating/sleeping/tick()
	var/probability = 10 //probability of heal per tick. 200 ticks in 40 seconds of sleep
	if((locate(/obj/structure/bed) in owner.loc)) //if in bed +10%
		probability +=10
	else
		if((locate(/obj/structure/table) in owner.loc))//if on a table
			probability +=5
	if((locate(/obj/item/bedsheet) in owner.loc))//if under a bedsheet
		probability +=10

	for(var/i in Cool)
		if(locate(i) in owner.loc)
			probability +=5 //from stuff on cool
			break

	for(var/i in SuperCool)
		if(locate(i) in owner.loc)
			probability +=5//from stuff on supercool
			break

	if(prob(probability))
		owner.adjustBruteLoss(-1, 0)
		owner.adjustFireLoss(-1, 0)
		owner.adjustToxLoss(-1, 0)

	if(owner.getStaminaLoss())
		owner.adjustStaminaLoss(-0.5) //reduce stamina loss by 0.5 per tick, 10 per 2 seconds
	if(human_owner && human_owner.drunkenness)
		human_owner.drunkenness *= 0.997 //reduce drunkenness by 0.3% per tick, 6% per 2 seconds
	if(prob(20))
		if(carbon_owner)
			carbon_owner.handle_dreams()
		if(prob(10) && owner.health > owner.crit_threshold)
			owner.emote("snore")