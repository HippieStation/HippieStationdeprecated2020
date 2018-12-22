/obj/item/shield/energy/deathsquad
	name = "elite energy combat shield"

/obj/item/shield/energy/deathsquad/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if (active)
		if(!istype(owner.mind.martial_art, /datum/martial_art/elite_cqc))
			owner.visible_message("<span class='warning'>[owner] tries to block [attack_text] with [src], but fails!</span>")
			return FALSE
		if(attack_type == THROWN_PROJECTILE_ATTACK)
			final_block_chance += 30
		if(attack_type == LEAP_ATTACK)
			final_block_chance = 100
			return 1
		if(attack_type == MELEE_ATTACK)
			final_block_chance = 90
		if(attack_type == PROJECTILE_ATTACK)
			final_block_chance = 70
			if(istype(hitby, /obj/item/projectile/bullet/neurotoxin))
				final_block_chance = 100
		SEND_SIGNAL(src, COMSIG_ITEM_HIT_REACT, args)
		if (prob(final_block_chance))
			owner.visible_message("<span class='danger'>[owner] skillfully blocks [attack_text] with [src]!</span>")
			return TRUE
	return FALSE