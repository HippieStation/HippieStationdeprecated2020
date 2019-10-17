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
			to_chat(world, "loaded trait [initial(MT.name)]")
			magic_traits += new M
	for(var/m in subtypesof(/datum/magic))
		var/datum/magic/M = m
		if(initial(M.name) && initial(M.roundstart))
			to_chat(world, "loaded magic [initial(M.name)]")
			var/datum/magic/magick = new m
			magick.setup()
			loaded_magic += magick
