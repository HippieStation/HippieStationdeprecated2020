//gangtool device
/obj/item/device/gangtool
	name = "suspicious device"
	desc = "A strange device of sorts. Hard to really make out what it actually does if you don't know how to operate it."
	icon_state = "gangtool-white"
	item_state = "radio"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	flags_1 = CONDUCT_1
	var/datum/team/gang/gang //Which gang uses this?
	var/recalling = 0
	var/outfits = 2
	var/free_pen = 0
	var/promotable = 0
	var/list/tags = list()

/obj/item/device/gangtool/attack_self(mob/user)
	..()
	if (!can_use(user))
		return
	var/datum/antagonist/gang/boss/L = user.mind.has_antag_datum(/datum/antagonist/gang/boss)
	var/dat
	if(!gang)
		dat += "This device is not registered.<br><br>"
		if(L)
			if(promotable && L.gang.leaders.len < MAX_GANG_LEADERS)
				dat += "Give this device to another member of your organization to use to promote them to Lieutenant.<br><br>"
				dat += "If this is meant as a spare device for yourself:<br>"
			dat += "<a href='?src=[REF(src)];register=1'>Register Device as Spare</a><br>"
		else if (promotable)
			if(L.gang.leaders.len < MAX_GANG_LEADERS)
				dat += "You have been selected for a promotion!<br>"
				dat += "<a href='?src=[REF(src)];register=1'>Accept Promotion</a><br>"
			else
				dat += "No promotions available: All positions filled.<br>"
		else
			dat += "This device is not authorized to promote.<br>"
	else
		if(gang.domination_time != NOT_DOMINATING)
			dat += "<center><font color='red'>Takeover In Progress:<br><B>[gang.domination_time] seconds remain</B></font></center>"

		dat += "Registration: <B>[gang.name] Gang Boss</B><br>"
		dat += "Organization Size: <B>[gang.members.len]</B> | Station Control: <B>[gang.territories.len] territories under control.</B><br>"
		dat += "Time until Influence grows: <B>[time2text(gang.next_point_time - world.time, "mm:ss")]</B><br>"
		dat += "<a href='?src=[REF(src)];commute=1'>Send message to Gang</a><br>"
		dat += "<a href='?src=[REF(src)];recall=1'>Recall shuttle</a><br>"
		dat += "<hr>"
		if(!islist(gang.buyable_items))
			gang.set_gang_item_list()
		for(var/cat in gang.buyable_items)
			dat += "<b>[cat]</b><br>"
			for(var/V in gang.buyable_items[cat])
				var/datum/gang_item/G = V
				if(!G.can_see(user, gang, src))
					continue

				var/cost = G.get_cost_display(user, gang, src)
				if(cost)
					dat += cost + " "

				var/toAdd = G.get_name_display(user, gang, src)
				if(G.can_buy(user, gang, src))
					toAdd = "<a href='?src=[REF(src)];purchase=[G.id]'>[toAdd]</a>"
				dat += toAdd
				var/extra = G.get_extra_info(user, gang, src)
				if(extra)
					dat += "<br><i>[extra]</i>"
				dat += "<br>"
			dat += "<br>"

	dat += "<a href='?src=[REF(src)];choice=refresh'>Refresh</a><br>"

	var/datum/browser/popup = new(user, "gangtool", "Welcome to GangTool v4.0", 340, 625)
	popup.set_content(dat)
	popup.open()



/obj/item/device/gangtool/Topic(href, href_list)
	if(!can_use(usr))
		return

	add_fingerprint(usr)

	if(href_list["register"])
		register_device(usr)

	else if(!gang) //Gangtool must be registered before you can use the functions below
		return

	if(href_list["purchase"])
		var/datum/gang_item/G = gang.boss_item_list[href_list["purchase"]]
		if(G && G.can_buy(usr, gang, src))
			G.purchase(usr, gang, src, FALSE)

	if(href_list["commute"])
		ping_gang(usr)
	if(href_list["recall"])
		recall(usr)
	attack_self(usr)


/obj/item/device/gangtool/proc/ping_gang(mob/user)
	if(!user)
		return
	var/message = stripped_input(user,"Discreetly send a gang-wide message.","Send Message") as null|text
	if(!message || !can_use(user))
		return
	if(!is_station_level(user.z))
		to_chat(user, "<span class='info'>[icon2html(src, user)]Error: Station out of range.</span>")
		return
	if(gang.members.len)
		var/ping = "<span class='danger'><B><i>[gang.name] [user in gang.leaders ? "Leader" : "Gangster"]</i>: [message]</B></span>"
		for(var/datum/mind/ganger in gang.members)
			if(ganger.current && is_station_level(ganger.current.z) && (ganger.current.stat == CONSCIOUS))
				to_chat(ganger.current, ping)
		for(var/mob/M in GLOB.dead_mob_list)
			var/link = FOLLOW_LINK(M, user)
			to_chat(M, "[link] [ping]")
		log_talk(user,"GANG: [key_name(user)] Messaged [gang.name] Gang: [message].",LOGSAY)


/obj/item/device/gangtool/proc/register_device(mob/user)
	if(gang)	//It's already been registered!
		return
	var/datum/antagonist/gang/G = user.mind.has_antag_datum(/datum/antagonist/gang, FALSE)
	if((promotable && G) || (user.mind.has_antag_datum(/datum/antagonist/gang/boss)))
		gang = G.gang
		gang.gangtools += src
		icon_state = "gangtool-[gang.color]"
		if(!(user.mind in gang.leaders))// replace gang datum with boss datum! todo
			G.promote()
			log_game("[key_name(user)] has been promoted to Lieutenant in the [gang.name] Gang")
			free_pen = 1
			gang.message_gangtools("[user] has been promoted to Lieutenant.")
			to_chat(user, "<FONT size=3 color=red><B>You have been promoted to Lieutenant!</B></FONT>")
			SSticker.mode.forge_gang_objectives(user.mind)
			SSticker.mode.greet_gang(user.mind,0)
			to_chat(user, "The <b>Gangtool</b> you registered will allow you to purchase weapons and equipment, and send messages to your gang.")
			to_chat(user, "Unlike regular gangsters, you may use <b>recruitment pens</b> to add recruits to your gang. Use them on unsuspecting crew members to recruit them. Don't forget to get your one free pen from the gangtool.")
	else
		to_chat(usr, "<span class='warning'>ACCESS DENIED: Unauthorized user.</span>")

/obj/item/device/gangtool/proc/recall(mob/user)
	if(!can_use(user))
		return 0

	if(SSshuttle.emergencyNoRecall)
		return 0

	if(recalling)
		to_chat(usr, "<span class='warning'>Error: Recall already in progress.</span>")
		return 0

	if(!gang.recalls)
		to_chat(usr, "<span class='warning'>Error: Unable to access communication arrays. Firewall has logged our signature and is blocking all further attempts.</span>")

	gang.message_gangtools("[user] is attempting to recall the emergency shuttle.")
	recalling = 1
	to_chat(loc, "<span class='info'>[icon2html(src, loc)]Generating shuttle recall order with codes retrieved from last call signal...</span>")

	sleep(rand(100,300))

	if(SSshuttle.emergency.mode != SHUTTLE_CALL) //Shuttle can only be recalled when it's moving to the station
		to_chat(user, "<span class='warning'>[icon2html(src, user)]Emergency shuttle cannot be recalled at this time.</span>")
		recalling = 0
		return 0
	to_chat(loc, "<span class='info'>[icon2html(src, loc)]Shuttle recall order generated. Accessing station long-range communication arrays...</span>")

	sleep(rand(100,300))

	if(!gang.dom_attempts)
		to_chat(user, "<span class='warning'>[icon2html(src, user)]Error: Unable to access communication arrays. Firewall has logged our signature and is blocking all further attempts.</span>")
		recalling = 0
		return 0

	var/turf/userturf = get_turf(user)
	if(is_station_level(userturf.z)) //Shuttle can only be recalled while on station
		to_chat(user, "<span class='warning'>[icon2html(src, user)]Error: Device out of range of station communication arrays.</span>")
		recalling = 0
		return 0
	var/datum/station_state/end_state = new /datum/station_state()
	end_state.count()
	if((100 * GLOB.start_state.score(end_state)) < 80) //Shuttle cannot be recalled if the station is too damaged
		to_chat(user, "<span class='warning'>[icon2html(src, user)]Error: Station communication systems compromised. Unable to establish connection.</span>")
		recalling = 0
		return 0
	to_chat(loc, "<span class='info'>[icon2html(src, loc)]Comm arrays accessed. Broadcasting recall signal...</span>")

	sleep(rand(100,300))

	recalling = 0
	log_game("[key_name(user)] has tried to recall the shuttle with a gangtool.")
	message_admins("[key_name_admin(user)] has tried to recall the shuttle with a gangtool.", 1)
	if(is_station_level(user.z)) //Check one more time that they are on station.
		if(SSshuttle.cancelEvac(user))
			gang.recalls--
			return 1

	to_chat(loc, "<span class='info'>[icon2html(src, loc)]No response recieved. Emergency shuttle cannot be recalled at this time.</span>")
	return 0

/obj/item/device/gangtool/proc/can_use(mob/living/carbon/human/user)
	if(!istype(user))
		return 0
	if(user.incapacitated())
		return 0
	if(!(src in user.contents))
		return 0
	if(!user.mind)
		return 0
	if(gang && (user.mind in gang.leaders))	//If it's already registered, only let the gang's bosses use this
		return 1
	return 0

/obj/item/device/gangtool/spare
	outfits = 1

/obj/item/device/gangtool/spare/lt
	promotable = 1
