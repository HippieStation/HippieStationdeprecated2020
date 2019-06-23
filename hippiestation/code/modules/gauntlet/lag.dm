//Originally coded for HippieStation by Steamp0rt, shared under the AGPL license.

/obj/item/badmin_stone/lag
	name = "Lag Stone"
	desc = "The bane of a coder's existence."
	color = "#20B2AA"
	ability_text = list("HELP INTENT: Set a point on the station, or if a point is already set, teleport back to it. Stuns you for a while, but heals you alot.",
		"GRAB INTENT: Swap places with the victim, and then fire a projectile!",
		"DISARM INTENT: Shoot a disorienting projectile")
	spell_types = list(/obj/effect/proc_holder/spell/self/infinity/doppelgangers,
		/obj/effect/proc_holder/spell/self/infinity/shuffle)
	gauntlet_spell_types = list(/obj/effect/proc_holder/spell/aoe_turf/conjure/timestop/lag_stone)
	stone_type = LAG_STONE
	var/turf/teleport_point

/obj/item/badmin_stone/lag/HelpEvent(atom/target, mob/living/user, proximity_flag)
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

/obj/item/badmin_stone/lag/GrabEvent(atom/target, mob/living/user, proximity_flag)
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

/obj/item/badmin_stone/lag/DisarmEvent(atom/target, mob/living/user, proximity_flag)
	FireProjectile(/obj/item/projectile/magic/lag_stone, target)
	user.changeNext_move(CLICK_CD_RANGE)

/////////////////////////////////////////////
/////////////////// SPELLS //////////////////
/////////////////////////////////////////////

/obj/effect/proc_holder/spell/self/infinity/doppelgangers
	name = "Lag Stone: Doppelgangers"
	desc = "Summon a bunch of (harmless) look-alikes of you!"
	action_icon_state = "doppelganger"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "lag"
	charge_max = 1800
	var/amt = 4

/obj/effect/proc_holder/spell/self/infinity/doppelgangers/cast(list/targets, mob/user)
	for(var/i = 1 to amt)
		var/mob/living/simple_animal/hostile/illusion/doppelganger/E = new(user.loc)
		E.setDir(user.dir)
		E.Copy_Parent(user, 30 SECONDS, 100)
		E.target = null
		random_step(E, 5, 100)

/mob/living/simple_animal/hostile/illusion/doppelganger
	melee_damage_lower = 0
	melee_damage_upper = 0
	speed = -1
	obj_damage = 0
	vision_range = 0
	environment_smash = ENVIRONMENT_SMASH_NONE


/obj/effect/proc_holder/spell/self/infinity/shuffle
	name = "Lag Stone: The Shuffle"
	desc = "Swap everyone in your view's position!"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "lag"
	charge_max = 750

/obj/effect/proc_holder/spell/self/infinity/shuffle/cast(list/targets, mob/user)
	var/list/mobs = list()
	var/list/moblocs = list()
	for(var/mob/living/L in view(7, user))
		moblocs += L.loc
		mobs += L
	shuffle_inplace(mobs)
	shuffle_inplace(moblocs)
	for(var/mob/living/L in mobs)
		if(!LAZYLEN(moblocs))
			break
		L.forceMove(moblocs[moblocs.len])
		moblocs.len -= 1

/obj/effect/proc_holder/spell/aoe_turf/conjure/timestop/lag_stone
	name = "Lag Stone: Summon Lag"
	desc = "Summon a large bout of lag within a 5-tile radius. Very infuriating. Badmin Stone holders are immune, however."
	action_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_icon_state = "lagfield"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "lag"
	summon_type = list(/obj/effect/timestop/wizard/lag_stone)
	clothes_req = FALSE
	staff_req = FALSE
	human_req = FALSE
	antimagic_allowed = TRUE
	charge_max = 750
	invocation_type = "none"

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
	eyeblur = 15
	stamina = 5
	nodamage = FALSE
	
/obj/item/projectile/magic/lag_stone/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(isliving(target))
		var/mob/living/M = target
		if(blocked != 100)
			M.Dizzy(35)
