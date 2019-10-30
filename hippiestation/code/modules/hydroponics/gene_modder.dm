/obj/machinery/plantgenes
	max_yield = 10
	min_production = 1
	max_endurance = 40 // IMPT: ALSO AFFECTS LIFESPAN

/obj/machinery/plantgenes/RefreshParts() // Comments represent the max you can set per tier, respectively. seeds.dm [219] clamps these for us but we don't want to mislead the viewer.
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		if(M.rating > 3)
			max_potency = 100
		else
			max_potency = initial(max_potency) + (M.rating*12) // 62,74,86,98 	 Clamps at 100
		max_yield = initial(max_yield)

	for(var/obj/item/stock_parts/scanning_module/SM in component_parts)
		max_endurance = initial(max_endurance) + (SM.rating * 25) // 35,60,85,100	Clamps at 10min 100max

	for(var/obj/item/stock_parts/micro_laser/ML in component_parts)
		var/wratemod = ML.rating * 2.5
		min_wrate = FLOOR(10-wratemod,1) // 7,5,2,0	Clamps at 0 and 10	You want this low
		min_wchance = 67-(ML.rating*16) // 48,35,19,3 	Clamps at 0 and 67	You want this low
		
	for(var/obj/item/circuitboard/machine/plantgenes/vaultcheck in component_parts)
		if(istype(vaultcheck, /obj/item/circuitboard/machine/plantgenes/vault)) // TRAIT_DUMB BOTANY TUTS
			max_potency = 100
			max_yield = 10
			min_production = 1
			max_endurance = 100
			min_wchance = 0
			min_wrate = 0
