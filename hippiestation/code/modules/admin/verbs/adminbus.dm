/client/proc/blow_fueltanks()
	set category = "Fun"
	set name = "Blowup fuel tanks"
	set desc = "Causes all fuel tanks on the map to explode"
	var/question = input("Are you sure you want to do this? This can potentially crash the server and probably won't work well...", "Input") in list("Yes", "No")
	if(question == "No")
		return FALSE

	if(!check_rights(R_FUN))
		return
	for(var/i in GLOB.fuel_tanks)
		var/obj/structure/reagent_dispensers/fueltank/FT = i
		if(FT.z == mob.z)
			FT.boom()
	log_admin("[key_name(usr)] exploded [GLOB.fuel_tanks.len] fuel tanks.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "SH")

