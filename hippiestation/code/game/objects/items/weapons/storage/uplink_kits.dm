/obj/item/weapon/storage/box/syndie_kit/hockey
	name = "\improper Ka-Nada Boxed S.S.F Hockey Set"
	desc = "The iconic extreme environment gear used by Ka-Nada special sport forces.\
	Used to devastating effect during the great northern sports wars of the second great athletic republic.\
	The unmistakeable grey and red gear provides great protection from most if not all environmental hazards\
	and combat threats in addition to coming with the signature weapon of the Ka-Nada SSF and all terrain Hyper-Blades\
	for enhanced mobility and lethality in melee combat. This power comes at a cost as your Ka-Nada benefactors expect\
	absolute devotion to the cause, once equipped you will be unable to remove the gear so be sure to make it count."

/obj/item/weapon/storage/box/syndie_kit/hockey/New()
	..()
	new /obj/item/weapon/hockeypack(src)
	new /obj/item/weapon/storage/belt/hippie/hockey(src)
	new /obj/item/clothing/suit/hippie/hockey(src)
	new /obj/item/clothing/shoes/hippie/hockey(src)
	new /obj/item/clothing/mask/hippie/hockey(src)
	new /obj/item/clothing/head/hippie/hockey(src)

/obj/item/weapon/storage/box/syndie_kit/bowling
	name = "\improper Right-Up-Your-Alley bowling kit"
	desc = "Bowling is definitely a real sport. Anyone who says otherwise is stupid.\
			Suit up with the latest in bowling fashion, and prepare to show off your skills.\
			Syndicate nanobots embedded in the bowling uniform will make you a real Mister 300,\
			with no training required."

/obj/item/weapon/storage/box/syndie_kit/bowling/New()
	..()
	new /obj/item/clothing/shoes/hippie/bowling(src)
	new /obj/item/clothing/under/hippie/bowling(src)
	new /obj/item/weapon/bowling(src)
	new /obj/item/weapon/bowling(src)
	new /obj/item/weapon/bowling(src)

/obj/item/weapon/storage/box/syndie_kit/wrestling
	name = "\improper Squared-Circle smackdown set"
	desc = "For millenia, man has dreamed of wrestling. In 1980, it was invented by the great Macho\
	Man Randy Savage. Although he is no longer with us, you can live on in his name with the latest in\
	wrestling technology. Corkscrew your enemies and smash them into a pulp with your newfound wrestling skills,\
	which you will obtain from this set. Now with a complimentary space-wrestling gear!"

/obj/item/weapon/storage/box/syndie_kit/wrestling/New()
	..()
	new /obj/item/clothing/mask/hippie/wrestling(src)
	new /obj/item/clothing/glasses/hippie/wrestling(src)
	new /obj/item/clothing/under/hippie/wrestling(src)
	new /obj/item/weapon/storage/belt/champion/wrestling(src)