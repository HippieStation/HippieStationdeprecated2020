#define OWNER 0
#define STRANGER 1

/datum/brain_trauma/severe/split_personality
	name = "Split Personality"
	desc = "Patient's brain is split into two personalities, which randomly switch control of the body."
	scan_desc = "complete lobe separation"
	gain_text = "<span class='warning'>You feel like your mind was split in two.</span>"
	lose_text = "<span class='notice'>You feel alone again.</span>"
	var/current_controller = OWNER
	var/initialized = FALSE //to prevent personalities deleting themselves while we wait for ghosts
	var/mob/living/split_personality/stranger_backseat //there's two so they can swap without overwriting
	var/mob/living/split_personality/owner_backseat
	var/mutemessage = FALSE	//Hippie add, to stop the personality swap message from being displayed twice
	var/owner_active = TRUE	//Hippie add, this will stop owner backseat getting deleted when they are controlling the body
	var/stranger_active = FALSE	//Hippie add, this will stop stranger backseat getting deleted when they are controlling the body

/datum/brain_trauma/severe/split_personality/on_gain()
	..()
	make_backseats()
	get_ghost()

/datum/brain_trauma/severe/split_personality/proc/make_backseats()
	stranger_backseat = new(owner, src)
	owner_backseat = new(owner, src)

/datum/brain_trauma/severe/split_personality/proc/get_ghost()
	set waitfor = FALSE
	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you want to play as [owner]'s split personality?", ROLE_PAI, null, null, 75, stranger_backseat)
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		stranger_backseat.key = C.key
		stranger_active = FALSE	//Hippie add
		owner_active = FALSE	//Hippie add
		addtimer(CALLBACK(src, .proc/switch_personalities), 20)			//Hippie add
		log_game("[key_name(stranger_backseat)] became [key_name(owner)]'s split personality.")
		message_admins("[key_name_admin(stranger_backseat)] became [key_name_admin(owner)]'s split personality.")
		addtimer(CALLBACK(src, .proc/set_flag), 30)	//Hippie change, change initialized to true with a timer so that our new ghost doesn't kick out the other guy immediately, or vice versa
	else
		addtimer(CALLBACK(src, .proc/make_backseats), 580)	//Hippie change, added this here as we're deleting the seats to refresh everything again
		addtimer(CALLBACK(src, .proc/get_ghost), 600)	//Hippie change, removed qdel and replaced with a timer for get_ghost so you don't lose this trauma if we cannot find a ghost
		qdel(stranger_backseat)
		qdel(owner_backseat)

/datum/brain_trauma/severe/split_personality/proc/set_flag()	//Hippie change, this proc has been added so qdel in on_life isn't immediately called as soon as we get a ghost
	initialized = TRUE

/datum/brain_trauma/severe/split_personality/proc/delete_seats()	//Hippie change, added this proc so we can add delay between our seats being swapped and deleted in on_life
	qdel(stranger_backseat)
	qdel(owner_backseat)	//The personality keeps the body if the owner decides to ghost for some reason... but look out, you're going to get a new personality soon!!!
	addtimer(CALLBACK(src, .proc/make_backseats), 580)	//Hippie change, added qdel on backseats and added a timer for make new backseats so the get_ghost's vote can properly be initiated, otherwise it freaks out and doesn't go through if someone ghosts
	addtimer(CALLBACK(src, .proc/get_ghost), 600)	//Hippie change, removed qdel and replaced with a timer for get_ghost so you don't lose this trauma if we cannot find a ghost

/datum/brain_trauma/severe/split_personality/on_life()
	if(owner_backseat && stranger_backseat)
		if(!stranger_backseat.client && !stranger_active && initialized)	//Hippie change, added this check for when the stranger is absent, we delete their seat and swap the controller to owner
			qdel(stranger_backseat)
			addtimer(CALLBACK(src, .proc/delete_seats), 1)
			initialized = FALSE
		if(!owner_backseat.client && !owner_active && initialized)	//Hippie change, added this check for when the owner is absent, we delete their seat and swap the controller to owner
			qdel(owner_backseat)
			addtimer(CALLBACK(src, .proc/delete_seats), 1)
			initialized = FALSE
		else if(prob(3) && initialized || !owner.client)	//Hippie add, added owner.client check so someone gets put in control as soon as a ghost comes in, when they come in, both ghosts do not have control
			switch_personalities()

/datum/brain_trauma/severe/split_personality/on_lose()
	if(current_controller != OWNER) //it would be funny to cure a guy only to be left with the other personality, but it seems too cruel
		switch_personalities()
	qdel(stranger_backseat)
	qdel(owner_backseat)
	..()

/datum/brain_trauma/severe/split_personality/proc/switch_personalities()
	if(QDELETED(owner) || owner.stat == DEAD || QDELETED(stranger_backseat) || QDELETED(owner_backseat))
		return

	var/mob/living/split_personality/current_backseat
	var/mob/living/split_personality/free_backseat
	if(current_controller == OWNER)
		current_backseat = stranger_backseat
		free_backseat = owner_backseat
		stranger_active = TRUE	//Hippie add
		owner_active = FALSE	//Hippie add
	else
		current_backseat = owner_backseat
		free_backseat = stranger_backseat
		stranger_active = FALSE	//Hippie add
		owner_active = TRUE		//Hippie add

	log_game("[key_name(current_backseat)] assumed control of [key_name(owner)] due to [src]. (Original owner: [current_controller == OWNER ? owner.ckey : current_backseat.ckey])")
	to_chat(owner, "<span class='userdanger'>You feel your control being taken away... your other personality is in charge now!</span>")
	to_chat(current_backseat, "<span class='userdanger'>You manage to take control of your body!</span>")

	//Body to backseat

	var/h2b_id = owner.computer_id
	var/h2b_ip= owner.lastKnownIP
	owner.computer_id = null
	owner.lastKnownIP = null

	free_backseat.ckey = owner.ckey

	free_backseat.name = owner.name

	if(owner.mind)
		free_backseat.mind = owner.mind

	if(!free_backseat.computer_id)
		free_backseat.computer_id = h2b_id

	if(!free_backseat.lastKnownIP)
		free_backseat.lastKnownIP = h2b_ip

	//Backseat to body

	var/s2h_id = current_backseat.computer_id
	var/s2h_ip= current_backseat.lastKnownIP
	current_backseat.computer_id = null
	current_backseat.lastKnownIP = null

	owner.ckey = current_backseat.ckey
	owner.mind = current_backseat.mind

	if(!owner.computer_id)
		owner.computer_id = s2h_id

	if(!owner.lastKnownIP)
		owner.lastKnownIP = s2h_ip

	current_controller = !current_controller

/mob/living/split_personality
	name = "split personality"
	real_name = "unknown conscience"
	var/mob/living/carbon/body
	var/datum/brain_trauma/severe/split_personality/trauma

/mob/living/split_personality/Initialize(mapload, _trauma)
	..()
	if(iscarbon(loc))
		body = loc
		name = body.real_name
		real_name = body.real_name
		trauma = _trauma

/mob/living/split_personality/Life()
	if(QDELETED(body))
		qdel(src) //in case trauma deletion doesn't already do it


	//Hippie change, removed body.stat check qdeleting the split personality because it still glitches otherwise

	//if one of the two ghosts, the other one stays permanently
	//Hippie change, removed the !body.client check as we're managing it up above

	..()

/mob/living/split_personality/Login()
	..()
	to_chat(src, "<span class='notice'>As a split personality, you cannot do anything but observe. However, you will eventually gain control of your body, switching places with the current personality.</span>")
	to_chat(src, "<span class='warning'><b>Do not commit suicide or put the body in a deadly position. Behave like you care about it as much as the owner.</b></span>")

/mob/living/split_personality/say(message)
	to_chat(src, "<span class='warning'>You cannot speak, your other self is controlling your body!</span>")
	return FALSE

/mob/living/split_personality/emote(message)
	return

///////////////BRAINWASHING////////////////////

/datum/brain_trauma/severe/split_personality/brainwashing
	name = "Split Personality"
	desc = "Patient's brain is split into two personalities, which randomly switch control of the body."
	scan_desc = "complete lobe separation"
	gain_text = ""
	lose_text = "<span class='notice'>You are free of your brainwashing.</span>"
	can_gain = FALSE
	var/codeword
	var/objective

/datum/brain_trauma/severe/split_personality/brainwashing/New(obj/item/organ/brain/B, _permanent, _codeword, _objective)
	..()
	if(_codeword)
		codeword = _codeword
	else
		codeword = pick(strings("ion_laws.json", "ionabstract")\
			| strings("ion_laws.json", "ionobjects")\
			| strings("ion_laws.json", "ionadjectives")\
			| strings("ion_laws.json", "ionthreats")\
			| strings("ion_laws.json", "ionfood")\
			| strings("ion_laws.json", "iondrinks"))

/datum/brain_trauma/severe/split_personality/brainwashing/on_gain()
	..()
	var/mob/living/split_personality/traitor/traitor_backseat = stranger_backseat
	traitor_backseat.codeword = codeword
	traitor_backseat.objective = objective

/datum/brain_trauma/severe/split_personality/brainwashing/make_backseats()
	stranger_backseat = new /mob/living/split_personality/traitor(owner, src, codeword, objective)
	owner_backseat = new(owner, src)

/datum/brain_trauma/severe/split_personality/brainwashing/get_ghost()
	set waitfor = FALSE
	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you want to play as [owner]'s brainwashed mind?", null, null, null, 75, stranger_backseat)
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		stranger_backseat.key = C.key
	else
		addtimer(CALLBACK(src, .proc/get_ghost), 600)	//Hippie change, removed qdel and replaced with a timer for get_ghost so you don't lose brainwashing if we cannot find a ghost

/datum/brain_trauma/severe/split_personality/brainwashing/on_life()
	return //no random switching

/datum/brain_trauma/severe/split_personality/brainwashing/on_hear(message, speaker, message_language, raw_message, radio_freq)
	if(owner.has_trait(TRAIT_DEAF) || owner == speaker)
		return message
	if(findtext(message, codeword))
		message = replacetext(message, codeword, "<span class='warning'>[codeword]</span>")
		addtimer(CALLBACK(src, /datum/brain_trauma/severe/split_personality.proc/switch_personalities), 10)
	return message

/datum/brain_trauma/severe/split_personality/brainwashing/on_say(message)
	if(findtext(message, codeword))
		return "" //oh hey did you want to tell people about the secret word to bring you back?
	return message

/mob/living/split_personality/traitor
	name = "split personality"
	real_name = "unknown conscience"
	var/objective
	var/codeword

/mob/living/split_personality/traitor/Login()
	..()
	to_chat(src, "<span class='notice'>As a brainwashed personality, you cannot do anything yet but observe. However, you may gain control of your body if you hear the special codeword, switching places with the current personality.</span>")
	to_chat(src, "<span class='notice'>Your activation codeword is: <b>[codeword]</b></span>")
	if(objective)
		to_chat(src, "<span class='notice'>Your master left you an objective: <b>[objective]</b>. Follow it at all costs when in control.</span>")

#undef OWNER
#undef STRANGER
