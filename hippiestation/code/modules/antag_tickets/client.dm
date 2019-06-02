/client
	var/datum/antag_ticket_holder/ticket_holder

/client/New(TopicData)
	. = ..()
	if(!GLOB.ticket_holders[ckey])
		ticket_holder = new(src)
		ticket_holder.LoadAntagTickets()
	else
		ticket_holder = GLOB.ticket_holders[ckey]
