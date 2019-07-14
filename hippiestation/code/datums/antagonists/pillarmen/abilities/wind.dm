/obj/effect/proc_holder/spell/self/pillar_nado
	name = "Tornado Form"
	desc = "Use your elemental control over wind to turn yourself into a tornado, flinging away to anything that dares cross your path."
	action_icon = 'icons/obj/wizard.dmi'
	action_icon_state = "tornado"
	action_background_icon = 'hippiestation/icons/mob/actions/backgrounds.dmi'
	action_background_icon_state = "bg_pillar"
	charge_max = 2 MINUTES
	clothes_req = FALSE

/obj/effect/proc_holder/spell/self/pillar_nado/cast(list/targets, mob/user)
	if(!pillarmen_check(user))
		revert_cast()
		return FALSE
	user.visible_message("<span class='danger'>Wind begins to swirl around [user] at alarming speeds!</span>")
	var/obj/effect/pillar_tornado/tornado = new(get_turf(user))
	user.forceMove(tornado)
	sleep(10 SECONDS)
	user.visible_message("<span class='warning'>The wind around [user] calms down...</span>")
	user.forceMove(get_turf(tornado))
	qdel(tornado)

/obj/effect/pillar_tornado
	name = "tornado"
	desc = "What is a tornado doing on a space station?!"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "tornado"
	layer = FLY_LAYER
	density = FALSE

/obj/effect/pillar_tornado/relaymove(mob/user, direction)
	step(src, direction)
	for(var/atom/movable/AM in loc)
		if(AM == src)
			continue
		toss_around(AM)

/obj/effect/pillar_tornado/proc/toss_around(atom/movable/AM)
	if(AM.anchored)
		return
	if(isliving(AM))
		var/mob/living/L = AM
		L.visible_message("<span class='warning'>[L] is sent flying by the tornado!</span>", "<span class='danger'>The tornado sends you flying!</span>")
		L.adjustBruteLoss(9)
	AM.throw_at(get_edge_target_turf(AM, pick(GLOB.alldirs)), 10, 3)


/obj/effect/forcefield/pillarmen/wind
	desc = "A whirling current of cold air blocking your path. It'd be unwise to cross it."
	var/mob/owner

/obj/effect/forcefield/wizard/Initialize(mapload, mob/summoner)
	. = ..()
	owner = summoner

/obj/effect/forcefield/wizard/CanPass(atom/movable/mover, turf/target)
	if(mover == owner)
		return TRUE
	if(ismob(mover))
		var/mob/M = mover
		if (M.mind)
			if(istype(M.mind.martial_art,/datum/martial_art/hamon))
				return TRUE
		M.visible_message("<span class='warning'>[M] gets sent flying by the whirlwind currents!</span>", "<span class='danger'>The currents sends you flying!</span>")
		M.throw_at(get_edge_target_turf(M, pick(GLOB.alldirs)), 10, 3)
		owner.Paralyze(70)
	return FALSE


/obj/effect/proc_holder/spell/targeted/forcewall/pillar_wind
	wall_type =	/obj/effect/forcefield/pillarmen/wind