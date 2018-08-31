/obj/item/integrated_circuit
	var/demands_object_input = FALSE
	var/can_input_object_when_closed = FALSE

// Can be called via electronic_assembly/attackby(). This also helps in case you want a circuit to behave differently
/obj/item/integrated_circuit/proc/additem(var/obj/item/I, var/mob/living/user)
	attackby(I, user)
