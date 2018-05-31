/datum/antagonist/abductor/greet()
	. = ..()
	owner.current.playsound_local(get_turf(owner.current), 'hippiestation/sound/ambience/antag/abductor.ogg',80,0)
	
