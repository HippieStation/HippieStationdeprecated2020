/datum/job/viceofficer
	title = "Vice Officer"
	flag = VICEOFFICER
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list("Head of Security")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of security"
	selection_color = "#ffeeee"
	minimal_player_age = 7
	var/tubbs = FALSE
	var/uniform_style = 0
	var/suit_style = 0

	outfit = /datum/outfit/job/vice_officer

	access = list(ACCESS_SECURITY, ACCESS_BRIG, ACCESS_MAINT_TUNNELS, ACCESS_WEAPONS, ACCESS_KITCHEN, ACCESS_BAR, ACCESS_HYDROPONICS, ACCESS_FORENSICS_LOCKERS, ACCESS_MECH_SECURITY, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_SECURITY, ACCESS_BRIG, ACCESS_MAINT_TUNNELS, ACCESS_WEAPONS, ACCESS_KITCHEN, ACCESS_BAR, ACCESS_HYDROPONICS)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_SEC
	mind_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_VICE_OFFICER

/datum/outfit/job/vice_officer
	name = "Vice Officer"
	jobtype = /datum/job/viceofficer

	glasses = /obj/item/clothing/glasses/hippie/miami
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/headset_sec
	suit = /obj/item/clothing/suit/hippie/viceofficer
	uniform = /obj/item/clothing/under/rank/viceofficer
	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/viceofficer
	r_pocket = /obj/item/assembly/flash/handheld
	suit_store = /obj/item/gun/energy/disabler
	backpack_contents = list(/obj/item/restraints/handcuffs/cable/zipties=1)

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	box = /obj/item/storage/box/security

	implants = list(/obj/item/implant/mindshield)


/datum/outfit/job/vice_officer/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return

	var/datum/job/viceofficer/J = SSjob.GetJobType(jobtype)

	if (!J.uniform_style)
		J.uniform_style = pick(1,2,3)
		J.suit_style = pick(1,2)

	if(!J.tubbs)//Crocket
		glasses = /obj/item/clothing/glasses/hippie/miami

		switch (J.uniform_style)
			if (1)
				uniform = /obj/item/clothing/under/rank/viceofficer/crocket1
			if (2)
				uniform = /obj/item/clothing/under/rank/viceofficer/crocket2
			if (3)
				uniform = /obj/item/clothing/under/rank/viceofficer/crocket3

		switch (J.suit_style)
			if (1)
				suit = /obj/item/clothing/suit/hippie/viceofficer/crocket1
			if (2)
				suit = /obj/item/clothing/suit/hippie/viceofficer/crocket2

	else//Tubbs
		l_pocket = /obj/item/clothing/accessory/pendant
		glasses = /obj/item/clothing/glasses/sunglasses

		switch (J.uniform_style)
			if (1)
				uniform = /obj/item/clothing/under/rank/viceofficer/tubbs1
			if (2)
				uniform = /obj/item/clothing/under/rank/viceofficer/tubbs2
			if (3)
				uniform = /obj/item/clothing/under/rank/viceofficer/tubbs3

		switch (J.suit_style)
			if (1)
				suit = /obj/item/clothing/suit/toggle/hippie/viceofficer/tubbs1
			if (2)
				suit = /obj/item/clothing/suit/hippie/viceofficer/tubbs2

	J.tubbs = !J.tubbs//switching for the next one=
