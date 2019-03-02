/datum/controller/subsystem/ticker/personal_report(client/C, popcount)
	var/list/parts = list()
	var/mob/M = C.mob
	if(M.mind && !isnewplayer(M))
		if(M.stat != DEAD && !isbrain(M))
			if(EMERGENCY_ESCAPED_OR_ENDGAMED)
				if(!M.onCentCom() && !M.onSyndieBase())
					parts += "<div class='panel stationborder'>"
					parts += "<span class='marooned'>You managed to survive, but were marooned on [station_name()]...</span>"
				else
					parts += "<div class='panel greenborder'>"
					parts += "<span class='greentext'>You managed to survive the events on [station_name()] as [M.real_name].</span>"
			else
				parts += "<div class='panel greenborder'>"
				parts += "<span class='greentext'>You managed to survive the events on [station_name()] as [M.real_name].</span>"
		else
			parts += "<div class='panel redborder'>"
			parts += "<span class='redtext'>You did not survive the events on [station_name()]...</span>"
	var/crewfailed = FALSE	//Greentext or no?
	M = var/datum/antagonist/crew/C
	if(M.has_antag_datum(C))	//Individual report if you are a crewmember
		if(M.objectives)
			for(var/datum/objective/objective in M.objectives)
				if(objective.check_completion())
					parts += "<b>Objective #[count]</b>: [objective.explanation_text] <span class='greentext'>Success!</b></span>"
				else
					parts += "<b>Objective #[count]</b>: [objective.explanation_text] <span class='redtext'>Failed!</span>"
					crewfailed = TRUE
	if(crewfailed)
		parts += "<span class='redtext'>You failed your crew objectives!</span>"
	else
		parts += "<span class='greentext'>You completed all your crew objectives!</span>"

	parts += "<div class='panel stationborder'>"
	parts += "<br>"
	parts += GLOB.survivor_report
	parts += "</div>"

	return parts.Join()