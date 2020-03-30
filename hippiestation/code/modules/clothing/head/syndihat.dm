// Shitty fluff items

/obj/item/clothing/glasses/monocle/syndie
	name = "syndicate monocle"
	alternate_worn_icon = 'hippiestation/icons/mob/syndihat.dmi'
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	item_flags = ABSTRACT | DROPDEL

/obj/item/clothing/glasses/monocle/syndie/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/obj/item/clothing/mask/fakemoustache/italian/syndie
	name = "moustache"
	desc = "It's an all-natural moustache."
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	flags_1 = MASKINTERNALS
	item_flags = ABSTRACT | DROPDEL
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE

/obj/item/clothing/mask/fakemoustache/italian/syndie/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/obj/item/clothing/under/lawyer/red/syndie
	name = "syndicate suit"
	desc = "Quite professional."
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	item_flags = ABSTRACT | DROPDEL

/obj/item/clothing/under/lawyer/red/syndie/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/obj/item/clothing/shoes/laceup/syndie
	name = "shined syndicate shoes"
	desc = "Made almost entirely out of gondolas."
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	item_flags = ABSTRACT | DROPDEL

/obj/item/clothing/shoes/laceup/syndie/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

// The hat its self

/obj/item/clothing/head/syndie_tophat
	name = "syndicate paper hat"
	desc = "For showing that you're a complete tool."
	icon = 'hippiestation/icons/obj/clothing/syndihat.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/syndihat.dmi'
	icon_state = "xmashat"
	item_state = "that"
	worn_x_dimension = 32
	worn_y_dimension = 32
	dynamic_hair_suffix = ""
	can_stack = FALSE
	equip_delay_other = 140
	strip_delay = 1800 // If you're willing to wait this fuckin long just for a hat, fine.
	flags_inv = HIDEHAIR|HIDEFACIALHAIR
	var/hat_desc
	var/telecrystals = 0 // how much the item originally costs
	var/been_equipped = FALSE
	var/tc_update_icon = FALSE
	var/mutable_appearance/evil_overlay
	var/get_stache = FALSE
	var/get_suit = FALSE
	var/get_glasses = FALSE
	var/get_glow = FALSE

/obj/item/clothing/head/syndie_tophat/Initialize()
	. = ..()
	evil_overlay = mutable_appearance('hippiestation/icons/mob/syndihat.dmi', "evilaura", -MUTATIONS_LAYER)
	evil_overlay.color = "#ff0130" // thanks for the syndie stone code, steamp0rt

/obj/item/clothing/head/syndie_tophat/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stack/telecrystal) && !been_equipped)
		var/obj/item/stack/telecrystal/T = I
		if(T.amount > 0)
			T.amount--
			telecrystals++
			update_telecrystals()
			to_chat(user, "<span class = 'notice'>You load the telecrystal into the hat.</span>")
			playsound(loc, 'sound/arcade/win.ogg', 50, 1, extrarange = -3, falloff = 10)
			if(T.amount == 0) // HORRIBLE SHITCODE
				qdel(T)
		else
			qdel(T)
	else
		. = ..()

/obj/item/clothing/head/syndie_tophat/MouseDrop(atom/over_object) // Copypasted from foilhat code, don't look at me!
	if(been_equipped)
		if(usr)
			var/mob/living/carbon/human/C = usr
			if(src == C.head)
				to_chat(C, "<span class='warning'>Why stoop down to NT?</span>")
				return
	..()

/obj/item/clothing/head/syndie_tophat/attack_hand(mob/user)
	if(been_equipped)
		if(iscarbon(user))
			var/mob/living/carbon/human/C = user
			if(src == C.head)
				to_chat(user, "<span class='warning'>Why stoop down to NT?</span>")
				return
	..()

/obj/item/clothing/head/syndie_tophat/proc/update_telecrystals()
	if(telecrystals < 0)
		tc_update_icon = FALSE
		name = "clown mitre"
		hat_desc = "It reeks of a humiliating failure. How did you even manage to get negative telecrystals?"
		icon = 'hippiestation/icons/obj/clothing/syndihat.dmi'
		alternate_worn_icon = 'hippiestation/icons/mob/syndihat.dmi'
		icon_state = "WTF"
	switch(telecrystals)
		if(1)
			name = "lame syndicate bowler hat"
			hat_desc = "For showing that you're a lackey."
			icon_state = "syndibowler"
		if(2)
			name = "syndicate bowler hat"
			hat_desc = "For showing that you're a slightly-above-average lackey."
			get_stache = TRUE
		if(3)
			name = "rogueish syndicate bowler hat"
			hat_desc = "For showing that you should spend another telecrystal on this hat."
		if(4)
			name = "wanted joe's syndicate bowler hat"
			hat_desc = "For showing that you rule the lackeys."
		if(5)
			name = "lunch thief's syndicate bowler hat"
			hat_desc = "For showing that you've got what it takes to show NT who is truly on top."
			get_suit = TRUE
			get_glow = TRUE
		if(6)
			name = "granny stabber's syndicate bowler hat"
		if(7)
			name = "accredited pickpocket's syndicate bowler hat"
		if(8)
			name = "wicked spacebank robber's syndicate bowler hat"
			hat_desc = "To show that you're in a league of your own, and would be the boss' first and best pick."
		if(9)
			name = "dastardly corporation overthrower's syndicate bowler hat"
			get_glasses = TRUE
		if(10)
			name = "syndicate tophat"
			hat_desc = "For showing that you're kind of a boss."
			alternate_worn_icon = 'hippiestation/icons/mob/large-worn-icons/64x64/head.dmi'
			worn_x_dimension = 64
			worn_y_dimension = 64
			tc_update_icon = TRUE
		if(11)
			name = "evil syndicate tophat"
		if(12)
			name = "vicious syndicate tophat"
		if(13)
			name = "loathsome syndicate tophat"
		if(14)
			name = "diabolical syndicate tophat"
		if(15)
			name = "delightfully devilish syndicate tophat"
			hat_desc = "Seymour!!!"
		if(16)
			name = "chaotic evil syndicate tophat"
			hat_desc = "Only a true monster would wear this!"
		if(17)
			name = "moustache twirler's profoundly nefarious syndicate tophat"
		if(18)
			name = "true villain's heinous syndicate tophat"
		if(19)
			name = "unrepentantly corrupt megalomaniac's syndicate tophat"
		if(20)
			name = "syndicate boss' tophat"
			hat_desc = "For showing that you are THE BOSS."
			icon_state = "syndihat-20"
			tc_update_icon = FALSE
		if(40) // you have to kill another traitor or have some shitty admin spoil the fun for you in order to get this far
			name = "Syndiman Sachs' syndicate tophat"
			hat_desc = "Unbelievable evil! No one is this man's ally!"
			icon_state = "syndihat-40"
			get_glow = FALSE
		if(60)
			name = "genocidal conqueror's calamitous syndicate tophat"
			hat_desc = "There's a line where we needed to stop, and you're crossing it."
			icon_state = "syndihat-60"
		if(80)
			name = "hat on legs"
			hat_desc = "You disgust me."
			icon_state = "syndihat-80"
		if(100 to INFINITY)
			name = "THE HAT"
			hat_desc = "<span class = 'narsie'>THE HAT COMETH.</span>"
			tc_update_icon = FALSE
			worn_x_dimension = 32
			worn_y_dimension = 32
			icon = 'hippiestation/icons/obj/clothing/syndihat.dmi'
			alternate_worn_icon = 'hippiestation/icons/obj/clothing/syndihat.dmi'
			icon_state = "THE-HAT"
	if(tc_update_icon)
		icon_state = "syndihat-[telecrystals]"
	desc = "[hat_desc] It's been made with <b>[telecrystals] TC.</b>"

/obj/item/clothing/head/syndie_tophat/equipped(mob/user, slot)
	if(!ishuman(user))
		return
	if(slot == SLOT_HEAD)
		var/mob/living/carbon/human/H = user
		//YANDEV TIER CODE
		// moustache
		if(get_stache)
			if(!istype(H.wear_mask, /obj/item/clothing/mask/fakemoustache/italian/syndie))
				if(!H.doUnEquip(H.wear_mask))
					qdel(H.wear_mask)
				H.equip_to_slot_or_del(new /obj/item/clothing/mask/fakemoustache/italian/syndie(H), SLOT_WEAR_MASK)

		// full suit

		if(get_suit)
			if(!istype(H.wear_mask, /obj/item/clothing/gloves/fingerless))
				if(!H.doUnEquip(H.gloves))
					qdel(H.gloves)
				H.equip_to_slot_or_del(new /obj/item/clothing/gloves/fingerless(H), SLOT_GLOVES)
			if(!istype(H.shoes, /obj/item/clothing/shoes/laceup/syndie))
				if(!H.doUnEquip(H.shoes))
					qdel(H.shoes)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/syndie(H), SLOT_SHOES)
			if(!istype(H.w_uniform, /obj/item/clothing/under/lawyer/red/syndie))
				if(!H.doUnEquip(H.w_uniform))
					qdel(H.w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/lawyer/red/syndie(H), SLOT_W_UNIFORM)

		// overlay

		if(get_glow) // prevents glow from clipping outside of THE HAT and so on
			H.add_overlay(evil_overlay)

		// monocle
		if(get_glasses)
			if(!istype(H.glasses, /obj/item/clothing/glasses/monocle/syndie))
				if(!H.doUnEquip(H.glasses))
					qdel(H.glasses)
				H.equip_to_slot_or_del(new /obj/item/clothing/glasses/monocle/syndie(H), SLOT_GLASSES)

		been_equipped = TRUE
		H.skin_tone = "latino"

		to_chat(H, "<span class = 'notice'>You put on the <b>[name]!</b>\
		<br><span class = 'notice'>It's been made with [telecrystals] of the finest telecrystals.\
		<br>Hat ranking: </span><span class = 'sciradio'><b>[hat_desc]</b>")
	. = ..()

/obj/item/clothing/head/syndie_tophat/dropped(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_item_by_slot(SLOT_HEAD) == src)
		if(get_suit)
			H.cut_overlay(evil_overlay)
		been_equipped = FALSE
		H.dust(TRUE) // your days of crime are over and you're utterly humiliated. this is a mercy kill.
		update_telecrystals()
	. = ..() 
