//A barebones antagonist team.
/datum/team
	var/list/datum/mind/members = list()
	var/name = "team"
	var/member_name = "member"
	var/list/objectives = list() //common objectives, these won't be added or removed automatically, subtypes handle this, this is here for bookkeeping purposes.

/datum/team/New(starting_members)
	. = ..()
	if(starting_members)
		if(islist(starting_members))
			for(var/datum/mind/M in starting_members)
				add_member(M)
		else
			add_member(starting_members)

/datum/team/proc/is_solo()
	return members.len == 1

/datum/team/proc/add_member(datum/mind/new_member)
	members |= new_member

/datum/team/proc/remove_member(datum/mind/member)
	members -= member

//Display members/victory/failure/objectives for the team
/datum/team/proc/roundend_report()
	var/list/report = list()

	report += "<span class='header'>[name]:</span>"
	report += "The [member_name]s were:"
	report += printplayerlist(members)

<<<<<<< HEAD:code/game/gamemodes/antag_team.dm
	return report.Join("<br>")

//Get all teams [of type team_type]
//TODO move these to some antag helpers file with get_antagonists
/proc/get_all_teams(team_type)
	. = list()
	for(var/V in GLOB.antagonists)
		var/datum/antagonist/A = V
		if(!A.owner)
			continue
		var/datum/team/T = A.get_team()
		if(!team_type || istype(T,team_type))
			. |= T
=======
	if(objectives.len)
		report += "<span class='header'>Team had following objectives:</span>"
		var/win = TRUE
		var/objective_count = 1
		for(var/datum/objective/objective in objectives)
			if(objective.check_completion())
				report += "<B>Objective #[objective_count]</B>: [objective.explanation_text] <span class='greentext'><B>Success!</span>"
			else
				report += "<B>Objective #[objective_count]</B>: [objective.explanation_text] <span class='redtext'>Fail.</span>"
				win = FALSE
			objective_count++
		if(win)
			report += "<span class='greentext'>The [name] was successful!</span>"
		else
			report += "<span class='redtext'>The [name] have failed!</span>"


	return "<div class='panel redborder'>[report.Join("<br>")]</div>"
>>>>>>> 126a544a74... Slaughter demon, Morph, ERT / Deathsquad antag datums. (#35156):code/modules/antagonists/_common/antag_team.dm
