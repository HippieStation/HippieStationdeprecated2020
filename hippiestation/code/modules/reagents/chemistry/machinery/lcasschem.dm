/obj/machinery/chem
	density = TRUE
	anchored = TRUE
	icon = 'hippiestation/icons/obj/chemical.dmi'
	resistance_flags = FIRE_PROOF | ACID_PROOF
	use_power = IDLE_POWER_USE
	idle_power_usage = 10
	var/obj/item/reagent_containers/beaker = null
	var/on = FALSE

/obj/machinery/chem/Initialize()
	. = ..()
	START_PROCESSING(SSfastprocess, src)

/obj/machinery/chem/Destroy()
	replace_beaker()
	return ..()

/obj/machinery/chem/examine(mob/user)
	..()
	if(panel_open)
		to_chat(user, "<span class='notice'>[src]'s maintenance hatch is open!</span>")

/obj/machinery/chem/on_deconstruction()
	replace_beaker()

/obj/machinery/chem/proc/replace_beaker(mob/living/user, obj/item/reagent_containers/new_beaker)
	if(beaker)
		beaker.forceMove(drop_location())
		if(user && Adjacent(user) && !issiliconoradminghost(user))
			user.put_in_hands(beaker)
	if(new_beaker)
		beaker = new_beaker
	else
		beaker = null
	update_icon()
	return TRUE

/obj/machinery/chem/AltClick(mob/living/user)
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	replace_beaker(user)
	return

/obj/machinery/chem/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, icon_state, icon_state, I))
		return

	if(default_deconstruction_crowbar(I))
		return

	if(istype(I, /obj/item/reagent_containers) && !(I.item_flags & ABSTRACT) && I.is_open_container())
		. = TRUE //no afterattack
		var/obj/item/reagent_containers/B = I
		if(!user.transferItemToLoc(B, src))
			return
		replace_beaker(user, B)
		to_chat(user, "<span class='notice'>You add [B] to [src].</span>")
		updateUsrDialog()
		update_icon()
		return
	return ..()

/obj/machinery/chem/pressure//yes i'm shamelessly copying chem heater code, no don't worry this is much better than the old code
	name = "Pressurized reaction chamber"
	desc = "Creates high pressures to suit certain reaction conditions"
	icon_state = "press"
	var/pressure = 0
	var/pressure_rate = 5
	var/max_pressure = 100
	circuit = /obj/item/circuitboard/machine/pressure

/obj/machinery/chem/pressure/RefreshParts()
	pressure_rate = initial(pressure_rate)
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		pressure_rate *= M.rating

/obj/machinery/chem/pressure/examine(mob/user)
	..()
	if(in_range(user, src) || isobserver(user))
		to_chat(user, "<span class='notice'>The status display reads: <br>Pressure rate at <b>[pressure_rate] psi</b> per interval.<span>")

/obj/machinery/chem/pressure/process()
	..()
	if(stat & NOPOWER)
		return
	if(on)
		pressure = min(pressure += pressure_rate, max_pressure)
	if(beaker)
		if(beaker.reagents.chem_pressure != pressure)
			beaker.reagents.chem_pressure = pressure
			beaker.reagents.chem_pressure = round(beaker.reagents.chem_pressure)
			beaker.reagents.handle_reactions()
	if(!on)
		pressure = max(pressure -= pressure_rate, 0)

/obj/machinery/chem/pressure/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "chem_pressure", name, 400, 400, master_ui, state)
		ui.open()

/obj/machinery/chem/pressure/ui_data()
	var/data = list()
	data["isActive"] = on
	data["isBeakerLoaded"] = beaker ? TRUE : FALSE
	data["internalPressure"] = pressure
	data["currentPressure"] = beaker ? beaker.reagents.chem_pressure : null
	data["beakerCurrentVolume"] = beaker ? beaker.reagents.total_volume : null
	data["beakerMaxVolume"] = beaker ? beaker.volume : null
	data["maxPressure"] = max_pressure

	var beakerContents[0]
	if(beaker)
		for(var/I in beaker.reagents.reagent_list)
			var/datum/reagent/R = I
			beakerContents.Add(list(list("name" = R.name, "volume" = R.volume))) // list in a list because Byond merges the first list...
	data["beakerContents"] = beakerContents
	return data

/obj/machinery/chem/pressure/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("power")
			on = !on
			. = TRUE
		if("eject")
			replace_beaker(usr)
			. = TRUE

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/chem/radioactive//break up in action dust I walk my brow and I strut my
	name = "Radioactive molecular reassembler"
	desc = "A mystical machine that changes molecules directly on the level of bonding."
	icon_state = "radio"
	var/material_amt = 0 //requires uranium in order to function
	var/target_radioactivity = 0
	var/max_rads = 1
	var/material_rate = 50
	var/pulse_prob = 50
	var/material_storage = 50000
	var/rad_pulse = 4000
	circuit = /obj/item/circuitboard/machine/radioactive

/obj/machinery/chem/radioactive/RefreshParts()
	material_rate = initial(material_rate)
	pulse_prob = initial(pulse_prob)
	material_storage = initial(material_storage)
	max_rads = initial(max_rads)
	rad_pulse = initial(rad_pulse)
	for(var/obj/item/stock_parts/micro_laser/ML in component_parts)
		material_rate /= ML.rating
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		pulse_prob /= C.rating
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		material_storage *= MB.rating
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		max_rads *= M.rating
		rad_pulse /= M.rating

/obj/machinery/chem/radioactive/examine(mob/user)
	..()
	if(in_range(user, src) || isobserver(user))
		to_chat(user, "<span class='notice'>The status display reads: <br>Material consumption at <b>[material_rate] units</b> per interval.<br>Radioactive contamination chance at <b>[pulse_prob]</b>% with <b>[rad_pulse] rads</b> per pulse.<br>Material storage size of <b>[material_storage/1000] sheets</b>.<br>Radioactive rate of <b>[max_rads] rads</b> per interval.<span>")

/obj/machinery/chem/radioactive/process()
	..()
	if(stat & NOPOWER)
		return
	if(on && beaker)
		icon_state = "radio_on"
		if(material_amt < material_rate)
			audible_message("<span class='notice'>The [src] pings in fury: showing the empty reactor indicator!.</span>")
			playsound(src, 'sound/machines/buzz-two.ogg', 60, 0)
			on = FALSE

		if(beaker.reagents.chem_radioactivity == target_radioactivity && target_radioactivity != 0)
			visible_message("<span class='notice'> A green light shows on the [src].</span>")
			playsound(src, 'sound/machines/ping.ogg', 50, 0)
			on = FALSE
		if(material_amt >= material_rate)
			if(beaker.reagents.chem_radioactivity > target_radioactivity)
				beaker.reagents.chem_radioactivity += max_rads
			if(beaker.reagents.chem_radioactivity < target_radioactivity)
				beaker.reagents.chem_radioactivity += max_rads

			beaker.reagents.chem_radioactivity = round(beaker.reagents.chem_radioactivity)
			beaker.reagents.handle_reactions()
			material_amt = max(material_amt -= material_rate, 0)
			if(prob(pulse_prob))
				radiation_pulse(src, min(rad_pulse, target_radioactivity * 200), 4, TRUE)
	if(!on)
		icon_state = "radio"

/obj/machinery/chem/radioactive/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stack/sheet/mineral/uranium))
		. = TRUE //no afterattack
		if(material_amt >= material_storage)
			to_chat(user, "<span class='warning'>The [src] is full!</span>")
			return
		to_chat(user, "<span class='notice'>You add the uranium to the [src].</span>")
		var/obj/item/stack/sheet/mineral/uranium/U = I
		material_amt = CLAMP(material_amt += U.amount * 1000, 0, material_storage)//50-200 sheets max
		user.dropItemToGround(I)
		qdel(I)//it's a var now
		return
	..()

/obj/machinery/chem/radioactive/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "chem_radioactive", name, 275, 400, master_ui, state)
		ui.open()

/obj/machinery/chem/radioactive/ui_data()
	var/data = list()
	data["targetRadioactivity"] = target_radioactivity
	data["isActive"] = on
	data["isBeakerLoaded"] = beaker ? TRUE : FALSE
	data["materialAmount"] = material_amt
	data["materialStorage"] = material_storage
	data["currentRadioactivity"] = beaker ? beaker.reagents.chem_radioactivity : null
	data["beakerCurrentVolume"] = beaker ? beaker.reagents.total_volume : null
	data["beakerMaxVolume"] = beaker ? beaker.volume : null

	var beakerContents[0]
	if(beaker)
		for(var/I in beaker.reagents.reagent_list)
			var/datum/reagent/R = I
			beakerContents.Add(list(list("name" = R.name, "volume" = R.volume))) // list in a list because Byond merges the first list...
	data["beakerContents"] = beakerContents
	return data

/obj/machinery/chem/radioactive/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("power")
			on = !on
			. = TRUE
		if("irradiate")
			var/target = params["target"]
			var/adjust = text2num(params["adjust"])
			if(target == "input")
				target = input("New target radioactivity:", name, target_radioactivity) as num|null
				if(!isnull(target) && !..())
					. = TRUE
			else if(adjust)
				target = target_radioactivity + adjust
			else if(text2num(target) != null)
				target = text2num(target)
				. = TRUE
			if(.)
				target_radioactivity = CLAMP(target, 0, 20)
		if("eject")
			on = FALSE
			replace_beaker(usr)
			. = TRUE

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/chem/bluespace
	name = "Bluespace recombobulator"
	desc = "Forget changing molecules , this thing changes the laws of physics itself in order to produce chemicals."
	icon_state = "blue"
	var/crystal_amt = 0
	var/intensity = 0
	var/max_intensity = 30
	var/material_storage = 10
	var/glitch_prob = 20
	circuit = /obj/item/circuitboard/machine/bluespace

/obj/machinery/chem/bluespace/RefreshParts()
	max_intensity = initial(max_intensity)
	material_storage = initial(material_storage)
	glitch_prob = initial(glitch_prob)
	for(var/obj/item/stock_parts/micro_laser/M in component_parts)
		max_intensity *= M.rating
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		glitch_prob /= C.rating
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		material_storage *= MB.rating

/obj/machinery/chem/bluespace/examine(mob/user)
	..()
	if(in_range(user, src) || isobserver(user))
		to_chat(user, "<span class='notice'>The status display reads: <br>Max intensity of <b>[max_intensity] B units</b>.<br>Malfunction probably at <b>[glitch_prob]</b>%.<br>Max material storage size of <b>[material_storage] crystals</b>.<span>")

/obj/machinery/chem/bluespace/process()
	..()
	if(stat & NOPOWER)
		return
	if(on && beaker)
		icon_state = "blue_on"
		if(crystal_amt < (intensity * 0.005))
			audible_message("<span class='notice'>The [src] pings in fury: showing a lack of bluespace activity!.</span>")
			playsound(src, 'sound/machines/buzz-two.ogg', 60, 0)
			on = FALSE
		if(beaker.reagents.chem_bluespaced == TRUE)
			beaker.reagents.handle_reactions()
			visible_message("<span class='notice'> A green light shows on the [src].</span>")
			playsound(src, 'sound/machines/ping.ogg', 50, 0)
			on = FALSE
		if(beaker && crystal_amt >= (intensity * 0.005))
			if(prob(intensity * 2))
				beaker.reagents.chem_bluespaced = TRUE
			beaker.reagents.handle_reactions()
			crystal_amt = max(crystal_amt -= intensity * 0.005, 0)
			if(prob(glitch_prob))//low chance but could still happen
				do_sparks(4)
				for(var/mob/living/L in range(2,src))//boy is this thing nasty!
					to_chat(L, ("<span class=\"warning\">You feel disorientated!</span>"))
					do_teleport(L, get_turf(L), 5, asoundin = 'sound/effects/phasein.ogg')
	if(!on)
		icon_state = "blue"

/obj/machinery/chem/bluespace/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stack/ore/bluespace_crystal))
		. = TRUE //no afterattack
		if(crystal_amt >= material_storage)
			to_chat(user, "<span class='warning'>The [src] is full!</span>")
			return
		to_chat(user, "<span class='notice'>You add the bluespace material to the [src].</span>")
		crystal_amt += 1//10-40 crystals max
		user.dropItemToGround(I)
		qdel(I)//it's a var now
		return
	..()
/obj/machinery/chem/bluespace/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "chem_bluespace", name, 400, 400, master_ui, state)
		ui.open()

/obj/machinery/chem/bluespace/ui_data()
	var/data = list()
	data["intensity"] = intensity
	data["isActive"] = on
	data["isBeakerLoaded"] = beaker ? TRUE : FALSE
	data["crystalAmount"] = crystal_amt
	data["isBluespaced"] = beaker ? beaker.reagents.chem_bluespaced : null
	data["beakerCurrentVolume"] = beaker ? beaker.reagents.total_volume : null
	data["beakerMaxVolume"] = beaker ? beaker.volume : null
	data["maxMaterial"] = material_storage

	var beakerContents[0]
	if(beaker)
		for(var/I in beaker.reagents.reagent_list)
			var/datum/reagent/R = I
			beakerContents.Add(list(list("name" = R.name, "volume" = R.volume))) // list in a list because Byond merges the first list...
	data["beakerContents"] = beakerContents
	return data

/obj/machinery/chem/bluespace/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("power")
			on = !on
			. = TRUE
		if("bluespace")
			var/target = params["target"]
			var/adjust = text2num(params["adjust"])
			if(target == "input")
				target = input("New emitter intensity:", name, intensity) as num|null
				if(!isnull(target) && !..())
					. = TRUE
			else if(adjust)
				target = intensity + adjust
			else if(text2num(target) != null)
				target = text2num(target)
				. = TRUE
			if(.)
				intensity = CLAMP(target, 0, max_intensity)
		if("eject")
			on = FALSE
			replace_beaker(usr)
			. = TRUE

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/chem/centrifuge
	name = "Centrifuge"
	desc = "Spins chemicals at high speeds to seperate them"
	icon_state = "cent_off"
	var/time_required = 10
	var/time = 0
	circuit = /obj/item/circuitboard/machine/centrifuge

/obj/machinery/chem/centrifuge/RefreshParts()
	time_required = initial(time_required)
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		time_required /= M.rating

/obj/machinery/chem/centrifuge/examine(mob/user)
	..()
	if(in_range(user, src) || isobserver(user))
		to_chat(user, "<span class='notice'>The status display reads: <br>Processing time of <b>[time_required] seconds</b>.<span>")

/obj/machinery/chem/centrifuge/process()
	..()
	if(stat & NOPOWER)
		return
	if(on && beaker)
		icon_state = "cent_on"
		if(time >= time_required)
			visible_message("<span class='notice'> A green light shows on the [src].</span>")
			playsound(src, 'sound/machines/ping.ogg', 50, 0)
			on = FALSE
			beaker.reagents.chem_centrifuged = TRUE
			beaker.reagents.handle_reactions()
			time = 0

		else if(time < time_required)
			time++
	if(!on)
		icon_state = "cent_off"

/obj/machinery/chem/centrifuge/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "chem_centrifuge", name, 275, 400, master_ui, state)
		ui.open()

/obj/machinery/chem/centrifuge/ui_data()
	var/data = list()
	data["isActive"] = on
	data["isBeakerLoaded"] = beaker ? TRUE : FALSE
	data["timeRemaining"] = time_required - time
	data["timeRequired"] = time_required
	data["beakerCurrentVolume"] = beaker ? beaker.reagents.total_volume : null
	data["beakerMaxVolume"] = beaker ? beaker.volume : null
	var beakerContents[0]
	if(beaker)
		for(var/I in beaker.reagents.reagent_list)
			var/datum/reagent/R = I
			beakerContents.Add(list(list("name" = R.name, "volume" = R.volume))) // list in a list because Byond merges the first list...
	data["beakerContents"] = beakerContents
	return data

/obj/machinery/chem/centrifuge/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("power")
			on = !on
			. = TRUE
		if("eject")
			on = FALSE
			replace_beaker(usr)
			. = TRUE

/obj/machinery/chem/centrifuge/replace_beaker()
	..()
	time = 0
