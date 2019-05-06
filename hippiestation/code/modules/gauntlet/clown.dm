/obj/item/infinity_stone/clown
	name = "Clown Stone"
	desc = "HONK HONK HONK HONK HONK"
	color = "#FFC0CB"
	stone_type = CLOWN_STONE
	ability_text = list("HELP INTENT: fire banana cream pies",
		"HARM INTENT: Spawn the Traps!",
		"DISARM INTENT: Throw a cleaner grenade")
	spell_types = list(/obj/effect/proc_holder/spell/self/infinity/pranksters_delusion)
	var/next_traps = 0
	var/next_cleaner = 0

/obj/item/infinity_stone/clown/HelpEvent(atom/target, mob/living/user, proximity_flag)
	var/obj/item/reagent_containers/food/snacks/pie/cream/pie = new(get_turf(user))
	pie.throw_at(target, 30, 3, user, FALSE)

/obj/item/infinity_stone/clown/HarmEvent(atom/target, mob/living/user, proximity_flag)
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

/obj/item/infinity_stone/clown/DisarmEvent(atom/target, mob/living/user, proximity_flag)
	if(next_cleaner > world.time)
		to_chat(user, "<span class='danger'>You need to wait [DisplayTimeText(next_cleaner - world.time)] to summon another cleaner grenade!</span>")
		return
	var/obj/item/grenade/chem_grenade/cleaner/C = new(get_turf(user))
	C.preprime(src, null, FALSE)
	C.throw_at(target, 7, 3, user, TRUE)
	next_cleaner = world.time + 10 SECONDS

/////////////////////////////////////////////
/////////////////// SPELLS //////////////////
/////////////////////////////////////////////

/obj/effect/proc_holder/spell/self/infinity/pranksters_delusion
	name = "Prankster's Delusion"
	desc = "Causes those around you to see others as a clumsy clown, including yourself! Now how will they know who is who?"
	charge_max = 750

/obj/effect/proc_holder/spell/self/infinity/pranksters_delusion/cast(list/targets, mob/user)
	for(var/mob/living/carbon/C in view(7, user))
		if(C == user)
			continue
		to_chat(C, "<span class='clown italics'>HONK.</span>")
		new /datum/hallucination/delusion(C, TRUE, "custom", 600, 0, "clown", 'icons/mob/clown_mobs.dmi')
