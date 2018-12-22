/datum/game_mode/wizard/raginmages
	name = "ragin' mages"
	config_tag = "raginmages"
	required_players = 20
	announce_span = "userdanger"
	announce_text = "There are many, many wizards attacking the station!\n\
	<span class='danger'>Wizards</span>: Accomplish your objectives and cause utter catastrophe!\n\
	<span class='notice'>Crew</span>: Try not to die..."
	var/max_mages = 0
	var/making_mage = 0
	var/mages_made = 1
	var/time_checked = 0
	var/bullshit_mode = 0 // requested by hornygranny
	var/time_check = 1500
	var/spawn_delay_min = 500
	var/spawn_delay_max = 700

/datum/game_mode/wizard/raginmages/post_setup()
	..()
	var/playercount = 0
	if(!max_mages && !bullshit_mode)
		for(var/mob/living/player in GLOB.mob_list)
			if(player.client && player.stat != 2)
				playercount += 1
			max_mages = round(playercount / 8)
			if(max_mages > 20)
				max_mages = 20
			if(max_mages < 1)
				max_mages = 1
	if(bullshit_mode)
		max_mages = INFINITY

/datum/game_mode/wizard/raginmages/check_finished()
	var/wizards_alive = 0
	for(var/datum/mind/wizard in wizards)
		if(!istype(wizard.current,/mob/living/carbon))
			continue
		if(istype(wizard.current,/mob/living/brain))
			continue
		if(wizard.current.stat==DEAD)
			continue
		if(wizard.current.stat==UNCONSCIOUS)
			if(wizard.current.health < 0)
				to_chat(wizard.current, "<font size='4'>The Space Wizard Federation is upset with your performance and have terminated your employment.</font>")
				wizard.current.death()
			continue
		wizards_alive++
	if(!time_checked)
		time_checked = world.time
	if(bullshit_mode)
		if(world.time > time_checked + time_check)
			max_mages = INFINITY
			time_checked = world.time
			make_more_mages()
			return ..()
	if (wizards_alive)
		if(world.time > time_checked + time_check && (mages_made < max_mages))
			time_checked = world.time
			make_more_mages()

	else
		if(mages_made >= max_mages)
			finished = 1
			return ..()
		else
			make_more_mages()
	return ..()

/datum/game_mode/wizard/raginmages/proc/make_more_mages()

	if(making_mage)
		return 0
	if(mages_made >= max_mages)
		return 0
	making_mage = 1
	mages_made++
	var/list/mob/dead/observer/candidates = list()
	var/mob/dead/observer/theghost = null
	spawn(rand(spawn_delay_min, spawn_delay_max))
		message_admins("SWF is still pissed, sending another wizard - [max_mages - mages_made] left.")
		for(var/mob/dead/observer/G in GLOB.player_list)
			if(G.client && !G.client.holder && !G.client.is_afk() && (ROLE_WIZARD in G.client.prefs.be_special))
				if(!is_banned_from(G.ckey, list(ROLE_WIZARD, ROLE_SYNDICATE)))
					if(age_check(G.client))
						candidates += G
		if(!candidates.len)
			message_admins("No applicable ghosts for the next ragin' mage, asking ghosts instead.")
			var/time_passed = world.time
			for(var/mob/dead/observer/G in GLOB.player_list)
				if(!is_banned_from(G.ckey, list(ROLE_WIZARD, ROLE_SYNDICATE)))
					if(age_check(G.client))
						spawn(0)
							switch(alert(G, "Do you wish to be considered for the position of Space Wizard Foundation 'diplomat'?","Please answer in 30 seconds!","Yes","No"))
								if("Yes")
									if((world.time-time_passed)>300)//If more than 30 game seconds passed.
										continue
									candidates += G
								if("No")
									continue

			sleep(300)
		if(!candidates.len)
			message_admins("This is awkward, sleeping until another mage check...")
			making_mage = 0
			mages_made--
			return
		else
			shuffle_inplace(candidates)
			for(var/mob/i in candidates)
				if(!i || !i.client) continue //Dont bother removing them from the list since we only grab one wizard

				theghost = i
				break

		if(theghost)
			var/mob/living/carbon/human/new_character= makeBody(theghost)
			new_character.mind.make_Wizard()
			making_mage = 0
			return 1

/datum/game_mode/wizard/raginmages/proc/makeBody(mob/dead/observer/G_found) // Uses stripped down and bastardized code from respawn character
	if(!G_found || !G_found.key)
		return

	//First we spawn a dude.
	var/mob/living/carbon/human/new_character = new //The mob being spawned.
	SSjob.SendToLateJoin(new_character)

	G_found.client.prefs.copy_to(new_character)
	new_character.dna.update_dna_identity()
	new_character.key = G_found.key

	return new_character

/datum/game_mode/wizard/raginmages/bullshit
	name = "very ragin' bullshit mages"
	config_tag = "veryraginbullshitmages"
	required_players = 20
	bullshit_mode = 1
	time_check = 250
	spawn_delay_min = 50
	spawn_delay_max = 150
	announce_text = "<span class='userdanger'>CRAAAWLING IIIN MY SKIIIN\n\
	THESE WOOOUNDS THEY WIIIL NOT HEEEAL</span>"
