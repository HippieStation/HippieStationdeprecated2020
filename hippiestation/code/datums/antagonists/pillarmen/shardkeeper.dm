/datum/antagonist/shardkeeper
	name = "Shardkeeper of Aja"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	prevent_roundtype_conversion = FALSE

/datum/antagonist/shardkeeper/greet()
	to_chat(owner, "<span class='userdanger'>You are a keeper of a shard of Aja!</span>")
	to_chat(owner, "<span class='danger'>You have a shard of the powerful Red Stone of Aja in your backpack. <b>Keep it safe at all costs, even if it means killing.</b></span>")

/datum/objective/shardkeeper
	name = "keep aja shard secure"
	explanation_text = "Keep the Aja Shard secure."

/datum/objective/shardkeeper/check_completion()
	if(!owner || !owner.current)
		return FALSE
	if(locate(/obj/item/redstone) in owner.current)
		return TRUE
	return FALSE
