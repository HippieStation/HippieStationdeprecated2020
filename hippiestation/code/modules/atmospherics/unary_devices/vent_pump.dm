/obj/machinery/atmospherics/components/unary/vent_pump
	var/cover = 0 //For hiding tiny objects in, 1 means cover is up, can hide.
	var/max_n_of_items = 5

/obj/machinery/atmospherics/components/unary/vent_pump/crowbar_act(mob/living/user, obj/item/I)
	if(I.use_tool(src, user, 50, volume=50))
		cover = !cover
		to_chat(user, "<span class='notice'>You pry [cover ? "off" : "in"] the vent cover.</span>")
	return TRUE

/obj/machinery/atmospherics/components/unary/vent_pump/attackby(obj/item/W, mob/user, params)
	if(cover)
		if(W.w_class == WEIGHT_CLASS_TINY && istype(W,/obj/item) && !istype(W,/obj/item/stack) && user.a_intent != INTENT_HARM)
			if(contents.len>=max_n_of_items || !user.transferItemToLoc(W, src))
				to_chat(user, "<span class='warning'>You can't seem to fit [W].</span>")
				return
			to_chat(user, "<span class='warning'>You insert [W] into [src].</span>")
			return
	..()

/obj/machinery/atmospherics/components/unary/vent_pump/attack_hand(mob/user)
	if(cover)
		if(!contents.len)
			to_chat(user, "<span class='warning'>There's nothing in [src]!</span>")
			return
		var/obj/item/I = contents[contents.len] //the most recently-added item
		user.put_in_hands(I)
		to_chat(user, "<span class='notice'>You take out [I] from [src].</span>")
	..()

/obj/machinery/atmospherics/components/unary/vent_pump/examine(mob/user)
	..()
	if(cover)
		to_chat(user, "Its cover is open.")
