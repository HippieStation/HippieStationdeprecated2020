/datum/status_effect/incapacitating/sleeping

	var/list/Cool = list(
	/obj/item/bedsheet/captain,
	/obj/item/bedsheet/syndie,
	/obj/item/bedsheet/medical,
	/obj/item/bedsheet/patriot,
	/obj/item/bedsheet/mime,
	/obj/item/bedsheet/clown,
	/obj/item/bedsheet/rainbow,
	/obj/item/bedsheet/cult
	)

	var/list/SuperCool = list(
	/obj/item/bedsheet/captain,
	/obj/item/bedsheet/syndie
	)//SuperCool stuff must also be on the Cool list


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

	if(istype(get_turf(owner), /turf/open/space))
		probability/=2 //nerfs space sleep. cant survive to loop back around in space anymore.

	//if(prob(probability))	//non rng edit. if we bring back rng, just tab the adjusts and make them -1

	if(probability>0)		//just in case we ever add negatives
		owner.adjustBruteLoss((-probability/100), 0)
		owner.adjustFireLoss((-probability/100), 0)
		owner.adjustToxLoss((-probability/100), 0)

	if(owner.getStaminaLoss())
		owner.adjustStaminaLoss(-0.5) //reduce stamina loss by 0.5 per tick, 10 per 2 seconds
	if(human_owner && human_owner.drunkenness)
		human_owner.drunkenness *= 0.997 //reduce drunkenness by 0.3% per tick, 6% per 2 seconds
	if(prob(20))
		if(carbon_owner)
			carbon_owner.handle_dreams()
		if(prob(10) && owner.health > owner.crit_threshold)
			owner.emote("snore")
