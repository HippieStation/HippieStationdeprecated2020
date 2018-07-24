//These circuits do things with lists, and use special list pins for stability.
/obj/item/integrated_circuit/lists/join
	name = "join circuit"
	desc = "This circuit is a huge fan of shipping. It joins 2 lists together."
	extended_desc = "Elements found in both lists will not be removed and can be found twice in the list."
	inputs = list(
		"list to join" = IC_PINTYPE_LIST,
		"list to join" = IC_PINTYPE_LIST
		)
	outputs = list(
		"joined list" = IC_PINTYPE_LIST
		)
	icon_state = "addition"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/lists/join/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/list/input_list2 = get_pin_data(IC_INPUT, 2)

	set_pin_data(IC_OUTPUT, 1, input_list+input_list2)
	push_data()
	activate_pin(2)
