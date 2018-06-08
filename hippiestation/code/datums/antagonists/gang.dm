// Gang Boss

/datum/antagonist/gangboss
	name = "Gang Boss"
	roundend_category = "gang"
	var/give_objectives = TRUE
	var/hud_version = "gangboss"
	var/datum/objective_team/gang/gang_team // Handles the gangsters
	var/outfit_type = /datum/outfit/gangboss

/datum/outfit/gangboss // INCOMPLETE
	name = "Gang Boss"
	l_pocket = /obj/item/pen/edagger
	r_pocket = /obj/item/toy/crayon/spraycan/lubecan
	backpack_contents = list(/obj/item/door_remote/omni,\
		/obj/item/clothing/glasses/hud/security/chameleon/)

/datum/antagonist/gangboss/on_gain()
/*	register()
	if(give_objectives)
		create_objectives() */
	equip_boss()
	greet()
/*
/datum/antagonist/gangboss/proc/register()
	SSticker.mode.gangs |= owner

/datum/antagonist/gangboss/proc/unregister()
	SSticker.mode.gangs -= src

/datum/objective_team/gang
	name = "gang"


/datum/antagonist/gangboss/proc/create_gang_team()
	gang_team = new(owner)
	gang_team.name = "[owner.current.real_name] team"
	update_gang_icons_added(owner.current) */

/*
/datum/antagonist/gangboss/proc/create_objectives()
	switch(rand(1,100))
		if(1 to 30)
			var/datum/objective/assassinate/kill_objective = new
			kill_objective.owner = owner
			kill_objective.find_target()
			objectives += kill_objective

			if (!(locate(/datum/objective/escape) in owner.objectives))
				var/datum/objective/escape/escape_objective = new
				escape_objective.owner = owner
				objectives += escape_objective

		if(31 to 60)
			var/datum/objective/steal/steal_objective = new
			steal_objective.owner = owner
			steal_objective.find_target()
			objectives += steal_objective

			if (!(locate(/datum/objective/escape) in owner.objectives))
				var/datum/objective/escape/escape_objective = new
				escape_objective.owner = owner
				objectives += escape_objective

		if(61 to 85)
			var/datum/objective/assassinate/kill_objective = new
			kill_objective.owner = owner
			kill_objective.find_target()
			objectives += kill_objective

			var/datum/objective/steal/steal_objective = new
			steal_objective.owner = owner
			steal_objective.find_target()
			objectives += steal_objective

			if (!(locate(/datum/objective/survive) in owner.objectives))
				var/datum/objective/survive/survive_objective = new
				survive_objective.owner = owner
				objectives += survive_objective

		else
			if (!(locate(/datum/objective/hijack) in owner.objectives))
				var/datum/objective/hijack/hijack_objective = new
				hijack_objective.owner = owner
				objectives += hijack_objective

	for(var/datum/objective/O in objectives)
		owner.objectives += O
*/
/*
/datum/antagonist/gangboss/on_removal()
	unregister()
	return ..() */

/datum/antagonist/gangboss/proc/equip_boss()
	if(!owner)
		return
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return
	if(H.mind)
		if(H.mind.assigned_role == "Clown")
			to_chat(H, "Your training has allowed you to overcome your clownish nature, allowing you to wield weapons without harming yourself.")
			H.dna.remove_mutation(CLOWNMUT)

/datum/antagonist/gangboss/greet()
	to_chat(owner, "<span class='boldannounce'>You are the Gang Boss!</span>")
	to_chat(owner, "<B>dis incomplete lul</B>")
	to_chat(owner, "As the Gang Boss, you can also promote your gang members to <b>Lieutenant</b>. Unlike regular gangsters, Lieutenants cannot be deconverted and are able to use recruitment pens and gangtools.")
	to_chat(owner, "The <b>Gangtool</b> in your backpack will allow you to purchase weapons and equipment, send messages to your gang, and recall the emergency shuttle from anywhere on the station.")
	to_chat(owner, "The <b>Recruitment Pen</b> in your left pocket will help you get your gang started. Stab unsuspecting crew members with it to recruit them. It won't work on loyalty implanted crew.")
	to_chat(owner,"The <b>Chameleon Security HUD</b> in your backpack will help you keep track of who is loyalty-implanted, and unable to be recruited.")
	to_chat(owner,"The <b>Territory Spraycan</b> in your right pocket can be used to claim areas of the station for your gang. The more territory your gang controls, the more influence you get. All gangsters can use these, so distribute them to grow your influence faster.")

/datum/antagonist/gangboss/farewell()
	to_chat(owner, "<span class='userdanger'>You have been brainwashed! You are no longer a Gang Boss!</span>")

/datum/antagonist/gangboss/gangster
	name = "Gangster"
	hud_version = "gangster"
	outfit_type = null

/datum/antagonist/gangboss/gangster/greet()
	to_chat(owner, "<B>ur a ganggie good job</b>.")
/*	owner.announce_objectives()

/datum/antagonist/wizard/apprentice/register()
	SSticker.mode.apprentices |= src

/datum/antagonist/wizard/apprentice/unregister()
	SSticker.mode.apprentices -= src

/datum/antagonist/wizard/apprentice/equip_wizard()
	. = ..()
	if(!owner)
		return
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return
	switch(school)
		if(APPRENTICE_DESTRUCTION)
			owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/projectile/magic_missile(null))
			owner.AddSpell(new /obj/effect/proc_holder/spell/aimed/fireball(null))
			to_chat(owner, "<B>Your service has not gone unrewarded, however. Studying under [master.current.real_name], you have learned powerful, destructive spells. You are able to cast magic missile and fireball.")
		if(APPRENTICE_BLUESPACE)
			owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/area_teleport/teleport(null))
			owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/ethereal_jaunt(null))
			to_chat(owner, "<B>Your service has not gone unrewarded, however. Studying under [master.current.real_name], you have learned reality bending mobility spells. You are able to cast teleport and ethereal jaunt.")
		if(APPRENTICE_HEALING)
			owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/charge(null))
			owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/forcewall(null))
			H.put_in_hands(new /obj/item/gun/magic/staff/healing(H))
			to_chat(owner, "<B>Your service has not gone unrewarded, however. Studying under [master.current.real_name], you have learned livesaving survival spells. You are able to cast charge and forcewall.")
		if(APPRENTICE_HEALING)
			owner.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/knock(null))
			owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/mind_transfer(null))
			to_chat(owner, "<B>Your service has not gone unrewarded, however. Studying under [master.current.real_name], you have learned stealthy, robeless spells. You are able to cast knock and mindswap.")

/datum/antagonist/wizard/apprentice/create_objectives()
	var/datum/objective/protect/new_objective = new /datum/objective/protect
	new_objective.owner = owner
	new_objective.target = master
	new_objective.explanation_text = "Protect [master.current.real_name], the wizard."
	owner.objectives += new_objective
	objectives += new_objective

//Random event wizard
/datum/antagonist/wizard/apprentice/imposter
	name = "Wizard Imposter"
	allow_rename = FALSE

/datum/antagonist/wizard/apprentice/imposter/greet()
	to_chat(owner, "<B>You are an imposter! Trick and confuse the crew to misdirect malice from your handsome original!</B>")
	owner.announce_objectives()

/datum/antagonist/wizard/apprentice/imposter/equip_wizard()
	var/mob/living/carbon/human/master_mob = master.current
	var/mob/living/carbon/human/H = owner.current
	if(!istype(master_mob) || !istype(H))
		return
	if(master_mob.ears)
		H.equip_to_slot_or_del(new master_mob.ears.type, slot_ears)
	if(master_mob.w_uniform)
		H.equip_to_slot_or_del(new master_mob.w_uniform.type, slot_w_uniform)
	if(master_mob.shoes)
		H.equip_to_slot_or_del(new master_mob.shoes.type, slot_shoes)
	if(master_mob.wear_suit)
		H.equip_to_slot_or_del(new master_mob.wear_suit.type, slot_wear_suit)
	if(master_mob.head)
		H.equip_to_slot_or_del(new master_mob.head.type, slot_head)
	if(master_mob.back)
		H.equip_to_slot_or_del(new master_mob.back.type, slot_back)

	//Operation: Fuck off and scare people
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/area_teleport/teleport(null))
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/turf_teleport/blink(null))
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/ethereal_jaunt(null))

/datum/antagonist/wizard/proc/update_wiz_icons_added(mob/living/wiz)
	var/datum/atom_hud/antag/wizhud = GLOB.huds[ANTAG_HUD_WIZ]
	wizhud.join_hud(wiz)
	set_antag_hud(wiz, hud_version)

/datum/antagonist/wizard/proc/update_wiz_icons_removed(mob/living/wiz)
	var/datum/atom_hud/antag/wizhud = GLOB.huds[ANTAG_HUD_WIZ]
	wizhud.leave_hud(wiz)
	set_antag_hud(wiz, null)


/datum/antagonist/wizard/academy
	name = "Academy Teacher"
	outfit_type = /datum/outfit/wizard/academy

/datum/antagonist/wizard/academy/equip_wizard()
	. = ..()

	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/ethereal_jaunt)
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/projectile/magic_missile)
	owner.AddSpell(new /obj/effect/proc_holder/spell/aimed/fireball)

	var/mob/living/M = owner.current
	if(!istype(M))
		return

	var/obj/item/implant/exile/Implant = new/obj/item/implant/exile(M)
	Implant.implant(M)

/datum/antagonist/wizard/academy/create_objectives()
	var/datum/objective/new_objective = new("Protect Wizard Academy from the intruders")
	new_objective.owner = owner
	owner.objectives += new_objective
	objectives += new_objective */