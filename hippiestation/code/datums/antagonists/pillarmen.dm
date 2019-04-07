//made by Karma
/datum/antagonist/pillarmen
    name = "Pillar Man"
    antagpanel_category = "Pillar Man"
    roundend_category = "pillarmen"
	job_rank = ROLE_PILLARMEN

/datum/antagonist/pillarmen/greet()
    to_chat(owner.current, "<span class='cultlarge'>You are a <span class='reallybig hypnophrase'>Pillar Man</span>.</span>")
    to_chat(owner.current, "<span class='cult'>You are a being of immense power, and you are not alone. You have a legion of vampires to help you enthrall the crew.</span>")
    to_chat(owner.current, "<span class='cult'>However, you are still mortal. You must ascend to godhood by utilizing the Red Stone of Aja with a stone mask.</span>")
    to_chat(owner.current, "<span class='cult'>Ascending will allow you to become the ultimate organism., however, you die if you fail to ascend by being stunned while ascending.</span>")
    to_chat(owner.current, "<span class='cult'>And finally, beware. There are competing Pillar Men out there trying to grab the gem before you, as it is one of a kind and can be used once only.</span>")

/datum/antagonist/pillarmen/on_gain()
    owner.current.move_force = MOVE_FORCE_OVERPOWERING
    owner.current.move_resist = 50000
    owner.current.set_species(/datum/species/pillarmen)