/obj/item/clothing/suit/face/custom/kazcoat
	name = "Commander Coat"
	desc = "Smells like hamburgers."
	icon_state = "kazcoat"
	item_state = "kazcoat"

/obj/item/clothing/suit/space/hardsuit/face/custom/ultramarine
	name = "Ultramarine Suit"
	desc = "The death of others is a small price to pay, as they fall, performing their duties in order to achieve glory for the interest of the best Ultramarine Captain - which of course is I, Cato Sicarius!"
	icon_state = "ultramarinesuit"
	item_state = "ultramarinesuit"
	w_class = WEIGHT_CLASS_NORMAL
	slowdown = 1
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 20)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/face/custom/ultramarine

/obj/item/clothing/suit/face/custom/paladinsuit
	name = "Paladin Armor"
	desc = "Now to be a white knight and shitpost on tumblr!"
	icon_state = "Paladinarmor"
	item_state = "Paladinarmor"
	slowdown = 3
	armor = list(melee = 80, bullet = 20, laser = 00, energy = -10, bomb = 5, bio = 0, rad = -20)

/obj/item/clothing/suit/face/custom/vg/russofurcoat
	name = "Russian fur coat"
	desc = "Let the land do the fighting for you."
	icon_state = "russofurcoat"
	body_parts_covered = ARMS|LEGS|CHEST


/obj/item/clothing/suit/space/hardsuit/face/custom/vg/soviet
	name = "Soviet hardsuit"
	desc = "Crafted with the pride of the proletariat. The last thing the enemy sees is the bottom of this armor's boot."
	icon_state = "rig-soviet"
	item_state = "rig-soviet"
	w_class = WEIGHT_CLASS_NORMAL
	slowdown = 1
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 20)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/face/custom/vg/soviet


/obj/item/clothing/under/face/custom/vg/sneaksuit
	name = "Sneaking suit"
	desc = "It's made of a strong material developed by the Soviet Union centuries ago which provides robust protection."
	icon_state = "sneakingsuit"
	item_state = "sneakingsuit"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0, fire = 30, acid = 30)
	strip_delay = 50
	alt_covers_chest = 1
	sensor_mode = 3
	random_sensor = 0


/obj/item/clothing/suit/toggle/jacket/face/custom/jojinam_medals
	name = "old military jacket"
	desc = "An old but well maintained military jacket with lots of army ribbons."
	icon_state = "joji01"
	item_state = "joji01"
	togglename = "buttons"


/obj/item/clothing/suit/toggle/jacket/face/custom/jojinam
	name = "old military jacket"
	desc = "An old but well maintained military jacket."
	icon_state = "joji02"
	item_state = "joji02"
	togglename = "buttons"


/obj/item/clothing/suit/toggle/jacket/face/custom/jojinamnew
	name = "vintage military jacket"
	desc = "A well worn military jacket made of Cotton. The essential accessory of any crazy veteran or creepy homeless man."
	icon_state = "jojinew01"
	item_state = "jojinew01"
	togglename = "buttons"

/obj/item/clothing/suit/toggle/jacket/face/custom/jojinamnew/cavalry
	name = "60's army jacket"
	desc = "An ancient U.S. Army field jacket with a 1st Cavalry patch, issued in the Vietnam War in the 1960's. This thing smells and looks old."
	icon_state = "jojinew02"
	item_state = "jojinew02"

/obj/item/clothing/suit/face/custom/krieg
	name = "NT Korp Armor"
	desc = "This station just got about 70% more grimdark."
	icon_state = "krieguniform"
	item_state = "krieguniform"
	armor = list(melee = 40, bullet = 55, laser = 66,energy = 40, bomb = 30, bio = 40, rad = 80, fire = 30, acid = 80)