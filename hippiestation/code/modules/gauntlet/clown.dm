//Originally coded for HippieStation by Steamp0rt, shared under the AGPL license.

/obj/item/badmin_stone/clown
	name = "Clown Stone"
	desc = "HONK HONK HONK HONK HONK"
	color = "#FFC0CB"
	stone_type = CLOWN_STONE
	ability_text = list("HELP INTENT: fire banana cream pies",
		"GRAB INTENT: Spawn the Traps!",
		"DISARM INTENT: Throw an angry monkey that will hunt whatever you target!")
	spell_types = list(/obj/effect/proc_holder/spell/self/infinity/pranksters_delusion,
		/obj/effect/proc_holder/spell/self/infinity/cake)
	stone_spell_types = list(/obj/effect/proc_holder/spell/self/infinity/honksong,
		/obj/effect/proc_holder/spell/self/infinity/party_popper)
	gauntlet_spell_types = list(/obj/effect/proc_holder/spell/self/infinity/thanoscar_thanoscar)
	var/next_traps = 0
	var/monkey_stockpile = 3
	var/next_monkey = 0

/obj/item/badmin_stone/clown/process()
	..()
	if(world.time >= next_monkey)
		monkey_stockpile = min(3, monkey_stockpile + 1)
		next_monkey = world.time + 25 SECONDS

/obj/item/badmin_stone/clown/HelpEvent(atom/target, mob/living/user, proximity_flag)
	var/obj/item/reagent_containers/food/snacks/pie/cream/pie = new(get_turf(user))
	pie.throw_at(target, 30, 3, user, TRUE)
	playsound(src, 'sound/magic/staff_animation.ogg', 50, 1)
	new /obj/effect/temp_visual/dir_setting/firing_effect/magic(get_turf(src))
	user.changeNext_move(CLICK_CD_RANGE)

/obj/item/badmin_stone/clown/GrabEvent(atom/target, mob/living/user, proximity_flag)
	if(next_traps > world.time)
		to_chat(user, "<span class='danger'>You need to wait [DisplayTimeText(next_traps - world.time)] to summon more traps!</span>")
		return
	var/list/trap_area = view(4, user)
	for(var/i=0,i<5,i++)
		var/turf/T = get_turf(pick_n_take(trap_area))
		var/trap_type = pick(list(
			/obj/structure/trap/stun,
			/obj/structure/trap/fire,
			/obj/structure/trap/chill,
			/obj/structure/trap/damage
		))
		var/obj/structure/trap/TR = new trap_type(T)
		TR.immune_minds += user.mind
		TR.charges = 1
		QDEL_IN(TR, 900) // they last 90 seconds
	next_traps = world.time + 15 SECONDS

/obj/item/badmin_stone/clown/DisarmEvent(atom/target, mob/living/user, proximity_flag)
	if(monkey_stockpile < 1)
		to_chat(user, "<span class='warning'>\The [src] is out of monkeys!</span>")
		return
	var/turf/monkey_loc = get_step(get_turf(user), get_dir(user, target))
	var/mob/living/carbon/monkey/monkey = new(monkey_loc)
	if(isliving(target))
		monkey.mode = MONKEY_HUNT
		monkey.target = target
	monkey.throw_at(target, 7, 3, src, TRUE)
	monkey_stockpile--

/////////////////////////////////////////////
/////////////////// SPELLS //////////////////
/////////////////////////////////////////////

/obj/effect/proc_holder/spell/self/infinity/party_popper
	name = "Clown Stone: Party Popper"
	desc = "Gib yourself and heal <b>everyone</b> around you, even the dead."
	action_icon_state = "partypop"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "clown"
	charge_max = 0

/obj/effect/proc_holder/spell/self/infinity/party_popper/cast(list/targets, mob/user)
	var/prompt = alert("Are you sure you'd like to pop? There's no way to be revived!", "Confirm", "Yes", "No")
	if(prompt != "Yes")
		revert_cast()
		return
	user.visible_message("<span class='notice big bold'>[user] pops!</span>")
	playsound(get_turf(user), 'sound/items/party_horn.ogg', 50, 1)
	for(var/mob/living/L in view(user, 7))
		if(L == user)
			continue
		for(var/i = 1 to 5)
			new /obj/effect/temp_visual/heal(get_turf(L))
		L.grab_ghost()
		L.revive(TRUE, TRUE)
		to_chat(L, "<span class='notice'>You feel amazing!</span>")
	user.gib(TRUE, TRUE, TRUE)

/obj/effect/proc_holder/spell/self/infinity/pranksters_delusion
	name = "Clown Stone: Prankster's Delusion"
	desc = "Causes those around you to see others as a clumsy clown (or maybe a gondola)! Now how will they know who is who?"
	action_icon_state = "prankstersdelusion"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "clown"
	charge_max = 750

/obj/effect/proc_holder/spell/self/infinity/pranksters_delusion/cast(list/targets, mob/user)
	for(var/mob/living/carbon/C in view(7, user))
		if(C == user)
			continue
		to_chat(C, "<span class='clown italics'>HONK.</span>")
		if(prob(50))
			new /datum/hallucination/delusion(C, TRUE, "custom", 600, 0, "clown", 'icons/mob/clown_mobs.dmi')
		else
			new /datum/hallucination/delusion(C, TRUE, "custom", 600, 0, "gondola", 'icons/mob/gondolas.dmi')

/obj/effect/proc_holder/spell/self/infinity/honksong
	name = "Clown Stone: Honksong"
	desc = "Summon a 6x6 dance floor, and dance to heal everyone around you (but yourself)!"
	charge_max = 1000
	action_icon_state = "honksong"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "clown"
	var/list/dancefloor_turfs
	var/list/dancefloor_turfs_types
	var/dancefloor_exists = FALSE
	var/turf/initial_loc
	var/lights_spinning = FALSE
	var/list/spotlights = list()
	var/list/sparkles = list()
	var/sparkles_setup = FALSE

/obj/effect/proc_holder/spell/self/infinity/honksong/cast(list/targets, mob/user)
	var/obj/item/badmin_stone/clown/clown_stone = locate() in user
	if(!clown_stone)
		to_chat(user, "<span class='notice'>How are you casting this without the clown stone wtf?</span>")
		return
	LAZYINITLIST(dancefloor_turfs)
	LAZYINITLIST(dancefloor_turfs_types)
	if(dancefloor_exists)
		dancefloor_exists = FALSE
		sparkles_setup = FALSE
		for(var/i in 1 to dancefloor_turfs.len)
			var/turf/T = dancefloor_turfs[i]
			if(T)
				T.ChangeTurf(dancefloor_turfs_types[i])
		QDEL_LIST(spotlights)
	else
		charge_counter = charge_max
		var/list/funky_turfs = RANGE_TURFS(3, user)
		dancefloor_exists = TRUE
		sparkles_setup = FALSE
		var/i = 1
		dancefloor_turfs.len = funky_turfs.len
		dancefloor_turfs_types.len = funky_turfs.len
		for(var/turf/open/T in funky_turfs)
			dancefloor_turfs[i] = T
			dancefloor_turfs_types[i] = T.type
			T.ChangeTurf((i % 2 == 0) ? /turf/open/floor/light/colour_cycle/dancefloor_a : /turf/open/floor/light/colour_cycle/dancefloor_b)
			i++
		user.visible_message("<span class='notice'>A dance floor forms around [user]!</span>")
		dance_setup(user)
		initial_loc = user.loc
		i = 1
		user.spin(175, 1)
		INVOKE_ASYNC(src, .proc/setup_sparkles, user)
		while(do_after(user, 10, target = clown_stone))
			user.spin(20, 1)
			user.SpinAnimation(7,1)
			if(prob(75))
				playsound(user, 'sound/items/bikehorn.ogg', 50, 1)
			else
				playsound(user, 'sound/items/airhorn2.ogg', 50, 1)
			lights_spin(user)
			for(var/o in 1 to dancefloor_turfs.len)
				var/turf/T = dancefloor_turfs[o]
				for(var/mob/living/L in T)
					if(L == user)
						continue
					L.heal_overall_damage(5, 5, 5)
					new /obj/effect/temp_visual/heal(get_turf(L))
			i++
		QDEL_LIST(sparkles)
		QDEL_LIST(spotlights)
		user.visible_message("<span class='notice'>The dance floor reverts back to normal...</span>")
		for(var/k in 1 to dancefloor_turfs.len)
			var/turf/T = dancefloor_turfs[k]
			if(T)
				T.ChangeTurf(dancefloor_turfs_types[k])


/obj/effect/proc_holder/spell/self/infinity/honksong/proc/dance_setup(mob/living/user)
	var/turf/cen = get_turf(user)
	FOR_DVIEW(var/turf/t, 3, get_turf(user),INVISIBILITY_LIGHTING)
		if(t.x == cen.x && t.y > cen.y)
			var/obj/item/flashlight/spotlight/L = new /obj/item/flashlight/spotlight(t)
			L.light_color = LIGHT_COLOR_RED
			L.light_power = 30-(get_dist(user,L)*8)
			L.range = 1+get_dist(user, L)
			spotlights+=L
			continue
		if(t.x == cen.x && t.y < cen.y)
			var/obj/item/flashlight/spotlight/L = new /obj/item/flashlight/spotlight(t)
			L.light_color = LIGHT_COLOR_PURPLE
			L.light_power = 30-(get_dist(user,L)*8)
			L.range = 1+get_dist(user, L)
			spotlights+=L
			continue
		if(t.x > cen.x && t.y == cen.y)
			var/obj/item/flashlight/spotlight/L = new /obj/item/flashlight/spotlight(t)
			L.light_color = LIGHT_COLOR_YELLOW
			L.light_power = 30-(get_dist(user,L)*8)
			L.range = 1+get_dist(user, L)
			spotlights+=L
			continue
		if(t.x < cen.x && t.y == cen.y)
			var/obj/item/flashlight/spotlight/L = new /obj/item/flashlight/spotlight(t)
			L.light_color = LIGHT_COLOR_GREEN
			L.light_power = 30-(get_dist(user,L)*8)
			L.range = 1+get_dist(user, L)
			spotlights+=L
			continue
		if((t.x+1 == cen.x && t.y+1 == cen.y) || (t.x+2==cen.x && t.y+2 == cen.y))
			var/obj/item/flashlight/spotlight/L = new /obj/item/flashlight/spotlight(t)
			L.light_color = LIGHT_COLOR_ORANGE
			L.light_power = 30-(get_dist(user,L)*8)
			L.range = 1.4+get_dist(user, L)
			spotlights+=L
			continue
		if((t.x-1 == cen.x && t.y-1 == cen.y) || (t.x-2==cen.x && t.y-2 == cen.y))
			var/obj/item/flashlight/spotlight/L = new /obj/item/flashlight/spotlight(t)
			L.light_color = LIGHT_COLOR_CYAN
			L.light_power = 30-(get_dist(user,L)*8)
			L.range = 1.4+get_dist(user, L)
			spotlights+=L
			continue
		if((t.x-1 == cen.x && t.y+1 == cen.y) || (t.x-2==cen.x && t.y+2 == cen.y))
			var/obj/item/flashlight/spotlight/L = new /obj/item/flashlight/spotlight(t)
			L.light_color = LIGHT_COLOR_BLUEGREEN
			L.light_power = 30-(get_dist(user,L)*8)
			L.range = 1.4+get_dist(user, L)
			spotlights+=L
			continue
		if((t.x+1 == cen.x && t.y-1 == cen.y) || (t.x+2==cen.x && t.y-2 == cen.y))
			var/obj/item/flashlight/spotlight/L = new /obj/item/flashlight/spotlight(t)
			L.light_color = LIGHT_COLOR_BLUE
			L.light_power = 30-(get_dist(user,L)*8)
			L.range = 1.4+get_dist(user, L)
			spotlights+=L
			continue
		continue
	FOR_DVIEW_END

/obj/effect/proc_holder/spell/self/infinity/honksong/proc/setup_sparkles(mob/living/user)
	for(var/i in 1 to 25)
		if(QDELETED(src) || QDELETED(user) || !dancefloor_exists || user.loc != initial_loc)
			return
		var/obj/effect/overlay/sparkles/S = new /obj/effect/overlay/sparkles(user)
		S.alpha = 0
		sparkles += S
		switch(i)
			if(1 to 8)
				S.orbit(user, 30, TRUE, 60, 36, TRUE)
			if(9 to 16)
				S.orbit(user, 62, TRUE, 60, 36, TRUE)
			if(17 to 24)
				S.orbit(user, 95, TRUE, 60, 36, TRUE)
			if(25)
				S.pixel_y = 7
				S.forceMove(get_turf(user))
		sleep(7)
	for(var/obj/reveal in sparkles)
		reveal.alpha = 255

/obj/effect/proc_holder/spell/self/infinity/honksong/proc/lights_spin(mob/living/user)
	for(var/obj/item/flashlight/spotlight/glow in spotlights) // The multiples reflects custom adjustments to each colors after dozens of tests
		if(QDELETED(src) || QDELETED(user) || !dancefloor_exists || QDELETED(glow) || user.loc != initial_loc)
			return
		if(glow.light_color == LIGHT_COLOR_RED)
			glow.light_color = LIGHT_COLOR_BLUE
			glow.light_power = glow.light_power * 1.48
			glow.light_range = 0
			glow.update_light()
		if(glow.light_color == LIGHT_COLOR_BLUE)
			glow.light_color = LIGHT_COLOR_GREEN
			glow.light_range = glow.range * (rand(85, 115)*0.01)
			glow.light_power = glow.light_power * 2 // Any changes to power must come in pairs to neutralize it for other colors
			glow.update_light()
		if(glow.light_color == LIGHT_COLOR_GREEN)
			glow.light_color = LIGHT_COLOR_ORANGE
			glow.light_power = glow.light_power * 0.5
			glow.light_range = 0
			glow.update_light()
		if(glow.light_color == LIGHT_COLOR_ORANGE)
			glow.light_color = LIGHT_COLOR_PURPLE
			glow.light_power = glow.light_power * 2.27
			glow.light_range = glow.range * (rand(85, 115)*0.01)
			glow.update_light()
		if(glow.light_color == LIGHT_COLOR_PURPLE)
			glow.light_color = LIGHT_COLOR_BLUEGREEN
			glow.light_power = glow.light_power * 0.44
			glow.light_range = 0
			glow.update_light()
		if(glow.light_color == LIGHT_COLOR_BLUEGREEN)
			glow.light_color = LIGHT_COLOR_YELLOW
			glow.light_range = glow.range * (rand(85, 115)*0.01)
			glow.update_light()
		if(glow.light_color == LIGHT_COLOR_YELLOW)
			glow.light_color = LIGHT_COLOR_CYAN
			glow.light_range = 0
			glow.update_light()
			continue
		if(glow.light_color == LIGHT_COLOR_CYAN)
			glow.light_color = LIGHT_COLOR_RED
			glow.light_power = glow.light_power * 0.68
			glow.light_range = glow.range * (rand(85, 115)*0.01)
			glow.update_light()

/obj/effect/proc_holder/spell/self/infinity/cake
	name = "Clown Stone: Let There Be Cake!"
	desc = "Summon a powerful cake at your feet, capable of healing those who eat it, and injuring those who are hit by it. <b>Only 2 cakes can exist at the same time.</b>"
	action_icon_state = "cake"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "clown"
	charge_max = 350
	var/list/cakes = list()

/obj/effect/proc_holder/spell/self/infinity/cake/proc/CountCakes()
	var/amt = 0
	for(var/obj/item/reagent_containers/food/snacks/store/cake/birthday/infinity/cake in cakes)
		if(!QDELETED(cake) && cake && istype(cake))
			amt++
	return amt

/obj/effect/proc_holder/spell/self/infinity/cake/proc/GetMostEatenCake()
	var/obj/item/reagent_containers/food/snacks/store/cake/birthday/infinity/nom_nom
	for(var/obj/item/reagent_containers/food/snacks/store/cake/birthday/infinity/cake in cakes)
		if(!QDELETED(cake) && (!nom_nom || cake.bitecount > nom_nom.bitecount))
			nom_nom = cake
	return nom_nom

/obj/effect/proc_holder/spell/self/infinity/cake/cast(list/targets, mob/user)
	if(CountCakes() >= 2)
		var/obj/item/reagent_containers/food/snacks/store/cake/birthday/infinity/nom_nom = GetMostEatenCake()
		if(istype(nom_nom))
			user.visible_message("<span class='notice'>\The [nom_nom] appears at [user]'s feet!</span>")
			nom_nom.forceMove(user.drop_location())
		else
			to_chat(user, "<span class='danger'>Only 2 cakes can exist at the same time!</span>")
		return
	user.visible_message("<span class='notice'>A cake appears at [user]'s feet!</span>")
	cakes += new /obj/item/reagent_containers/food/snacks/store/cake/birthday/infinity(get_turf(user))

/obj/item/reagent_containers/food/snacks/store/cake/birthday/infinity
	name = "infinity cake"
	throwforce = 35
	list_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/sprinkles = 10, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/medicine/omnizine = 25)
	tastes = list("cake" = 3, "power" = 2, "sweetness" = 1)

/obj/item/reagent_containers/food/snacks/store/cake/birthday/infinity/slice(accuracy, obj/item/W, mob/user)
	to_chat(user, "<span class='notice'>An invisible force stops you from cutting [src]!</span>")

/obj/item/reagent_containers/food/snacks/store/cake/birthday/infinity/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(!. && isliving(hit_atom))
		var/mob/living/L = hit_atom
		L.fire_stacks += 3
		L.IgniteMob()
		qdel(src)

/obj/effect/proc_holder/spell/self/infinity/thanoscar_thanoscar
	name = "Clown Stone: THANOS CAR"
	desc = "Summon the legendary THANOS CAR!"
	action_icon_state = "_thanoscar"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "clown"
	invocation_type = "shout"
	invocation = "THANOS CAR THANOS CAR"
	charge_max = 1300

/obj/effect/proc_holder/spell/self/infinity/thanoscar_thanoscar/cast(list/targets, mob/user)
	user.visible_message("<span class='danger bold'>[user] summons the THANOS CAR!</span>")
	var/obj/vehicle/sealed/car/thanos/thanos_car = new(get_turf(user))
	thanos_car.mob_forced_enter(user, TRUE)
	addtimer(CALLBACK(thanos_car, /obj/vehicle/sealed/car/thanos.proc/ByeBye), 15 SECONDS)
	

///////////////////////////////////////
//////// THANOS CAR THANOS CAR ////////
///////////////////////////////////////

/obj/vehicle/sealed/car/thanos
	name = "THANOS CAR"
	desc = "THANOS CAR THANOS CAR"
	icon = 'hippiestation/icons/obj/infinity.dmi'
	icon_state = "thanoscar"
	color = "#6F3C89"
	max_integrity = 45
	max_occupants = 1
	key_type = null
	movedelay = 0.6
	do_explode = FALSE
	var/bloodiness = 0

/obj/vehicle/sealed/car/thanos/Bump(atom/movable/M)
	. = ..()
	if(isliving(M))
		var/mob/living/L = M
		visible_message("<span class='danger'>[src] rams into [L]!</span>")
		L.throw_at(get_edge_target_turf(src, get_dir(src, L)), 7, 5)
		L.take_bodypart_damage(10, check_armor = TRUE)

/obj/vehicle/sealed/car/thanos/driver_move(mob/user, direction)
	. = ..()
	if(. && bloodiness)
		var/obj/effect/decal/cleanable/blood/tracks/B = new(loc)
		B.add_blood_DNA(return_blood_DNA())
		B.setDir(direction)
		bloodiness--


/obj/vehicle/sealed/car/thanos/proc/RunOver(mob/living/carbon/H)
	log_combat(src, H, "run over", null, "(DAMTYPE: [uppertext(BRUTE)])")
	H.visible_message("<span class='danger'>[src] drives over [H]!</span>", \
					"<span class='userdanger'>[src] drives over you!</span>")
	playsound(loc, 'sound/effects/splat.ogg', 50, 1)

	var/damage = rand(1,3)
	H.apply_damage(0.5*damage, BRUTE, BODY_ZONE_HEAD, H.run_armor_check(BODY_ZONE_HEAD, "melee"))
	H.apply_damage(0.5*damage, BRUTE, BODY_ZONE_CHEST, H.run_armor_check(BODY_ZONE_CHEST, "melee"))
	H.apply_damage(0.5*damage, BRUTE, BODY_ZONE_L_LEG, H.run_armor_check(BODY_ZONE_L_LEG, "melee"))
	H.apply_damage(0.5*damage, BRUTE, BODY_ZONE_R_LEG, H.run_armor_check(BODY_ZONE_R_LEG, "melee"))
	H.apply_damage(0.5*damage, BRUTE, BODY_ZONE_L_ARM, H.run_armor_check(BODY_ZONE_L_ARM, "melee"))
	H.apply_damage(0.5*damage, BRUTE, BODY_ZONE_R_ARM, H.run_armor_check(BODY_ZONE_R_ARM, "melee"))

	var/turf/T = get_turf(src)
	T.add_mob_blood(H)

	var/list/blood_dna = H.get_blood_dna_list()
	add_blood_DNA(blood_dna)
	bloodiness += 4

/obj/vehicle/sealed/car/thanos/proc/ByeBye()
	for(var/mob/living/L in return_occupants())
		mob_exit(L, TRUE)
		L.throw_at(get_edge_target_turf(src, dir), 7, 5)
	visible_message("<span class='danger'>[src] explodes!</span>")
	explosion(get_turf(src), 0, 0, 2, 3, flame_range = 3)
	qdel(src)

/mob/living/carbon/human/Crossed(atom/movable/AM)
	var/obj/vehicle/sealed/car/thanos/TC = AM
	if(istype(TC))
		TC.RunOver(src)
	return ..()
