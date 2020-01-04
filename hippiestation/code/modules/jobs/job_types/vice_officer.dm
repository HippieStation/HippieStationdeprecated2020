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

	glasses = /obj/item/clothing/glasses/sunglasses
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
