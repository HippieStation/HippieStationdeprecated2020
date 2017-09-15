/datum/reagent/fuel/unholywater/on_mob_life(mob/living/M)
	if(iscultist(M))
		M.drowsyness = max(M.drowsyness-5, 0)
		M.adjustToxLoss(-3, 0)
		M.adjustOxyLoss(-3, 0)
		M.adjustBruteLoss(-3, 0)
		M.adjustFireLoss(-3, 0)
		M.adjustCloneLoss(-5, 0)
		M.adjustBrainLoss(-3, 0)
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			if(C.blood_volume < BLOOD_VOLUME_NORMAL)
				C.blood_volume += 5
	else
		M.adjustBrainLoss(3)
		M.adjustToxLoss(1, 0)
		M.adjustFireLoss(2, 0)
		M.adjustOxyLoss(2, 0)
		M.adjustBruteLoss(2, 0)
	holder.remove_reagent(src.id, 1)
	return FINISHONMOBLIFE(M)

/datum/reagent/shadowling_blindness_smoke
	name = "odd black liquid"
	id = "blindness_smoke"
	description = "<::ERROR::> CANNOT ANALYZE REAGENT <::ERROR::>"
	color = "#000000" //Complete black (RGB: 0, 0, 0)
	metabolization_rate = 100 //lel

/datum/reagent/shadowling_blindness_smoke/on_mob_life(mob/living/M)
	if(!is_shadow_or_thrall(M))
		to_chat(M, "<span class='warning'><b>You breathe in the black smoke, and your eyes burn horribly!</b></span>")
		M.blind_eyes(5)
		if(prob(25))
			M.visible_message("<b>[M]</b> claws at their eyes!")
			M.Stun(3, 0)
			. = 1
	else
		to_chat(M, "<span class='notice'><b>You breathe in the black smoke, and you feel revitalized!</b></span>")
		M.adjustOxyLoss(-2, 0)
		M.adjustToxLoss(-2, 0)
		. = 1
	return ..() || .

/datum/reagent/water/reaction_turf(turf/open/T, reac_volume)
	. = ..()
	for(var/mob/living/simple_animal/hostile/gremlin/G in src)
		G.divide()

/datum/reagent/arclumin//memechem made in honour of the late arclumin
	name = "Arc-Luminol"
	id = "arclumin"
	description = "You have no idea what the fuck this is but it looks absurdly unstable. It is emitting a sickly glow suggesting ingestion is probably not a great idea."
	reagent_state = LIQUID
	color = "#ffff66" //RGB: 255, 255, 102
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/arclumin/on_mob_life(mob/living/carbon/M)//windup starts off with constant shocking, confusion, dizziness and oscillating luminosity
	M.electrocute_act(1, 1, 1, stun = FALSE) //Override because it's caused from INSIDE of you
	M.set_light(rand(1,3))
	M.confused += 2
	M.dizziness += 4
	if(current_cycle >= 20) //the fun begins as you become a demigod of chaos
		var/turf/open/T = get_turf(holder.my_atom)
		switch(rand(1,5))

			if(1)
				playsound(T, 'sound/magic/lightningbolt.ogg', 50, 1)
				tesla_zap(T, zap_range = 6, power = 1000, explosive = FALSE)//weak tesla zap
				M.Stun(2)

			if(2)
				playsound(T, 'sound/effects/EMPulse.ogg', 30, 1)
				do_teleport(M, T, 5)

			if(3)
				M.randmuti()
				if(prob(75))
					M.randmutb()
				if(prob(1))
					M.randmutg()
				M.updateappearance()
				M.domutcheck()

			if(4)
				empulse(T, 3, 5, 1)

			if(5)
				playsound(T, 'sound/effects/supermatter.ogg', 20, 1)
				radiation_pulse(T, 4, 8, 25, 0)
	..()

/datum/reagent/arclumin/on_mob_delete(mob/living/M)// so you don't remain at luminosity 3 forever
	M.set_light(0)

/datum/reagent/arclumin/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if(method == TOUCH)
		M.electrocute_act(5, 1, 1, stun = FALSE)
		M.set_light(1)
		var/turf/T = get_turf(M)
		do_teleport(M, T, 2)

/datum/reagent/arclumin/reaction_turf(turf/T, reac_volume)
	if(reac_volume >= 7)
		if(!isspaceturf(T))
			var/obj/effect/decal/cleanable/arc/A = locate() in T.contents
			if(!A)
				A = new/obj/effect/decal/cleanable/arc(T)
			A.reagents.add_reagent("arclumin", reac_volume)
