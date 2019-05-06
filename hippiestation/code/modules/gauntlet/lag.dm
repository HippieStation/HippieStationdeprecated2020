/obj/item/infinity_stone/lag
	name = "Lag Stone"
	desc = "The bane of a coder's existence."
	color = "#654321"
	ability_text = list("HELP INTENT: Set a point on the station, or if a point is already set, teleport back to it. Stuns you for a while, but heals you alot.",
		"HARM INTENT: Phase to nearby point.",
		"GRAB INTENT: Swap places with the victim, and then fire a projectile!",
		"DISARM INTENT: Shoot a disorienting projectile")
	spell_types = list(/obj/effect/proc_holder/spell/aoe_turf/conjure/timestop/lag_stone)
	stone_type = LAG_STONE
	var/turf/teleport_point

/obj/item/infinity_stone/lag/HelpEvent(atom/target, mob/living/user, proximity_flag)
	var/turf/T = get_turf(target)
	if(T == teleport_point)
		to_chat(user, "<span class='notice'>You unset [T] as your teleportation point.</span>")
		teleport_point = null
		return
	if(!teleport_point || !istype(teleport_point))
		if(proximity_flag)
			to_chat(user, "<span class='notice'>You set [T] as your teleportation point.</span>")
			teleport_point = T
		return
	else
		user.visible_message("<span class='danger'>[user] melts into the air and warps away!</span>", "<span class='notice'>We warp to our location, but doing so saps our strength...</span></span>")
		do_teleport(user, teleport_point, channel = TELEPORT_CHANNEL_BLUESPACE)
		user.Paralyze(450)
		user.heal_overall_damage(45, 45, 45, null, TRUE)

/obj/item/infinity_stone/lag/HarmEvent(atom/target, mob/living/user, proximity_flag)
	if(target in view(user.client.view, user))
		var/turf/from = get_turf(user)
		var/turf/there = get_turf(target)
		var/obj/spot1 = new /obj/effect/temp_visual/dir_setting/ninja/phase/out(from)
		do_teleport(user, there, channel = TELEPORT_CHANNEL_BLUESPACE)
		var/obj/spot2 = new /obj/effect/temp_visual/dir_setting/ninja/phase(there)
		spot1.Beam(spot2, "blur", time=20)

/obj/item/infinity_stone/lag/GrabEvent(atom/target, mob/living/user, proximity_flag)
	if(!isliving(target))
		to_chat(user, "<span class='notice'>You can only switch places with living targets!</span>")
		return
	var/turf/them = get_turf(target)
	var/turf/us = get_turf(user)
	user.visible_message("<span class='danger'>[user] flickers out, and in their place, [target] appears!</span>")
	target.visible_message("<span class='danger'>[target] flickers out, and in their place, [user] appears!</span>")
	do_teleport(user, them, channel = TELEPORT_CHANNEL_BLUESPACE)
	do_teleport(target, us, channel = TELEPORT_CHANNEL_BLUESPACE)
	FireProjectile(/obj/item/projectile/magic/arcane_barrage, us)
	user.changeNext_move(CLICK_CD_RANGE)

/obj/item/infinity_stone/lag/DisarmEvent(atom/target, mob/living/user, proximity_flag)
	FireProjectile(/obj/item/projectile/magic/lag_stone, target)
	user.changeNext_move(CLICK_CD_RANGE)

/////////////////////////////////////////////
/////////////////// SPELLS //////////////////
/////////////////////////////////////////////

/obj/effect/proc_holder/spell/aoe_turf/conjure/timestop/lag_stone
	name = "Lag Stone: Summon Lag"
	desc = "Summon a large bout of lag within a 5-tile radius. Very infuriating. Infinity Stone holders are immune, however."
	summon_type = list(/obj/effect/timestop/wizard/lag_stone)
	clothes_req = FALSE
	staff_req = FALSE
	human_req = FALSE
	charge_max = 750

/obj/effect/timestop/wizard/lag_stone
	name = "lagfield"
	desc = "Oh no. OH NO."
	freezerange = 4
	duration = 175
	pixel_x = -64
	pixel_y = -64
	start_sound = 'hippiestation/sound/effects/unnatural_clock_noises.ogg'

/obj/effect/timestop/wizard/lag_stone/Initialize(mapload, radius, time, list/immune_atoms, start)
	. = ..()
	var/matrix/ntransform = matrix(transform)
	ntransform.Scale(2)
	animate(src, transform = ntransform, time = 2, easing = EASE_IN|EASE_OUT)

/////////////////////////////////////////////
/////////////////// ITEMS ///////////////////
/////////////////////////////////////////////

/obj/item/projectile/magic/lag_stone
	name = "lagbeam"
	icon_state = "omnilaser"
	stutter = 15
	jitter = 15
	eyeblur = 20
	stamina = 7.5
	
/obj/item/projectile/magic/lag_stone/on_hit(atom/target, blocked = FALSE)
	if(isliving(target))
		var/mob/living/M = target
		if(blocked != 100)
			M.Dizzy(35)
