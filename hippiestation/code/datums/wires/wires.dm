/datum/wires/proc/npc_tamper(mob/living/L)
	if(!wires.len)
		return

	var/wire_to_screw = pick(wires)

	if(is_color_cut(wire_to_screw) || prob(50)) //CutWireColour() proc handles both cutting and mending wires. If the wire is already cut, always mend it back. Otherwise, 50% to cut it and 50% to pulse it
		cut(wire_to_screw)
	else
		pulse(wire_to_screw, L)

/proc/is_wire_tool(obj/item/I)
	if(istype(I, /obj/item/device/multitool))
		return TRUE
	if(istype(I, /obj/item/wirecutters))
		return TRUE
	if(istype(I, /obj/item/holotool))
		return TRUE
	if(istype(I, /obj/item/device/assembly))
		var/obj/item/device/assembly/A = I
		if(A.attachable)
			return TRUE
	return

/datum/wires/ui_act(action, params)
	if(..() || !interactable(usr))
		return
	var/target_wire = params["wire"]
	var/mob/living/L = usr
	var/obj/item/I = L.get_active_held_item()
	switch(action)
		if("cut")
			if(istype(I, /obj/item/wirecutters) ||  istype(I, /obj/item/holotool) || IsAdminGhost(usr))
				playsound(holder, I.usesound, 20, 1)
				cut_color(target_wire)
				. = TRUE
			else
				to_chat(L, "<span class='warning'>You need wirecutters!</span>")
		if("pulse")
			if(istype(I, /obj/item/device/multitool) || istype(I, /obj/item/holotool) || IsAdminGhost(usr))
				playsound(holder, 'sound/weapons/empty.ogg', 20, 1)
				pulse_color(target_wire, L)
				. = TRUE
			else
				to_chat(L, "<span class='warning'>You need a multitool!</span>")
		if("attach")
			if(is_attached(target_wire))
				var/obj/item/O = detach_assembly(target_wire)
				if(O)
					L.put_in_hands(O)
					. = TRUE
			else
				if(istype(I, /obj/item/device/assembly))
					var/obj/item/device/assembly/A = I
					if(A.attachable)
						if(!L.temporarilyRemoveItemFromInventory(A))
							return
						if(!attach_assembly(target_wire, A))
							A.forceMove(L.drop_location())
						. = TRUE
					else
						to_chat(L, "<span class='warning'>You need an attachable assembly!</span>")
