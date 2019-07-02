/datum/team/pillarmen
	name = "Pillar Men"
	var/team_name = "pls fix" //randomly generated
	var/datum/mind/pillarMan
	var/list/datum/mind/vampires = list()
	var/list/datum/mind/thralls = list()
	var/ascended
	var/hud_entry_num

/datum/team/pillarmen/Destroy()
	var/datum/atom_hud/antag/pillarhud = GLOB.huds[hud_entry_num]
	GLOB.huds -= GLOB.huds[hud_entry_num]
	qdel(pillarhud)
	. = ..()

/datum/team/pillarmen/roundend_report()
	var/list/parts = new/list
	if(ascended)
		parts += "<span class='greentext big'>The [team_name] Pillar Man managed to ascend, against all odds!</span>"
	else
		parts += "<span class='redtext big'>The [team_name] Pillar Man failed to ascend!</span>"
	parts += "<span class='header'>The Pillar Man was:</span>"
	parts += printplayer(pillarMan)
	parts += "<span class='header'>The Vampires were:</span>"
	parts += printplayerlist(vampires)
	parts += "<span class='header'>The Vampiric Thralls were:</span>"
	parts += printplayerlist(thralls)
	return "<div class='panel redborder'>[parts.Join("<br>")]</div>"
