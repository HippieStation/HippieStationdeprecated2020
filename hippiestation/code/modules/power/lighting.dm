/obj/machinery/light/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1)
	. = ..()
	if(. && !QDELETED(src))
		if(prob(damage_amount * 10))
			flicker(damage_amount*rand(1,3))

/obj/machinery/light/flicker(var/amount = rand(10, 20))
	set waitfor = 0
	if(flickering)
		return
	flickering = TRUE
	if(on && status == LIGHT_OK)
		visible_message("<span class='warning'>[src] begins flickering!</span>","<span class='italics'>You hear an electrical sparking.</span>")
		for(var/i = 0; i < amount; i++)
			if(status != LIGHT_OK)
				break
			on = !on
			if(prob(18) && !on)//only spark when off so it doesn't occur too much
				do_sparks(1, FALSE, src)
			else if(prob(40))
				bulb_colour = LIGHT_COLOR_BROWN
				playsound(src, pick('sound/effects/sparks1.ogg', 'sound/effects/sparks2.ogg', 'sound/effects/sparks3.ogg', 'sound/effects/sparks4.ogg', 'sound/effects/light_flicker.ogg'), 100, 1)
			update(FALSE)
			sleep(rand(1, 5))
		on = (status == LIGHT_OK)
		bulb_colour = initial(bulb_colour)
		update(FALSE)
	flickering = FALSE