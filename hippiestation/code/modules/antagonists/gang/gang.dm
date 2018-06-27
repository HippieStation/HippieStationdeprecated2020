/datum/antagonist/gang
	var/name = "Gangster"
	var/roundend_category = "gangsters"
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

/datum/antagonist/gang/greet()
	to_chat(owner, "<span class='userdanger'>You are now a revolutionary! Help your cause. Do not harm your fellow freedom fighters. You can identify your comrades by the red \"R\" icons, and your leaders by the blue \"R\" icons. Help them kill the heads to win the revolution!</span>")
	owner.announce_objectives()

/datum/antagonist/gang/create_team(datum/team/gang/new_team)
	if(!new_team)
		var/gangteam = pick_n_take(GLOB.possible_gangs)
		if(gangteam)
			gang = new gangteam
	gang = new_team

/datum/antagonist/rev/proc/create_objectives()
	owner.objectives |= gang.objectives

/datum/antagonist/rev/proc/remove_objectives()
	owner.objectives -= gang.objectives

//Bump up to boss
/datum/antagonist/gang/proc/promote()
	var/old_gang = gang
	var/datum/mind/old_owner = owner
	owner.remove_antag_datum(/datum/antagonist/gang)
	var/datum/antagonist/gang/leader/new_boss = new()
	old_owner.add_antag_datum(new_boss,old_gang)
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
	var/mob/living/carbon/C = candidate
	if(!istype(C)) //Can't convert simple animals
		return FALSE
	return TRUE

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

/datum/antagonist/rev/farewell()
	if(ishuman(owner.current))
		owner.current.visible_message("<span class='deconversion_message'>[owner.current] looks like [owner.current.p_theyve()] just remembered [owner.current.p_their()] real allegiance!</span>", null, null, null, owner.current)
		to_chat(owner, "<span class='userdanger'>You are no longer a brainwashed revolutionary! Your memory is hazy from the time you were a rebel...the only thing you remember is the name of the one who brainwashed you...</span>")
	else if(issilicon(owner.current))
		owner.current.visible_message("<span class='deconversion_message'>The frame beeps contentedly, purging the hostile memory engram from the MMI before initalizing it.</span>", null, null, null, owner.current)
		to_chat(owner, "<span class='userdanger'>The frame's firmware detects and deletes your neural reprogramming! You remember nothing but the name of the one who flashed you.</span>")

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

/datum/antagonist/rev/head/equip_rev()
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return

	if(remove_clumsy && owner.assigned_role == "Clown")
		to_chat(owner, "Your training has allowed you to overcome your clownish nature, allowing you to wield weapons without harming yourself.")
		H.dna.remove_mutation(CLOWNMUT)

	if(give_flash)
		var/obj/item/assembly/flash/T = new(H)
		var/list/slots = list (
			"backpack" = SLOT_IN_BACKPACK,
			"left pocket" = SLOT_L_STORE,
			"right pocket" = SLOT_R_STORE
		)
		var/where = H.equip_in_one_of_slots(T, slots)
		if (!where)
			to_chat(H, "The Syndicate were unfortunately unable to get you a flash.")
		else
			to_chat(H, "The flash in your [where] will help you to persuade the crew to join your cause.")

	if(give_hud)
		var/obj/item/organ/cyberimp/eyes/hud/security/syndicate/S = new(H)
		S.Insert(H, special = FALSE, drop_if_replaced = FALSE)
		to_chat(H, "Your eyes have been implanted with a cybernetic security HUD which will help you keep track of who is mindshield-implanted, and therefore unable to be recruited.")



GLOBAL_LIST_INIT(gang_colors_pool, list("red","orange","yellow","green","blue","purple", "white"))

#define INFLUENCE_INTERVAL 1800

/datum/team/gang
	name = "Gang"
	member_name = "gangster"
	var/list/leaders // bosses and lieutenants
	var/influence = 0 // influence of the gang, based on how many territories they own. Can be used to buy weapons and tools from a gang uplink.
	var/list/territories = list() // territories owned by the gang.
	var/list/lost_territories = list() // territories lost by the gang.
	var/list/new_territories = list() // territories captured by the gang.
	var/list/gangtools = list()
	var/next_point_interval = INFLUENCE_INTERVAL
	var/next_point_time
	var/list/buyable_items

/datum/team/gang/New(starting_members)
	. = ..()
	if(starting_members)
		if(islist(starting_members))
			for(var/datum/mind/M in starting_members)
				LAZYADD(leaders, M)
		else
			LAZYADD(leaders, starting_members)
	next_point_time = world.time + next_point_interval
	START_PROCESSING(SSobj, src)

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
	var/list/winners = list() //stores the winners if there are any

	if(world.time > next_point_time)
		handle_territories()

/*to check
		if(G.is_dominating)
			if(G.domination_time_remaining() < 0)
				winners += G

	if(world.time > next_point_time)
		next_point_time = world.time + next_point_interval

	if(winners.len)
		if(winners.len > 1) //Edge Case: If more than one dominator complete at the same time
			for(var/datum/gang/G in winners)
				G.domination(0.5)
			priority_announce("Multiple station takeover attempts have made simultaneously. Conflicting takeover attempts appears to have restarted.","Network Alert")
		else
			var/datum/gang/G = winners[1]
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
	message += "<b>[territory_new.len] new territories:</b><br><i>[added_names]</i><br>"
	message += "<b>[territory_lost.len] territories lost:</b><br><i>[lost_names]</i><br>"
	//Clear the lists
	new_territories = list()
	lost_territories = list()
	var/control = round((territories.len/GLOB.start_state.num_territories)*100, 1)
	var/uniformed = check_clothing()
	message += "Your gang now has <b>[control]% control</b> of the station.<BR>*---------*<BR>"
	if(is_dominating)
		var/seconds_remaining = domination_time_remaining()
		var/new_time = max(180, seconds_remaining - (uniformed * 4) - (territory.len * 2))
		if(new_time < seconds_remaining)
			message += "Takeover shortened by [seconds_remaining - new_time] seconds for defending [territory.len] territories.<BR>"
			set_domination_time(new_time)
		message += "<b>[seconds_remaining] seconds remain</b> in hostile takeover.<BR>"
	else
		var/new_influence = check_territory_income()
		if(new_influence != influence)
			message += "Gang influence has increased by [new_influence - influence] for defending [territory.len] territories and [uniformed] uniformed gangsters.<BR>"
		influence = new_influence
		message += "Your gang now has <b>[influence] influence</b>.<BR>"
	announce_all_influence(message)

/datum/team/gang/proc/check_territory_income()
	var/new_influence = min(999,points + 15 + (check_clothing() * 2) + territory.len)
	return new_influence

/datum/team/gang/proc/check_clothing()
	//Count uniformed gangsters
	var/uniformed = 0
	for(var/datum/mind/gangmind in members)
		if(ishuman(gangmind.current))
			var/mob/living/carbon/human/gangster = gangmind.current
			//Gangster must be alive and on station
			if((gangster.stat == DEAD) || (is_station_z_level(gangster.z)))
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
			if(mob.mind.gang_datum == src)
				tochat(mob, "<span class='warning'>\icon[tool] [message]</span>")
				playsound(mob.loc, 'sound/machines/twobeep.ogg', 50, 1)

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
