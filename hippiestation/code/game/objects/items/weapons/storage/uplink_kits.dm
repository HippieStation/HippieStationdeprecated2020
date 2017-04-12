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
	new /obj/item/weapon/storage/belt/hockey(src)
	new /obj/item/clothing/suit/armor/hockey(src)
	new /obj/item/clothing/shoes/hockey(src)
	new /obj/item/clothing/mask/gas/hockey(src)
	new /obj/item/clothing/head/helmet/hockey(src)

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
	new /obj/item/weapon/twohanded/bowling(src)
	new /obj/item/weapon/twohanded/bowling(src)
	new /obj/item/weapon/twohanded/bowling(src)
	var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(src)
	P.info = "<B><center>The Art of the Bowl</center></B>:<BR>Bowling is a centuries old craft, one long-forgotten by most. Because of this, very few posses the ability to bowl correctly. This is why your bowling uniform has
			been imbued with the latest in nanobot technology. This will help you bowl correctly without any proper training. To bowl, first make sure you are wearing your uniform.
			Then, equip a bowling ball as if you would a chainsaw or other two-handed weapon. When you throw the bowling ball, it will barrel down the hallway and knock down anybody
			in its path. Make sure not to walk into your own bowling ball!"
	P.name = "The Art of the Bowl"

/obj/item/weapon/storage/box/syndie_kit/wrestling
	name = "\improper Squared-Circle smackdown set"
	desc = "For millenia, man has dreamed of wrestling. In 1980, it was invented by the great Macho\
	Man Randy Savage. Although he is no longer with us, you can live on in his name with the latest in\
	wrestling technology. Corkscrew your enemies and smash them into a pulp with your newfound wrestling skills,\
	which you will obtain from this set. Now with a complimentary space-unitard and space-wrestling helmet!"

/obj/item/weapon/storage/box/syndie_kit/wrestling/New()
	..()
	new /obj/item/clothing/mask/gas/wrestling(src)
	new /obj/item/clothing/glasses/wrestling(src)
	new /obj/item/clothing/under/wrestling(src)
	new /obj/item/weapon/storage/belt/champion/wrestling(src)