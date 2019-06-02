/client
	var/datum/antag_ticket_holder/ticket_holder

/client/New(TopicData)
	. = ..()
	ticket_holder = new(src)
	ticket_holder.LoadAntagTickets()
