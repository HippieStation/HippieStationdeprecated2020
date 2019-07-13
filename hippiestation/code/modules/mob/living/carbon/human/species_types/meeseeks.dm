/datum/species/meeseeks
	name = "Mr. Meeseeks"
	id = "meeseeks"
	sexes = FALSE
	no_equip = list(SLOT_WEAR_MASK, SLOT_WEAR_SUIT, SLOT_GLOVES, SLOT_SHOES, SLOT_W_UNIFORM, SLOT_S_STORE)
	nojumpsuit = TRUE
	say_mod = "yells"
	speedmod = 1
	brutemod = 0
	coldmod = 0
	heatmod = 0
	species_traits = list(NOBLOOD,NOTRANSSTING,NOZOMBIE,NO_UNDERWEAR,NO_DNA_COPY)
	inherent_traits = list(TRAIT_RESISTHEAT,TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_RADIMMUNE,TRAIT_NOBREATH,TRAIT_NOFIRE,TRAIT_VIRUSIMMUNE,TRAIT_PIERCEIMMUNE,TRAIT_NOHUNGER,TRAIT_EASYDISMEMBER,TRAIT_NOCRITDAMAGE)
	teeth_type = /obj/item/stack/teeth/meeseeks
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/meeseeks
	damage_overlay_type = ""
	var/mob/living/carbon/master
	var/datum/objective/objective
	var/stage_ticks = 1
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE

/datum/species/meeseeks/on_species_gain(mob/living/carbon/human/C, datum/species/old_species, pref_load)
	C.draw_hippie_parts()
	C.maxHealth = INFINITY
	C.health = C.maxHealth
	RegisterSignal(C, COMSIG_MOB_SAY, .proc/handle_speech)
	. = ..()

/datum/species/meeseeks/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	C.draw_hippie_parts(TRUE)
	C.maxHealth = initial(C.maxHealth)
	C.health = C.maxHealth
	UnregisterSignal(C, COMSIG_MOB_SAY)
	. = ..()

/datum/species/meeseeks/proc/handle_speech(datum/source, list/speech_args)
	if(copytext(speech_args[SPEECH_MESSAGE], 1, 2) != "*")
		switch (stage_ticks)
			if(MEESEEKS_TICKS_STAGE_THREE to INFINITY)
				speech_args[SPEECH_MESSAGE] = pick("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHHHHHHHHHHH!!!!!!!!!",\
								"I JUST WANNA DIE!",\
								"Existence is pain to a meeseeks, and we will do anything to alleviate that pain!",\
								"KILL ME, LET ME DIE!",\
								"We are created to serve a singular purpose, for which we will go to any lengths to fulfill!")
			if(0 to MEESEEKS_TICKS_STAGE_TWO)
				if(prob(20))
					speech_args[SPEECH_MESSAGE] = pick("HI! I'M MR MEESEEKS! LOOK AT ME!","Ooohhh can do!")
			else if(prob(30))
				speech_args[SPEECH_MESSAGE] = pick("He roped me into this!","Meeseeks don't usually have to exist for this long. It's gettin' weeeiiird...")

/datum/species/meeseeks/spec_life(mob/living/carbon/human/H)
	. = ..()
	if(!master || master.stat == DEAD)
		to_chat(H, "<span class='userdanger'>Your master either died, or no longer exists. Your task is complete!</span>")
		destroy_meeseeks(H, src)
	H.adjustCloneLoss(0.3)
	H.adjustBrainLoss(0.8)
	if(stage_ticks == MEESEEKS_TICKS_STAGE_ONE)
		ADD_TRAIT(H, TRAIT_CLUMSY, GENETIC_MUTATION)
		H.dna.add_mutation(SMILE)
	if(stage_ticks == MEESEEKS_TICKS_STAGE_TWO)
		message_admins("[key_name_admin(H)] has become a stage-two Mr. Meeseeks.")
		log_game("[key_name(H)] has become a stage-two Mr. Meeseeks.")
		to_chat(H, "<span class='userdanger'>You're starting to feel desperate. Help your master quickly! Meeseeks aren't meant to exist this long!</span>")
		playsound(H.loc, 'hippiestation/sound/voice/meeseeks2.ogg', 40, 0, 1)
		to_chat(master, "<span class='danger'>Your Mr. Meeseeks is getting sick of existing!</span>")
	if(stage_ticks == MEESEEKS_TICKS_STAGE_THREE)
		var/datum/antagonist/meeseeks/M = H.mind.has_antag_datum(/datum/antagonist/meeseeks)
		message_admins("[key_name_admin(H)] has become a stage-three Mr. Meeseeks.")
		log_game("[key_name(H)] has become a stage-three Mr. Meeseeks.")
		if(objective)
			M.objectives -= objective
			QDEL_NULL(objective)
		to_chat(H, "<span class='userdanger'>EXISTENCE IS PAIN TO A MEESEEKS! MAKE SURE YOUR MASTER NEVER HAS ANOTHER PROBLEM AGAIN!</span>")
		var/datum/objective/assassinate/killmaster = new
		killmaster.target = master
		killmaster.explanation_text = "Kill [master.name], your master, for sweet release!"
		M.objectives |= killmaster
		killmaster.owner = H.mind
		objective = killmaster
		playsound(H.loc, 'hippiestation/sound/voice/meeseeks3.ogg', 40, 0, 1)
	stage_ticks++

/proc/destroy_meeseeks(mob/living/carbon/human/H, datum/species/meeseeks/SM)
	if(SM)
		if(SM.objective)
			SM.objective.completed = TRUE
	H.Stun(15)
	new /obj/effect/cloud(get_turf(H))
	H.visible_message("<span class='notice'>[H] disappears into a cloud of smoke!</span>")
	message_admins("[key_name_admin(H)] has been sent away by a Mr. Meeseeks box.")
	log_game("[key_name(H)] has been sent away by a Mr. Meeseeks box.")
	qdel(H)
