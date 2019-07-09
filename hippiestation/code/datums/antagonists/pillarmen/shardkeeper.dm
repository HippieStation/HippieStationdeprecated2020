/datum/antagonist/shardkeeper
	name = "Shardkeeper of Aja"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	prevent_roundtype_conversion = FALSE
	var/datum/martial_art/hamon/hamon

/datum/antagonist/shardkeeper/on_gain()
	. = ..()
	if(owner && ishuman(owner.current))
		hamon = new
		hamon.teach(owner.current)

/datum/antagonist/shardkeeper/on_removal()
	. = ..()
	if(owner && ishuman(owner.current) && hamon)
		hamon.remove(owner.current)
		qdel(hamon)

/datum/antagonist/shardkeeper/greet()
	to_chat(owner, "<span class='userdanger'>You are a keeper of a shard of Aja!</span>")
	to_chat(owner, "<span class='danger'>You have a shard of the powerful Red Stone of Aja in your backpack. <b>Keep it safe at all costs, even if it means killing.</b></span>")
	to_chat(owner, "<span class='danger'>In addition, you know the ancient art of <span class='hypnophrase'>Hamon</span>. Use this to fight against enemies!</span>")

/datum/objective/shardkeeper
	name = "keep aja shard secure"
	explanation_text = "Keep the Aja Shard secure."

/datum/objective/shardkeeper/check_completion()
	if(!owner || !owner.current)
		return FALSE
	if(locate(/obj/item/redstone) in owner.current)
		return TRUE
	return FALSE
