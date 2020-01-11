#define WINTER_LOW 247.039 // -15 degrees Fahrenheit
#define WINTER_TEMP_FACTOR 0.85

GLOBAL_VAR(winter_starttemp)
GLOBAL_VAR(winter_timer)
GLOBAL_VAR_INIT(winter_starttime, 0)
GLOBAL_VAR_INIT(winter, FALSE)
GLOBAL_LIST_INIT(winter_blacklisted_areas, typecacheof(list(/area/engine/supermatter, /area/space, /area/science/mixing/chamber)))
GLOBAL_LIST_INIT(winter_blacklisted_tiles, typecacheof(list(/turf/open/floor/engine/vacuum, /turf/open/floor/engine/air, /turf/open/floor/engine/n2o, /turf/open/floor/engine/co2, /turf/open/floor/engine/plasma, /turf/open/floor/engine/o2, /turf/open/floor/plasteel/dark/telecomms)))

/proc/StartWinter()
	if(!SSticker.IsRoundInProgress())
		to_chat(usr, "<span class='notice'>The round hasn't started or has ended!</span>")
		return
	if(GLOB.winter)	
		to_chat(usr, "<span class='notice'>Winter is already active!</span>")
		return
	GLOB.winter_starttemp = GLOB.winter_starttemp || T20C
	var/first_time = TRUE
	if(GLOB.winter_starttemp != T20C)
		first_time = FALSE
		if(alert("It appears winter has been ran previously. It stopped at [GLOB.winter_starttemp * (9/5) - 459.67] Fahrenheit. Keep this temperature?",,"Yes","No") == "No")
			GLOB.winter_starttemp = T20C
	if(alert("Are you SURE you want to begin winter? This will cause station-wide effects!",,"Yes","No") == "No")
		return
	GLOB.winter = TRUE
	GLOB.winter_starttime = world.time
	if(alert("Announce winter to the station?",,"Yes","No") == "Yes")
		priority_announce("The Central Command Space Weather Service has detected a space winter storm headed your way.\nExpect extremely low temperatures, and higher coffee prices.", "Space Weather Alert")
	if(first_time)
		for(var/obj/machinery/vending/V in GLOB.machines)
			for(var/datum/data/vending_product/R in (V.product_records + V.coin_records + V.hidden_records))
				if(R.product_path in list(/obj/item/reagent_containers/food/drinks/coffee, /obj/item/reagent_containers/food/drinks/mug/tea, /obj/item/reagent_containers/food/drinks/mug/coco))
					R.amount = FLOOR(R.amount / 2, 1)
					R.custom_price = (R.custom_price || V.default_price) * 2
	message_admins("[key_name_admin(usr)] has started winter.")
	log_admin("[key_name(usr)] has started winter.")
	GLOB.winter_timer = addtimer(CALLBACK(GLOBAL_PROC, .proc/ProgressWinter), 15 SECONDS, TIMER_STOPPABLE|TIMER_UNIQUE)

/proc/StopWinter()
	if(!GLOB.winter)	
		to_chat(usr, "<span class='notice'>Winter isn't active.</span>")
		return
	if(alert("Are you SURE you want to stop winter?",,"Yes","No") == "No")
		return
	GLOB.winter = FALSE
	message_admins("[key_name_admin(usr)] has stopped winter.")
	log_admin("[key_name(usr)] has stopped winter.")
	if(GLOB.winter_timer)
		deltimer(GLOB.winter_timer)

/proc/ProgressWinter()
	if(!GLOB.winter)
		return
	var/mins = (world.time - GLOB.winter_starttime) / 600
	var/new_temp = max(WINTER_LOW, GLOB.winter_starttemp - (mins * 1.75) * WINTER_TEMP_FACTOR)
	//var/fahrenheit = new_temp * (9/5) - 459.67
	var/list/turfs = list()
	for(var/z in SSmapping.levels_by_trait(ZTRAIT_STATION))
		turfs += block(locate(1,1,z), locate(world.maxx,world.maxy,z))
	for(var/turf/open/O in turfs)
		if(is_type_in_typecache(O, GLOB.winter_blacklisted_tiles))
			continue
		if(is_type_in_typecache(O.loc, GLOB.winter_blacklisted_areas))
			continue
		var/datum/gas_mixture/env = O.return_air()
		if(!env)
			continue
		var/heat_capacity = env.heat_capacity()
		var/requiredPower = min(abs(env.temperature - new_temp) * heat_capacity, 35000)

		if(requiredPower < 1)
			continue

		var/deltaTemperature = requiredPower / (heat_capacity * 2)
		if(deltaTemperature)
			env.temperature -= deltaTemperature
			O.air_update_turf()
			O.temperature = env.temperature
	GLOB.winter_timer = addtimer(CALLBACK(GLOBAL_PROC, .proc/ProgressWinter), 15 SECONDS, TIMER_STOPPABLE|TIMER_UNIQUE)
