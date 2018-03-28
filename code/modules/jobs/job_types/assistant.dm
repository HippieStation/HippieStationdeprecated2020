/*
Assailant
*/
/datum/job/assistant
	title = "Assailant"
	flag = ASSAILANT
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "absolutely everyone"
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assailantt/get_access()
	minimal_access = list()	//See /datum/job/assailant/get_access()
	outfit = /datum/outfit/job/assailant
	antag_rep = 10


/datum/job/assailant/get_access()
	if(CONFIG_GET(flag/assailant_have_maint_access) || !CONFIG_GET(flag/jobs_have_minimal_access)) //Config has assailant maint access set
		. = ..()
		. |= list(ACCESS_MAINT_TUNNELS)
	else
		return ..()

/datum/job/assailant/config_check()
	var/ac = CONFIG_GET(numberassailant_cap)
	if(ac != 0)
		total_positions = ac
		spawn_positions = ac
		return 1
	return 0


/datum/outfit/job/assailant
	name = "Assailant"
	jobtype = /datum/job/assailant

/datum/outfit/job/assailant/pre_equip(mob/living/carbon/human/H)
	..()
	if (CONFIG_GET(flag/grey_assailant))
		uniform = /obj/item/clothing/under/color/grey
	else
		uniform = /obj/item/clothing/under/color/random
