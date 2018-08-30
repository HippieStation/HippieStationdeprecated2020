/obj/item/electronic_assembly/attackby(obj/item/I, mob/living/user)
	if(can_anchor && default_unfasten_wrench(user, I, 20))
		return
	if(istype(I, /obj/item/integrated_circuit))
		if(!user.canUnEquip(I))
			return FALSE
		if(try_add_component(I, user))
			return TRUE
		else
			for(var/obj/item/integrated_circuit/input/S in assembly_components)
				S.attackby_react(I,user,user.a_intent)
			return ..()
	else if(istype(I, /obj/item/multitool) || istype(I, /obj/item/integrated_electronics/wirer) || istype(I, /obj/item/integrated_electronics/debugger))
		if(opened)
			interact(user)
			return TRUE
		else
			to_chat(user, "<span class='warning'>[src]'s hatch is closed, so you can't fiddle with the internal components.</span>")
			for(var/obj/item/integrated_circuit/input/S in assembly_components)
				S.attackby_react(I,user,user.a_intent)
			return ..()
	else if(istype(I, /obj/item/stock_parts/cell))
		if(!opened)
			to_chat(user, "<span class='warning'>[src]'s hatch is closed, so you can't access \the [src]'s power supplier.</span>")
			for(var/obj/item/integrated_circuit/input/S in assembly_components)
				S.attackby_react(I,user,user.a_intent)
			return ..()
		if(battery)
			to_chat(user, "<span class='warning'>[src] already has \a [battery] installed. Remove it first if you want to replace it.</span>")
			for(var/obj/item/integrated_circuit/input/S in assembly_components)
				S.attackby_react(I,user,user.a_intent)
			return ..()
		I.forceMove(src)
		battery = I
		diag_hud_set_circuitstat() //update diagnostic hud
		playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
		to_chat(user, "<span class='notice'>You slot \the [I] inside \the [src]'s power supplier.</span>")
		return TRUE
	else if(istype(I, /obj/item/integrated_electronics/detailer))
		var/obj/item/integrated_electronics/detailer/D = I
		detail_color = D.detail_color
		update_icon()
	else
		if(user.a_intent != "help")
			return ..()
		var/list/input_selection = list()
		//Check all the components asking for an input
		for(var/obj/item/integrated_circuit/input in assembly_components)
			if((input.demands_object_input && opened) || (input.demands_object_input && input.can_input_object_when_closed))
				var/i = 0
				//Check if there is another component with the same name and append a number for identification
				for(var/s in input_selection)
					var/obj/item/integrated_circuit/s_circuit = input_selection[s]
					if(s_circuit.name == input.name && s_circuit.displayed_name == input.displayed_name && s_circuit != input)
						i++
				var/disp_name= "[input.displayed_name] \[[input]\]"
				if(i)
					disp_name += " ([i+1])"
				//Associative lists prevent me from needing another list and using a Find proc
				input_selection[disp_name] = input

		var/obj/item/integrated_circuit/choice
		if(input_selection)
			if(input_selection.len == 1)
				choice = input_selection[input_selection[1]]
			else
				var/selection = input(user, "Where do you want to insert that item?", "Interaction") as null|anything in input_selection
				if(!check_interactivity(user))
					return ..()
				if(selection)
					choice = input_selection[selection]
			if(choice)
				choice.additem(I, user)
		for(var/obj/item/integrated_circuit/input/S in assembly_components)
			S.attackby_react(I,user,user.a_intent)
		return ..()

/obj/item/electronic_assembly/attack_self(mob/user)
	if(!check_interactivity(user))
		return
	if(opened)
		interact(user)

	var/list/input_selection = list()
	//Check all the components asking for an input
	for(var/obj/item/integrated_circuit/input/input in assembly_components)
		if(input.can_be_asked_input)
			var/i = 0
			//Check if there is another component with the same name and append a number for identification
			for(var/s in input_selection)
				var/obj/item/integrated_circuit/s_circuit = input_selection[s]
				if(s_circuit.name == input.name && s_circuit.displayed_name == input.displayed_name && s_circuit != input)
					i++
			var/disp_name= "[input.displayed_name] \[[input]\]"
			if(i)
				disp_name += " ([i+1])"
			//Associative lists prevent me from needing another list and using a Find proc
			input_selection[disp_name] = input

	var/obj/item/integrated_circuit/input/choice


	if(input_selection)
		if(input_selection.len ==1)
			choice = input_selection[input_selection[1]]
		else
			var/selection = input(user, "What do you want to interact with?", "Interaction") as null|anything in input_selection
			if(!check_interactivity(user))
				return
			if(selection)
				choice = input_selection.[selection]

	if(choice)
		choice.ask_for_input(user)
