/obj/item/projectile/bullet/magnum
	damage = 60

/obj/item/projectile/bullet/c38 // Detectives .38 revolver
	paralyze = 0
	stun = 0
	damage = 15
	stamina = 45 //Plus the 15 base damage means two shots will down a perp

/obj/item/projectile/bullet/weakbullet2/on_hit(atom/target, blocked = 0)
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(prob(50))
			C.dropItemToGround(C.get_active_held_item())
		..()


/obj/item/projectile/bullet/shotgun_stunslug // Syndie bulldog shotgun stunslugs
	stun = 0
	paralyze = 0
	stamina = 80 //Stunshot can stay potent to give nukies an edge.

/obj/item/projectile/bullet/p50 // Sniper rifles
	stun = 10
	paralyze = 10

/obj/item/projectile/bullet/pellet/shotgun_buckshot
	damage = 6.25

/obj/item/projectile/bullet/pellet/shotgun_rubbershot
	damage = 1.5
	stamina = 12.5

/obj/item/projectile/bullet/process_hit(turf/T, atom/target, qdel_self, hit_something = FALSE)
	. = ..()
	if(ishuman(target) && damage && !nodamage)
		var/obj/effect/decal/cleanable/blood/hitsplatter/B = new(target.loc, target)
		B.add_blood_DNA(return_blood_DNA())
		var/dist = rand(1,3)
		var/turf/targ = get_ranged_target_turf(target, get_dir(starting, target), dist)
		B.GoTo(targ, dist)