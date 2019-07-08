GLOBAL_VAR_INIT(pm_hatched, FALSE)

/obj/effect/proc_holder/spell/self/pillar_hatch
	name = "Emerge"
	desc = "Emerge from your shell, and become a full Pillar Man"
	action_icon = 'hippiestation/icons/mob/actions.dmi'
	action_icon_state = "emerge"
	action_background_icon = 'hippiestation/icons/mob/actions/backgrounds.dmi'
	action_background_icon_state = "bg_pillar"
	charge_max = 0
	clothes_req = FALSE
	var/emerging = FALSE

/obj/effect/proc_holder/spell/self/pillar_hatch/cast(list/targets, mob/user)
	if(emerging || !user || user.stat || !is_station_level(user.z) || !ishuman(user))
		revert_cast()
		return
	var/mob/living/carbon/human/H = user
	var/thingy = alert(H,"Are you sure you want to emerge? You cannot undo this!",,"Yes","No")
	switch(thingy)
		if("No")
			revert_cast()
		if("Yes")
			emerging = TRUE
			INVOKE_ASYNC(src, .proc/emerge, H)

/obj/effect/proc_holder/spell/self/pillar_hatch/proc/emerge(mob/living/carbon/human/H)
	var/element = input(H, "Pick your element", "Pillar Men Elements") as null|anything in GLOB.pm_elements
	if(!element)
		emerging = FALSE
		revert_cast()
		return
	GLOB.pm_elements -= element
	H.status_flags |= GODMODE
	H.SetStun(INFINITY)
	var/list/walls = list()
	var/list/original_turfs = list()
	for(var/turf/T in orange(1, get_turf(H)))
		var/turf_type = T.type
		var/turf/closed/wall/mineral/sandstone/SSW = T.PlaceOnTop(/turf/closed/wall/mineral/sandstone)
		walls += SSW
		original_turfs[SSW] = turf_type
	notify_ghosts("[H] has begun to emerge as a Pillar Man at [get_area(H)]", source = H, action = NOTIFY_ORBIT)
	H.visible_message("<span class='notice bold'>[H] closes their eyes and begins to concentrate...</span>")
	sleep(100)
	H.visible_message("<span class='notice bold'>[H]'s muscles begin to bulge out, as their skin tans...</span>")
	H.unequip_everything()
	H.set_species(/datum/species/pillarmen)
	H.faction |= "pillarmen"
	H.undershirt = "Nude"
	H.underwear = "Nude"
	H.socks = "Nude"
	H.update_body()
	H.SetStun(0)
	H.status_flags &= ~GODMODE
	sleep(100)
	H.visible_message("<span class='notice bold'>[H] smiles as they begin to punch their way out of their cocoon...</span>")
	for(var/i = 1 to 10)
		playsound(get_turf(H), 'sound/effects/bang.ogg', 100, TRUE)
		sleep(10)
	H.visible_message("<span class='danger bold'>[H] bursts out of the sandstone cocoon, full of power!</span>")
	for(var/turf/closed/wall/mineral/sandstone/SSW in walls)
		var/orig = original_turfs[SSW]
		if(ispath(orig))
			SSW.PlaceOnTop(orig)
		else
			SSW.ScrapeAway()
	notify_ghosts("[H] has emerged as a Pillar Man at [get_area(H)]", source = H, action = NOTIFY_ORBIT)
	playsound(get_turf(H), 'sound/hallucinations/veryfar_noise.ogg', 100, TRUE)
	H.mind.RemoveSpell(src)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/absorb)
	switch(element)
		if("Wind")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/pillar_nado)
		if("Light")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/pillar_blade)
	if(!GLOB.pm_hatched)
		GLOB.pm_hatched = TRUE
		var/list/eligible = list()
		var/list/got_stone = list()
		for(var/datum/mind/M in SSticker.minds)
			if(!M.current)
				continue
			if(M.has_antag_datum(/datum/antagonist/pillar_thrall) || M.has_antag_datum(/datum/antagonist/pillarmen) || M.has_antag_datum(/datum/antagonist/vampire))
				continue
			if(!is_station_level(M.current))
				continue
			if(!considered_alive(M))
				continue
			if(considered_afk(M))
				continue
			eligible += M.current
		while(got_stone.len < 4)
			var/mob/living/L = pick_n_take(eligible)
			var/obj/item/stack/redshard/RS = new(get_turf(L))
			L.equip_to_slot(RS, SLOT_IN_BACKPACK)
			var/datum/antagonist/shardkeeper/SK = L.mind.add_antag_datum(/datum/antagonist/shardkeeper)
			SK = L.mind.has_antag_datum(/datum/antagonist/shardkeeper)
			var/datum/objective/shardkeeper/SKO = new
			SK.objectives += SKO
			L.mind.announce_objectives()
			got_stone += L

/obj/effect/proc_holder/spell/self/absorb
	name = "Absorb Bullets"
	desc = "Soften your outer flesh, allowing you to absorb and store ballistic projectiles for 10 seconds, before shooting them at nearby targets."
	action_icon = 'hippiestation/icons/mob/actions.dmi'
	action_icon_state = "breflect"
	action_background_icon = 'hippiestation/icons/mob/actions/backgrounds.dmi'
	action_background_icon_state = "bg_pillar"
	charge_max = 3 MINUTES
	clothes_req = FALSE

/obj/effect/proc_holder/spell/self/absorb/cast(list/targets, mob/user)
	if(!pillarmen_check(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	var/datum/antagonist/pillarmen/PA = user.mind.has_antag_datum(/datum/antagonist/pillarmen)
	var/datum/species/pillarmen/PM = H.dna.species
	if(!PA || !H || !PM)
		revert_cast()
		return
	PM.absorbing = TRUE
	sleep(10 SECONDS)
	PM.absorbing = FALSE
	if(!LAZYLEN(PM.stored_projectiles))
		return
	for(var/p in PM.stored_projectiles)
		var/turf/startloc = get_turf(user)
		var/atom/target
		var/list/people_to_shoot_at = list()
		for(var/mob/living/L in view(world.view, user))
			if(L == user)
				continue
			if(L.mind in PA.pillarTeam.members)
				continue
			people_to_shoot_at += L
		if(LAZYLEN(people_to_shoot_at))
			target = pick(people_to_shoot_at)
		else
			target = get_edge_target_turf(startloc, pick(GLOB.alldirs))
		var/obj/item/projectile/P = new p(startloc)
		user.visible_message("<span class='danger'>[user] sends [P] flying out[isliving(target) ? " at [target]!" : "!"]")
		P.starting = startloc
		P.firer = H
		P.yo = target.y - startloc.y
		P.xo = target.x - startloc.x
		P.original = target
		P.preparePixelProjectile(target, startloc)
		P.fire()
		sleep((7 SECONDS) / PM.stored_projectiles.len)
