#define DEFAULT_SLOT_AMT	1
#define HANDS_SLOT_AMT		2
#define BACKPACK_SLOT_AMT	3

/datum/preferences
	features = list("mcolor" = "FFF", "tail_lizard" = "Smooth", "tail_human" = "None", "snout" = "Round", "horns" = "None", "ears" = "None", "wings" = "None", "frills" = "None", "spines" = "None", "body_markings" = "None", "legs" = "Normal Legs", "moth_wings" = "Plain", "ipc_screen" = "Sunburst")
	max_save_slots = 6
	friendlyGenders = list("Male" = "male", "Female" = "female")
	var/gear_points = 5
	var/list/gear_categories
	var/list/chosen_gear
	var/gear_tab
	var/hippie_toggles = HIPPIE_TOGGLES_DEFAULT // our own toggles.
	var/voice

/datum/preferences/New(client/C, key_override)
	parent = C

	for(var/custom_name_id in GLOB.preferences_custom_names)
		custom_names[custom_name_id] = get_default_name(custom_name_id)

	UI_style = GLOB.available_ui_styles[1]
	if(istype(C))
		if(!IsGuestKey(key_override || C.key))
			load_path(key_override ? ckey(key_override) : C.ckey)
			unlock_content = C.IsByondMember()
			if(unlock_content)
				max_save_slots = 8
	var/loaded_preferences_successfully = load_preferences()
	if(loaded_preferences_successfully)
		if(load_character())
			return
	//we couldn't load character data so just randomize the character appearance + name
	random_character()		//let's create a random character then - rather than a fat, bald and naked man.
	real_name = pref_species.random_name(gender,1)
	if(!loaded_preferences_successfully)
		save_preferences()
	save_character()		//let's save this new random character so it doesn't keep generating new ones.
	menuoptions = list()
	
/datum/preferences/New(client/C, key_override)
	..()
	LAZYINITLIST(chosen_gear)

/datum/preferences/proc/add_hippie_choices(dat)
	if("ipc_screen" in pref_species.mutant_bodyparts)
		dat += "<td valign='top' width='7%'>"

		dat += "<h3>Screen</h3>"

		dat += "<a href='?_src_=prefs;preference=ipc_screen;task=input'>[features["ipc_screen"]]</a><BR>"

		dat += "</td>"
	return dat

/datum/preferences/proc/process_hippie_link(mob/user, list/href_list)
	switch(href_list["task"])
		if("input")
			switch(href_list["preference"])
				if("ipc_screen")
					var/new_ipc_screen
					new_ipc_screen = input(user, "Choose your character's screen:", "Character Preference") as null|anything in GLOB.ipc_screens_list
					if(new_ipc_screen)
						features["ipc_screen"] = new_ipc_screen
				if("voice")
					var/list/voices = ((gender == FEMALE) ? splittext(CONFIG_GET(string/tts_voice_female), ",") : splittext(CONFIG_GET(string/tts_voice_male), ","))
					var/new_voice = input(user, "Choose your character's TTS voice:", "Character Preference") as null|anything in voices
					if(new_voice)
						voice = new_voice
		else
			switch(href_list["preference"])
				if("hear_tts")
					hippie_toggles ^= SOUND_TTS
				if("hear_footsteps")
					hippie_toggles ^= SOUND_FOOTSTEPS
				if("hear_vox")
					hippie_toggles ^= SOUND_VOX
				if("gear")
					if(href_list["clear_loadout"])
						LAZYCLEARLIST(chosen_gear)
						gear_points = initial(gear_points)
						save_preferences()
					if(href_list["select_category"])
						for(var/i in GLOB.loadout_items)
							if(i == href_list["select_category"])
								gear_tab = i
					if(href_list["toggle_gear_path"])
						var/datum/gear/G = GLOB.loadout_items[gear_tab][href_list["toggle_gear_path"]]
						if(!G)
							return
						var/toggle = text2num(href_list["toggle_gear"])
						if(!toggle && (G.type in chosen_gear))//toggling off and the item effectively is in chosen gear)
							LAZYREMOVE(chosen_gear, G.type)
							gear_points += initial(G.cost)
						else if(toggle && (!locate(G, chosen_gear)))
							if(!is_loadout_slot_available(G.category))
								to_chat(user, "<span class='danger'>You cannot take this loadout, as you've already chosen too many of the same category!</span>")
								return
							if(gear_points >= initial(G.cost))
								LAZYADD(chosen_gear, G.type)
								gear_points -= initial(G.cost)

/datum/preferences/proc/hippie_dat_replace(current_tab)
	//This proc is for menus other than game pref and char pref
	switch(current_tab)
		if(2)
			. += "<table><tr><td width='340px' height='300px' valign='top'>"
			. += "<h2>Hippie OOC Settings</h2>"

			. += "<b>Play Text-to-Speech:</b> <a href='?_src_=prefs;preference=hear_tts'>[(hippie_toggles & SOUND_TTS) ? "Enabled":"Disabled"]</a><br>" // let user toggle TTS sounds
			. += "<b>Play Footsteps:</b> <a href='?_src_=prefs;preference=hear_footsteps'>[(hippie_toggles & SOUND_FOOTSTEPS) ? "Enabled":"Disabled"]</a><br>" // let user toggle footsteps
			. += "<b>Play AI Vox:</b> <a href='?_src_=prefs;preference=hear_vox'>[(hippie_toggles & SOUND_VOX) ? "Enabled":"Disabled"]</a><br>" // let user toggle AI vox

			. += "</tr></table>"
		if(4)
			if(!gear_tab)
				gear_tab = GLOB.loadout_items[1]
			. += "<table align='center' width='100%'>"
			. += "<tr><td colspan=4><center><b><font color='[gear_points == 0 ? "#E67300" : "#3366CC"]'>[gear_points]</font> loadout points remaining.</b> \[<a href='?_src_=prefs;preference=gear;clear_loadout=1'>Clear Loadout</a>\]</center></td></tr>"
			. += "<tr><td colspan=4><center>You can only choose one item per category, unless it's an item that spawns in your backpack or hands.</center></td></tr>"
			. += "<tr><td colspan=4><center><b>"
			var/firstcat = TRUE
			for(var/i in GLOB.loadout_items)
				if(firstcat)
					firstcat = FALSE
				else
					. += " |"
				if(i == gear_tab)
					. += " <span class='linkOn'>[i]</span> "
				else
					. += " <a href='?_src_=prefs;preference=gear;select_category=[i]'>[i]</a> "
			. += "</b></center></td></tr>"
			. += "<tr><td colspan=4><hr></td></tr>"
			. += "<tr><td colspan=4><b><center>[gear_tab]</center></b></td></tr>"
			. += "<tr><td colspan=4><hr></td></tr>"
			. += "<tr style='vertical-align:top;'><td width=15%><b>Name</b></td>"
			. += "<td width=5% style='vertical-align:top'><b>Cost</b></td>"
			. += "<td><font size=2><b>Restrictions</b></font></td>"
			. += "<td><font size=2><b>Description</b></font></td></tr>"
			for(var/j in GLOB.loadout_items[gear_tab])
				var/datum/gear/gear = GLOB.loadout_items[gear_tab][j]
				var/class_link = ""
				if(gear.type in chosen_gear)
					class_link = "class='linkOn' href='?_src_=prefs;preference=gear;toggle_gear_path=[j];toggle_gear=0'"
				else if(gear_points <= 0)
					class_link = "class='linkOff'"
				else
					class_link = "href='?_src_=prefs;preference=gear;toggle_gear_path=[j];toggle_gear=1'"
				. += "<tr style='vertical-align:top;'><td width=15%><a style='white-space:normal;' [class_link]>[j]</a></td>"
				. += "<td width = 5% style='vertical-align:top'>[gear.cost]</td><td>"
				if(islist(gear.restricted_roles))
					if(gear.restricted_roles.len)
						. += "<font size=2>"
						. += gear.restricted_roles.Join(";")
						. += "</font>"
				. += "</td><td><font size=2><i>[gear.description]</i></font></td></tr>"
			. += "</table>"

/datum/preferences/proc/is_loadout_slot_available(slot)
	var/list/L = list()
	for(var/i in chosen_gear)
		var/datum/gear/G = i
		var/occupied_slots = L[slot_to_string(initial(G.category))] ? L[slot_to_string(initial(G.category))] + 1 : 1
		LAZYSET(L, slot_to_string(initial(G.category)), occupied_slots)
	switch(slot)
		if(SLOT_IN_BACKPACK)
			if(L[slot_to_string(SLOT_IN_BACKPACK)] < BACKPACK_SLOT_AMT)
				return TRUE
		if(SLOT_HANDS)
			if(L[slot_to_string(SLOT_HANDS)] < HANDS_SLOT_AMT)
				return TRUE
		else
			if(L[slot_to_string(slot)] < DEFAULT_SLOT_AMT)
				return TRUE

/datum/preferences/copy_to(mob/living/carbon/human/character, icon_updates, roundstart_checks)
	. = ..()
	if(character.dna && voice)
		character.dna.tts_voice = voice
