//made by Karma

/datum/antagonist/pillarmen
	name = "Pillar Man"
	antagpanel_category = "Pillar Man"
	roundend_category = "pillar men"
	job_rank = ROLE_PILLARMEN
	var/datum/team/pillarmen/pillarManTeam //Will have the pillar man himself, the vampires and the thralls.
	var/ascended = FALSE
	var/true_name = "" // rng, changed

/datum/antagonist/pillarmen/on_gain()
	. = ..()

/datum/antagonist/pillarmen/on_removal()
	. = ..()
	pillarManTeam.pillars -= owner

/datum/antagonist/pillarmen/create_team(datum/team/pillarmen/new_team)
	if(istype(new_team))
		pillarManTeam = new_team
		pillarManTeam.pillarMan = owner

/datum/antagonist/pillarmen/get_team()
	return pillarManTeam

/datum/antagonist/pillarmen/greet()
	to_chat(owner.current, "<span class='cultlarge'>You are a <span class='reallybig hypnophrase'>Pillar Man</span>, in disguise.</span>")
	to_chat(owner.current, "<span class='cult'>In order to unlock your immense power, you must hatch first.</span>")
	to_chat(owner.current, "<span class='cult'>However, you are still mortal. You must ascend to godhood by utilizing the Red Stone of Aja with a stone mask.</span>")
	to_chat(owner.current, "<span class='cult'>There are other Pillar Men, working to get the stone. Get the stone before the others, in order to ascend!</span>")
	to_chat(owner.current, "<span class='cult'>Ascending will allow you to become the ultimate organism, however, you die if you fail to ascend by being stunned while ascending.</span>")
