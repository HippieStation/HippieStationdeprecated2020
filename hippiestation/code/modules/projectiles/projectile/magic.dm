#define RESET_FISTED 30

/obj/item/projectile/magic/fist
	name = "strong fist"
	damage = 20
	damage_type = BRUTE
	nodamage = 0
	armour_penetration = 50 //You punch very hard.
	range = 2 //Just a little bit longer than melee range, for ease of use.
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "disintegrate"
	item_state = "disintegrate"

/obj/item/projectile/magic/fist/on_hit(target)
	.=..()
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		C.fist_casted = TRUE
		addtimer(CALLBACK(C, /mob/living/carbon.proc/reset_fist_casted), RESET_FISTED)
	if(ismovableatom(target))
		var/atom/movable/AM = target
		AM.throw_at(get_edge_target_turf(AM,get_dir(src, AM)), 15, 10) //This sends you FLYING at high speed.


#undef RESET_FISTED

/obj/item/projectile/magic/monkeyman/monkeyball
	name = "monkey decimation ball"
	icon = 'hippiestation/icons/obj/projectiles.dmi'
	icon_state = "monkey_fireball"
	damage = 15
	damage_type = BURN
	nodamage = 0

/obj/item/projectile/magic/monkeyman/monkeyball/on_hit(target)
	. = ..()
	var/turf/T = get_turf(target)
	explosion(T, -1, 0, 1, 1, 0, 0)
	if(ismob(target)) //multiple flavors of pain
		var/mob/living/M = target
		M.take_overall_damage(0,15)