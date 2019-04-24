/datum/job/chaplain/after_spawn(mob/living/H, mob/M)
	. = ..()
	H.add_trait(TRAIT_ANTIMAGIC, JOB_TRAIT)
