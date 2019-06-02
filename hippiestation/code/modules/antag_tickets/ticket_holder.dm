/datum/antag_ticket_holder
	var/list/antag_tickets = list()
	var/client/client

/datum/antag_ticket_holder/New(c)
	. = ..()
	client = c


/datum/antag_ticket_holder/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.always_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "antag_tickets", "Antag Tickets", 700, 600, master_ui, state)
		ui.set_autoupdate(TRUE)
		ui.open()

/datum/antag_ticket_holder/ui_data(mob/user)
	. = list()
	if(check_rights_for(user.client, R_ADMIN))
		.["admin"] = TRUE
	.["tickets"] = list()
	for(var/A in antag_tickets)
		var/datum/antag_ticket/AT = antag_tickets[A]
		if(AT)
			.["tickets"] += list(list(
				"id" = AT.id,
				"desc" = AT.reason,
				"amount" = AT.amount,
				"creator" = AT.creator
			))

/datum/antag_ticket_holder/ui_act(action, params)
	if(..())
		return
	var/ticket_id = params["ticket_id"]
	switch(action)
		if("create")
			if(!check_rights(R_ADMIN))
				return
			var/reason = input(usr, "Please enter the reason for the antag ticket", "Antag Ticket Forge", "") as text|null
			if(!reason)
				reason = "No reason given"
			var/amount = input(usr, "Please enter the amount of antag tokens", "Antag Ticket Forge", "") as num|null
			if(!amount)
				to_chat(usr, "<span class='danger bold'>You must specify an amount of antag tokens!</span>")
				return
			var/datum/antag_ticket/AT = new(0, amount, reason, usr.ckey)
			log_admin_private("[key_name(usr)] has created an antag ticket for [ckey(client.key)], with [amount] tokens: \"[reason]\".")
			message_admins("[key_name_admin(usr)] has created an antag ticket for [ckey(client.key)], with [amount] tokens: \"[reason]\".")
			SaveAntagTicket(AT)
			LoadAntagTickets()
		if("edit")
			if(!check_rights(R_ADMIN) || !ticket_id)
				return
			var/reason = input(usr, "Please enter the reason for the antag ticket", "Antag Ticket Printer", "") as text|null
			var/amount = input(usr, "Please enter the amount of antag tokens", "Antag Ticket Printer", "") as num|null
			var/datum/antag_ticket/AT = antag_tickets["[ticket_id]"]
			if(AT)
				var/msg = "has updated [ckey(client.key)]'s antag ticket"
				if(reason)
					AT.reason = reason
					msg = "[msg] with the reason \"[reason]\""
				if(amount)
					msg = "[msg][reason ? ", and" : ""] with the amount \"[amount]\""
					AT.amount = amount
				log_admin_private("[key_name(usr)] [msg].")
				message_admins("[key_name_admin(usr)] [msg].")
				UpdateAntagTicket(AT)
		if("delete")
			if(!check_rights(R_ADMIN) || !ticket_id)
				return
			var/datum/antag_ticket/AT = antag_tickets["[ticket_id]"]
			if(AT && alert("Are you sure you want to remove this antag ticket?","Confirm Removal","Yes","No") == "Yes")
				log_admin_private("[key_name(usr)] has has deleted's [ckey(client.key)] antag ticket, which had the reason \"[AT.reason]\".")
				message_admins("[key_name_admin(usr)] has has deleted's [ckey(client.key)] antag ticket, which had the reason \"[AT.reason]\".")
				RemoveAntagTicket(AT)

/datum/antag_ticket_holder/proc/LoadAntagTickets()
	if(LAZYLEN(antag_tickets))
		QDEL_LIST(antag_tickets)
	var/datum/DBQuery/get_tickets = SSdbcore.NewQuery("SELECT `id`, `amount`, `desc`, `creator` FROM [format_table_name("antag_tickets")] WHERE ckey = '[sanitizeSQL(client.ckey)]'")
	if(get_tickets.Execute())
		while(get_tickets.NextRow())
			var/id = text2num(get_tickets.item[1])
			var/amt = text2num(get_tickets.item[2])
			var/desc = get_tickets.item[3]
			var/creator = get_tickets.item[4]
			antag_tickets["[id]"] = new /datum/antag_ticket(id, amt, desc, creator)

/datum/antag_ticket_holder/proc/SaveAntagTicket(datum/antag_ticket/ticket)
	var/datum/DBQuery/set_tickets = SSdbcore.NewQuery("INSERT INTO [format_table_name("antag_tickets")] (`ckey`, `desc`, `amount`, `creator`) VALUES ('[sanitizeSQL(client.ckey)]', '[sanitizeSQL(ticket.reason)]', '[sanitizeSQL(ticket.amount)]', '[sanitizeSQL(ticket.creator)]') ")
	if(!set_tickets.warn_execute())
		qdel(set_tickets)

/datum/antag_ticket_holder/proc/RemoveAntagTicket(datum/antag_ticket/ticket)
	var/datum/DBQuery/set_tickets = SSdbcore.NewQuery("DELETE FROM [format_table_name("antag_tickets")] WHERE `id` = '[sanitizeSQL(ticket.id)]'")
	QDEL_NULL(antag_tickets["[ticket.id]"])
	if(!set_tickets.warn_execute())
		qdel(set_tickets)

/datum/antag_ticket_holder/proc/UpdateAntagTicket(datum/antag_ticket/ticket)
	if(ticket.amount < 1)
		RemoveAntagTicket(ticket)
		return
	var/datum/DBQuery/set_tickets = SSdbcore.NewQuery("UPDATE [format_table_name("antag_tickets")] SET `desc` = '[sanitizeSQL(ticket.reason)]', `amount` = '[sanitizeSQL(ticket.amount)]' WHERE `id` = '[sanitizeSQL(ticket.id)]'")
	if(!set_tickets.warn_execute())
		qdel(set_tickets)

/datum/antag_ticket_holder/proc/RedeemAntagTicket(reason)
	for(var/A in antag_tickets)
		var/datum/antag_ticket/AT = antag_tickets[A]
		if(AT.amount < 1) // shouldn't ever happen, but let's be safe
			continue
		AT.amount -= 1
		UpdateAntagTicket(AT)
		to_chat(client, "<span class='notice'>An antag token has been redeemed for the following reason: \"<b>[reason]</b>\".</span>")
		SEND_SOUND(client, sound('hippiestation/sound/misc/insertcoin.ogg'))
		SEND_SOUND(client, sound('sound/arcade/win.ogg'))
		return TRUE
	return FALSE
