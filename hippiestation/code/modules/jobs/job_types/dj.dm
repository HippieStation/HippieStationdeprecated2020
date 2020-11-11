/datum/job/discjockey //Named discjockey instead of DJ because DJ in the obj path causes errors.
	title = "DJ"
	flag = DJ
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"

	outfit = /datum/outfit/job/discjockey

	access = list(ACCESS_DJ)
	minimal_access = list(ACCESS_DJ)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_CIV

	display_order = JOB_DISPLAY_ORDER_DJ

/datum/outfit/job/discjockey
	name = "DJ"
	jobtype = /datum/job/discjockey

	shoes = /obj/item/clothing/shoes/funk
	belt = /obj/item/pda/discjockey
	ears = /obj/item/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/hippie/telvis
	l_pocket = /obj/item/megaphone
	backpack_contents = list(
			/obj/item/storage/box/glowsticks,
			/obj/item/storage/box/laserpointers
	)
