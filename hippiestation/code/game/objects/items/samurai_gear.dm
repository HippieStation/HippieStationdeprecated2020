/obj/item/clothing/head/helmet/samurai
	name = "kabuto"
	desc = "A helmet worn by the samurai of feudal Japan on old Earth."
	icon = 'hippiestation/icons/obj/samurai_gear.dmi'
	icon_state = "kabuto"
	item_state = "kabuto"
	alternate_worn_icon = 'hippiestation/icons/mob/head.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF
	flags_inv = HIDEEARS|HIDEHAIR
	force = 3
	armor = list("melee" = 40, "bullet" = 30, "laser" = 20, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 50)

/obj/item/clothing/under/samurai
	name = "yakama"
	desc = "A garmet that is usually found in Japanese culture."
	icon = 'hippiestation/icons/obj/samurai_gear.dmi'
	icon_state = "yakama"
	item_state = "yakama"
	alternate_worn_icon = 'hippiestation/icons/mob/uniform.dmi'
	alternate_screams = list('hippiestation/sound/voice/yo.ogg')

/obj/item/clothing/mask/samurai
	name = "menpo mask"
	desc = "A mask worn by ancient samurai warriors. Very fashionable."
	icon = 'hippiestation/icons/obj/samurai_gear.dmi'
	icon_state = "menpo"
	item_state = "menpo"
	alternate_worn_icon = 'hippiestation/icons/mob/mask.dmi'
	flags_inv = HIDEFACE

/obj/item/clothing/suit/armor/samurai
	name = "haramaki armor"
	desc = "Ancient, powerful armor worn by the samurai of feudal Japan that allows its user to ignore slowdown caused by damage."
	icon = 'hippiestation/icons/obj/samurai_gear.dmi'
	icon_state = "haramaki"
	item_state = "haramaki"
	alternate_worn_icon = 'hippiestation/icons/mob/suit.dmi'
	armor = list("melee" = 50, "bullet" = 20, "laser" = 10, "energy" = 10, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 80, "acid" = 80)
	strip_delay = 120
	equip_delay_other = 60
	force = 3
	body_parts_covered = CHEST|GROIN|ARMS
	var/equipped = FALSE

/obj/item/clothing/suit/armor/samurai/equipped(mob/living/carbon/human/user, slot)
	..()
	if(slot == ITEM_SLOT_OCLOTHING)
		equipped = TRUE
		ADD_TRAIT(user, TRAIT_IGNOREDAMAGESLOWDOWN, CLOTHING_TRAIT)
		to_chat(user, "<span class ='notice'>You feel like you can ignore all pain!")

/obj/item/clothing/suit/armor/samurai/pickup(mob/user)
	..()
	if(equipped)
		equipped = FALSE
		REMOVE_TRAIT(user, TRAIT_IGNOREDAMAGESLOWDOWN, CLOTHING_TRAIT)
		to_chat(user, "<span class='userdanger'>Your body can no longer ignore damage!")

/obj/item/clothing/suit/armor/samurai/item_action_slot_check(slot, mob/user)
	if(slot == ITEM_SLOT_OCLOTHING)
		return FALSE
	return TRUE

/obj/item/clothing/suit/armor/samurai/doStrip(mob/stripper, mob/owner)
	..()
	if(equipped)
		equipped = FALSE
		REMOVE_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, CLOTHING_TRAIT)
		to_chat(owner, "<span class='userdanger'>Your body can no longer ignore damage!")

/obj/item/clothing/shoes/samurai
	name = "suneate shoes"
	desc = "Some shoes that probably go pretty well with samurai clothing."
	icon = 'hippiestation/icons/obj/samurai_gear.dmi'
	icon_state = "suneate"
	item_state = "suneate"
	alternate_worn_icon = 'hippiestation/icons/mob/feet.dmi'

/obj/item/clothing/gloves/samurai
	name = "kote gloves"
	desc = "A comfortable pair of insulated gloves that probably originated in feudal Japan."
	icon = 'hippiestation/icons/obj/samurai_gear.dmi'
	icon_state = "kote"
	item_state = "kote"
	alternate_worn_icon = 'hippiestation/icons/mob/hands.dmi'
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	body_parts_covered = HANDS|ARMS
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 25, "acid" = 0)
	siemens_coefficient = 0

/obj/item/melee/samurai_sword
	name = "samurai sword"
	desc = "The sword of a true samurai."
	icon = 'hippiestation/icons/obj/samurai_gear.dmi'
	icon_state = "samurai_sword"
	item_state = "samurai_sword"
	lefthand_file = 'hippiestation/icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/weapons/melee_righthand.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/belt.dmi'
	slot_flags = ITEM_SLOT_BELT
	force = 25
	throwforce = 10
	sharpness = IS_SHARP
	w_class = WEIGHT_CLASS_BULKY
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "gored", "ripped", "diced", "cut")
	block_chance = 25
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = FIRE_PROOF
	materials = list(MAT_METAL = 1000)

/obj/item/forged/melee/dagger/samurai_dagger
	name = "tanto"
	desc = "When you don't have your sword, use this."
	icon = 'hippiestation/icons/obj/samurai_gear.dmi'
	icon_state = "tanto"
	item_state = "tanto"
	lefthand_file = 'hippiestation/icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/weapons/melee_righthand.dmi'
	force = 6
	throwforce = 13
	speed = 3
	sharpness = IS_SHARP
	w_class = WEIGHT_CLASS_SMALL
	hitsound = 'hippiestation/sound/weapons/knife.ogg'
	embedding = list("embed_chance" = 30, "embedded_pain_multiplier" = 0.25, "embedded_fall_pain_multiplier" = 1, "embedded_impact_pain_multiplier" = 0.75, "embedded_unsafe_removal_pain_multiplier" = 1.25)

/obj/item/storage/belt/samurai
	name = "daisho obe waist wrap"
	desc = "Used to strap tantos and samurai swords to the user."
	icon = 'hippiestation/icons/obj/samurai_gear.dmi'
	icon_state = "daisho_obi"
	item_state = "daisho_obi"
	alternate_worn_icon = 'hippiestation/icons/mob/belt.dmi'
	max_integrity = 25

/obj/item/storage/belt/samurai/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 2
	STR.rustle_sound = FALSE
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.set_holdable(list(
		/obj/item/melee/samurai_sword,
		/obj/item/forged/melee/dagger/samurai_dagger
		))

/obj/item/storage/belt/samurai/update_icon()
	item_state = "daisho_obi"
	if(contents.len == 2)
		item_state = "daisho_obi_both"
	else if(contents.len == 1)
		item_state = "daisho_obi_tanto"
	if(loc && isliving(loc))
		var/mob/living/L = loc
		L.regenerate_icons()
	..()

/obj/item/storage/belt/samurai/attackby(mob/user)
	..()
	update_icon()

/obj/item/samuraibeacon //I made a new beacon because the choice prompt in normal choice beacons would be redundant since samurai armor would be the only choice.
	name = "samurai armaments beacon"
	desc = "Summon the armaments of the anicent and feared samurai."
	icon = 'icons/obj/device.dmi'
	icon_state = "gangtool-blue"
	item_state = "radio"

/obj/item/samuraibeacon/attack_self(mob/living/user)
	if(canUseBeacon(user))
		var/mob/living/M = user
		var/obj/new_item = new /obj/structure/closet/crate/wooden/samurai()
		var/obj/structure/closet/supplypod/bluespacepod/pod = new()
		pod.explosionSize = list(0,0,0,0)
		new_item.forceMove(pod)
		var/msg = "<span class=danger>You notice a strange target on the ground. It might be best to step back!</span>"
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(istype(H.ears, /obj/item/radio/headset))
				msg = "You hear something crackle in your ears for a moment before a voice speaks.  \"Please stand by for a message from Central Command.  Message as follows: <span class='bold'>Item request received. Your package is inbound, please stand back from the landing site.</span> Message ends.\""
		to_chat(M, msg)
		new /obj/effect/DPtarget(get_turf(src), pod)
		qdel(src)


/obj/item/samuraibeacon/proc/canUseBeacon(mob/living/user)
	if(user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return TRUE
	else
		playsound(src, 'sound/machines/buzz-sigh.ogg', 40, 1)
		return FALSE

/obj/structure/closet/crate/wooden/samurai
	name = "samurai chest"
	desc = "A storage used by the samurai."

/obj/structure/closet/crate/wooden/samurai/PopulateContents()
	..()
	new /obj/item/clothing/head/helmet/samurai(src)
	new /obj/item/clothing/under/samurai(src)
	new /obj/item/clothing/mask/samurai(src)
	new /obj/item/clothing/suit/armor/samurai(src)
	new /obj/item/clothing/shoes/samurai(src)
	new /obj/item/clothing/gloves/samurai(src)
	new /obj/item/melee/samurai_sword(src)
	new /obj/item/forged/melee/dagger/samurai_dagger(src)
	new /obj/item/storage/belt/samurai(src)
