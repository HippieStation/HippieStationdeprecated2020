//made by Karma


/datum/team/pillarmen
    name = "Pillar Men"
    var/team_name = "pls fix" //randomly generated
    var/datum/mind/mainPillarMan
    var/list/datum/mind/vampires 
    var/list/datum/mind/thralls

/datum/team/pillarmen/roundend_report()
    var/list/parts = new/list
    if(ascended)
        parts += "<span class='greentext big'>The [team_name] Pillar Man has managed to ascend, against all odds!</span>"
    else
        parts += "<span class='redtext big'>The [team_name] Pillar Man has failed to ascend!</span>"
    parts += "<span class='cult'>The Pillar Man was [printplayer(mainPillarMan)].</span>"
    parts += "<span class='cult'>The vampires were [printplayerlist(vampires)].</span>"
    parts += "<span class='cult'>The vampiric thralls were [printplayerlist(thralls)].</span>"
    return "<div class='panel redborder'>[parts.Join("<br>")]</div>"




/datum/antagonist/pillarmen
    name = "Pillar Man"
    antagpanel_category = "Pillar Man"
    roundend_category = "pillarmen"
    job_rank = ROLE_PILLARMEN
    var/datum/team/pillarmen/pillarManTeam = new //Will have the pillar man himself, the vampires and the thralls.
    var/ascended = FALSE
    var/true_name = "" // rng, changed


/datum/antagonist/pillarmen/create_team(datum/team/pillarmen/new_team)

    

/datum/antagonist/pillarmen/get_team()
    return pillar_man_team

/datum/antagonist/pillarmen/greet()
    to_chat(owner.current, "<span class='cultlarge'>You are a <span class='reallybig hypnophrase'>Pillar Man</span>.</span>")
    to_chat(owner.current, "<span class='cult'>You are a being of immense power, and you are not alone. You have a legion of vampires to help you enthrall the crew.</span>")
    to_chat(owner.current, "<span class='cult'>However, you are still mortal. You must ascend to godhood by utilizing the Red Stone of Aja with a stone mask.</span>")
    to_chat(owner.current, "<span class='cult'>Ascending will allow you to become the ultimate organism., however, you die if you fail to ascend by being stunned while ascending.</span>")
    to_chat(owner.current, "<span class='cult'>And finally, beware. There are competing Pillar Men out there trying to form the gem from the pieces it has broken into before you, as it is one of a kind and can be used only once.</span>")

/datum/antagonist/pillarmen/on_gain()
    owner.current.move_force = MOVE_FORCE_OVERPOWERING
    owner.current.move_resist = 50000
    owner.current.ventcrawler = VENTCRAWLER_ALWAYS
    owner.current.set_species(/datum/species/pillarmen)

/datum/antagonist/pillarmen/proc/ascend()
    to_chat(owner.current, "<span class='cultlarge cultitalic'></span>")


/datum/species/pillarmen
    name = "Pillar Man"
    id = "pillarmen"
	species_traits = list(NO_DNA_COPY)
	inherent_traits = list(TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_IGNORESLOWDOWN, TRAIT_SLEEPIMMUNE, TRAIT_XRAY_VISION, TRAIT_NOSOFTCRIT)
	inherent_biotypes = list(MOB_HUMANOID)
	damage_overlay_type = "" //they won't show signs of damage until they're dead.
	changesource_flags = 0
