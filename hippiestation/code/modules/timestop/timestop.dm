GLOBAL_VAR(timestop)
GLOBAL_LIST_INIT(timestop_blacklist, typecacheof(list(/obj/screen, /obj/effect, /obj/machinery/light))) // for some reason lightbulbs, and just lightbulbs, act up when timestopped.

/datum/timestop
	var/list/frozen_mobs
	var/list/frozen_things
	var/list/negative_things
	var/list/immune
	var/z_level
	var/time = 10 SECONDS

/datum/timestop/New(t, zl)
	..()
	if(GLOB.timestop && GLOB.timestop != src) // only one timestop can exist at once
		qdel(src)
		return
	GLOB.timestop = src
	if(zl)
		z_level = zl
	if(t)
		time = t
	for(var/mob/living/L in GLOB.player_list)
		if(HAS_TRAIT(L, TRAIT_TIMELESS))
			LAZYSET(immune, L, TRUE)
		if(istype(L, /mob/living/simple_animal/hostile/guardian))
			var/mob/living/simple_animal/hostile/guardian/G = L
			if(HAS_TRAIT(G.summoner, TRAIT_TIMELESS))
				LAZYSET(immune, G, TRUE)
	INVOKE_ASYNC(src, .proc/za_warudo)

/datum/timestop/Destroy()
	..()
	GLOB.timestop = null

/datum/timestop/proc/za_warudo()
	START_PROCESSING(SSfields, src)
	var/sound/S = sound('hippiestation/sound/effects/unnatural_clock_noises.ogg')
	SEND_SOUND(world, S)
	for(var/atom/movable/A in world)
		freeze_atom(A)
	sleep(time)
	S.frequency = -1
	SEND_SOUND(world, S)
	STOP_PROCESSING(SSfields, src)
	unfreeze_all()
	qdel(src)

// copypaste from timestop below
/datum/timestop/proc/freeze_atom(atom/movable/A)
	if(LAZYACCESS(immune, A) || !istype(A))
		return FALSE
	if(!isobj(A) && !ismob(A))
		return FALSE
	if(z_level && (A.z != z_level))
		return FALSE
	if(is_type_in_typecache(A, GLOB.timestop_blacklist))
		return FALSE
	var/frozen = TRUE
	into_the_negative_zone(A)
	LAZYADD(negative_things, A)
	if(isliving(A))
		freeze_mob(A)
	else if(istype(A, /obj/item/projectile))
		freeze_projectile(A)
	else if(istype(A, /obj/mecha))
		freeze_mecha(A)
	else
		frozen = FALSE
	if(A.throwing)
		freeze_throwing(A)
		frozen = TRUE
	if(!frozen)
		return

	if(!LAZYACCESS(frozen_things, A))
		LAZYSET(frozen_things, A, A.move_resist)
		A.move_resist = INFINITY
	RegisterSignal(A, COMSIG_MOVABLE_PRE_MOVE, .proc/unfreeze_atom)
	RegisterSignal(A, COMSIG_ITEM_PICKUP, .proc/unfreeze_atom)
	return TRUE

/datum/timestop/proc/unfreeze_all()
	for(var/i in frozen_things)
		unfreeze_atom(i)
	for(var/atom/A in negative_things)
		escape_the_negative_zone(A)

/datum/timestop/proc/unfreeze_atom(atom/movable/A)
	if(A.throwing)
		unfreeze_throwing(A)
	if(isliving(A))
		unfreeze_mob(A)
	else if(istype(A, /obj/item/projectile))
		unfreeze_projectile(A)
	else if(istype(A, /obj/mecha))
		unfreeze_mecha(A)

	UnregisterSignal(A, COMSIG_MOVABLE_PRE_MOVE)
	UnregisterSignal(A, COMSIG_ITEM_PICKUP)
	A.move_resist = LAZYACCESS(frozen_things, A)
	LAZYREMOVE(frozen_things, A)

/datum/timestop/process()
	for(var/mob/living/L in frozen_mobs)
		L.Stun(20, 1, 1)
		
/datum/timestop/proc/freeze_mecha(obj/mecha/M)
	M.completely_disabled = TRUE

/datum/timestop/proc/unfreeze_mecha(obj/mecha/M)
	M.completely_disabled = FALSE
	
/datum/timestop/proc/freeze_throwing(atom/movable/AM)
	var/datum/thrownthing/T = AM.throwing
	T.paused = TRUE

/datum/timestop/proc/unfreeze_throwing(atom/movable/AM)
	var/datum/thrownthing/T = AM.throwing
	if(T)
		T.paused = FALSE

/datum/timestop/proc/freeze_projectile(obj/item/projectile/P)
	P.paused = TRUE

/datum/timestop/proc/unfreeze_projectile(obj/item/projectile/P)
	P.paused = FALSE

/datum/timestop/proc/freeze_mob(mob/living/L)
	LAZYADD(frozen_mobs, L)
	L.Stun(20, 1, 1)
	walk(L, 0) //stops them mid pathing even if they're stunimmune
	if(isanimal(L))
		var/mob/living/simple_animal/S = L
		S.toggle_ai(AI_OFF)
	if(ishostile(L))
		var/mob/living/simple_animal/hostile/H = L
		H.LoseTarget()

/datum/timestop/proc/unfreeze_mob(mob/living/L)
	L.AdjustStun(-20, 1, 1)
	LAZYREMOVE(frozen_mobs, L)
	if(isanimal(L))
		var/mob/living/simple_animal/S = L
		S.toggle_ai(initial(S.AIStatus))

//you don't look quite right, is something the matter?
/datum/timestop/proc/into_the_negative_zone(atom/A)
	A.add_atom_colour(list(-1,0,0,0, 0,-1,0,0, 0,0,-1,0, 0,0,0,1, 1,1,1,0), TEMPORARY_COLOUR_PRIORITY)

//let's put some colour back into your cheeks
/datum/timestop/proc/escape_the_negative_zone(atom/A)
	A.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY)

// freeze things as they happen

/atom/Initialize()
	if(GLOB.timestop)
		var/datum/timestop/TS = GLOB.timestop
		TS.freeze_atom(src)
	return ..()

/obj/item/projectile/process()
	if(GLOB.timestop && !paused)
		var/datum/timestop/TS = GLOB.timestop
		TS.freeze_atom(src)
	return ..()
