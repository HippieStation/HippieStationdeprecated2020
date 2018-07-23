/datum/antagonist/gang
	name = "Gangster"
	roundend_category = "gangsters"
	can_coexist_with_others = FALSE
	job_rank = ROLE_GANG
	antagpanel_category = "Gang"
	var/hud_type = "gangster"
	var/datum/team/gang/gang

/datum/antagonist/gang/can_be_owned(datum/mind/new_owner)
	. = ..()
	if(.)
		if(new_owner.assigned_role in GLOB.command_positions)
			return FALSE
		if(new_owner.unconvertable)
			return FALSE
		if(new_owner.current && new_owner.current.isloyal())
			return FALSE

/datum/antagonist/gang/apply_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	update_gang_icons_added(M)

/datum/antagonist/gang/remove_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	update_gang_icons_removed(M)



/datum/antagonist/gang/proc/equip_gang()
	return

/datum/antagonist/gang/on_gain()
	. = ..()
	create_objectives()
	equip_gang()
	owner.current.log_message("<font color='red'>Has been converted to the gang!</font>", INDIVIDUAL_ATTACK_LOG)

/datum/antagonist/gang/on_removal()
	remove_objectives()
	. = ..()

/datum/antagonist/gang/create_team(datum/team/gang/new_team)
	if(!new_team)
		var/gangteam = pick_n_take(GLOB.possible_gangs)
		if(gangteam)
			gang = new gangteam
	gang = new_team

/datum/antagonist/gang/proc/create_objectives()
	owner.objectives |= gang.objectives

/datum/antagonist/gang/proc/remove_objectives()
	owner.objectives -= gang.objectives

//Bump up to boss
/datum/antagonist/gang/proc/promote()
	var/old_gang = gang
	var/datum/mind/old_owner = owner
	owner.remove_antag_datum(/datum/antagonist/gang)
	var/datum/antagonist/gang/boss/new_boss = new
	new_boss.silent = TRUE
	old_owner.add_antag_datum(new_boss,old_gang)
	new_boss.silent = FALSE
	to_chat(old_owner, "<span class='userdanger'>Stuff to add!</span>")

/*no clue
/datum/antagonist/rev/get_admin_commands()
	. = ..()
	.["Promote"] = CALLBACK(src,.proc/admin_promote)

/datum/antagonist/rev/proc/admin_promote(mob/admin)
	var/datum/mind/O = owner
	promote()
	message_admins("[key_name_admin(admin)] has head-rev'ed [O].")
	log_admin("[key_name(admin)] has head-rev'ed [O].")

/datum/antagonist/rev/head/admin_add(datum/mind/new_owner,mob/admin)
	give_flash = TRUE
	give_hud = TRUE
	remove_clumsy = TRUE
	new_owner.add_antag_datum(src)
	message_admins("[key_name_admin(admin)] has head-rev'ed [new_owner.current].")
	log_admin("[key_name(admin)] has head-rev'ed [new_owner.current].")
	to_chat(new_owner.current, "<span class='userdanger'>You are a member of the revolutionaries' leadership now!</span>")

/datum/antagonist/rev/head/get_admin_commands()
	. = ..()
	. -= "Promote"
	.["Take flash"] = CALLBACK(src,.proc/admin_take_flash)
	.["Give flash"] = CALLBACK(src,.proc/admin_give_flash)
	.["Repair flash"] = CALLBACK(src,.proc/admin_repair_flash)
	.["Demote"] = CALLBACK(src,.proc/admin_demote)

/datum/antagonist/rev/head/proc/admin_take_flash(mob/admin)
	var/list/L = owner.current.get_contents()
	var/obj/item/assembly/flash/flash = locate() in L
	if (!flash)
		to_chat(admin, "<span class='danger'>Deleting flash failed!</span>")
		return
	qdel(flash)

/datum/antagonist/rev/head/proc/admin_give_flash(mob/admin)
	//This is probably overkill but making these impact state annoys me
	var/old_give_flash = give_flash
	var/old_give_hud = give_hud
	var/old_remove_clumsy = remove_clumsy
	give_flash = TRUE
	give_hud = FALSE
	remove_clumsy = FALSE
	equip_rev()
	give_flash = old_give_flash
	give_hud = old_give_hud
	remove_clumsy = old_remove_clumsy

/datum/antagonist/rev/head/proc/admin_repair_flash(mob/admin)
	var/list/L = owner.current.get_contents()
	var/obj/item/assembly/flash/flash = locate() in L
	if (!flash)
		to_chat(admin, "<span class='danger'>Repairing flash failed!</span>")
	else
		flash.crit_fail = 0
		flash.update_icon()

/datum/antagonist/rev/head/proc/admin_demote(datum/mind/target,mob/user)
	message_admins("[key_name_admin(user)] has demoted [owner.current] from head revolutionary.")
	log_admin("[key_name(user)] has demoted [owner.current] from head revolutionary.")
	demote()
*/
/datum/antagonist/gang/boss
	name = "Gang boss"
	hud_type = "gang_boss"

/datum/antagonist/gang/boss/antag_listing_name()
	return ..() + "(Boss)"

/datum/antagonist/gang/proc/update_gang_icons_added(mob/living/M)
	var/datum/atom_hud/antag/ganghud = GLOB.huds[ANTAG_HUD_GANG]
	ganghud.join_hud(M)
	set_antag_hud(M,hud_type)

/datum/antagonist/gang/proc/update_gang_icons_removed(mob/living/M)
	var/datum/atom_hud/antag/ganghud = GLOB.huds[ANTAG_HUD_GANG]
	ganghud.leave_hud(M)
	set_antag_hud(M, null)

/datum/antagonist/gang/proc/can_be_converted(mob/living/candidate)
	if(!candidate.mind)
		return FALSE
	if(!can_be_owned(candidate.mind))
		return FALSE
	var/mob/living/carbon/human/H = candidate
	if(!istype(H)) //Can't nonhumans
		return FALSE
	return TRUE

/datum/antagonist/gang/boss/proc/add_gangster(datum/mind/gangster_mind, check = TRUE)
	var/datum/antagonist/dudegang = gangster_mind.has_antag_datum(/datum/antagonist/gang)
	if(dudegang)
		if(dudegang == gang)
			return 3//dude's already in the same gang
		return 0//dude's in an enemy gang oh fuck,also check if it's a boss
	if(check && gangster_mind.current.isloyal()) //Check to see if the potential gangster is implanted
		return 1
	if(check)
		if(iscarbon(gangster_mind.current))
			var/mob/living/carbon/carbon_mob = gangster_mind.current
			carbon_mob.silent = max(carbon_mob.silent, 5)
			carbon_mob.flash_act(1, 1)
		gangster_mind.current.Stun(100)
	if(G.is_deconvertible)
		G.greet_gangster(gangster_mind.current)
	gangster_mind.current.log_message("<font color='red'>Has been converted to the [G.name] Gang!</font>", INDIVIDUAL_ATTACK_LOG)
	gangster_mind.special_role = "[G.name] Gangster"

	G.add_gang_hud(gangster_mind)
	if(jobban_isbanned(gangster_mind.current, ROLE_GANG))
		INVOKE_ASYNC(src, /datum/game_mode.proc/replace_jobbaned_player, gangster_mind.current, ROLE_GANG, ROLE_GANG)
	return 2

/*
/datum/antagonist/gang/proc/add_revolutionary(datum/mind/rev_mind,stun = TRUE)
	if(!can_be_converted(rev_mind.current))
		return FALSE
	if(stun)
		if(iscarbon(rev_mind.current))
			var/mob/living/carbon/carbon_mob = rev_mind.current
			carbon_mob.silent = max(carbon_mob.silent, 5)
			carbon_mob.flash_act(1, 1)
		rev_mind.current.Stun(100)
	rev_mind.add_antag_datum(/datum/antagonist/rev,rev_team)
	rev_mind.special_role = ROLE_REV
	return TRUE

/datum/antagonist/rev/head/proc/demote()
	var/datum/mind/old_owner = owner
	var/old_team = rev_team
	silent = TRUE
	owner.remove_antag_datum(/datum/antagonist/rev/head)
	var/datum/antagonist/rev/new_rev = new /datum/antagonist/rev()
	new_rev.silent = TRUE
	old_owner.add_antag_datum(new_rev,old_team)
	new_rev.silent = FALSE
	to_chat(old_owner, "<span class='userdanger'>Revolution has been disappointed of your leader traits! You are a regular revolutionary now!</span>")
*/
/datum/antagonist/gang/farewell()
	if(ishuman(owner.current))
		owner.current.visible_message("<span class='deconversion_message'>[owner.current] looks like [owner.current.p_theyve()] just remembered [owner.current.p_their()] real allegiance!</span>", null, null, null, owner.current)
		to_chat(owner, "<span class='userdanger'>You are no longer a gangster!</span>")
/*
//blunt trauma deconversions call this through species.dm spec_attacked_by()
/datum/antagonist/rev/proc/remove_revolutionary(borged, deconverter)
	log_attack("[owner.current] (Key: [key_name(owner.current)]) has been deconverted from the revolution by [deconverter] (Key: [key_name(deconverter)])!")
	if(borged)
		message_admins("[ADMIN_LOOKUPFLW(owner.current)] has been borged while being a [name]")
	owner.special_role = null
	if(iscarbon(owner.current))
		var/mob/living/carbon/C = owner.current
		C.Unconscious(100)
	owner.remove_antag_datum(type)

/datum/antagonist/rev/head/remove_revolutionary(borged,deconverter)
	if(!borged)
		return
	. = ..()
*/
/datum/antagonist/gang/boss/equip_gang()
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return

	if(remove_clumsy && owner.assigned_role == "Clown")
		to_chat(owner, "Your training has allowed you to overcome your clownish nature, allowing you to wield weapons without harming yourself.")
		H.dna.remove_mutation(CLOWNMUT)
	var/obj/item/device/gangtool/gangtool = new()
	var/obj/item/pen/gang/T = new()
	var/obj/item/toy/crayon/spraycan/gang/SC = new(null,gang)
	var/obj/item/clothing/glasses/hud/security/chameleon/C = new(null,gang)

	var/list/slots = list (
		"backpack" = SLOT_IN_BACKPACK,
		"left pocket" = SLOT_L_STORE,
		"right pocket" = SLOT_R_STORE
	)
	var/where = H.equip_in_one_of_slots(T, slots)
	if (!where)
		to_chat(H, "Your Syndicate benefactors were unfortunately unable to get you a Gangtool.")
	else
		gangtool.register_device(H)
		to_chat(H, "The <b>Gangtool</b> in your [where] will allow you to purchase weapons and equipment, send messages to your gang, and recall the emergency shuttle from anywhere on the station.")
		to_chat(H, "As the gang boss, you can also promote your gang members to <b>lieutenant</b>. Unlike regular gangsters, Lieutenants cannot be deconverted and are able to use recruitment pens and gangtools.")

	var/where2 = H.equip_in_one_of_slots(T, slots)
	if (!where2)
		to_chat(H, "Your Syndicate benefactors were unfortunately unable to get you a recruitment pen to start.")
	else
		to_chat(H, "The <b>recruitment pen</b> in your [where2] will help you get your gang started. Stab unsuspecting crew members with it to recruit them.")

	var/where3 = H.equip_in_one_of_slots(SC, slots)
	if (!where3)
		to_chat(H, "Your Syndicate benefactors were unfortunately unable to get you a territory spraycan to start.")
	else
		to_chat(H, "The <b>territory spraycan</b> in your [where3] can be used to claim areas of the station for your gang. The more territory your gang controls, the more influence you get. All gangsters can use these, so distribute them to grow your influence faster.")

	var/where4 = H.equip_in_one_of_slots(C, slots)
	if (!where4)
		to_chat(H, "Your Syndicate benefactors were unfortunately unable to get you a chameleon security HUD.")
	else
		to_chat(H, "The <b>chameleon security HUD</b> in your [where4] will help you keep track of who is mindshield-implanted, and unable to be recruited.")

#define INFLUENCE_INTERVAL 1800
/datum/team/gang
	name = "Gang"
	member_name = "gangster"
	var/list/leaders = list() // bosses and lieutenants
	var/influence = 0 // influence of the gang, based on how many territories they own. Can be used to buy weapons and tools from a gang uplink.
	var/list/territories = list() // territories owned by the gang.
	var/list/lost_territories = list() // territories lost by the gang.
	var/list/new_territories = list() // territories captured by the gang.
	var/list/gangtools = list()
	var/next_point_interval = INFLUENCE_INTERVAL
	var/next_point_time
	var/domination_time = NOT_DOMINATING
	var/dom_attempts
	var/color
	var/recalls = 3 // Once this reaches 0, this gang cannot force recall the shuttle with their gangtool anymore
	var/list/buyable_items = list()

/datum/team/gang/New(starting_members)
	. = ..()
	GLOB.gangs += src
	if(starting_members)
		if(islist(starting_members))
			for(var/datum/mind/groveboss in starting_members)
				LAZYADD(leaders, groveboss)
				var/datum/antagonist/gang/boss/gb = new
				groveboss.add_antag_datum(gb, src)
				gb.gang = src
				gb.equip_gang()

		else
			var/datum/mind/CJ = starting_members
			if(istype(CJ))
				LAZYADD(leaders, CJ)
				var/datum/antagonist/gang/boss/bossdatum = new
				CJ.add_antag_datum(bossdatum, src)
				bossdatum.gang = src
				bossdatum.equip_gang()
	color = rgb(rand(0,255),rand(0,255),rand(0,255))
	next_point_time = world.time + next_point_interval
	START_PROCESSING(SSobj, src)

/datum/team/gang/Destroy()
	GLOB.gangs -= src
	..()

/datum/team/gang/proc/greet_gangster(mob/gangster)
	to_chat(gangster, "<FONT size=3 color=red><B>You are now a member of the [name] Gang!</B></FONT>")
	to_chat(gangster, "<font color='red'>Help your bosses take over the station by claiming territory with <b>special spraycans</b> only they can provide. Simply spray on any unclaimed area of the station.</font>")
	to_chat(gangster, "<font color='red'>Their ultimate objective is to take over the station with a Dominator machine.</font>")
	to_chat(gangster, "<font color='red'>You can identify your bosses by their <b>large, bright \[G\] <font color='[color]'>icon</font></b>.</font>")
	gangster.mind.store_memory("You are a member of the [name] Gang!")

/datum/team/gang/proc/set_gang_item_list()
	var/list/all_items = subtypesof(/datum/gang_item) // starting list with code-parents to remove
	var/list/final_list = list()
	for(var/i in all_items)
		var/datum/gang_item/G = i
		if(G.gang_whitelist.len && !(type in G.gang_whitelist))
			continue
		if(G.gang_blacklist.len && type in G.gang_blacklist)
			continue
		if(!G.id) // it's a code-parent
			continue
		if(!islist(final_list[G.category]))
			final_list[G.category] = list()
		final_list[G.category] += G
	buyable_items = final_list

/datum/team/gang/process()
	if(world.time > next_point_time)
		handle_territories()

	if(world.time > next_point_time)
		next_point_time = world.time + next_point_interval

	if(domination_time != NOT_DOMINATING)
		if(!domination_time)
			domination()
			/*
			G.is_dominating = FALSE
			SSticker.mode.explosion_in_progress = TRUE
			SSticker.station_explosion_cinematic(1,"gang war", null)
			SSticker.mode.explosion_in_progress = FALSE
			SSticker.force_ending = TRUE*/

/datum/team/gang/roundend_report()
	var/list/report = list()
	var/win = FALSE
	var/objective_count = 1
	report += "<span class='header'>[name]:</span>"
	for(var/datum/objective/objective in objectives)
		if(objective.check_completion())
			report += "<B>Objective #[objective_count]</B>: [objective.explanation_text] <span class='greentext'><B>Success!</span>"
		else
			report += "<B>Objective #[objective_count]</B>: [objective.explanation_text] <span class='redtext'>Fail.</span>"
			win = FALSE
		objective_count++
	if(win)
		report += "<span class='greentext'>The [name] gang was successful!</span>"
	else
		report += "<span class='redtext'>The [name] gang has failed!</span>"

	report += "The [name] gang bosses were:"
	report += printplayerlist(leaders)
	report += "The [name] [member_name]s were:"
	report += printplayerlist(members)

	return "<div class='panel redborder'>[report.Join("<br>")]</div>"

/datum/team/gang/proc/handle_territories()

	if(!leaders.len)
		return
	var/added_names = ""
	var/lost_names = ""

	//Re-add territories that were reclaimed, so if they got tagged over, they can still earn income if they tag it back before the next status report
	var/list/reclaimed_territories = new_territories & lost_territories
	territories |= reclaimed_territories
	new_territories -= reclaimed_territories
	lost_territories -= reclaimed_territories

	//Process lost territories
	for(var/area in lost_territories)
		if(lost_names != "")
			lost_names += ", "
		lost_names += "[lost_territories[area]]"
		territories -= area

	//Calculate and report influence growth

	//Process new territories
	for(var/area in new_territories)
		if(added_names != "")
			added_names += ", "
		added_names += "[new_territories[area]]"
		territories += area

	//Report territory changes
	var/message = "<b>[src] Gang Status Report:</b>.<BR>*---------*<BR>"
	message += "<b>[new_territories.len] new territories:</b><br><i>[added_names]</i><br>"
	message += "<b>[lost_territories.len] territories lost:</b><br><i>[lost_names]</i><br>"
	//Clear the lists
	new_territories = list()
	lost_territories = list()
	var/control = round((territories.len/GLOB.start_state.num_territories)*100, 1)
	var/uniformed = check_clothing()
	message += "Your gang now has <b>[control]% control</b> of the station.<BR>*---------*<BR>"
	if(domination_time != NOT_DOMINATING)
		var/new_time = max(180, domination_time - (uniformed * 4) - (territories.len * 2))
		if(new_time < domination_time)
			message += "Takeover shortened by [domination_time - new_time] seconds for defending [territories.len] territories.<BR>"
			domination_time = new_time
		message += "<b>[new_time] seconds remain</b> in hostile takeover.<BR>"
	else
		var/new_influence = check_territory_income()
		if(new_influence != influence)
			message += "Gang influence has increased by [new_influence - influence] for defending [territories.len] territories and [uniformed] uniformed gangsters.<BR>"
		influence = new_influence
		message += "Your gang now has <b>[influence] influence</b>.<BR>"
	announce_all_influence(message)

/datum/team/gang/proc/check_territory_income()
	var/new_influence = min(999,influence + 15 + (check_clothing() * 2) + territories.len)
	return new_influence

/datum/team/gang/proc/check_clothing()
	//Count uniformed gangsters
	var/uniformed = 0
	for(var/datum/mind/gangmind in members)
		if(ishuman(gangmind.current))
			var/mob/living/carbon/human/gangster = gangmind.current
			//Gangster must be alive and on station
			if((gangster.stat == DEAD) || (is_station_level(gangster.z)))
				continue

			var/obj/item/clothing/outfit
			var/obj/item/clothing/gang_outfit
			if(gangster.w_uniform)
				outfit = gangster.w_uniform
				if(outfit.gang == src)
					gang_outfit = outfit
			if(gangster.wear_suit)
				outfit = gangster.wear_suit
				if(outfit.gang == src)
					gang_outfit = outfit

			if(gang_outfit)
				gangster << "<span class='notice'>The [src] Gang's influence grows as you wear [gang_outfit].</span>"
				uniformed++
	return uniformed

/datum/team/gang/proc/announce_all_influence(message)
	if(!gangtools.len || !message)
		return
	for(var/obj/item/device/gangtool/tool in gangtools)
		var/mob/living/mob = tool.loc
		if(!istype(mob)) continue
		if(mob && mob.mind && mob.stat == CONSCIOUS)
			if(mob.mind.has_antag_datum(/datum/team/gang) == src)
				to_chat(mob, "<span class='warning'>\icon[tool] [message]</span>")
				playsound(mob.loc, 'sound/machines/twobeep.ogg', 50, 1)

/datum/team/gang/proc/adjust_influence(value)
	influence = max(0, influence + value)

/datum/team/gang/proc/message_gangtools(message)
	if(!gangtools.len || !message)
		return
	for(var/i in gangtools)
		var/obj/item/device/gangtool/tool = i
		var/mob/living/mob = get(tool.loc, /mob/living)
		if(mob && mob.mind && mob.stat == CONSCIOUS)
			if(mob.mind.has_antag_datum(/datum/team/gang) == src)
				to_chat(mob, "<span class='warning'>[icon2html(tool, mob)] [message]</span>")
			return

/datum/team/gang/proc/domination()
	domination_time = determine_domination_time()
	set_security_level("delta")

/datum/team/gang/proc/determine_domination_time()
	return max(180,480 - (round((territories.len/GLOB.start_state.num_territories)*100, 1) * 9))

/datum/team/gang/clandestine
	name = "Clandestine"

/datum/team/gang/prima
	name = "Prima"

/datum/team/gang/zerog
	name = "Zero-G"

/datum/team/gang/max
	name = "Max"

/datum/team/gang/blasto
	name = "Blasto"

/datum/team/gang/waffle
	name = "Waffle"

/datum/team/gang/north
	name = "North"

/datum/team/gang/omni
	name = "Omni"

/datum/team/gang/newton
	name = "Newton"

/datum/team/gang/cyber
	name = "Cyber"

/datum/team/gang/donk
	name = "Donk"

/datum/team/gang/gene
	name = "Gene"

/datum/team/gang/gib
	name = "Gib"

/datum/team/gang/tunnel
	name = "Tunnel"

/datum/team/gang/diablo
	name = "Diablo"

/datum/team/gang/psyke
	name = "Psyke"

/datum/team/gang/osiron
	name = "Osiron"

/datum/team/gang/sirius
	name = "Sirius"

/datum/team/gang/sleepingcarp
	name = "Sleeping Carp"

/datum/team/gang/h
	name = "H"

/datum/team/gang/rigatonifamily
	name = "Rigatony family"
