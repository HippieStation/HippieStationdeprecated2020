/client/cmd_admin_rejuvenate(mob/living/M in GLOB.mob_list)
	. = ..(M)
	M.unascend_animation()
	M.visible_message("<span class='warning bold'>[M] was healed by divine intervention!</span>")