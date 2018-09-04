/mob/living/simple_animal/slime/handle_feeding() //makes slimes gain nutrition faster to buff them for our shorter rounds
	if(!ismob(buckled))
		return
	var/mob/M = buckled

	if(stat)
		Feedstop(silent = TRUE)

	if(M.stat == DEAD) // our victim died
		if(!client)
			if(!rabid && !attacked)
				if(M.LAssailant && M.LAssailant != M)
					if(prob(50))
						if(!(M.LAssailant in Friends))
							Friends[M.LAssailant] = 1
						else
							++Friends[M.LAssailant]
		else
			to_chat(src, "<i>This subject does not have a strong enough life energy anymore...</i>")

		if(M.client && ishuman(M))
			if(prob(85))
				rabid = 1 //we go rabid after finishing to feed on a human with a client.

		Feedstop()
		return

	if(iscarbon(M))
		var/mob/living/carbon/C = M
		C.adjustCloneLoss(rand(4,8)) //doubled from 2,4
		C.adjustToxLoss(rand(2,4)) //doubled from 1,2

		if(prob(10) && C.client)
			to_chat(C, "<span class='userdanger'>[pick("You can feel your body becoming weak!", \
			"You feel like you're about to die!", \
			"You feel every part of your body screaming in agony!", \
			"A low, rolling pain passes through your body!", \
			"Your body feels as if it's falling apart!", \
			"You feel extremely weak!", \
			"A sharp, deep pain bathes every inch of your body!")]</span>")

	else if(isanimal(M))
		var/mob/living/simple_animal/SA = M

		var/totaldamage = 0 //total damage done to this unfortunate animal
		totaldamage += SA.adjustCloneLoss(rand(4,8)) //doubled
		totaldamage += SA.adjustToxLoss(rand(2,4)) //doubled

		if(totaldamage <= 0) //if we did no(or negative!) damage to it, stop
			Feedstop(0, 0)
			return

	else
		Feedstop(0, 0)
		return

	add_nutrition((rand(14, 30) * CONFIG_GET(number/damage_multiplier)))  //was previously 'add_nutrition((rand(7, 15) * CONFIG_GET(number/damage_multiplier)))' before being buffed

	//Heal yourself.
	adjustBruteLoss(-3)
