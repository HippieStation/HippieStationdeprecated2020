/obj/machinery/fluid_pump
	name = "portable fluid pump"
	desc = "When anchored and activated it will drain liquids in a large area."
	density = TRUE
	icon = 'hippiestation/icons/obj/power.dmi'
	icon_state = "fluid_pump"
	light_color = LIGHT_COLOR_RED
	anchored = FALSE
	var/datum/looping_sound/pump/soundloop
	var/active = FALSE

/obj/machinery/fluid_pump/Initialize()
	. = ..()
	soundloop = new(list(src), FALSE)

/obj/machinery/fluid_pump/attackby(obj/item/I, mob/user, params)

	if(istype(I, /obj/item/wrench))
		if(anchored && !active)
			anchored = FALSE
			to_chat(user, "<span class='notice'>You disengage the locking mechanism on the pump and it automatically disconnects from the pipe network.</span>")
			playsound(src, I.usesound, 75, 1)
			return
		if(!anchored)
			anchored = TRUE
			to_chat(user, "<span class='notice'>You engage the locking mechanism on the pump and it connects to a nearby pipe.</span>")
			playsound(src, I.usesound, 75, 1)
			return
	else
		return ..()

/obj/machinery/fluid_pump/process()
	if(active)
		var/count = 0
		soundloop.start()
		for(var/obj/effect/liquid/L in view(8, src))
			count++
			if(!L.is_static && L.viscosity)
				var/chance = CLAMP((100 / L.viscosity) / max(get_dist(src, L), 1), 30, 100)
				if(prob(chance))
					L.depth--
					L.active = TRUE
					L.update_depth()
		if(!count)
			active = FALSE
			soundloop.stop()
			visible_message("<span class='danger'>[src] suddenly shuts down, showing the 'no liquid detected' warning light!</span>")
			set_light(0)

/obj/machinery/fluid_pump/attack_hand(mob/user)
	if(!anchored)
		to_chat(user, "<span class='warning'>Anchor it first!</span>")
	else
		if(!active)
			to_chat(user, "<span class='notice'>You activate the pump.</span>")
			active = TRUE
			set_light(l_range = 3, l_power = 1.5)
		else
			to_chat(user, "<span class='notice'>You deactivate the pump.</span>")
			active = FALSE
			set_light(0)
			soundloop.stop()

/obj/machinery/fluid_pump/Destroy()
	soundloop.stop()
	return ..()
