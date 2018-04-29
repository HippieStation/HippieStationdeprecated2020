/datum/antagonist/brother/greet()
	. = ..()
	owner.current.playsound_local(get_turf(owner.current), 'hippiestation/sound/ambience/antag/brother.ogg',80,0)
	
