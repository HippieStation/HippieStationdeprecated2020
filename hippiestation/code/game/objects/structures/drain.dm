/obj/structure/drain
	name = "drain"
	desc = "Hooked up to a discrete series of underfloor pipes that lead...somewhere. High viscosity liquids may cause clogging."
	icon = 'hippiestation/icons/obj/drain.dmi'
	icon_state = "drain"
	density = FALSE
	anchored = TRUE
	layer = GAS_SCRUBBER_LAYER
	max_integrity = 400//it's small and made of thick strong metal
	var/welded = FALSE
	var/datum/looping_sound/drain/soundloop
	var/counter = 0

/obj/structure/drain/Initialize()
	. =..()
	soundloop = new(list(src), FALSE)

/obj/structure/drain/process()
	if(counter > 25 || welded)
		STOP_PROCESSING(SSliquids, src)
		counter = 0
		soundloop.stop()
	counter++
	for(var/obj/effect/liquid/L in view(4, src))
		soundloop.start()
		if(!L.is_static && L.viscosity)
			var/chance = CLAMP(30 / L.viscosity, 10, 100)
			if(get_dist(src,L) < 2)
				qdel(L)
			else if(prob(chance))
				step_to(L, src)

/obj/structure/drain/welder_act(mob/living/user, obj/item/I)
	if(!welded && I.use_tool(src, user, 0, volume=40))
		user.visible_message("<span class='notice'>[user] seals \the [src] shut.</span>")
		welded = TRUE
		desc += " It looks permanently sealed!"
		return
	return ..()

/obj/structure/drain/AltClick(mob/living/user)
	if(isobserver(user))
		return

	if (!user.canUseTopic(src))
		to_chat(user, "<span class='info'>You can't do this right now!</span>")
		return
	if(!(datum_flags & DF_ISPROCESSING))
		to_chat(user, "<span class='info'>You activate [src] via a digital switch.</span>")
		START_PROCESSING(SSliquids, src)
	else
		to_chat(user, "<span class='info'>[src] is already active!</span>")

/obj/structure/drain/obj_break(damage_flag)
	if(!broken && !(flags_1 & NODECONSTRUCT_1))
		broken = TRUE
		STOP_PROCESSING(SSliquids, src)
		var/obj/item/stack/sheet/metal/M = new(loc)
		M.amount = 3

/obj/structure/drain/examine(mob/user)
	. = ..()
	to_chat(user, "<span class='notice'>It is [welded ? "welded shut" : "unwelded"].</span>")

/obj/structure/drain/Destroy()
	STOP_PROCESSING(SSliquids, src)
	soundloop.stop()
	return ..()


/obj/structure/drain_assembly
	name = "drain frame"
	desc = "It's the frame part of a drain. Wrench down and add some grilles."
	icon = 'hippiestation/icons/obj/drain.dmi'
	icon_state = "assembly"
	density = FALSE
	anchored = FALSE
	layer = GAS_SCRUBBER_LAYER
	max_integrity = 200

/obj/structure/drain_assembly/wrench_act(mob/user, obj/item/tool)
	user.visible_message("<span class='notice'>[user] [anchored ? "unwrenches" : "wrenches"] \the [src] [anchored ? "" : "down"]</span>", "<span class='notice'>You [anchored ? "unwrench" : "wrench"] \the [src] [anchored ? "" : "down"]</span>")
	anchored = !anchored

/obj/structure/drain_assembly/attackby(obj/item/W, mob/user, params)
	if(!anchored)
		to_chat(user, "<span class='warning'>You need to wrench \the [src] down first!</span>")
		return
	if(istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = W
		if(R.get_amount() >= 5)
			user.visible_message("<span class='notice'>[user] adds grilles to the drain.</span>", "<span class='notice'>You finish making the drain.</span>")
			R.use(5)
			var/obj/structure/drain/D = new /obj/structure/drain(get_turf(src))
			D.add_fingerprint(user)
			qdel(src)
		else
			to_chat(user, "<span class='warning'>You don't have enough rods to finish the drain!</span>")

/obj/item/drain_assembly
	name = "drain frame"
	desc = "It's the frame part of a drain. Wrench down and add some grilles."
	icon = 'hippiestation/icons/obj/drain.dmi'
	icon_state = "assembly"
	flags_1 = NOBLUDGEON

/obj/item/drain_assembly/wrench_act(mob/user, obj/item/tool)
	if(!isturf(loc))
		to_chat(user, "<span class='warning'>Put \the [src] on the floor first!</span>")
		return
	var/obj/structure/DA = new /obj/structure/drain(get_turf(src))
	user.visible_message("<span class='notice'>[user] wrenches \the [src] down</span>", "<span class='notice'>You wrench \the [src] down</span>")
	DA.anchored = TRUE
	DA.add_fingerprint(user)
