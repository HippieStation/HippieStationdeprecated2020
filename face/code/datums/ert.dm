/datum/outfit/ert/commander/krieg
	name = "Death Korps of Krieg"
	uniform = /obj/item/clothing/under/color/black
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/headset_cent
	glasses = /obj/item/clothing/glasses/sunglasses
	head = /obj/item/clothing/head/face/custom/krieg
	belt = /obj/item/storage/belt/security/webbing
	suit = /obj/item/clothing/suit/face/custom/krieg
	mask = /obj/item/clothing/mask/gas
	l_pocket = /obj/item/tank/internals/emergency_oxygen/engi
	back = /obj/item/storage/backpack/satchel
	r_pocket = /obj/item/pda/heads
	l_hand = /obj/item/gun/energy/laser/retro/face/custom/lasgun
	id = /obj/item/card/id/ert

	backpack_contents = list(/obj/item/storage/box/engineer=1,\
		/obj/item/storage/firstaid/advanced=1,\
		/obj/item/grenade/plastic/c4=1)

/datum/outfit/ert/debt
	name = "Debt Collector"
	uniform = /obj/item/clothing/under/face/custom/debt
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/headset_cent
	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/storage/belt/utility/full
	suit = /obj/item/clothing/suit/hazardvest
	l_pocket = /obj/item/tank/internals/emergency_oxygen/engi
	back = /obj/item/storage/backpack/holding
	r_pocket = /obj/item/pda/heads
	id = /obj/item/card/id/ert

	backpack_contents = list(/obj/item/storage/box/survival_mining=1,\
		/obj/item/bodybag/bluespace=3)

/datum/antagonist/ert/commander/krieg
	outfit = /datum/outfit/ert/commander/krieg
	role = "Guardsman"

/datum/antagonist/ert/debt
	outfit = /datum/outfit/ert/debt
	role = "Debt Collector"


/datum/ert/deathkorp
	leader_role = /datum/antagonist/ert/commander/krieg
	roles = list(/datum/antagonist/ert/commander/krieg)
	code = "Blue"
	mission = "Eliminate all xenobiological threats to the station."
	polldesc = "an Nanotrasen Anti-Xeno Korps team"

/datum/ert/debtcollector
	leader_role = /datum/antagonist/ert.debt
	roles = list(/datum/antagonist/ert/debt)
	code = "Blue"
	mission = "Steal EVERYTHING. ONLY attack the crew in self defense or you may be banned!"
	polldesc = "an debt collector team"
