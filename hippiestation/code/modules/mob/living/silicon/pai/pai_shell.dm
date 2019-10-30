/mob/living/silicon/pai/fold_out(force = FALSE)
	if(istype(remote_control,/obj/item/integrated_circuit/input/pAI_connector))
		to_chat(src,"<span class='notice'>The connector is too small to allow you to change form in it.</span>")
		return FALSE
	return(..(force))
