SUBSYSTEM_DEF(magic)
	name = "Magic"
	init_order = INIT_ORDER_XKEYSCORE
	flags = SS_NO_FIRE
	var/magical_factor
	var/list/loaded_magic = list()
	var/list/magic_traits = list()

/datum/controller/subsystem/magic/Initialize()
	. = ..()
	magical_factor = rand(MAGIC_RANDOMIZATION_MIN, MAGIC_RANDOMIZATION_MAX) * 0.1
	for(var/M in subtypesof(/datum/magic_trait))
		var/datum/magic_trait/MT = M
		if(initial(MT.name))
			magic_traits += new M
