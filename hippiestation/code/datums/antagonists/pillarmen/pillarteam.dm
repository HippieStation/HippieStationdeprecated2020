/datum/team/pillarmen
	name = "Pillar Men"
	var/team_name = "pls fix" //randomly generated
	var/datum/mind/pillarMan
	var/list/datum/mind/vampires
	var/list/datum/mind/thralls
	var/ascended

/datum/team/pillarmen/roundend_report()
	var/list/parts = new/list
	if(ascended)
		parts += "<span class='greentext big'>The [team_name] Pillar Man managed to ascend, against all odds!</span>"
	else
		parts += "<span class='redtext big'>The [team_name] Pillar Man failed to ascend!</span>"
	parts += "<b>The Pillar Man was:</b>"
	parts += printplayer(pillarMan)
	parts += "<b>The Vampires were:</b>"
	parts += printplayerlist(vampires)
	parts += "<b>The Vampiric Thralls were:</b>"
	parts += printplayerlist(thralls)
	return "<div class='panel redborder'>[parts.Join("<br>")]</div>"
