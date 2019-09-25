/obj/structure/window/reinforced
	state = WINDOW_SCREWED_TO_FRAME

/obj/structure/window/reinforced/examine(mob/user)
	. = ..()
	if(anchored && state == WINDOW_SCREWED_TO_FRAME)
		. += "<span class='notice'>The window is <b>screwed</b> to the frame.</span>"
	else if(anchored && state == WINDOW_IN_FRAME)
		. += "<span class='notice'>The window is <i>unscrewed</i> but <b>pried</b> into the frame.</span>"
	else if(anchored && state == WINDOW_OUT_OF_FRAME)
		. += "<span class='notice'>The window is out of the frame, but could be <i>pried</i> in. It is <b>screwed</b> to the floor.</span>"
	else if(!anchored)
		. += "<span class='notice'>The window is <i>unscrewed</i> from the floor, and could be deconstructed by <b>wrenching</b>.</span>"

/obj/structure/window/reinforced/attackby(obj/item/I, mob/living/user, params)
	if(!can_be_reached(user))
		return TRUE //skip the afterattack
	add_fingerprint(user)
	if(I.tool_behaviour == TOOL_WELDER && user.a_intent == INTENT_HELP)
		if(obj_integrity < max_integrity)
			if(!I.tool_start_check(user, amount=0))
				return

			to_chat(user, "<span class='notice'>You begin repairing [src]...</span>")
			if(I.use_tool(src, user, 40, volume=50))
				obj_integrity = max_integrity
				update_nearby_icons()
				to_chat(user, "<span class='notice'>You repair [src].</span>")
		else
			to_chat(user, "<span class='warning'>[src] is already in good condition!</span>")
		return
	if(!(flags_1&NODECONSTRUCT_1))
		if(I.tool_behaviour == TOOL_SCREWDRIVER)
			I.play_tool_sound(src, 75)
			if(state == WINDOW_SCREWED_TO_FRAME || state == WINDOW_IN_FRAME)
				to_chat(user, "<span class='notice'>You begin to [state == WINDOW_SCREWED_TO_FRAME ? "unscrew the window from":"screw the window to"] the frame...</span>")
				if(I.use_tool(src, user, decon_speed, extra_checks = CALLBACK(src, .proc/check_state_and_anchored, state, anchored)))
					state = (state == WINDOW_IN_FRAME ? WINDOW_SCREWED_TO_FRAME : WINDOW_IN_FRAME)
					to_chat(user, "<span class='notice'>You [state == WINDOW_IN_FRAME ? "unfasten the window from":"fasten the window to"] the frame.</span>")
			else if(state == WINDOW_OUT_OF_FRAME)
				to_chat(user, "<span class='notice'>You begin to [anchored ? "unscrew the frame from":"screw the frame to"] the floor...</span>")
				if(I.use_tool(src, user, decon_speed, extra_checks = CALLBACK(src, .proc/check_state_and_anchored, state, anchored)))
					setAnchored(!anchored)
					to_chat(user, "<span class='notice'>You [anchored ? "fasten the frame to":"unfasten the frame from"] the floor.</span>")
		else if(I.tool_behaviour == TOOL_CROWBAR && (state == WINDOW_OUT_OF_FRAME || state == WINDOW_IN_FRAME))
			to_chat(user, "<span class='notice'>You begin to lever the window [state == WINDOW_OUT_OF_FRAME ? "into":"out of"] the frame...</span>")
			I.play_tool_sound(src, 75)
			if(I.use_tool(src, user, decon_speed, extra_checks = CALLBACK(src, .proc/check_state_and_anchored, state, anchored)))
				state = (state == WINDOW_OUT_OF_FRAME ? WINDOW_IN_FRAME : WINDOW_OUT_OF_FRAME)
				to_chat(user, "<span class='notice'>You pry the window [state == WINDOW_IN_FRAME ? "into":"out of"] the frame.</span>")
			return
		else if(I.tool_behaviour == TOOL_WRENCH && !anchored)
			I.play_tool_sound(src, 75)
			to_chat(user, "<span class='notice'> You begin to disassemble [src]...</span>")
			if(I.use_tool(src, user, decon_speed, extra_checks = CALLBACK(src, .proc/check_state_and_anchored, state, anchored)))
				var/obj/item/stack/sheet/G = new glass_type(user.loc, glass_amount)
				G.add_fingerprint(user)
				playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
				to_chat(user, "<span class='notice'>You successfully disassemble [src].</span>")
				qdel(src)
			return
	return ..()
