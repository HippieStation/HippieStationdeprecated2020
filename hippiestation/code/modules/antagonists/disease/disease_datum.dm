/datum/antagonist/disease/greet()
	. = ..()
	owner.current.playsound_local(get_turf(owner.current), 'hippiestation/sound/ambience/antag/disease.ogg',80,0)
	
