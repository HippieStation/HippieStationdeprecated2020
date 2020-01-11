/mob/living/scp_173
	name = "SCP-173"
	desc = "A statue, constructed from concrete and rebar with traces of Krylon brand spray paint"
	icon = 'hippiestation/icons/mob/scpicon/scpmobs/scp-173.dmi'
	ventcrawler = VENTCRAWLER_NUDE
	icon_state = "173"

	maxHealth = INFINITY
	health = INFINITY
	move_force = MOVE_FORCE_EXTREMELY_STRONG
	move_resist = MOVE_FORCE_EXTREMELY_STRONG
	pull_force = MOVE_FORCE_EXTREMELY_STRONG


	var/last_snap = 0
	var/list/next_blinks = list()
	var/cannot_be_seen = 1
	
/mob/living/scp_173/Initialize(mapload, var/mob/living/creator)
	. = ..()
	// Give spells
	mob_spell_list += new /obj/effect/proc_holder/spell/aoe_turf/flicker_lights(src)
	mob_spell_list += new /obj/effect/proc_holder/spell/aoe_turf/blindness(src)
	mob_spell_list += new /obj/effect/proc_holder/spell/targeted/night_vision(src)


/mob/living/scp_173/proc/can_be_seen(turf/destination)
	if(!cannot_be_seen)
		return null
	// Check for darkness
	var/turf/T = get_turf(loc)
	if(T && destination && T.lighting_object)
		if(T.get_lumcount()<0.1 && destination.get_lumcount()<0.1) // No one can see us in the darkness, right?
			return null
		if(T == destination)
			destination = null

	// We aren't in darkness, loop for viewers.
	var/list/check_list = list(src)
	if(destination)
		check_list += destination

	// This loop will, at most, loop twice.
	for(var/atom/check in check_list)
		for(var/mob/living/M in viewers(world.view + 1, check) - src)
			if(M.client && !M.has_unlimited_silicon_privilege)
				if(!M.eye_blind)
					return M
		for(var/obj/mecha/M in view(world.view + 1, check)) //assuming if you can see them they can see you
			if(M.occupant && M.occupant.client)
				if(!M.occupant.eye_blind)
					return M.occupant
	return null
	
/mob/living/scp_173/Move(turf/NewLoc)
	if(can_be_seen(NewLoc))
		if(client)
			to_chat(src, "<span class='warning'>You cannot move, there are eyes on you!</span>")
		return 0
	return ..()
	
/mob/living/scp_173/movement_delay()
	return -5

/mob/living/scp_173/UnarmedAttack(var/atom/A)
	if(!can_be_seen() && ishuman(A))
		var/mob/living/carbon/human/H = A
		if(H.stat == DEAD)
			to_chat(src, "<span class='warning'><I>[H] is already dead!</I></span>")
			return
		visible_message("<span class='danger'>[src] snaps [H]'s neck!</span>")
		playsound(loc, pick('hippiestation/sound/scpsounds/scp/spook/NeckSnap1.ogg', 'hippiestation/sound/scpsounds/scp/spook/NeckSnap3.ogg'), 50, 1)
		H.death()

/mob/living/scp_173/Life()
	. = ..()
	if (isobj(loc))
		return
	var/list/our_view = view(src, 13)
	for(var/A in next_blinks)
		if(!(A in our_view))
			next_blinks[A] = null
			continue
		if(world.time >= next_blinks[A])
			var/mob/living/carbon/human/H = A
			if(H.stat) // Sleeping or dead people can't blink!
				next_blinks[A] = null
				continue
			H.visible_message("<span class='notice'>[H] blinks.</span>")
			H.blind_eyes(3)
			next_blinks[H] = 10+world.time+rand(6 SECONDS, 30 SECONDS)
