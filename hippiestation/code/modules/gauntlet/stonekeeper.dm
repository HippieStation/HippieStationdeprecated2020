/datum/antagonist/stonekeeper
	name = "Stonekeeper"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE

/datum/antagonist/stonekeeper/greet()
	to_chat(owner, "<span class='userdanger'>You are a stonekeeper!</span>")
	to_chat(owner, "<span class='danger'>You have an infinity stone in your backpack. Keep it safe at all costs, even if it means killing.</span>")


/datum/objective/stonekeeper
	name = "keep infinity stone secure"
	explanation_text = "Keep your Infinity Stone secure."
	var/obj/item/infinity_stone/stone

/datum/objective/stonekeeper/update_explanation_text()
	if(stone)
		explanation_text = "Keep the [stone] secured at all costs."

/datum/objective/stonekeeper/check_completion()
	var/list/datum/mind/owners = get_owners()
	for(var/datum/mind/M in owners)
		if(!M || !M.current)
			return FALSE
		if(stone in M.current.GetAllContents())
			return TRUE
	return FALSE
