/obj/item/reagent_containers/glass/rag/afterattack(atom/A as obj|turf|area, mob/user,proximity)
	if(!istype(A) || !proximity || !check_allowed_items(A, target_self=1))
		return
	if(iscarbon(A) && A.reagents && reagents.total_volume)
		var/mob/living/carbon/C = A
		var/reagentlist = pretty_string_from_reagent_list(reagents)
		var/log_object = "a damp rag containing [reagentlist]"
		if(user.a_intent == INTENT_HARM && !C.is_mouth_covered())
			reagents.reaction(C, INGEST)
			reagents.trans_to(C, reagents.total_volume)
			C.visible_message("<span class='danger'>[user] has smothered \the [C] with \the [src]!</span>", "<span class='userdanger'>[user] has smothered you with \the [src]!</span>", "<span class='italics'>You hear some struggling and muffled cries of surprise.</span>")
			log_combat(user, C, "smothered", log_object)
		else
			reagents.reaction(C, TOUCH)
			reagents.clear_reagents()
			C.visible_message("<span class='notice'>[user] has touched \the [C] with \the [src].</span>")
			log_combat(user, C, "touched", log_object)
	else if(istype(A, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.
		if(A.is_open_container())
			if(!reagents.total_volume)
				to_chat(user, "<span class='warning'>[src] is empty!</span>")
				return
			if(A.reagents.total_volume >= A.reagents.maximum_volume)
				to_chat(user, "<span class='notice'>[A] is full.</span>")
				return
			var/trans = reagents.trans_to(A, amount_per_transfer_from_this)
			to_chat(user, "<span class='notice'>You transfer [trans] unit\s of the solution to [A].</span>")
		else
			if(reagents.total_volume >= reagents.maximum_volume)
				to_chat(user, "<span class='notice'>[src] is full.</span>")
				return
			if(!A.reagents.total_volume)
				to_chat(user, "<span class='warning'>[A] is empty!</span>")
				return
			else
				var/trans = A.reagents.trans_to(src, amount_per_transfer_from_this)
				to_chat(user, "<span class='notice'>You fill [src] with [trans] unit\s of the contents of [A].</span>")
				return
	else if(A.is_open_container() && A.reagents) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			to_chat(user, "<span class='warning'>[src] is empty!</span>")
			return
		if(A.reagents.total_volume >= A.reagents.maximum_volume)
			to_chat(user, "<span class='notice'>[A] is full.</span>")
			return
		var/trans = reagents.trans_to(A, amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>You transfer [trans] unit\s of the solution to [A].</span>")
	else if(istype(A) && src in user)
		user.visible_message("[user] starts to wipe down [A] with [src]!", "<span class='notice'>You start to wipe down [A] with [src]...</span>")
		if(do_after(user,30, target = A))
			user.visible_message("[user] finishes wiping off [A]!", "<span class='notice'>You finish wiping off [A].</span>")
			SEND_SIGNAL(A, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_MEDIUM)
	return
