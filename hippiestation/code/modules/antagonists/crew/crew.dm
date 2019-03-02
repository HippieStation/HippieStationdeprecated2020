/datum/antagonist/crew
	name = "Crewmember"
	var/datum/mind/M
	show_in_antagpanel = FALSE
	show_in_roundend = FALSE	//WE ARE GOING TO GET SPAMMED TO SHIT IF THIS IS TRUE

/datum/antagonist/crew/New()
	. = ..()
	M = var/datum/antagonist/crew/C
	M.forge_objectives(M.assigned_role = assigned_job)
	crew_team += M

/datum/antagonist/crew/greet()
	to_chat(M, "<b><font size=3 color='green'>You are a crewmember aboard the station. Help keep the station running and ensure the safety of your fellow crewmembers.</font></b>"
	M.announce_objectives()

/datum/antagonist/crew/proc/forge_objectives(M, var/assigned_job == "")
	M = var/datum/antagonist/crew/C
	for(var/job_required in var/datum/objective/crew/crew_job/obj)
		if(obj.job_required == assigned_job)	//Check if this crew member has the job required for this objective
			if((!obj in M.objectives))	//Don't repeat objectives pls
				M.objectives += new /datum/objective/crew/crew_job/obj
			else
				continue	//Plenty of other job objectives to choose from
		if(!obj.job_required)	//If no job requirement for this one, we can take it
			M.objectives += new /datum/objective/crew/crew_job/obj



