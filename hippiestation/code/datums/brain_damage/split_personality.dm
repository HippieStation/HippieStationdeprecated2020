#define OWNER 0
#define STRANGER 1

/datum/brain_trauma/severe/split_personality
	var/owner_active = TRUE
	var/stranger_active = FALSE
	var/mute_message = FALSE

/datum/brain_trauma/severe/split_personality/get_ghost()
	set waitfor = FALSE
	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you want to play as [owner]'s split personality?", ROLE_PAI, null, null, 75, stranger_backseat)
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		stranger_backseat.key = C.key
		stranger_backseat.client = C.client
		stranger_active = TRUE
		owner_active = TRUE
		switch_personalities()
		log_game("[key_name(stranger_backseat)] became [key_name(owner)]'s split personality.")
		message_admins("[key_name_admin(stranger_backseat)] became [key_name_admin(owner)]'s split personality.")
		initialized = TRUE
	else
		addtimer(CALLBACK(src, .proc/get_ghost), 600)

/datum/brain_trauma/severe/split_personality/on_life()
	if(owner_backseat && stranger_backseat)
		if(!stranger_backseat.client && !stranger_active && initialized)
			addtimer(CALLBACK(src, .proc/get_ghost), 600)
			initialized = FALSE
		if(!owner_backseat.client && !owner_active && initialized)
			mute_message = TRUE
			owner_backseat = stranger_backseat
			to_chat(owner_backseat, "<span class='userdanger'>You feel your other personality is leaving... you have gained permanent control!</span>")
			qdel(src)
		else if(prob(3) && initialized || !owner.client)
			switch_personalities()

/datum/brain_trauma/severe/split_personality/on_lose()
	if(!owner_backseat.client && owner_active && initialized)
		switch_personalities()
	else if (current_controller == !OWNER)
		switch_personalities()
	QDEL_NULL(stranger_backseat)
	QDEL_NULL(owner_backseat)
	..()

/datum/brain_trauma/severe/split_personality/switch_personalities()
	if(QDELETED(owner) || owner.stat == DEAD || QDELETED(stranger_backseat) || QDELETED(owner_backseat))
		return

	var/mob/living/split_personality/current_backseat
	var/mob/living/split_personality/free_backseat
	if(current_controller == OWNER)
		current_backseat = stranger_backseat
		free_backseat = owner_backseat
		stranger_active = TRUE
		owner_active = FALSE
	else
		current_backseat = owner_backseat
		free_backseat = stranger_backseat
		stranger_active = FALSE
		owner_active = TRUE

	log_game("[key_name(current_backseat)] assumed control of [key_name(owner)] due to [src]. (Original owner: [current_controller == OWNER ? owner.ckey : current_backseat.ckey])")
	if(!mute_message)
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
	var/mute_login_message = FALSE

/mob/living/split_personality/Life()
	if(QDELETED(body))
		qdel(src) //in case trauma deletion doesn't already do it

/mob/living/split_personality/Login()
	..()
	if(!mute_login_message)	//This should only ever pop up once
		to_chat(src, "<span class='notice'>As a split personality, you cannot do anything but observe. However, you will eventually gain control of your body, switching places with the current personality.</span>")
		to_chat(src, "<span class='warning'><b>Do whatever you want but try not to get the body killed.</b></span>")
		mute_login_message = TRUE

/datum/brain_trauma/severe/split_personality/brainwashing/get_ghost()
	set waitfor = FALSE
	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you want to play as [owner]'s brainwashed mind?", null, null, null, 75, stranger_backseat)
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		stranger_backseat.key = C.key
		stranger_backseat.client = C.client
	else
		addtimer(CALLBACK(src, .proc/get_ghost), 600)

/datum/brain_trauma/severe/split_personality/brainwashing/on_say(message)
	if(findtext(message, codeword))
		return "la li lu le lo" //oh hey did you want to tell people about the secret word to bring you back?
	return message

#undef OWNER
#undef STRANGER