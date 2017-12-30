/mob/living/simple_animal/hostile/asteroid/goliath
	maxHealth = 200
	health = 200
	melee_damage_lower = 20
	melee_damage_upper = 20

/mob/living/simple_animal/hostile/asteroid/goliath/beast/ancient
	maxHealth = 300
	health = 300

/obj/effect/temp_visual/goliath_tentacle/trip()
	var/latched = FALSE
	for(var/mob/living/L in loc)
		if((!QDELETED(spawner) && spawner.faction_check_mob(L)) || L.stat == DEAD)
			continue
		visible_message("<span class='danger'>[src] grabs hold of [L]!</span>")
		L.Stun(50) //What fucking retard thought it was a good idea to give goliaths a 10-second stun, Jesus Christ
		L.adjustBruteLoss(rand(10,15))
		latched = TRUE
	if(!latched)
		retract()
	else
		deltimer(timerid)
		timerid = addtimer(CALLBACK(src, .proc/retract), 10, TIMER_STOPPABLE)
