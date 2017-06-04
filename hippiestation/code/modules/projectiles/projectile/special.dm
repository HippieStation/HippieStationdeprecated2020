/obj/item/projectile/energy/bolt
	stun = 0.1
	weaken = 0

/obj/item/projectile/energy/bolt/on_hit(atom/target, blocked = 0)
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		C.reagents.add_reagent("skewium", 10)
		C.hallucination += 30