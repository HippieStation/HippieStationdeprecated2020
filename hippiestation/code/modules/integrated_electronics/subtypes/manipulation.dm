/obj/item/integrated_circuit/manipulation/shocker
	name = "shocker circuit"
	desc = "Used to shock adjacent creatures with electricity."
	icon_state = "shocker"
	extended_desc = "The circuit accepts a reference to creature,who needs to be shocked. It can shock target on adjacent tiles. \
	Severity determines  hardness of shock and it's power consumption. It's given between 0 and 60."
	w_class = WEIGHT_CLASS_TINY
	complexity = 10
	inputs = list("target" = IC_PINTYPE_REF,"severity" = IC_PINTYPE_NUMBER)
	outputs = list()
	activators = list("shock" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 0

/obj/item/integrated_circuit/manipulation/shocker/on_data_written()
	var/s = get_pin_data(IC_INPUT, 2)
	power_draw_per_use = Clamp(s,0,60)*5000000/60

/obj/item/integrated_circuit/manipulation/shocker/do_work()
	..()
	var/turf/T = get_turf(src)
	var/atom/movable/AM = get_pin_data_as_type(IC_INPUT, 1, /mob/living)
	if(!istype(AM,/mob/living)) //Invalid input
		return
	var/mob/living/M = AM
	if(!M.Adjacent(T))
		return //Can't reach
	to_chat(M, "<span class='danger'>You feel a sharp shock!</span>")
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(12, 1, src)
	s.start()
	var/stf=Clamp(get_pin_data(IC_INPUT, 2),0,60)
	M.Knockdown(stf)
	M.apply_effect(STUTTER, stf)