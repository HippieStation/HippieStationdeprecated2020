//lightning effect definition moved to hippie module path is hippie/object/effects/holy.dm

/client/proc/cmd_smite(mob/living/M in mob_list)
	set category = "Fun"
	set name = "Smite"
	if(!holder || !check_rights(R_FUN))
		return

	if(!isliving(M))
		usr << "This can only be used on instances of type /mob/living"
		return

	var/options = list("Brute","Burn","Toxin","Oxygen","Clone","Brain","Stamina","Heal","Gib","Cancel")
	var/requiresdam = options - list("Heal","Gib","Cancel")

	var/confirm = null
	var/damtype_word = null
	var/dam = 0

	var/holylighteffect = FALSE

	var/datum/callback/smitecall = null

	confirm = input(src, "Really smite [M.name]([M.ckey])?", "Divine Retribution") in list("Yeah", "Nah")
	if(confirm == "Nah")
		return

	damtype_word = input(src, "What kind of damage?", "PUT YOUR FAITH IN THE LIGHT") in options

	if(damtype_word in requiresdam)
		dam = input(src, "How much damage?", "THE LIGHT SHALL BURN YOU") as num
		if(!dam)
			return

	if(damtype_word == "Cancel")
		return

	var/obj/effect/holy/lightning/L = new /obj/effect/holy/lightning()
	L.start(M)

	switch(damtype_word)
		if("Brute")
			smitecall = new(M, /mob/living/proc/adjustBruteLoss, dam)
		if("Burn")
			smitecall = new(M, /mob/living/proc/adjustFireLoss, dam)
		if("Toxin")
			smitecall = new(M, /mob/living/proc/adjustToxLoss, dam)
		if("Oxygen")
			smitecall = new(M, /mob/living/proc/adjustOxyLoss, dam)
		if("Clone")
			smitecall = new(M, /mob/living/proc/adjustCloneLoss, dam)
		if("Brain")
			smitecall = new(M, /mob/living/proc/adjustBrainLoss, dam)
		if("Stamina")
			smitecall = new(M, /mob/living/proc/adjustStaminaLoss, dam)
		if("Heal")
			holylighteffect = TRUE
			smitecall = new(M, /mob/living/proc/revive, TRUE, TRUE)
		if("Gib")
			smitecall = new(M, /mob/living/gib)

	if(holylighteffect)
		var/obj/effect/holy/HL = new /obj/effect/holy()
		addtimer(CALLBACK(HL, /obj/effect/holy/proc/start, M), 5)
	addtimer(smitecall, 5)

	if(damtype_word in requiresdam)
		log_admin("[src]([src.ckey]) smote [M] ([M.ckey]) with [damtype_word] for [dam] damage.")
		message_admins("[src]([src.ckey]) smote [M] ([M.ckey]) with [damtype_word] for [dam] damage.")
	else
		log_admin("[src]([src.ckey]) smote [M] ([M.ckey]) with [damtype_word].")
		message_admins("[src]([src.ckey]) smote [M] ([M.ckey]) with [damtype_word].")