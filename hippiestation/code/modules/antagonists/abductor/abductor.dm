/datum/antagonist/abductor/greet()
	to_chat(owner.current, "<span class='notice'>You are the [owner.special_role]!</span>")
	to_chat(owner.current, "<span class='notice'>With the help of your teammate, kidnap and experiment on station crew members!</span>")
	to_chat(owner.current, "<span class='notice'>[greet_text]</span>")
	owner.announce_objectives()
  owner.current.playsound_local(get_turf(owner.current), 'hippiestation/sound/ambience/antag/abductor.ogg',80,0)
  
