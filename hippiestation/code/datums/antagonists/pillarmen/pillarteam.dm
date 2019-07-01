/datum/team/pillarmen
	name = "Pillar Men"
	var/team_name = "pls fix" //randomly generated
	var/list/datum/mind/pillars
	var/list/datum/mind/vampires
	var/list/datum/mind/thralls
	var/ascended

/datum/team/pillarmen/roundend_report()
	var/list/parts = new/list
	if(ascended)
		parts += "<span class='greentext big'>The Pillar Men managed to ascend, against all odds!</span>"
	else
		parts += "<span class='redtext big'>The Pillar Men failed to ascend!</span>"
	parts += "<b>The Pillar Men were:</b>"
	parts += printplayerlist(pillars)
	parts += "<b>The Vampires were:</b>"
	parts += printplayerlist(vampires)
	parts += "<b>The Vampiric Thralls were:</b>"
	parts += printplayerlist(thralls)
	return "<div class='panel redborder'>[parts.Join("<br>")]</div>"
