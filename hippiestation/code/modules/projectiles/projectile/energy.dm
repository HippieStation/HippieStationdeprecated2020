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