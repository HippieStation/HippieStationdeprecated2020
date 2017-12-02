#define MORPH_COOLDOWN 10

mob/living/simple_animal/hostile/morph
	speed = 1
	maxHealth = 250
	health = 250
	obj_damage = 100
	melee_damage_lower = 35
	melee_damage_upper = 35
	armour_penetration = 100 //Pain

/mob/living/simple_animal/hostile/morph/proc/assume(atom/movable/target)
	melee_damage_lower = 10
	melee_damage_upper = 10

/mob/living/simple_animal/hostile/morph/AttackingTarget()
	if(isliving(target))
		var/mob/living/L = target
		if(L.stat == DEAD)
			if(do_after(src, 10, target = L))
				if(eat(L))
					adjustHealth(-125)
	else if(isitem(target))
		var/obj/item/I = target
		if(!I.anchored)
			if(do_after(src, 5, target = I))
				eat(I)
			return
	return ..()
