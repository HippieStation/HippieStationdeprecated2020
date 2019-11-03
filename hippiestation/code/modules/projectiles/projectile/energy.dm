/obj/item/projectile/energy/electrode
	stun = 0
	paralyze = 0
	stamina = 60

/obj/item/projectile/energy/electrode/on_hit(atom/target, blocked = 0)
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(prob(50))
			C.dropItemToGround(C.get_active_held_item())
		..()

/obj/item/projectile/beam/disabler
	damage = 39 //it should take about four shots to down someone, but seeing as people regen stamina all the time, setting it to 25 means you would need 5 shots.

/obj/item/ammo_casing/caseless/laser // I didn't know where to put this.
	fire_sound = 'hippiestation/sound/weapons/Laser.ogg'

/obj/item/ammo_casing/energy
	fire_sound = 'hippiestation/sound/weapons/Laser.ogg'

/obj/item/projectile/energy/singulo
	name = "gravitational singularity"
	desc = "A gravitational singularity."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "singularity_s1"
	var/singulo_range = 5

/obj/item/projectile/energy/singulo/Range()
	..()
	transform *= 1.25 //25% larger per tile
	eat()

/obj/item/projectile/energy/singulo/on_hit(atom/target)
	. = ..()
	target.singularity_act()

/obj/item/projectile/energy/singulo/proc/eat()
	for(var/tile in spiral_range_turfs(2, src))
		var/turf/T = tile
		if(!T || !isturf(loc))
			continue
		T.singularity_pull(src, singulo_range)
		for(var/thing in T)
			if(isturf(loc) && thing != src)
				var/atom/movable/X = thing
				X.singularity_pull(src, singulo_range)
			CHECK_TICK
	return
