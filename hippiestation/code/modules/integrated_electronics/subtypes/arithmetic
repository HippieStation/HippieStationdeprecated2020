// -Max- //
/obj/item/integrated_circuit/arithmetic/max
	name = "max circuit"
	desc = "This circuit sends out the highest number."
	extended_desc = "The highest number is put out. Null is ignored."
	icon_state = "addition"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/min_comparision = FALSE

/obj/item/integrated_circuit/arithmetic/max/do_work()
	var/result
	for(var/k in 1 to inputs.len)
		var/I = get_pin_data(IC_INPUT, k)
		if(!isnum(I))	continue
		if(!isnum(result) || (!min_comparision && I > result) || (min_comparision && I < result))
			result = I
	if(!isnum(result))
		result = 0
	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// -Min- //
/obj/item/integrated_circuit/arithmetic/max/min
	name = "min circuit"
	desc = "This circuit sends out the smallest number."
	extended_desc = "The smallest number is put out. Null is ignored. In case no number is found, 0 is given out."
	min_comparision = TRUE
