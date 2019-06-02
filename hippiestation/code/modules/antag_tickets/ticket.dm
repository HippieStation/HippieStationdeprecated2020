GLOBAL_LIST_EMPTY(token_users)

/datum/antag_ticket
	var/reason = ""
	var/amount = 1
	var/id = 0
	var/creator = ""
	var/antag_type = "Any Antagonist"

/datum/antag_ticket/New(uid, amt, res, cre, ant)
	..()
	id = uid
	amount = amt
	reason = res
	creator = cre
	antag_type = ant
