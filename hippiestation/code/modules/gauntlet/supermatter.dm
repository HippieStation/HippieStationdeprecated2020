//Originally coded for HippieStation by Steamp0rt, shared under the AGPL license.

/obj/item/badmin_stone/supermatter
	name = "Supermatter Stone"
	desc = "Don't touch, it's hot! Oh yeah, and it bends reality."
	stone_type = SUPERMATTER_STONE
	color = "#ECF332"
	spell_types = list (/obj/effect/proc_holder/spell/spacetime_dist/supermatter_stone)
	gauntlet_spell_types = list(/obj/effect/proc_holder/spell/targeted/tesla/supermatter_stone,
		/obj/effect/proc_holder/spell/targeted/infinity/delamination)
	ability_text = list("HELP INTENT: Fire a short-range, burning-hot crystal spray", 
		"GRAB INTENT: Fire a long-range, rapid, but low damage volt ray",
		"DISARM INTENT: Fire a short-range fire blast that knocks people back.", 
		"Use on a material to use 25 sheets of it for a golem. 2 minute cooldown!")
	var/next_golem = 0

/obj/item/badmin_stone/supermatter/DisarmEvent(atom/target, mob/living/user, proximity_flag)
	if(!HandleGolem(user, target))
		FireProjectile(/obj/item/projectile/forcefire, target)
		user.changeNext_move(6)

/obj/item/badmin_stone/supermatter/GrabEvent(atom/target, mob/living/user, proximity_flag)
	if(!proximity_flag || !HandleGolem(user, target))
		FireProjectile(/obj/item/projectile/voltray, target)
		user.changeNext_move(CLICK_CD_RAPID)

/obj/item/badmin_stone/supermatter/HelpEvent(atom/target, mob/living/user, proximity_flag)
	if(!proximity_flag || !HandleGolem(user, target))
		FireProjectile(/obj/item/projectile/supermatter_stone, target)
		user.changeNext_move(CLICK_CD_RANGE)


/obj/item/badmin_stone/supermatter/proc/HandleGolem(mob/living/user, atom/target)
	var/static/list/golem_shell_species_types = list(
		/obj/item/stack/sheet/metal	                = /datum/species/golem,
		/obj/item/stack/sheet/glass 	            = /datum/species/golem/glass,
		/obj/item/stack/sheet/plasteel 	            = /datum/species/golem/plasteel,
		/obj/item/stack/sheet/mineral/sandstone	    = /datum/species/golem/sand,
		/obj/item/stack/sheet/mineral/plasma	    = /datum/species/golem/plasma,
		/obj/item/stack/sheet/mineral/diamond	    = /datum/species/golem/diamond,
		/obj/item/stack/sheet/mineral/gold	        = /datum/species/golem/gold,
		/obj/item/stack/sheet/mineral/silver	    = /datum/species/golem/silver,
		/obj/item/stack/sheet/mineral/uranium	    = /datum/species/golem/uranium,
		/obj/item/stack/sheet/mineral/bananium	    = /datum/species/golem/bananium,
		/obj/item/stack/sheet/mineral/titanium	    = /datum/species/golem/titanium,
		/obj/item/stack/sheet/mineral/plastitanium	= /datum/species/golem/plastitanium,
		/obj/item/stack/sheet/mineral/abductor	    = /datum/species/golem/alloy,
		/obj/item/stack/sheet/mineral/wood	        = /datum/species/golem/wood,
		/obj/item/stack/sheet/bluespace_crystal	    = /datum/species/golem/bluespace,
		/obj/item/stack/sheet/runed_metal	        = /datum/species/golem/runic,
		/obj/item/stack/medical/gauze	            = /datum/species/golem/cloth,
		/obj/item/stack/sheet/cloth	                = /datum/species/golem/cloth,
		/obj/item/stack/sheet/mineral/adamantine	= /datum/species/golem/adamantine,
		/obj/item/stack/sheet/plastic	            = /datum/species/golem/plastic,
		/obj/item/stack/tile/brass					= /datum/species/golem/clockwork,
		/obj/item/stack/tile/bronze					= /datum/species/golem/bronze,
		/obj/item/stack/sheet/cardboard				= /datum/species/golem/cardboard,
		/obj/item/stack/sheet/leather				= /datum/species/golem/leather,
		/obj/item/stack/sheet/bone					= /datum/species/golem/bone,
		/obj/item/stack/sheet/cloth/durathread		= /datum/species/golem/durathread,
		/obj/item/stack/sheet/cotton/durathread		= /datum/species/golem/durathread,
		/obj/item/stack/sheet/capitalisium			= /datum/species/golem/capitalist,
		/obj/item/stack/sheet/stalinium				= /datum/species/golem/soviet)
	if(istype(target, /obj/item/stack))
		if(world.time < next_golem)
			to_chat(user, "<span class='notice'>You need to wait [DisplayTimeText(world.time-next_golem)] before you can make another golem.</span>")
			return TRUE
		var/obj/item/stack/O = target
		var/species = golem_shell_species_types[O.merge_type]
		if(species)
			if(O.use(25))
				to_chat(user, "<span class='notice'>You materialize a golem with 25 sheets of [O].</span>")
				new /obj/item/golem_shell/servant(get_turf(target), species, user)
				next_golem = world.time + 2 MINUTES
				return TRUE
	return FALSE

/////////////////////////////////////////////
/////////////////// SPELLS //////////////////
/////////////////////////////////////////////

/obj/effect/proc_holder/spell/spacetime_dist/supermatter_stone
	name = "Supermatter Stone: Reality Distortion"
	desc = "Bend reality until it's unrecognizable for a short time."
	action_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_icon_state = "reality"
	clothes_req = FALSE
	human_req = FALSE
	staff_req = FALSE
	invocation_type = "none"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "sm"

/obj/effect/proc_holder/spell/targeted/infinity/delamination
	name = "Supermatter Stone: Delamination!"
	desc = "After 3 seconds, put a marker on someone, which will EXPLODE after 15 seconds!"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "sm"

/obj/effect/proc_holder/spell/targeted/infinity/delamination/InterceptClickOn(mob/living/caller, params, atom/t)
	. = ..()
	if(!.)
		revert_cast()
		return FALSE
	if(!isliving(t))
		revert_cast()
		return FALSE
	var/mob/living/L = t
	if(locate(/obj/item/badmin_stone) in L.GetAllContents())
		L.visible_message("<span class='danger bold'>[L] resists an unseen force!</span>")
		Finished()
		return TRUE
	remove_ranged_ability()
	if(!caller.Adjacent(L))
		to_chat(caller, "<span class='notice'>They're too far away!</span>")
		revert_cast()
		return FALSE
	if(do_after(caller, 30, target = L))
		L.visible_message("<span class='danger bold'>[L] seems a bit hot...</span>", "<span class='userdanger'>You feel like you'll explode any second!</span>")
		addtimer(CALLBACK(GLOBAL_PROC, .proc/explosion, L, 0, 0, 2, 3, TRUE, FALSE, 3), 150)
	Finished()
	return TRUE

/////////////////////////////////////////////
/////////////////// STUFF ///////////////////
/////////////////////////////////////////////

/obj/item/projectile/supermatter_stone
	name = "burning crystal"
	icon_state = "guardian"
	damage = 15
	damage_type = BURN
	color = "#ECF332"
	speed = 0.95
	armour_penetration = 100

/obj/item/projectile/voltray
	name = "volt ray"
	icon = 'icons/effects/beam.dmi'
	flag = "laser"
	nodamage = TRUE // handled in on_hit
	tracer_type = /obj/effect/projectile/tracer/voltray
	muzzle_type = /obj/effect/projectile/muzzle/voltray
	impact_type = /obj/effect/projectile/impact/voltray
	hitscan = TRUE

/obj/item/projectile/voltray/on_hit(atom/target, blocked)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		C.electrocute_act(7, src, 1, FALSE, FALSE, FALSE, FALSE, FALSE)
	else if(isliving(target))
		var/mob/living/L = target
		L.electrocute_act(7, src, 1, FALSE, FALSE, FALSE, FALSE)

/obj/effect/projectile/tracer/voltray
	name = "volt ray"
	icon_state = "solar"

/obj/effect/projectile/muzzle/voltray
	name = "volt ray"
	icon_state = "solar"

/obj/effect/projectile/impact/voltray
	name = "volt ray"
	icon_state = "solar"

/obj/item/projectile/forcefire
	name = "forcefire"
	icon_state = "plasma"
	damage = 10
	damage_type = BURN
	range = 5
	speed = 0.95
	var/knockback = 3

/obj/item/projectile/forcefire/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(ismovable(target))
		var/atom/movable/AM = target
		if(!AM.anchored)
			if(isliving(AM))
				var/mob/living/L = AM
				L.adjust_fire_stacks(2)
				L.IgniteMob()
				L.Paralyze(4)
			AM.throw_at(get_edge_target_turf(AM, get_dir(src, AM)), knockback, 4)

/obj/effect/proc_holder/spell/targeted/tesla/supermatter_stone
	name = "Supermatter Blast"
	desc = "Charge up an arc of supermatter-amped electricity"
	action_icon = 'icons/obj/supermatter.dmi'
	action_icon_state = "darkmatter_glow"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "sm"
	human_req = FALSE
	clothes_req = FALSE
	staff_req = FALSE
	antimagic_allowed = TRUE
	invocation_type = "none"

/obj/effect/proc_holder/spell/targeted/tesla/supermatter_stone/cast(list/targets, mob/user = usr)
	ready = FALSE
	var/mob/living/carbon/target = targets[1]
	Snd=sound(null, repeat = 0, wait = 1, channel = Snd.channel) //byond, why you suck?
	playsound(get_turf(user),Snd,50,0)// Sorry MrPerson, but the other ways just didn't do it the way i needed to work, this is the only way.
	if(get_dist(user,target)>range)
		to_chat(user, "<span class='notice'>[target.p_theyre(TRUE)] too far away!</span>")
		Reset(user)
		return

	playsound(get_turf(user), 'sound/effects/empzap.ogg', 50, 1)
	user.Beam(target,icon_state="nzcrentrs_power",time=5)

	Bolt(user,target,40,10,user)
	Reset(user)

/obj/effect/proc_holder/spell/targeted/tesla/supermatter_stone/Bolt(mob/origin,mob/target,bolt_energy,bounces,mob/user = usr)
	origin.Beam(target,icon_state="nzcrentrs_power",time=5)
	var/mob/living/carbon/current = target
	if(bounces < 1)
		current.electrocute_act(bolt_energy,"SM Bolt",safety=1)
		playsound(get_turf(current), 'sound/effects/empzap.ogg', 50, 1, -1)
	else
		current.electrocute_act(bolt_energy,"SM Bolt",safety=1)
		playsound(get_turf(current), 'sound/effects/empzap.ogg', 50, 1, -1)
		var/list/possible_targets = new
		for(var/mob/living/M in view(range,target))
			if(user == M || target == M && los_check(current,M)) // || origin == M ? Not sure double shockings is good or not
				continue
			possible_targets += M
		if(!possible_targets.len)
			return
		var/mob/living/next = pick(possible_targets)
		if(next)
			Bolt(current,next,max((bolt_energy-5),5),bounces-1,user)
