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
	name = "Shuttle Engineer"
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
	id = /obj/item/card/id/ert/Engineer

	backpack_contents = list(/obj/item/storage/box/engineer=1,\
		/obj/item/stack/sheet/metal/fifty=1,\
		/obj/item/stack/sheet/glass/fifty=1,\
		/obj/item/stack/sheet/mineral/gold/twenty=1,\
		/obj/item/stack/sheet/mineral/silver/twenty=1,\
		/obj/item/stack/sheet/mineral/plasma/twenty=1,\
		/obj/item/stack/sheet/mineral/uranium/twenty=1,\
		/obj/item/stack/sheet/mineral/bananium/twenty=1)

/obj/item/paper/pmc_contract // you know what's up
	name = "paper- 'ION PMC Contract'"
	info = "<B>ION, Incorporated, hereafter referred to as the COMPANY, and the CONTRACTOR agree to enter into a new formal arrangement commencing on the TWENTY-FIRST (21) Day of the SEVENTH (7) Month of the year TWO THOUSAND FIVE-HUNDRED AND FIFTY-NINE (2559), hereafter referred to as the OPERATION. <BR> The CONTRACTOR agrees that the rules of engagement hereafter referred to as the ROE (Expounded in detail in Annex II) fall under the remit of the UCMH. Furthermore, the OPERATION stipulates NO UNAUTHORIZED USE OF DEADLY FORCE unless fired upon. <BR> The COMPANY reserves the right to extend or narrow the scope of the UCMJ (Uniform Code of Military Justice) are to be detailed and countersigned in future addenda to this contract. <BR> Agile changes to the ROE are authorized under tactical COMPANY supervision. <BR> The CONTRACTOR agrees to the full liability of any and all deviations from the ROE within the OPERATION AOR nonwithstanding CLIENT or COMPANY contractual addenda. <BR> <BR> --ION <B>"

/obj/effect/mob_spawn/human/face/pmc
	name = "Merc Spawner"
	desc = "A sleeper designed to hold a soldier during transit."
	mob_name = "IoN Private Security"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	outfit = /datum/outfit/PMC
	roundstart = FALSE
	death = FALSE
	flavour_text = "<b>You're awake. You're a Mercanary, Hired by Space Station 13. Find out who hired you, and follow their orders. You are not an antagonist, so don't start shooting people for no reason. Follow your orders, no matter what."
	assignedrole = "ION PMC Member"

/obj/effect/mob_spawn/human/face/pmc/Initialize(mapload)
	. = ..()
	var/area/A = get_area(src)
	if(A)
		notify_ghosts("A Mercanary has been spawned!", source = src, action=NOTIFY_ATTACK, flashwindow = FALSE, ignore_key = POLL_IGNORE_ASHWALKER)

/datum/outfit/PMC
	name = "Ion Private Security"
	uniform = /obj/item/clothing/under/face/custom/pmc
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/headset_cent
	glasses = /obj/item/clothing/glasses/meson/night
	head = /obj/item/clothing/head/helmet/swat/face/custom/pmc
	belt = /obj/item/storage/belt/security/webbing
	suit = /obj/item/clothing/suit/armor/face/Ionpmc
	back = /obj/item/storage/backpack/satchel

	backpack_contents = list(/obj/item/storage/box/engineer=1,\
		/obj/item/stack/sheet/metal/fifty=1,\
		/obj/item/kitchen/knife/combat=1,\
		/obj/item/paper/pmc_contract=1,\
		/obj/item/gun/ballistic/automatic/pistol/m1911=1,\
		/obj/item/storage/firstaid/tactical=1)