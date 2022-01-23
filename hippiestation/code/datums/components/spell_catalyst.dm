/* Used to see if an item can act as a spell catalyst */
/datum/component/spell_catalyst

/datum/component/spell_catalyst/Initialize()
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE,.proc/OnExamine)
	.=..()

/datum/component/spell_catalyst/proc/OnExamine(datum/source, mob/user)
	to_chat(user, "<span class='notice'>[parent] gives off a gentle, magical blue glow.</span>")
