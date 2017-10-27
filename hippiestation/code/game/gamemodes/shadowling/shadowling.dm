#define LIGHT_DAM_THRESHOLD 0.25
#define LIGHT_HEAL_THRESHOLD 2
#define LIGHT_DAMAGE_TAKEN 7

/*

SHADOWLING: A gamemode based on previously-run events

Aliens called shadowlings are on the station.
These shadowlings can 'enthrall' crew members and enslave them.
They also burn in the light but heal rapidly whilst in the dark.
The game will end under two conditions:
	1. The shadowlings die
	2. The emergency shuttle docks at CentCom

Shadowling strengths:
	- The dark
	- Hard vacuum (They are not affected by it, but are affected by starlight!)
	- Their thralls who are not harmed by the light
	- Stealth

Shadowling weaknesses:
	- The light
	- Fire
	- Enemy numbers
	- Burn-based weapons and items (flashbangs, lasers, etc.)

Shadowlings start off disguised as normal crew members, and they only have two abilities: Hatch and Enthrall.
They can still enthrall and perhaps complete their objectives in this form.
Hatch will, after a short time, cast off the human disguise and assume the shadowling's true identity.
They will then assume the normal shadowling form and gain their abilities.

The shadowling will seem OP, and that's because it kinda is. Being restricted to the dark while being alone most of the time is extremely difficult and as such the shadowling needs powerful abilities.
Made by Xhuis

*/



/*
	GAMEMODE
*/


/datum/game_mode
	var/list/datum/mind/shadows = list()
	var/list/datum/mind/thralls = list()
	var/list/shadow_objectives = list()
	var/required_thralls = 15 //How many thralls are needed (this is changed in pre_setup, so it scales based on pop)
	var/shadowling_ascended = 0 //If at least one shadowling has ascended
	var/shadowling_dead = 0 //is shadowling kill
	var/objective_explanation
	var/thrall_ratio = 1
	
/datum/game_mode/proc/replace_jobbaned_player(mob/living/M, role_type, pref)
	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you want to play as a [role_type]?", "[role_type]", null, pref, 50, M)
	var/mob/dead/observer/theghost = null
	if(candidates.len)
		theghost = pick(candidates)
		to_chat(M, "Your mob has been taken over by a ghost! Appeal your job ban if you want to avoid this in the future!")
		message_admins("[key_name_admin(theghost)] has taken control of ([key_name_admin(M)]) to replace a jobbaned player.")
		M.ghostize(0)
		M.key = theghost.key

/proc/is_thrall(var/mob/living/M)
	return istype(M) && M.mind && SSticker && SSticker.mode && (M.mind in SSticker.mode.thralls)


/proc/is_shadow_or_thrall(var/mob/living/M)
	return istype(M) && M.mind && SSticker && SSticker.mode && ((M.mind in SSticker.mode.thralls) || (M.mind in SSticker.mode.shadows))


/proc/is_shadow(var/mob/living/M)
	return istype(M) && M.mind && SSticker && SSticker.mode && (M.mind in SSticker.mode.shadows)


/datum/game_mode/shadowling
	name = "shadowling"
	config_tag = "shadowling"
	antag_flag = ROLE_SHADOWLING
	required_players = 26
	required_enemies = 3
	recommended_enemies = 2
	restricted_jobs = list("AI", "Cyborg")
	protected_jobs = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain")

/datum/game_mode/shadowling/announce()
	to_chat(world, "<b>The current game mode is - Shadowling!</b>")
	to_chat(world, "<b>There are alien <span class='shadowling'>shadowlings</span> on the station. Crew: Kill the shadowlings before they can enthrall the crew. Shadowlings: Enthrall the crew while remaining in hiding.</b>")

/datum/game_mode/shadowling/pre_setup()
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		restricted_jobs += protected_jobs

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		restricted_jobs += "Assistant"

	var/shadowlings = max(3, round(num_players()/14))


	while(shadowlings)
		var/datum/mind/shadow = pick(antag_candidates)
		shadows += shadow
		antag_candidates -= shadow
		shadow.special_role = "Shadowling"
		shadow.restricted_roles = restricted_jobs
		shadowlings--

	var/thrall_scaling = round(num_players() / 3)
	required_thralls = Clamp(thrall_scaling, 15, 30)

	thrall_ratio = required_thralls / 15

	return 1

/datum/game_mode/shadowling/generate_report()
	return "Sightings of strange alien creatures have been observed in your area. These aliens supposedly possess the ability to enslave unwitting personnel and leech from their power. \
	Be wary of dark areas and ensure all lights are kept well-maintained. Closely monitor all crew for suspicious behavior and perform dethralling surgery if they have obvious tells. Investigate all \
	reports of odd or suspicious sightings in maintenance."

/datum/game_mode/shadowling/post_setup()
	for(var/datum/mind/shadow in shadows)
		log_game("[shadow.key] (ckey) has been selected as a Shadowling.")
		sleep(10)
		to_chat(shadow.current, "<br>")
		to_chat(shadow.current, "<span class='shadowling'><b><font size=3>You are a shadowling!</font></b></span>")
		greet_shadow(shadow)
		finalize_shadowling(shadow)
		process_shadow_objectives(shadow)
		//give_shadowling_abilities(shadow)
	..()
	return

/datum/game_mode/proc/greet_shadow(datum/mind/shadow)
	to_chat(shadow.current, "<b>Currently, you are disguised as an employee aboard [station_name()]].</b>")
	to_chat(shadow.current, "<b>In your limited state, you have three abilities: Enthrall, Hatch, and Hivemind Commune.</b>")
	to_chat(shadow.current, "<b>Any other shadowlings are your allies. You must assist them as they shall assist you.</b>")
	to_chat(shadow.current, "<b>If you are new to shadowling, or want to read about abilities, check the wiki page at https://wiki.hippiestation.com/index.php?title=Shadowling</b><br>")
	to_chat(shadow.current, "<b>You require [required_thralls] thralls to ascend.</b><br>")
	shadow.current.playsound_local(get_turf(shadow.current), 'hippiestation/sound/ambience/antag/sling.ogg', 100, FALSE, pressure_affected = FALSE)




/datum/game_mode/proc/process_shadow_objectives(datum/mind/shadow_mind)
	var/objective = "enthrall" //may be devour later, but for now it seems murderbone-y

	if(objective == "enthrall")
		objective_explanation = "Ascend to your true form by use of the Ascendance ability. This may only be used with [required_thralls] collective thralls, while hatched, and is unlocked with the Collective Mind ability."
		shadow_objectives += "enthrall"
		shadow_mind.memory += "<b>Objective #1</b>: [objective_explanation]"
		to_chat(shadow_mind.current, "<b>Objective #1</b>: [objective_explanation]<br>")


/datum/game_mode/proc/finalize_shadowling(datum/mind/shadow_mind)
	var/mob/living/carbon/human/S = shadow_mind.current
	shadow_mind.AddSpell(new /obj/effect/proc_holder/spell/self/shadowling_hatch(null))
	shadow_mind.AddSpell(new /obj/effect/proc_holder/spell/self/shadowling_hivemind(null))
	spawn(0)
		update_shadow_icons_added(shadow_mind)
		if(shadow_mind.assigned_role == "Clown")
			to_chat(S, "<span class='notice'>Your alien nature has allowed you to overcome your clownishness.</span>")
			S.dna.remove_mutation(CLOWNMUT)

/datum/game_mode/proc/add_thrall(datum/mind/new_thrall_mind)
	if(!istype(new_thrall_mind))
		return 0
	if(!(new_thrall_mind in thralls))
		update_shadow_icons_added(new_thrall_mind)
		thralls += new_thrall_mind
		new_thrall_mind.special_role = "thrall"
		message_admins("[key_name_admin(new_thrall_mind.current)] was enthralled by a shadowling!")
		log_game("[key_name(new_thrall_mind.current)] was enthralled by a shadowling!")

		new_thrall_mind.AddSpell(new /obj/effect/proc_holder/spell/self/lesser_shadowling_hivemind(null))
		new_thrall_mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/lesser_glare(null))
		new_thrall_mind.AddSpell(new /obj/effect/proc_holder/spell/self/lesser_shadow_walk(null))
		new_thrall_mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/night_vision/thrall(null))
		to_chat(new_thrall_mind.current, "<span class='shadowling'><b>You see the truth. Reality has been torn away and you realize what a fool you've been.</b></span>")
		to_chat(new_thrall_mind.current, "<span class='shadowling'><b>The shadowlings are your masters.</b> Serve them above all else and ensure they complete their goals.</span>")
		to_chat(new_thrall_mind.current, "<span class='shadowling'>You may not harm other thralls or the shadowlings. However, you do not need to obey other thralls.</span>")
		to_chat(new_thrall_mind.current, "<span class='shadowling'>Your body has been irreversibly altered. The attentive can see this - you may conceal it by wearing a mask.</span>")
		to_chat(new_thrall_mind.current, "<span class='shadowling'>Though not nearly as powerful as your masters, you possess some weak powers. These can be found in the Thrall Abilities tab.</span>")
		to_chat(new_thrall_mind.current, "<span class='shadowling'>You may communicate with your allies by using the Lesser Commune ability.</span>")
		new_thrall_mind.current.playsound_local(get_turf(new_thrall_mind.current), 'hippiestation/sound/ambience/antag/thrall.ogg', 100, FALSE, pressure_affected = FALSE)
		if(jobban_isbanned(new_thrall_mind.current, ROLE_SHADOWLING))
			replace_jobbaned_player(new_thrall_mind.current, ROLE_SHADOWLING, ROLE_SHADOWLING)
		return 1

/datum/game_mode/proc/remove_thrall(datum/mind/thrall_mind, var/kill = 0)
	if(!istype(thrall_mind) || !(thrall_mind in thralls) || !isliving(thrall_mind.current)) return 0 //If there is no mind, the mind isn't a thrall, or the mind's mob isn't alive, return
	update_shadow_icons_removed(thrall_mind)
	thralls.Remove(thrall_mind)
	message_admins("[key_name_admin(thrall_mind.current)] was dethralled!")
	log_game("[key_name(thrall_mind.current)] was dethralled!")
	thrall_mind.special_role = null
	for(var/obj/effect/proc_holder/spell/S in thrall_mind.spell_list)
		thrall_mind.RemoveSpell(S)
	if(kill && ishuman(thrall_mind.current)) //If dethrallization surgery fails, kill the mob as well as dethralling them
		var/mob/living/carbon/human/H = thrall_mind.current
		H.visible_message("<span class='warning'>[H] jerks violently and falls still.</span>", \
						  "<span class='userdanger'>A piercing white light floods your mind, banishing your memories as a thrall and--</span>")
		H.death()
		return 1
	var/mob/living/M = thrall_mind.current
	if(issilicon(M))
		M.audible_message("<span class='notice'>[M] lets out a short blip.</span>", \
						  "<span class='userdanger'>You have been turned into a robot! You are no longer a thrall! Though you try, you cannot remember anything about your servitude...</span>")
	else
		M.visible_message("<span class='big'>[M] looks like their mind is their own again!</span>", \
						  "<span class='userdanger'>A piercing white light floods your eyes. Your mind is your own again! Though you try, you cannot remember anything about the shadowlings or your time \
						  under their command...</span>")
	return 1

/datum/game_mode/proc/remove_shadowling(datum/mind/ling_mind)
	if(!istype(ling_mind) || !(ling_mind in shadows)) return 0
	update_shadow_icons_removed(ling_mind)
	shadows.Remove(ling_mind)
	message_admins("[key_name_admin(ling_mind.current)] was de-shadowlinged!")
	log_game("[key_name(ling_mind.current)] was de-shadowlinged!")
	ling_mind.special_role = null
	for(var/obj/effect/proc_holder/spell/S in ling_mind.spell_list)
		ling_mind.RemoveSpell(S)
	var/mob/living/M = ling_mind.current
	if(issilicon(M))
		M.audible_message("<span class='notice'>[M] lets out a short blip.</span>", \
						  "<span class='userdanger'>You have been turned into a robot! You are no longer a shadowling! Though you try, you cannot remember anything about your time as one...</span>")
	else
		M.visible_message("<span class='big'>[M] screams and contorts!</span>", \
						  "<span class='userdanger'>THE LIGHT-- YOUR MIND-- <i>BURNS--</i></span>")
		spawn(30)
			if(!M || QDELETED(M))
				return
			M.visible_message("<span class='warning'>[M] suddenly bloats and explodes!</span>", \
							  "<span class='warning'><b>AAAAAAAAA<font size=3>AAAAAAAAAAAAA</font><font size=4>AAAAAAAAAAAA----</font></span>")
			playsound(M, 'sound/magic/Disintegrate.ogg', 100, 1)
			M.gib()


/datum/game_mode/shadowling/proc/check_shadow_victory()
	return shadowling_ascended


/datum/game_mode/shadowling/declare_completion()
	if(check_shadow_victory()) //Doesn't end instantly - this is hacky and I don't know of a better way ~X
		to_chat(world, "<span class='greentext'>The shadowlings have ascended and taken over the station!</span>")
	else if(!check_shadow_victory() && check_shadow_death()) //If the shadowlings have ascended, they can not lose the round
		to_chat(world, "<span class='redtext'>The shadowlings have been killed by the crew!</span>")
	else if(!check_shadow_victory() && SSshuttle.emergency.mode >= SHUTTLE_ESCAPE)
		to_chat(world, "<span class='redtext'>The crew escaped the station before the shadowlings could ascend!</span>")
	else
		to_chat(world, "<span class='redtext'>The shadowlings have failed!</span>")
	..()
	return 1

/datum/game_mode/shadowling/proc/check_shadow_death()
	for(var/datum/mind/shadow_mind in shadows)
		var/turf/T = get_turf(shadow_mind.current)
		if((shadow_mind) && (shadow_mind.current) && (shadow_mind.current.stat != DEAD) && T && (T.z in GLOB.station_z_levels))
			if(ishuman(shadow_mind.current))
				return FALSE
	return TRUE
	
/datum/game_mode/shadowling/check_finished()
	. = ..()
	if(check_shadow_death())
		return TRUE


/datum/game_mode/proc/auto_declare_completion_shadowling()
	var/text = ""
	if(shadows.len)
		text += "<br><span class='big'><b>The shadowlings were:</b></span>"
		for(var/datum/mind/shadow in shadows)
			text += printplayer(shadow)
		text += "<br>"
		if(thralls.len)
			text += "<br><span class='big'><b>The thralls were:</b></span>"
			for(var/datum/mind/thrall in thralls)
				text += printplayer(thrall)
	text += "<br>"
	to_chat(world, text)


/*
	MISCELLANEOUS
*/


/datum/species/shadow/ling
	//Normal shadowpeople but with enhanced effects
	name = "Shadowling"
	id = "shadowling"
	say_mod = "chitters"
	species_traits = list(NOBREATH,RESISTCOLD,RESISTPRESSURE,NOGUNS,NOBLOOD,RADIMMUNE,VIRUSIMMUNE,PIERCEIMMUNE,NO_UNDERWEAR)
	no_equip = list(slot_wear_mask, slot_glasses, slot_gloves, slot_shoes, slot_w_uniform, slot_s_store)
	nojumpsuit = 1
	mutanteyes = /obj/item/organ/eyes/night_vision/alien/sling
	burnmod = 1.5 //1.5x burn damage, 2x is excessive
	heatmod = 1.5

/datum/species/shadow/ling/on_species_gain(mob/living/carbon/human/C)
	C.draw_hippie_parts()
	. = ..()

/datum/species/shadow/ling/on_species_loss(mob/living/carbon/human/C)
	C.draw_hippie_parts(TRUE)
	. = ..()

/datum/species/shadow/ling/spec_life(mob/living/carbon/human/H)
	var/light_amount = 0
	H.nutrition = NUTRITION_LEVEL_WELL_FED //i aint never get hongry
	if(isturf(H.loc))
		var/turf/T = H.loc
		light_amount = T.get_lumcount()
		if(light_amount > LIGHT_DAM_THRESHOLD) //Can survive in very small light levels. Also doesn't take damage while incorporeal, for shadow walk purposes
			H.take_overall_damage(0, LIGHT_DAMAGE_TAKEN)
			if(H.stat != DEAD)
				to_chat(H, "<span class='userdanger'>The light burns you!</span>") //Message spam to say "GET THE FUCK OUT"
				H.playsound_local(get_turf(H), 'sound/weapons/sear.ogg', 150, 1, pressure_affected = FALSE)
		else if (light_amount < LIGHT_HEAL_THRESHOLD)
			H.heal_overall_damage(5,5)
			H.adjustToxLoss(-5)
			H.adjustBrainLoss(-25) //Shad O. Ling gibbers, "CAN U BE MY THRALL?!!"
			H.adjustCloneLoss(-1)
			H.SetKnockdown(0)
			H.SetStun(0)

/datum/species/shadow/ling/lesser //Empowered thralls. Obvious, but powerful
	name = "Lesser Shadowling"
	id = "l_shadowling"
	say_mod = "chitters"
	species_traits = list(NOBREATH,NOBLOOD,RADIMMUNE)
	burnmod = 1.1
	heatmod = 1.1

/datum/species/shadow/ling/lesser/spec_life(mob/living/carbon/human/H)
	var/light_amount = 0
	H.nutrition = NUTRITION_LEVEL_WELL_FED //i aint never get hongry
	if(isturf(H.loc))
		var/turf/T = H.loc
		light_amount = T.get_lumcount()
		if(light_amount > LIGHT_DAM_THRESHOLD && !H.incorporeal_move)
			H.take_overall_damage(0, LIGHT_DAMAGE_TAKEN/2)
		else if (light_amount < LIGHT_HEAL_THRESHOLD)
			H.heal_overall_damage(2,2)
			H.adjustToxLoss(-5)
			H.adjustBrainLoss(-25)
			H.adjustCloneLoss(-1)

/datum/game_mode/proc/update_shadow_icons_added(datum/mind/shadow_mind)
	var/datum/atom_hud/antag/shadow_hud = GLOB.huds[ANTAG_HUD_SHADOW]
	shadow_hud.join_hud(shadow_mind.current)
	set_antag_hud(shadow_mind.current, ((shadow_mind in shadows) ? "shadowling" : "thrall"))

/datum/game_mode/proc/update_shadow_icons_removed(datum/mind/shadow_mind)
	var/datum/atom_hud/antag/shadow_hud = GLOB.huds[ANTAG_HUD_SHADOW]
	shadow_hud.leave_hud(shadow_mind.current)
	set_antag_hud(shadow_mind.current, null)
