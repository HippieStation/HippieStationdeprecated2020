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
	if(owner.health > HEALTH_THRESHOLD_FULLCRIT) // shittier code but at least it verified works.
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

/datum/status_effect/badmin_stone
	id = "badmin_stone"
	status_type = STATUS_EFFECT_MULTIPLE
	duration = -1
	tick_interval = 10
	alert_type = null
	var/obj/item/badmin_stone/stone
	var/next_msg = 0

/datum/status_effect/badmin_stone/on_creation(mob/living/new_owner, obj/item/badmin_stone/new_stone)
	. = ..()
	if(.)
		stone = new_stone

/datum/status_effect/badmin_stone/Destroy()
	stone = null
	return ..()

/datum/status_effect/badmin_stone/tick()
	var/has_other_stone = FALSE
	if(istype(stone.loc, /obj/item/badmin_gauntlet))
		return
	for(var/obj/item/badmin_stone/IS in owner.GetAllContents())
		if(IS != stone && !istype(IS.loc, /obj/item/badmin_gauntlet))
			has_other_stone = TRUE
	if(!has_other_stone)
		return
	if(world.time >= next_msg)
		owner.visible_message("<span class='danger'>[owner]'s [pick("face", "hands", "arms", "legs")] bruises a bit...</span>", "<span class='userdanger'>Your body can't handle holding two badmin stones at once!</span>")
		next_msg = world.time + rand(10 SECONDS, 25 SECONDS)
	owner.adjustBruteLoss(4.5) // starting at 7 damage for 2 stones, plus 4.5 damage per extra stone.
