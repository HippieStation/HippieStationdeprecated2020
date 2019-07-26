// why does this exist? simply so stands show up on roundend screen.

/datum/antagonist/stand
	name = "Stand"
	show_in_antagpanel = FALSE
	var/datum/guardian_stats/stats
	var/summoner

/datum/antagonist/stand/roundend_report()
	var/list/parts = list()
	parts += printplayer(owner)
	if(summoner)
		parts += "<li><B>SUMMONER</B>: [summoner]</li>"
	if(stats)
		parts += "<li><b>DAMAGE:</b> [level_to_grade(stats.damage)]</li>"
		parts += "<li><b>DEFENSE:</b> [level_to_grade(stats.defense)]</li>"
		parts += "<li><b>SPEED:</b> [level_to_grade(stats.speed)]</li>"
		parts += "<li><b>POTENTIAL:</b> [level_to_grade(stats.potential)]</li>"
		parts += "<li><b>RANGE:</b> [level_to_grade(stats.range)]</li>"
		if(stats.ability)
			parts += "<li><b>SPECIAL ABILITY:</b> [stats.ability.name]</li>"
		for(var/datum/guardian_ability/minor/M in stats.minor_abilities)
			parts += "<li><b>MINOR ABILITY:</b> [M.name]</li>"
	return parts.Join("<br>")

/datum/antagonist/stand/antag_panel_data()
	var/mob/living/simple_animal/hostile/guardian/G = owner.current
	return "<B>Summoner: [G.summoner]/([G.summoner.ckey])</B>"
