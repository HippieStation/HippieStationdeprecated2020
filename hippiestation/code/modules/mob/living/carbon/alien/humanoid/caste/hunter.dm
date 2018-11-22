/mob/living/carbon/alien/humanoid/hunter/leap_at(atom/A)
	if(!((mobility_flags & (MOBILITY_MOVE | MOBILITY_STAND)) != (MOBILITY_MOVE | MOBILITY_STAND) || leaping) && !(pounce_cooldown > world.time) && !(!has_gravity() || !A.has_gravity()))
		add_trait(TRAIT_STUNIMMUNE, "hippie-alium")
	return ..()

/mob/living/carbon/alien/humanoid/hunter/leap_end()
	remove_trait(TRAIT_STUNIMMUNE, "hippie-alium")
	return ..()