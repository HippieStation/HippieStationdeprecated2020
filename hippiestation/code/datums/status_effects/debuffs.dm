/datum/status_effect/incapacitating/sleeping

	var/list/cool = list(
	/obj/item/bedsheet/captain,
	/obj/item/bedsheet/syndie,
	/obj/item/bedsheet/medical,
	/obj/item/bedsheet/patriot,
	/obj/item/bedsheet/mime,
	/obj/item/bedsheet/clown,
	/obj/item/bedsheet/rainbow,
	/obj/item/bedsheet/cult
	)

	var/list/supercool = list(
	/obj/item/bedsheet/captain,
	/obj/item/bedsheet/syndie
	)//supercool stuff must also be on the cool list


/datum/status_effect/incapacitating/sleeping/tick()
	var/healing = 10 //	healing/100 per tick. 200 ticks in 40 seconds of sleep
	if((locate(/obj/structure/bed) in owner.loc)) //if in bed +10%
		healing +=10
	else
		if((locate(/obj/structure/table) in owner.loc))//if on a table
			healing +=5


	if((locate(/obj/item/bedsheet) in owner.loc))//if under a bedsheet
		healing +=10


	for(var/i in cool)
		if(locate(i) in owner.loc)
			healing +=5 //from stuff on cool
			break

	for(var/i in supercool)
		if(locate(i) in owner.loc)
			healing +=5//from stuff on supercool
			break

	if(istype(get_turf(owner), /turf/open/space))
		healing/=2 //nerfs space sleep. cant survive to loop back around in space anymore.


	owner.adjustBruteLoss((-healing/100), 0)
	owner.adjustFireLoss((-healing/100), 0)
	owner.adjustToxLoss((-healing/100), 0)

	..()
