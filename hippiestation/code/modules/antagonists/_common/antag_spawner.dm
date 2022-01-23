/obj/item/antag_spawner/nuke_ops/spawn_antag(client/C, turf/T, kind, datum/mind/user)
	var/mob/living/carbon/human/M = new/mob/living/carbon/human(T)
	C.prefs.copy_to(M)
	M.key = C.key

	var/datum/antagonist/nukeop/new_op = new()
	new_op.send_to_spawnpoint = FALSE
	new_op.nukeop_outfit = /datum/outfit/syndicate/no_crystals

	var/datum/antagonist/nukeop/creator_op = user.has_antag_datum(/datum/antagonist/nukeop,TRUE)
	if(creator_op)
		M.mind.add_antag_datum(new_op,creator_op.nuke_team)
		M.mind.special_role = "Nuclear Operative"
	INVOKE_ASYNC(src, .proc/choose_kit, M)

/obj/item/antag_spawner/nuke_ops/proc/choose_kit(mob/living/carbon/human/H)
	var/choice = null
	while(!choice)
		choice = input(H, "Choose your kit", "Choose your kit") as anything in list("C-20r bundle", "Bulldog bundle", "Bioterror bundle", "Sniper bundle", "Spetsnaz Pyro bundle", "Stealth bundle", "ALLAH ACKBAR")
		if(!choice)
			continue
		switch(choice)
			if("C-20r bundle")
				H.put_in_hands(new /obj/item/storage/backpack/duffelbag/syndie/c20rbundle(H.drop_location()))
			if("Bulldog bundle")
				H.put_in_hands(new /obj/item/storage/backpack/duffelbag/syndie/bulldogbundle(H.drop_location()))
			if("Bioterror bundle")
				H.put_in_hands(new /obj/item/storage/backpack/duffelbag/syndie/med/bioterrorbundle(H.drop_location()))
			if("Sniper bundle")
				H.put_in_hands(new /obj/item/storage/briefcase/sniperbundle(H.drop_location()))
			if("Spetsnaz Pyro bundle")
				H.put_in_hands(new /obj/item/storage/backpack/duffelbag/syndie/firestarter(H.drop_location()))
			if("Stealth bundle")
				H.put_in_hands(new /obj/item/storage/briefcase/stealthbundle(H.drop_location()))
			if("ALLAH ACKBAR")
				var/obj/item/implant/explosive/macro/macrobomb = new(H)
				macrobomb.implant(H, H, TRUE, TRUE)

/obj/item/storage/briefcase/stealthbundle
	force = 15

/obj/item/storage/briefcase/stealthbundle/PopulateContents()
	new /obj/item/card/emag(src)
	new /obj/item/pen/sleepy(src)
	if(prob(50))
		new /obj/item/gun/energy/kinetic_accelerator/crossbow(src)
		new /obj/item/pen/edagger(src)
	else
		new /obj/item/storage/box/syndie_kit/chemical(src)
		new /obj/item/gun/chem(src)
