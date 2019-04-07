/*TG Bad traits*/
/datum/quirk/blooddeficiency
	name = "Blood Deficiency"
	desc = "Your body can't produce enough blood to sustain itself."
	value = -2
	gain_text = "<span class='danger'>You feel your vigor slowly fading away.</span>"
	lose_text = "<span class='notice'>You feel vigorous again.</span>"
	medical_record_text = "Patient requires regular treatment for blood loss due to low production of blood."

/datum/quirk/blooddeficiency/on_process()
	var/mob/living/carbon/human/H = quirk_holder
	if(NOBLOOD in H.dna.species.species_traits) //can't lose blood if your species doesn't have any
		return
	else
		if (H.blood_volume > (BLOOD_VOLUME_SAFE - 25)) // just barely survivable without treatment
			H.blood_volume -= 0.275

/datum/quirk/blindness
	name = "Blind"
	desc = "You are completely blind, nothing can counteract this."
	value = -4
	gain_text = "<span class='danger'>You can't see anything.</span>"
	lose_text = "<span class='notice'>You miraculously gain back your vision.</span>"
	medical_record_text = "Subject has permanent blindness."

/datum/quirk/blindness/add()
	quirk_holder.become_blind(ROUNDSTART_TRAIT)

/datum/quirk/blindness/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/clothing/glasses/blindfold/white/B = new(get_turf(H))
	if(!H.equip_to_slot_if_possible(B, SLOT_GLASSES, bypass_equip_delay_self = TRUE)) //if you can't put it on the user's eyes, put it in their hands, otherwise put it on their eyes
		H.put_in_hands(B)
	H.regenerate_icons()

/datum/quirk/brainproblems
	name = "Brain Tumor"
	desc = "You have a little friend in your brain that is slowly destroying it. Better bring some mannitol!"
	value = -3
	gain_text = "<span class='danger'>You feel smooth.</span>"
	lose_text = "<span class='notice'>You feel wrinkled again.</span>"
	medical_record_text = "Patient has a tumor in their brain that is slowly driving them to brain death."

/datum/quirk/brainproblems/on_process()
	quirk_holder.adjustBrainLoss(0.2)

/datum/quirk/deafness
	name = "Deaf"
	desc = "You are incurably deaf."
	value = -2
	mob_trait = TRAIT_DEAF
	gain_text = "<span class='danger'>You can't hear anything.</span>"
	lose_text = "<span class='notice'>You're able to hear again!</span>"
	medical_record_text = "Subject's cochlear nerve is incurably damaged."

/datum/quirk/heavy_sleeper
	name = "Heavy Sleeper"
	desc = "You sleep like a rock! Whenever you're put to sleep or knocked unconscious, you take a little bit longer to wake up."
	value = -1
	mob_trait = TRAIT_HEAVY_SLEEPER
	gain_text = "<span class='danger'>You feel sleepy.</span>"
	lose_text = "<span class='notice'>You feel awake again.</span>"
	medical_record_text = "Patient has abnormal sleep study results and is difficult to wake up."

/datum/quirk/nearsighted //t. errorage
	name = "Nearsighted"
	desc = "You are nearsighted without prescription glasses, but spawn with a pair."
	value = -1
	gain_text = "<span class='danger'>Things far away from you start looking blurry.</span>"
	lose_text = "<span class='notice'>You start seeing faraway things normally again.</span>"
	medical_record_text = "Patient requires prescription glasses in order to counteract nearsightedness."

/datum/quirk/nearsighted/add()
	quirk_holder.become_nearsighted(ROUNDSTART_TRAIT)

/datum/quirk/nearsighted/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/clothing/glasses/regular/glasses = new(get_turf(H))
	H.put_in_hands(glasses)
	H.equip_to_slot(glasses, SLOT_GLASSES)
	H.regenerate_icons() //this is to remove the inhand icon, which persists even if it's not in their hands

/datum/quirk/nonviolent
	name = "Pacifist"
	desc = "The thought of violence makes you sick. So much so, in fact, that you can't hurt anyone."
	value = -2
	mob_trait = TRAIT_PACIFISM
	gain_text = "<span class='danger'>You feel repulsed by the thought of violence!</span>"
	lose_text = "<span class='notice'>You think you can defend yourself again.</span>"
	medical_record_text = "Patient is unusually pacifistic and cannot bring themselves to cause physical harm."

/datum/quirk/paraplegic
	name = "Paraplegic"
	desc = "Your legs do not function. Nothing will ever fix this. But hey, free wheelchair!"
	value = -3
	human_only = TRUE
	gain_text = null // Handled by trauma.
	lose_text = null
	medical_record_text = "Patient has an untreatable impairment in motor function in the lower extremities."

/datum/quirk/paraplegic/add()
	var/datum/brain_trauma/severe/paralysis/paraplegic/T = new()
	var/mob/living/carbon/human/H = quirk_holder
	H.gain_trauma(T, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/paraplegic/on_spawn()
	if(quirk_holder.buckled) // Handle late joins being buckled to arrival shuttle chairs.
		quirk_holder.buckled.unbuckle_mob(quirk_holder)

	var/turf/T = get_turf(quirk_holder)
	var/obj/structure/chair/spawn_chair = locate() in T

	var/obj/vehicle/ridden/wheelchair/wheels = new(T)
	if(spawn_chair) // Makes spawning on the arrivals shuttle more consistent looking
		wheels.setDir(spawn_chair.dir)

	wheels.buckle_mob(quirk_holder)

	// During the spawning process, they may have dropped what they were holding, due to the paralysis
	// So put the things back in their hands.

	for(var/obj/item/I in T)
		if(I.fingerprintslast == quirk_holder.ckey)
			quirk_holder.put_in_hands(I)

/datum/quirk/poor_aim
	name = "Poor Aim"
	desc = "You're terrible with guns and can't line up a straight shot to save your life. Dual-wielding is right out."
	value = -1
	mob_trait = TRAIT_POOR_AIM
	medical_record_text = "Patient possesses a strong tremor in both hands."

/datum/quirk/prosopagnosia
	name = "Prosopagnosia"
	desc = "You have a mental disorder that prevents you from being able to recognize faces at all."
	value = -1
	mob_trait = TRAIT_PROSOPAGNOSIA
	medical_record_text = "Patient suffers from prosopagnosia and cannot recognize faces."

/datum/quirk/prosthetic_limb
	name = "Prosthetic Limb"
	desc = "An accident caused you to lose one of your limbs. Because of this, you now have a random prosthetic!"
	value = -1
	var/slot_string = "limb"

/datum/quirk/prosthetic_limb/on_spawn()
	var/limb_slot = pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/bodypart/old_part = H.get_bodypart(limb_slot)
	var/obj/item/bodypart/prosthetic
	switch(limb_slot)
		if(BODY_ZONE_L_ARM)
			prosthetic = new/obj/item/bodypart/l_arm/robot/surplus(quirk_holder)
			slot_string = "left arm"
		if(BODY_ZONE_R_ARM)
			prosthetic = new/obj/item/bodypart/r_arm/robot/surplus(quirk_holder)
			slot_string = "right arm"
		if(BODY_ZONE_L_LEG)
			prosthetic = new/obj/item/bodypart/l_leg/robot/surplus(quirk_holder)
			slot_string = "left leg"
		if(BODY_ZONE_R_LEG)
			prosthetic = new/obj/item/bodypart/r_leg/robot/surplus(quirk_holder)
			slot_string = "right leg"
	prosthetic.replace_limb(H)
	qdel(old_part)
	H.regenerate_icons()

/datum/quirk/prosthetic_limb/post_add()
	to_chat(quirk_holder, "<span class='boldannounce'>Your [slot_string] has been replaced with a surplus prosthetic. It is fragile and will easily come apart under duress. Additionally, \
	you need to use a welding tool and cables to repair it, instead of bruise packs and ointment.</span>")

/datum/quirk/insanity
	name = "Reality Dissociation Syndrome"
	desc = "You suffer from a severe disorder that causes very vivid hallucinations. Mindbreaker toxin can suppress its effects, and you are immune to mindbreaker's hallucinogenic properties. <b>This is not a license to grief.</b>"
	value = -2
	//no mob trait because it's handled uniquely
	gain_text = "<span class='userdanger'>...</span>"
	lose_text = "<span class='notice'>You feel in tune with the world again.</span>"
	medical_record_text = "Patient suffers from acute Reality Dissociation Syndrome and experiences vivid hallucinations."

/datum/quirk/insanity/on_process()
	if(quirk_holder.reagents.has_reagent("mindbreaker"))
		quirk_holder.hallucination = 0
		return
	if(prob(2)) //we'll all be mad soon enough
		madness()

/datum/quirk/insanity/proc/madness()
	quirk_holder.hallucination += rand(10, 25)

/datum/quirk/insanity/post_add() //I don't /think/ we'll need this but for newbies who think "roleplay as insane" = "license to kill" it's probably a good thing to have
	if(!quirk_holder.mind || quirk_holder.mind.special_role)
		return
	to_chat(quirk_holder, "<span class='big bold info'>Please note that your dissociation syndrome does NOT give you the right to attack people or otherwise cause any interference to \
	the round. You are not an antagonist, and the rules will treat you the same as other crewmembers.</span>")

/datum/quirk/obstructive
	name = "Physically Obstructive"
	desc = "You somehow manage to always be in the way. You can't swap places with other people."
	value = -1
	mob_trait = TRAIT_NOMOBSWAP
	gain_text = "<span class='danger'>You feel like you're in the way.</span>"
	lose_text = "<span class='notice'>You feel less like you're in the way.</span>"

/datum/quirk/junkie
	name = "Junkie"
	desc = "You can't get enough of hard drugs."
	value = -2
	gain_text = "<span class='danger'>You suddenly feel the craving for drugs.</span>"
	lose_text = "<span class='notice'>You feel like you should kick your drug habit.</span>"
	medical_record_text = "Patient has a history of hard drugs."
	var/drug_list = list("crank", "krokodil", "morphine", "happiness", "methamphetamine") //List of possible IDs
	var/reagent_id //ID picked from list
	var/datum/reagent/reagent_type //If this is defined, reagent_id will be unused and the defined reagent type will be instead.
	var/datum/reagent/reagent_instance
	var/where_drug
	var/obj/item/drug_container_type //If this is defined before pill generation, pill generation will be skipped. This is the type of the pill bottle.
	var/obj/item/drug_instance
	var/where_accessory
	var/obj/item/accessory_type //If this is null, it won't be spawned.
	var/obj/item/accessory_instance
	var/tick_counter = 0

/datum/quirk/junkie/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	reagent_id = pick(drug_list)
	if (!reagent_type)
		var/datum/reagent/prot_holder = GLOB.chemical_reagents_list[reagent_id]
		reagent_type = prot_holder.type
	reagent_instance = new reagent_type()
	H.reagents.addiction_list.Add(reagent_instance)
	var/current_turf = get_turf(quirk_holder)
	if (!drug_container_type)
		drug_container_type = /obj/item/storage/pill_bottle
	drug_instance = new drug_container_type(current_turf)
	if (istype(drug_instance, /obj/item/storage/pill_bottle))
		var/pill_state = "pill[rand(1,20)]"
		for(var/i in 1 to 7)
			var/obj/item/reagent_containers/pill/P = new(drug_instance)
			P.icon_state = pill_state
			P.reagents.add_reagent(reagent_id, 1)

	if (accessory_type)
		accessory_instance = new accessory_type(current_turf)
	var/list/slots = list(
		"in your left pocket" = SLOT_L_STORE,
		"in your right pocket" = SLOT_R_STORE,
		"in your backpack" = SLOT_IN_BACKPACK
	)
	where_drug = H.equip_in_one_of_slots(drug_instance, slots, FALSE) || "at your feet"
	if (accessory_instance)
		where_accessory = H.equip_in_one_of_slots(accessory_instance, slots, FALSE) || "at your feet"
	announce_drugs()

/datum/quirk/junkie/post_add()
	if(where_drug == "in your backpack" || where_accessory == "in your backpack")
		var/mob/living/carbon/human/H = quirk_holder
		SEND_SIGNAL(H.back, COMSIG_TRY_STORAGE_SHOW, H)

/datum/quirk/junkie/proc/announce_drugs()
	to_chat(quirk_holder, "<span class='boldnotice'>There is a [drug_instance.name] of [reagent_instance.name] [where_drug]. Better hope you don't run out...</span>")

/datum/quirk/junkie/on_process()
	var/mob/living/carbon/human/H = quirk_holder
	if (tick_counter == 60) //Halfassed optimization, increase this if there's slowdown due to this quirk
		var/in_list = FALSE
		for (var/datum/reagent/entry in H.reagents.addiction_list)
			if(istype(entry, reagent_type))
				in_list = TRUE
				break
		if(!in_list)
			H.reagents.addiction_list += reagent_instance
			reagent_instance.addiction_stage = 0
			to_chat(quirk_holder, "<span class='danger'>You thought you kicked it, but you suddenly feel like you need [reagent_instance.name] again...")
		tick_counter = 0
	else
		++tick_counter

/datum/quirk/junkie/smoker
	name = "Smoker"
	desc = "Sometimes you just really want a smoke. Probably not great for your lungs."
	value = -1
	gain_text = "<span class='danger'>You could really go for a smoke right about now.</span>"
	lose_text = "<span class='notice'>You feel like you should quit smoking.</span>"
	medical_record_text = "Patient is a current smoker."
	reagent_type = /datum/reagent/drug/nicotine
	accessory_type = /obj/item/lighter/greyscale
	var/cigarette_name

/datum/quirk/junkie/smoker/on_spawn()
	drug_container_type = pick(/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/fancy/cigarettes/cigpack_midori,
		/obj/item/storage/fancy/cigarettes/cigpack_uplift,
		/obj/item/storage/fancy/cigarettes/cigpack_robust,
		/obj/item/storage/fancy/cigarettes/cigpack_robustgold,
		/obj/item/storage/fancy/cigarettes/cigpack_carp,
		/obj/item/storage/fancy/cigarettes/cigars,
		/obj/item/storage/fancy/cigarettes/cigars/cohiba,
		/obj/item/storage/fancy/cigarettes/cigars/havana)
	if(istype(drug_container_type, /obj/item/storage/fancy/cigarettes/cigars))
		cigarette_name = "cigar"
	else
		cigarette_name = "cigarette"
	. = ..()

/datum/quirk/junkie/smoker/announce_drugs()
	to_chat(quirk_holder, "<span class='boldnotice'>There is a [drug_instance.name] [where_drug], and a lighter [where_accessory]. Make sure you don't run out of them!</span>")

/datum/quirk/junkie/smoker/on_process()
	. = ..()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/I = H.get_item_by_slot(SLOT_WEAR_MASK)
	if (istype(I, /obj/item/clothing/mask/cigarette))
		var/obj/item/storage/fancy/cigarettes/C = drug_instance
		if(istype(I, C.spawn_type) && prob(1))
			to_chat(quirk_holder, "<span class='notice'>You feel great smoking your usual brand of [cigarette_name]")
		else if(prob(1))
			to_chat(quirk_holder, "<span class='warning'>You'd prefer if you were smoking your usual brand of [cigarette_name]")

/datum/quirk/family_heirloom	//Custom edition :)
	name = "Family Heirloom"
	desc = "You are the current owner of an heirloom, passed down for generations. You have to keep it safe!"
	value = -1
	var/obj/item/heirloom
	var/where
	var/time_without_heirloom = 0
	var/goingtodie = FALSE	//lol

/datum/quirk/family_heirloom/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/heirloom_type

	if(is_species(H, /datum/species/moth) && prob(50))
		heirloom_type = /obj/item/flashlight/lantern/heirloom_moth
	else
		switch(quirk_holder.mind.assigned_role)
			//Service jobs
			if("Clown")
				heirloom_type = /obj/item/bikehorn/golden
			if("Mime")
				heirloom_type = /obj/item/reagent_containers/food/snacks/baguette
			if("Janitor")
				heirloom_type = pick(/obj/item/mop, /obj/item/caution, /obj/item/reagent_containers/glass/bucket)
			if("Cook")
				heirloom_type = pick(/obj/item/reagent_containers/food/condiment/saltshaker, /obj/item/kitchen/rollingpin, /obj/item/clothing/head/chefhat)
			if("Botanist")
				heirloom_type = pick(/obj/item/cultivator, /obj/item/reagent_containers/glass/bucket, /obj/item/storage/bag/plants)
			if("Bartender")
				heirloom_type = pick(/obj/item/reagent_containers/glass/rag, /obj/item/clothing/head/that, /obj/item/reagent_containers/food/drinks/shaker)
			if("Curator")
				heirloom_type = pick(/obj/item/pen/fountain, /obj/item/storage/pill_bottle/dice)
			if("Assistant")
				heirloom_type = /obj/item/storage/toolbox/mechanical/old/heirloom
			//Security/Command
			if("Captain")
				heirloom_type = /obj/item/reagent_containers/food/drinks/flask/gold
			if("Head of Security")
				heirloom_type = /obj/item/book/manual/wiki/security_space_law
			if("Warden")
				heirloom_type = /obj/item/book/manual/wiki/security_space_law
			if("Security Officer")
				heirloom_type = pick(/obj/item/book/manual/wiki/security_space_law, /obj/item/clothing/head/beret/sec)
			if("Detective")
				heirloom_type = /obj/item/reagent_containers/food/drinks/bottle/whiskey
			if("Lawyer")
				heirloom_type = pick(/obj/item/gavelhammer, /obj/item/book/manual/wiki/security_space_law)
			//RnD
			if("Research Director")
				heirloom_type = /obj/item/toy/plush/slimeplushie
			if("Scientist")
				heirloom_type = /obj/item/toy/plush/slimeplushie
			if("Roboticist")
				heirloom_type = pick(subtypesof(/obj/item/toy/prize)) //look at this nerd
			//Medical
			if("Chief Medical Officer")
				heirloom_type = pick(/obj/item/clothing/neck/stethoscope, /obj/item/bodybag)
			if("Medical Doctor")
				heirloom_type = pick(/obj/item/clothing/neck/stethoscope, /obj/item/bodybag)
			if("Chemist")
				heirloom_type = /obj/item/book/manual/wiki/chemistry
			if("Virologist")
				heirloom_type = /obj/item/reagent_containers/syringe
			//Engineering
			if("Chief Engineer")
				heirloom_type = pick(/obj/item/clothing/head/hardhat/white, /obj/item/screwdriver, /obj/item/wrench, /obj/item/weldingtool, /obj/item/crowbar, /obj/item/wirecutters)
			if("Station Engineer")
				heirloom_type = pick(/obj/item/clothing/head/hardhat, /obj/item/screwdriver, /obj/item/wrench, /obj/item/weldingtool, /obj/item/crowbar, /obj/item/wirecutters)
			if("Atmospheric Technician")
				heirloom_type = pick(/obj/item/lighter, /obj/item/lighter/greyscale, /obj/item/storage/box/matches)
			//Supply
			if("Quartermaster")
				heirloom_type = pick(/obj/item/stamp, /obj/item/stamp/denied)
			if("Cargo Technician")
				heirloom_type = /obj/item/clipboard
			if("Shaft Miner")
				heirloom_type = pick(/obj/item/pickaxe/mini, /obj/item/shovel)

	if(!heirloom_type)
		heirloom_type = pick(
		/obj/item/toy/cards/deck,
		/obj/item/lighter,
		/obj/item/dice/d20)
	heirloom = new heirloom_type(get_turf(quirk_holder))
	var/list/slots = list(
		"in your left pocket" = SLOT_L_STORE,
		"in your right pocket" = SLOT_R_STORE,
		"in your backpack" = SLOT_IN_BACKPACK
	)
	where = H.equip_in_one_of_slots(heirloom, slots, FALSE) || "at your feet"

/datum/quirk/family_heirloom/post_add()
	if(where == "in your backpack")
		var/mob/living/carbon/human/H = quirk_holder
		SEND_SIGNAL(H.back, COMSIG_TRY_STORAGE_SHOW, H)

	to_chat(quirk_holder, "<span class='boldnotice'>There is a precious family [heirloom.name] [where], passed down from generation to generation. Keep it safe!</span>")

	var/list/names = splittext(quirk_holder.real_name, " ")
	var/family_name = names[names.len]

	heirloom.AddComponent(/datum/component/heirloom, quirk_holder.mind, family_name)

/datum/quirk/family_heirloom/on_process()
	var/mob/living/carbon/human/H = quirk_holder
	if(H.stat != DEAD)
		if(H.stat == CONSCIOUS)	//Can't feel much if you're passed out
			if(heirloom in quirk_holder.GetAllContents())
				switch(time_without_heirloom)
					if(0)
						if(prob(0.5))
							to_chat(H, "<span class='notice'>You feel safe, knowing that your family heirloom is with you.</span>")
							time_without_heirloom = 0
					if(1 to 2)
						to_chat(H, "<span class='notice'>You're relieved you found your heirloom, and calm down.</span>")
						time_without_heirloom = 0
					if(3)
						to_chat(H, "<span class='notice'>You finally found your heirloom again. What a relief.</span>")
						time_without_heirloom = 0
					if(4)
						to_chat(H, "<span class='notice'>After so long desperately, frantically searching around for it, you finally found your heirloom again. You let out a sigh of relief. This is going to take a while to recover from.</span>")
						time_without_heirloom = 0
			else
				switch(time_without_heirloom)
					if(0)
						if(prob(5))
							to_chat(H, "<span class='warning'>You realise you've lost your heirloom. You need to get it back!</span>")
							time_without_heirloom += 1
					if(1)
						if(prob(2))
							to_chat(H, "<span class='warning'>You've been a while without your heirloom... you're starting to feel uneasy without it!</span>")
							quirk_holder.Jitter(5)
							time_without_heirloom += 1
					if(2)
						if(prob(10))
							to_chat(H, "<span class='warning'>You feel uneasy without your heirloom...</span>")
							quirk_holder.Jitter(5)
						if(prob(1))
							to_chat(H, "<span class='warning'>You're starting to feel really bad! You <font size='3'><b>NEED</b></font> to get your heirloom back!!</span>")
							quirk_holder.Jitter(10)
							if(H.getOxyLoss() < 40)
								quirk_holder.emote("scream")
							time_without_heirloom += 1
					if(3)
						if(prob(20))
							H.Jitter(5)
						if(prob(10))
							if(H.getOxyLoss() < 40)
								H.emote("cough")
						if(prob(5))
							H.Dizzy(20)
						if(prob(1))
							to_chat(H, "<span class='warning'><font size='3'>YOU NEED YOUR HEIRLOOM BACK NOW!!!</font></span>")
							time_without_heirloom += 1
					if(4)	//Now we're really getting fucked up
						H.Jitter(10)
						H.hallucination = 5
						if(prob(10))
							H.adjustStaminaLoss(5)
							if(H.getOxyLoss() < 40)
								H.emote("cough")
						if(prob(10))
							H.vomit(5)
						if(prob(10))
							to_chat(H, "<span class='warning'><font size='2'>Your heart violently pumps in your chest as you desperately search for your heirloom!</font></span>")
							H.AdjustKnockdown(10)
							H.adjustBrainLoss(5)
							H.Dizzy(20)
							if(H.getOxyLoss() < 40)
								H.emote("scream")
						if(prob(10))
							H.adjustStaminaLoss(5)
							H.AdjustKnockdown(10)
							to_chat(H, "<span class='warning'>You fall over in your panic to find your heirloom!</span>")
						if(prob(5))
							to_chat(H, "<span class='warning'>You can't feel yourself breathing!</span>")
							if(H.getOxyLoss() < 40)
								H.losebreath++
								H.emote("gasp")
						if(prob(0.5) && !goingtodie)
							switch(pick(1,2))
								if(1)
									to_chat(H, "<span class='warning'><font size='3'>Your heart is starting to pound even harder... even faster... you need that heirloom now! You need it now!!</font></span>")
									goingtodie = TRUE
									addtimer(CALLBACK(src, .proc/make_heartattack), 300)	//You best find that thing soon kid
								if(2)
									to_chat(H, "<span class='warning'><font size='3'>You're starting to feel really, really sick from the panic! You need that heirloom now!</font></span>")
									goingtodie = TRUE
									addtimer(CALLBACK(src, .proc/throwup_organ), 300)	//You best find that thing soon kid
	else
		time_without_heirloom = 0	//Give them a chance, if they revive afterwards

/datum/quirk/family_heirloom/clone_data()
	return heirloom

/datum/quirk/family_heirloom/on_clone(data)
	heirloom = data

/datum/quirk/family_heirloom/proc/make_heartattack()	//You're fucked m8
	var/mob/living/carbon/human/H = quirk_holder
	if(time_without_heirloom > 0)
		to_chat(H, "<span class='warning'><font size='3'><b>You can't take it, it's too much! Your heart keeps pounding and it's not stopping, it's not st-</b></font></span>")
		H.set_heartattack(TRUE)
	goingtodie = FALSE

/datum/quirk/family_heirloom/proc/throwup_organ()	//You're fucked m8: version 2
	var/mob/living/carbon/human/H = quirk_holder
	if(time_without_heirloom > 0)
		to_chat(H, "<span class='warning'><font size='3'><b>Your insides are violently churning around... you can't hold it in any longer!</b></font></span>")
		H.vomit(5, 1, 5)
		H.spew_organ(5, 2)
	goingtodie = FALSE

/* Hippie Bad traits */
/datum/quirk/flatulence
	name = "Involuntary flatulence"
	desc = "A spasm in the patient's sphincter will cause them to uncontrollably fart at random intervals."
	value = -1
	gain_text = "<span class='danger'>Your butt starts to twitch!</span>"
	lose_text = "<span class='notice'>Your butt settles down.</span>"
	medical_record_text = "Patient has a muscular spasm in their rectal sphincter, gaseous discharge may occour."

/datum/quirk/flatulence/on_process()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		if(prob(3))
			var/obj/item/organ/butt/B = quirk_holder.getorgan(/obj/item/organ/butt)
			if(!B)
				to_chat(quirk_holder, "<span class='warning'>The building pressure in your colon hurts!</span>")
				quirk_holder.adjustBruteLoss(rand(2,6))
			else if(prob(1))
				quirk_holder.emote("superfart")
			else
				quirk_holder.emote("fart")


/datum/quirk/smallbutt
	name = "Small anal cavity"
	desc = "Muscular contractions cause the patient's anal cavity to be undersized."
	value = -1
	gain_text = "<span class='danger'>Your butt tenses up!</span>"
	lose_text = "<span class='notice'>Your butt muscles relax.</span>"
	medical_record_text = "Tension in the patient's butt muscles has caused their anal cavity to become small."

/datum/quirk/smallbutt/add()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		var/obj/item/organ/butt/B = quirk_holder.getorgan(/obj/item/organ/butt)
		if(!B)
			to_chat(quirk_holder, "<span class='warning'>You somehow gained this trait without a butt, contact an admin.</span>")
			qdel(src)
			return

		GET_COMPONENT_FROM(STR, /datum/component/storage, B)
		if(STR.max_items > 0)
			STR.max_items = STR.max_items - 1
		else
			to_chat(quirk_holder, "<span class='warning'>Dat booty can't get any smaller!</span>")
			qdel(src)

/datum/quirk/smallbutt/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		var/obj/item/organ/butt/B = quirk_holder.getorgan(/obj/item/organ/butt)
		if(!B)
			return

		GET_COMPONENT_FROM(STR, /datum/component/storage, B)
		STR.max_items = STR.max_items + 1


