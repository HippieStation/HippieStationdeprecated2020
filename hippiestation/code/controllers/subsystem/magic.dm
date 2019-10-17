SUBSYSTEM_DEF(magic)
	name = "Magic"
	init_order = INIT_ORDER_XKEYSCORE
	flags = SS_NO_FIRE
	var/magical_factor
	var/list/loaded_spells

/datum/controller/subsystem/magic/Initialize()
	. = ..()
	magical_factor = rand(MAGIC_RANDOMIZATION_MIN, MAGIC_RANDOMIZATION_MAX)
