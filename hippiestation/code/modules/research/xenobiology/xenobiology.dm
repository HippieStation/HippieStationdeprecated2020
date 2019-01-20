/obj/effect/golemrune/human
	name = "human rune"
	desc = "a strange rune used to create humans. It glows when spirits are nearby."

/obj/effect/golemrune/human/attack_hand(mob/living/user)
	var/mob/dead/observer/ghost
	for(var/mob/dead/observer/O in src.loc)
		if(!O.client)
			continue
		if(O.mind && O.mind.current && O.mind.current.stat != DEAD)
			continue
		if (O.orbiting)
			continue
		ghost = O
		break
	if(!ghost)
		to_chat(user, "<span class='warning'>The rune fizzles uselessly! There is no spirit nearby.</span>")
		return
	var/mob/living/carbon/human/G = new /mob/living/carbon/human
	G.forceMove(src.loc)
	G.key = ghost.key
	to_chat(G, "You are a human spawned by adminbus.")
	log_game("[key_name(G)] was made a human via humanrune by [key_name(user)].")
	log_admin("[key_name(G)] was made a human via humanrune by [key_name(user)].")
	qdel(src)

/obj/item/slimepotion/slime/docility/attack(mob/living/carbon/alien/target, mob/user)//HIPPIECODE, TAMING XENOS
	if(!isalien(target)) // in this will only proc if it's an alien
		return ..()
	if(!target.mind) // in case the alien doesn't have minds
		to_chat(user, "<span class='notice'>This xeno seems dumb as balls.</span>")
		return ..()
	var/datum/objective/protect/protect_objective
	to_chat(user, "<span class='notice'>hold still while you feed the potion.</span>") //warns about the taming process starting
	if(do_after(user,50, target)) //5 second timer, both would have to stay still, meaning unless the xeno is willing or stunned this shit wont fly
		to_chat(target,"<span class='notice'>You feel a surge of loyalty towards [user].</span>")
		to_chat(target,"<span class='userdanger'> You MUST obey any command given to you by your master (that doesn't violate any rules). Unless your master specifically tells you so, You are not to act like an antag while bonded.</span>")
		to_chat(target,"<span class='danger'>You CANNOT harm your master. Check your memory (with the notes verb) if you forget who your master is.</span>")
		if(!target.mind.special_role) //adds the mindslave antag, since it's basically mindslaved
			target.mind.special_role = "Mindslave"
			SSticker.mode.traitors |= target.mind
		protect_objective = new /datum/objective/protect
		protect_objective.owner = target.mind
		protect_objective.target = user.mind
		protect_objective.explanation_text = "Protect [user], your Master. Obey any command given by them, do not do anything that would harm then, and do not kill others as that could give him problems (unless told to)."
		var/datum/antagonist/mindslave/M = target.mind.add_antag_datum(/datum/antagonist/mindslave) 
		M.master_name = user.real_name
		M.master_ckey = user.ckey
		M.objectives |= protect_objective
		message_admins("[user]/([user.ckey]) made a Docilified a xeno, [target]/([target.ckey]).") //warns admins
		to_chat(target,"<span class='warning'>You absorb the potion and feel the need to serve and protect user.real_name.</span>")
		to_chat(user, "<span class='notice'>You feed the Xeno the potion, calming it down and befriending it.</span>")
		var/newname = copytext(sanitize(input(user, "Would you like to give the Xeno a name?", "Name your new pet", "pet Xeno") as null|text),1,MAX_NAME_LEN)
		if (!newname) //name the xeno cause lol
			newname = "pet xeno"
		target.name = newname
		target.real_name = newname
		qdel(src) //the potion is spent
