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
