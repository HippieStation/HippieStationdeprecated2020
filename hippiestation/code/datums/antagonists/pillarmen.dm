//made by Karma
/datum/antagonist/pillarmen
    name = "Pillar Man"
    antagpanel_category = "Pillar Man"
    roundend_category = "pillarmen"
	job_rank = ROLE_PILLARMEN

/datum/antagonist/pillarmen/greet()
    to_chat(owner.current, "<span class='cultlarge'>You are a <span class='reallybig hypnophrase'>Pillar Man</span>.</span>")
    to_chat(owner.current, "<span class='cult'>You are a being of immense power, and you are not alone. You have other Pillar Men to help you and a legion of vampires to help you enthrall the crew.</span>")
    to_chat(owner.current, "<span class='cult'>However, you are still mortal. You must ascend to godhood by utilizing the Red Stone of Aja with a stone mask.</span>")
    to_chat(owner.current, "<span class='cult'>Ascending will allow your other Pillar Men to ascend with you, however, you die if you fail to ascend by being stunned while ascending.</span>")

/datum/antagonist/pillarmen/on_gain()