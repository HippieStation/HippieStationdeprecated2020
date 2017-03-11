/obj/item/projectile/plasmoid
 	name = "plasmoid"
 	icon = 'icons/hippie/obj/projectiles.dmi'
 	icon_state = "plasmoid"
 	damage_type = BURN
 	damage = 20
 	range = 14
 	luminosity = 2
 	var/temperature = 200

/obj/item/projectile/plasmoid/on_hit(atom/target, blocked = 0)
	..()
	if(istype(target,/turf/)||istype(target,/obj/structure/))
		target.ex_act(2)
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.bodytemperature += temperature
		M.adjust_fire_stacks(1)
		M.IgniteMob()
	return 1