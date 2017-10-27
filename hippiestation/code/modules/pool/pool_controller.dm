
//Originally stolen from paradise. Credits to tigercat2000.
//Modified a lot by Kokojo and Tortellini Tony.
/obj/machinery/poolcontroller
	name = "Pool Controller"
	desc = "A controller for the nearby pool."
	icon = 'hippiestation/icons/turf/pool.dmi'
	icon_state = "poolc_3"
	anchored = TRUE
	density = TRUE
	use_power = TRUE
	idle_power_usage = 75
	var/list/linkedturfs //List contains all of the linked pool turfs to this controller, assignment happens on initialize
	var/temperature = 3 //1-5 Frigid Cool Normal Warm Scalding
	var/srange = 6 //The range of the search for pool turfs, change this for bigger or smaller pools.
	var/linkedmist = list() //Used to keep track of created mist
	var/misted = FALSE //Used to check for mist.
	var/obj/item/reagent_containers/beaker = null
	var/cur_reagent = "water"
	var/drainable = FALSE
	var/drained = FALSE
	var/bloody = 0
	var/obj/machinery/drain/linkeddrain = null
	var/timer = 0 //we need a cooldown on that shit.
	var/reagenttimer = 0 //We need 2.
	var/shocked = FALSE//Shocks morons, like an airlock.
	var/tempunlocked = FALSE
	var/canplus = TRUE
	var/canminus = TRUE
	resistance_flags = INDESTRUCTIBLE|UNACIDABLE

/obj/machinery/poolcontroller/Initialize()
	. = ..()
	wires = new /datum/wires/poolcontroller(src)
	for(var/turf/open/pool/W in range(srange,src)) //Search for /turf/open/beach/water in the range of var/srange
		LAZYADD(linkedturfs, W)
	for(var/obj/machinery/drain/pooldrain in range(srange,src))
		src.linkeddrain = pooldrain

/obj/machinery/poolcontroller/emag_act(user as mob) //Emag_act, this is called when it is hit with a cryptographic sequencer.
	if(!emagged) //If it is not already emagged, emag it.
		to_chat(user, "<span class='warning'>You disable the [src]'s safety features.</span>")
		do_sparks(5, TRUE, src)
		emagged = TRUE
		tempunlocked = TRUE
		drainable = TRUE
		do_sparks(1, 1)
		if(GLOB.adminlog)
			log_say("[key_name(user)] emagged the poolcontroller")
			message_admins("[key_name_admin(user)] emagged the poolcontroller")

/obj/machinery/poolcontroller/attackby(obj/item/W, mob/user)
	if(shocked && !(stat & NOPOWER))
		shock(user,50)

	if(stat & (NOPOWER|BROKEN))
		return

	if(istype(W,/obj/item/reagent_containers/glass/beaker))
		if(beaker)
			to_chat(user, "A beaker is already loaded into the machine.")
			return

		if(W.reagents.total_volume >= 100 && W.reagents.reagent_list.len == 1) //check if full and allow one reageant only.

			for(var/X in W.reagents.reagent_list)
				var/datum/reagent/R = X
				if(R.reagent_state == SOLID)
					to_chat(user, "The pool cannot accept reagents in solid form!.")
					return

				else
					beaker =  W
					user.dropItemToGround(W)
					W.loc = src
					to_chat(user, "You add the beaker to the machine!")
					updateUsrDialog()
					cur_reagent = "[R.name]"

					for(var/I in linkedturfs)
						var/turf/open/pool/P = I
						if(P.reagents)
							P.reagents.clear_reagents()
							P.reagents.add_reagent(R.id, 100)

					if(GLOB.adminlog)
						log_say("[key_name(user)] has changed the pool's chems to [R.name]")
						message_admins("[key_name_admin(user)] has changed the pool's chems to [R.name].")
					timer = 15
		else
			to_chat(user, "<span class='notice'>This machine only accepts full large beakers of one reagent.</span>")
		return

	if (istype(W,/obj/item/screwdriver))
		cut_overlays()
		panel_open = !panel_open
		to_chat(user, "You [panel_open ? "open" : "close"] the maintenance panel.")
		if(panel_open)
			add_overlay("wires")
		return
	else
		return attack_hand(user)


//procs
/obj/machinery/poolcontroller/proc/shock(mob/user, prb)
	if(stat & (BROKEN|NOPOWER))		// unpowered, no shock
		return 0
	if(!prob(prb))
		return 0
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if(electrocute_mob(user, get_area(src), src, 0.7))
		return 1
	else
		return 0

/obj/machinery/poolcontroller/proc/poolreagent()
	for(var/X in linkedturfs)
		var/turf/open/pool/W = X
		for(var/mob/living/carbon/human/swimee in W)
			if(beaker && cur_reagent && W.reagents)
				for(var/Q in W.reagents.reagent_list)
					var/datum/reagent/R = Q
					if(R.reagent_state == SOLID)
						R.reagent_state = LIQUID
				W.reagents.reaction(swimee, VAPOR, 0.03) //3 percent
				for(var/Q in W.reagents.reagent_list)
					var/datum/reagent/R = Q
					swimee.reagents.add_reagent(R.id, 0.5) //osmosis
		for(var/obj/objects in W)
			if(beaker && cur_reagent && W.reagents)
				W.reagents.reaction(objects, VAPOR, 1)
			reagenttimer = 4
	changecolor()


/obj/machinery/poolcontroller/process()
	updatePool() //Call the mob affecting proc)
	if(timer > 0)
		timer--
		updateUsrDialog()
	if(reagenttimer > 0)
		reagenttimer--
	if(stat & (NOPOWER|BROKEN))
		return
	else if(reagenttimer == 0 && !drained)
		poolreagent()

/obj/machinery/poolcontroller/proc/updatePool()
	if(!drained)
		for(var/X in linkedturfs) //Check for pool-turfs linked to the controller.
			var/turf/open/pool/W = X
			for(var/mob/living/M in W) //Check for mobs in the linked pool-turfs.
				switch(temperature) //Apply different effects based on what the temperature is set to.
					if(5) //Scalding
						M.bodytemperature = min(500, M.bodytemperature + 50) //heat mob at 35k(elvin) per cycle

					if(1) //Freezing
						M.bodytemperature = max(0, M.bodytemperature - 60) //cool mob at -35k per cycle, less would not affect the mob enough.
						if(M.bodytemperature <= 50 && !M.stat)
							M.apply_status_effect(/datum/status_effect/freon)

					if(3) //Normal temp does nothing, because it's just room temperature water.

					if(4) //Warm
						M.bodytemperature = min(360, M.bodytemperature + 20) //Heats up mobs till the termometer shows up

					else //Cool
						M.bodytemperature = max(250, M.bodytemperature - 20) //Cools mobs till the termometer shows up
				var/mob/living/carbon/human/drownee = M
				if(drownee.stat == DEAD)
					continue
				if(drownee && drownee.lying && !drownee.internal)
					if(drownee.stat != CONSCIOUS)
						drownee.adjustOxyLoss(9)
						to_chat(drownee, "<span class='danger'>You're quickly drowning!</span>")
					else
						if(!drownee.internal)
							drownee.adjustOxyLoss(4)
							if(prob(35))
								to_chat(drownee, "<span class='danger'>You're lacking air!</span>")

			for(var/obj/effect/decal/cleanable/decal in W)
				CHECK_TICK
				animate(decal, alpha = 10, time = 20)
				QDEL_IN(decal, 25)
				if(istype(decal,/obj/effect/decal/cleanable/blood) || istype(decal, /obj/effect/decal/cleanable/trail_holder))
					bloody = TRUE
	changecolor()

/obj/machinery/poolcontroller/proc/changecolor()
	var/rcolor
	if(beaker && LAZYLEN(beaker.reagents.reagent_list))
		rcolor = mix_color_from_reagents(beaker.reagents.reagent_list)
	for(var/X in linkedturfs)
		var/turf/open/pool/color1 = X
		if(bloody)
			if(rcolor)
				color1.color = BlendRGB(rgb(150, 20, 20), rcolor, 0.5)
				color1.watereffect.color = BlendRGB(rgb(150, 20, 20), rcolor, 0.5)
			else
				color1.color = rgb(150, 20, 20)
				color1.watereffect.color = rgb(150, 20, 20)
		else if(!bloody && rcolor)
			color1.color = rcolor
			color1.watereffect.color = rcolor

		if(!bloody && (!beaker || !LAZYLEN(beaker.reagents.reagent_list)))
			color1.color = null
			color1.watereffect.color = null

/obj/machinery/poolcontroller/proc/miston() //Spawn /obj/effect/mist (from the shower) on all linked pool tiles
	for(var/X in linkedturfs)
		var/turf/open/pool/W = X
		if(W.filled)
			var/M = new /obj/effect/mist(W)
			if(misted)
				return
			linkedmist += M
	misted = TRUE //var just to keep track of when the mist on proc has been called.

/obj/machinery/poolcontroller/proc/mistoff() //Delete all /obj/effect/mist from all linked pool tiles.
	for(var/M in linkedmist)
		qdel(M)
	misted = FALSE //no mist left, turn off the tracking var

/obj/machinery/poolcontroller/proc/handle_temp()
	timer = 10
	mistoff()
	switch(temperature)
		if(1)
			canminus = FALSE
			canplus = TRUE
		if(2)
			if(tempunlocked)
				canminus = TRUE
				canplus = TRUE
			else
				canminus = FALSE
				canplus = TRUE
		if(3)
			canminus = TRUE
			canplus = TRUE
		if(4)
			if(tempunlocked)
				canminus = TRUE
				canplus = TRUE
			else
				canminus = TRUE
				canplus = FALSE
		if(5)
			miston()
			canminus = TRUE
			canplus = FALSE
	icon_state = "poolc_[temperature]"
	update_icon()

/obj/machinery/poolcontroller/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, \
															datum/tgui/master_ui = null, datum/ui_state/state = GLOB.physical_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "poolcontrol", name, 420, 405, master_ui, state)
		ui.open()

/obj/machinery/poolcontroller/ui_data()
	var/list/data = list()
	data["candrain"] = drainable
	data["draining"] = drained
	data["temperature"] = temperature
	data["tempunlocked"] = tempunlocked
	data["linkeddrain"] = linkeddrain
	data["canminus"] = canminus
	data["canplus"] = canplus
	data["chemical"] = cur_reagent
	data["beaker"] = beaker
	data["timer"] = timer

	return data

/obj/machinery/poolcontroller/ui_act(action, params)
	if(..())
		return
	if(timer > 0)
		return
	switch(action)
		if("increase")
			if(canplus)
				temperature += 1
				. = TRUE
			handle_temp()
		if("decrease")
			if(canminus)
				temperature -= 1
				. = TRUE
			handle_temp()
		if("eject")
			if(beaker)
				var/obj/item/reagent_containers/glass/B = beaker
				B.loc = loc
				beaker = null
				. = TRUE
			changecolor()
		if("drain")
			if(drainable)
				mistoff()
				timer = 60
				linkeddrain.active = 1
				linkeddrain.timer = 15
				if(linkeddrain.status == 0)
					new /obj/effect/whirlpool(linkeddrain.loc)
					temperature = 3
				if(linkeddrain.status == 1)
					new /obj/effect/effect/waterspout(linkeddrain.loc)
					temperature = 3
				handle_temp()
				bloody = FALSE
				. = TRUE

/obj/machinery/poolcontroller/attack_hand(mob/user)
	if(shocked && !(stat & NOPOWER))
		shock(user,50)
	if(stat & (NOPOWER|BROKEN))
		return
	user.set_machine(src)
	if(panel_open)
		wires.interact(user)
	..()

/obj/machinery/poolcontroller/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/poolcontroller/attack_alien(mob/user)
	return attack_hand(user)

/obj/machinery/poolcontroller/attack_hulk(mob/user)
	return attack_hand(user)

/obj/machinery/poolcontroller/proc/reset(wire)
	switch(wire)
		if(WIRE_SHOCK)
			if(!wires.is_cut(wire))
				shocked = FALSE
