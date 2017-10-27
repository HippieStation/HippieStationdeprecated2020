/obj/item/projectile/bullet/magnum
	damage = 45
	speed = 0.8
	armour_penetration = 30

/obj/item/projectile/bullet/weakbullet2
	knockdown = 0
	stun = 0
	stamina = 45 //Plus the 15 base damage means two shots will down a perp

/obj/item/projectile/bullet/weakbullet2/on_hit(atom/target, blocked = 0)
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(prob(50))
			C.dropItemToGround(C.get_active_held_item())
		..()


/obj/item/projectile/bullet/stunshot
	stun = 0
	knockdown = 0
	stamina = 80 //Stunshot can stay potent to give nukies an edge.

/obj/item/projectile/bullet/sniper
	stun = 1
	knockdown = 1
