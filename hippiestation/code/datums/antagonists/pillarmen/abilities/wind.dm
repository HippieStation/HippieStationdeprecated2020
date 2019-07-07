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
