/obj/effect/mob_spawn/human/face/centcomengineer
	name = "shuttle engineer sleeper"
	desc = "A sleeper designed to hold a robust engineer to make a much more advanced shuttle."
	mob_name = "Shuttle Engineer"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	outfit = /datum/outfit/centcomshuttle
	roundstart = FALSE
	death = FALSE
	flavour_text = "<b>Welcome back to the land of the living. Or the awake. <span class='big bold'>You're a Central Command Engineer,</span> Your job is to modify the emergency shuttle to make it the best it can be. Or the worst, whatever.<span class='big bold'>It must be at least Air tight and livable. </span>  "
	assignedrole = "Central Command Shuttle Engineer"

/obj/effect/mob_spawn/human/face/centcomengineer/Initialize(mapload)
	. = ..()
	var/area/A = get_area(src)
	if(A)
		notify_ghosts("A Central Command Shuttle Engineer has been spawned!", source = src, action=NOTIFY_ATTACK, flashwindow = FALSE, ignore_key = POLL_IGNORE_ASHWALKER)

/datum/outfit/centcomshuttle
	uniform = /obj/item/clothing/under/rank/centcom_officer
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/headset_cent
	glasses = /obj/item/clothing/glasses/meson/night
	head = /obj/item/clothing/head/hardhat/weldhat/orange
	belt = /obj/item/storage/belt/utility/full
	suit = /obj/item/clothing/suit/hazardvest
	l_pocket = /obj/item/tank/internals/emergency_oxygen/engi
	back = /obj/item/storage/backpack/satchel
	r_pocket = /obj/item/pda/heads
	l_hand = /obj/item/construction/rcd/combat
	id = /obj/item/card/id

	backpack_contents = list(/obj/item/storage/box/engineer=1,\
		/obj/item/stack/sheet/metal/fifty=1,\
		/obj/item/stack/sheet/glass/fifty=1,\
		/obj/item/stack/sheet/mineral/gold/twenty=1,\
		/obj/item/stack/sheet/mineral/silver/twenty=1,\
		/obj/item/stack/sheet/mineral/plasma/twenty=1,\
		/obj/item/stack/sheet/mineral/uranium/twenty=1,\
		/obj/item/stack/sheet/mineral/bananium/twenty=1)
