
/obj/machinery/gibber
	name = "gibber"
	desc = "The name isn't descriptive enough?"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "grinder"
	density = 1
	anchored = 1
	layer = 3.1 //animation reasons
	var/operating = 0 //Is it on?
	var/dirty = 0 // Does it need cleaning?
	var/gibtime = 40 // Time from starting until meat appears
	var/meat_produced = 0
	var/ignore_clothing = 0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 500
	var/locked = 0
	var/bloodToUse = "A10808" //green or red blood

//auto-gibs anything that bumps into it
/obj/machinery/gibber/autogibber
	var/turf/input_plate

/obj/machinery/gibber/autogibber/New()
	..()
	spawn(5)
		for(var/i in cardinal)
			var/obj/machinery/mineral/input/input_obj = locate( /obj/machinery/mineral/input, get_step(src.loc, i) )
			if(input_obj)
				if(isturf(input_obj.loc))
					input_plate = input_obj.loc
					qdel(input_obj)
					break

		if(!input_plate)
			diary << "a [src] didn't find an input plate."
			return

/obj/machinery/gibber/autogibber/Bumped(atom/A)
	if(!input_plate) return

	if(ismob(A))
		var/mob/M = A

		if(M.loc == input_plate)
			M.loc = src
			M.gib()


/obj/machinery/gibber/New()
	..()
	src.add_overlay(image('icons/obj/kitchen.dmi', "grjam"))
	var/obj/item/weapon/circuitboard/machine/B = new /obj/item/weapon/circuitboard/machine/gibber(null)
	B.apply_default_parts(src)

/obj/item/weapon/circuitboard/machine/gibber
	name = "Gibber (Machine Board)"
	build_path = /obj/machinery/gibber
	origin_tech = "programming=2;engineering=2"
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/manipulator = 1)

/obj/machinery/gibber/clean_blood()
	..()
	dirty = 0
	update_icon()

/obj/machinery/gibber/RefreshParts()
	var/gib_time = 40
	for(var/obj/item/weapon/stock_parts/matter_bin/B in component_parts)
		meat_produced += B.rating
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		gib_time -= 5 * M.rating
		gibtime = gib_time
		if(M.rating >= 2)
			ignore_clothing = 1

/obj/machinery/gibber/update_icon()
	cut_overlays()
	if (dirty)
		var/image/I = image('icons/obj/kitchen.dmi', "grbloody")
		I.color = bloodToUse
		add_overlay(I)
	if(stat & (NOPOWER|BROKEN))
		return
	if (!occupant)
		src.add_overlay(image('icons/obj/kitchen.dmi', "grjam"))
	else if (operating)
		src.add_overlay(image('icons/obj/kitchen.dmi', "gruse"))
	else
		src.add_overlay(image('icons/obj/kitchen.dmi', "gridle"))

/obj/machinery/gibber/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/machinery/gibber/container_resist(mob/living/user)
	go_out()

/obj/machinery/gibber/attack_hand(mob/user)
	if(stat & (NOPOWER|BROKEN))
		return
	if(operating)
		user << "<span class='danger'>It's locked and running.</span>"
		return

	if(user.pulling && user.a_intent == INTENT_GRAB && isliving(user.pulling))
		var/mob/living/L = user.pulling
		if(!iscarbon(L))
			user << "<span class='danger'>This item is not suitable for the gibber!</span>"
			return
		var/mob/living/carbon/C = L
		if(C.buckled ||C.has_buckled_mobs())
			user << "<span class='warning'>[C] is attached to something!</span>"
			return
		if(C.abiotic(1) && !ignore_clothing)
			user << "<span class='danger'>Subject may not have abiotic items on.</span>"
			return

		user.visible_message("<span class='danger'>[user] starts to put [C] into the gibber!</span>")
		src.add_fingerprint(user)
		if(do_after(user, gibtime, target = src))
			if(C && user.pulling == C && !C.buckled && !C.has_buckled_mobs() && !occupant)
				var/turf/prevloc = C.loc
				user.visible_message("<span class='danger'>[user] stuffs [C] into the gibber!</span>")
				occupant = C
				update_icon()
				StuffAnim(prevloc)
	if(locked)
		user << "<span class='danger'>Wait for [occupant.name] to finish being loaded!</span>"
	if(occupant)
		startgibbing(user)

/obj/effect/overlay/gibberperson
	use_fade = FALSE

/obj/machinery/gibber/proc/StuffAnim(var/turf/prevloc)
	if(!src.occupant)
		return

	src.locked = 1
	var/turf/newloc = src.loc
	if(prevloc) newloc = prevloc

	if(!isturf(newloc)) return
	var/obj/effect/overlay/gibberperson/feedee = new(newloc)
	feedee.name = src.occupant.name
	feedee.icon = getFlatIcon(src.occupant)
	occupant.alpha = 0

	var/matrix/span1 = matrix(feedee.transform)
	sleep (5)
	span1.Turn(60)
	var/matrix/span2 = matrix(feedee.transform)
	span2.Turn(120)
	var/matrix/span3 = matrix(feedee.transform)
	span3.Turn(180)
	animate(feedee, transform = span1, pixel_y = 15, time=2)
	animate(transform = span2, pixel_y = 25, time = 1) //If we instantly turn the guy 180 degrees he'll just pop out and in of existance all weird-like
	animate(transform = span3, time = 2, easing = ELASTIC_EASING)
	sleep(2)
	if(!feedee)
		locked = 0
		return
	feedee.loc = src.loc
	sleep(3)
	if(!feedee)
		locked = 0
		return
	feedee.layer = src.layer - 0.1
	animate(feedee, pixel_y = -5, time=20)
	sleep(5)
	if(!feedee)
		locked = 0
		return
	feedee.icon += icon('icons/obj/kitchen.dmi', "cuticon")
	sleep(15)
	if(feedee)
		qdel(feedee)
	locked = 0

/obj/machinery/gibber/attackby(obj/item/P, mob/user, params)
	if(default_deconstruction_screwdriver(user, "grinder_open", "grinder", P))
		return

	else if(exchange_parts(user, P))
		return

	else if(default_pry_open(P))
		return

	else if(default_unfasten_wrench(user, P))
		return

	else if(default_deconstruction_crowbar(P))
		return
	else
		return ..()



/obj/machinery/gibber/verb/eject()
	set category = "Object"
	set name = "empty gibber"
	set src in oview(1)

	if(usr.incapacitated())
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/gibber/proc/go_out()
	dropContents()
	update_icon()

/obj/machinery/gibber/proc/startgibbing(mob/user)
	if(src.operating)
		return
	if(!src.occupant)
		visible_message("<span class='italics'>You hear a loud metallic grinding sound.</span>")
		return
	use_power(1000)
	visible_message("<span class='italics'>You hear a loud squelchy grinding sound.</span>")
	playsound(src.loc, 'sound/machines/juicer.ogg', 50, 1)
	src.operating = 1
	dirty = 1
	bloodToUse = "#A10808"
	if(isalien(occupant))
		bloodToUse = "green"
	update_icon()
	var/image/blood = new('icons/obj/kitchen.dmi', "grinding")
	blood.color = bloodToUse
	add_overlay(blood)
	var/offset = prob(50) ? -2 : 2
	animate(src, pixel_x = pixel_x + offset, time = 0.2, loop = 200) //start shaking
	var/sourcename = src.occupant.real_name
	var/sourcejob
	if(ishuman(occupant))
		var/mob/living/carbon/human/gibee = occupant
		sourcejob = gibee.job
	var/sourcenutriment = src.occupant.nutrition / 15
	var/sourcetotalreagents = src.occupant.reagents.total_volume
	var/typeofmeat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human
	var/typeofskin = /obj/item/stack/sheet/animalhide/human

	var/obj/item/weapon/reagent_containers/food/snacks/meat/slab/allmeat[meat_produced]
	var/obj/item/stack/sheet/animalhide/allskin

	if(ishuman(occupant))
		var/mob/living/carbon/human/gibee = occupant
		if(gibee.dna && gibee.dna.species)
			typeofmeat = gibee.dna.species.meat
			typeofskin = gibee.dna.species.skinned_type
		else
			typeofmeat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human
			typeofskin = /obj/item/stack/sheet/animalhide/human
	else if(iscarbon(occupant))
		var/mob/living/carbon/C = occupant
		typeofmeat = C.type_of_meat
		if(ismonkey(C))
			typeofskin = /obj/item/stack/sheet/animalhide/monkey
		else if(isalien(C))
			typeofskin = /obj/item/stack/sheet/animalhide/xeno

	for (var/i=1 to meat_produced)
		var/obj/item/weapon/reagent_containers/food/snacks/meat/slab/newmeat = new typeofmeat
		var/obj/item/stack/sheet/animalhide/newskin = new typeofskin
		newmeat.name = "[sourcename] [newmeat.name]"
		if(istype(newmeat))
			newmeat.subjectname = sourcename
			newmeat.reagents.add_reagent ("nutriment", sourcenutriment / meat_produced) // Thehehe. Fat guys go first
			if(sourcejob)
				newmeat.subjectjob = sourcejob
		src.occupant.reagents.trans_to (newmeat, round (sourcetotalreagents / meat_produced, 1)) // Transfer all the reagents from the
		allmeat[i] = newmeat
		allskin = newskin

	add_logs(user, occupant, "gibbed")
	src.occupant.death(1)
	src.occupant.ghostize()
	qdel(src.occupant)
	spawn(src.gibtime)
		playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)
		operating = 0
		var/turf/T = get_turf(src)
		var/list/turf/nearby_turfs = RANGE_TURFS(3,T) - T
		var/obj/item/skin = allskin
		skin.loc = src.loc
		skin.throw_at(pick(nearby_turfs),meat_produced,3)
		for (var/i=1 to meat_produced)
			var/obj/item/meatslab = allmeat[i]
			meatslab.loc = src.loc
			meatslab.throw_at(pick(nearby_turfs),i,3)
		if(bloodToUse == "#A10808")
			new /obj/effect/gibspawner/human(loc)
		else
			new /obj/effect/gibspawner/xeno(loc)

		pixel_x = initial(pixel_x) //return to its spot after shaking
		src.operating = 0
		update_icon()
