/obj/item/projectile/energy/bolt
	stun = 0.1
	weaken = 0

/obj/item/projectile/energy/bolt/on_hit(atom/target, blocked = 0)
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(!C.reagents.has_reagent("skewium", 5)) //you can keep them topped off with just under 10 skewium.
			C.reagents.add_reagent("skewium", 5)
		if(C.hallucination < 20) // We only want to go about as high as 30 halucination.
			C.hallucination += 10