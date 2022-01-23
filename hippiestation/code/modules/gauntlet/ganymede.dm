//Originally coded for HippieStation by Steamp0rt, shared under the AGPL license.

// haha get it? they're both moons. titan and ganymede.
/datum/species/ganymede
	name = "Ganymedian"
	id = "ganymede"
	species_traits = list(NOTRANSSTING, NOZOMBIE, NO_DNA_COPY, NOEYESPRITES, AGENDER, NO_UNDERWEAR, NOFLASH, MUTCOLORS)
	inherent_traits = list(TRAIT_NOBREATH, TRAIT_NOHUNGER, TRAIT_RESISTCOLD, TRAIT_RESISTHEAT, TRAIT_NOLIMBDISABLE, TRAIT_NODISMEMBER, TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE, TRAIT_STABLEHEART, TRAIT_VIRUSIMMUNE, TRAIT_STUNIMMUNE, TRAIT_SLEEPIMMUNE, TRAIT_PUSHIMMUNE, TRAIT_NOGUNS, TRAIT_PIERCEIMMUNE,
		TRAIT_SHOCKIMMUNE, TRAIT_RADIMMUNE)
	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	changesource_flags = MIRROR_BADMIN
	mutanteyes = /obj/item/organ/eyes/night_vision/alien/ganymede
	sexes = FALSE

/datum/species/ganymede/on_species_gain(mob/living/carbon/human/C, datum/species/old_species, pref_load)
	C.draw_hippie_parts()
	. = ..()

/datum/species/ganymede/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	C.draw_hippie_parts(TRUE)
	. = ..()


/obj/item/clothing/head/hippie/ganymedian
	name = "Ganymedian Helmet"
	desc = "A robust-looking helmet from Ganymede."
	alternate_worn_icon = 'hippiestation/icons/mob/large-worn-icons/64x64/head.dmi'
	icon_state = "ganymede"
	item_state = "ganymede"
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELM_MAX_TEMP_PROTECT
	armor = list("melee" = 50, "bullet" = 65, "laser" = 65, "energy" = 45, "bomb" = 100, "bio" = 30, "rad" = 30, "fire" = 70, "acid" = 30)

/obj/item/clothing/head/hippie/ganymedian/equipped(mob/user, slot)
	if(slot == ITEM_SLOT_HEAD)
		ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
		item_flags |= DROPDEL
	return ..()

/obj/item/clothing/suit/hippie/ganymedian
	name = "Ganymedian Armor"
	desc = "Robust-looking armor from Ganymede."
	icon_state = "ganymede"
	item_state = "ganymede"
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	armor = list("melee" = 50, "bullet" = 65, "laser" = 65, "energy" = 45, "bomb" = 100, "bio" = 30, "rad" = 30, "fire" = 70, "acid" = 30)

/obj/item/clothing/suit/hippie/ganymedian/equipped(mob/user, slot)
	if(slot == ITEM_SLOT_OCLOTHING)
		ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
		item_flags |= DROPDEL
	return ..()

/obj/item/tank/jetpack/ganypack
	name = "Ganypack"
	desc = "An alien-made jetpack, capable of infinite spaceflight."
	icon = 'hippiestation/icons/obj/infinity.dmi'
	icon_state = "ganypack"
	item_state = "flightpack_off"
	gas_type = null
	actions_types = list(/datum/action/item_action/toggle_jetpack, /datum/action/item_action/jetpack_stabilization)

/obj/item/tank/jetpack/ganypack/turn_off(mob/user)
	. = ..()
	item_state = "flightpack_off"
	slowdown = 0

/obj/item/tank/jetpack/ganypack/turn_on(mob/user)
	. = ..()
	item_state = "flightpack_boost"
	slowdown = 1

/obj/item/tank/jetpack/ganypack/allow_thrust(num, mob/living/user)
	if(!on)
		return
	return TRUE

/obj/item/tank/jetpack/ganypack/ex_act(severity, target)
	return

/obj/item/tank/jetpack/ganypack/equipped(mob/user, slot)
	if(slot == ITEM_SLOT_BACK)
		ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
		item_flags |= DROPDEL
	return ..()

/obj/item/clothing/under/hippie/ganymedian
	name = "ganymedian jumpsuit"
	desc = "It's uh, not actually a jumpsuit. This is, in fact, a literal placeholder!"
	icon_state = ""
	item_state = ""
	item_color = ""
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL
	has_sensor = NO_SENSORS
	can_adjust = 0

/obj/item/clothing/under/hippie/ganymedian/equipped(mob/user, slot)
	if(slot == ITEM_SLOT_OCLOTHING)
		ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
		item_flags |= DROPDEL
	return ..()

/obj/item/clothing/shoes/ganymedian
	name = "ganymedian shoes"
	desc = "It's uh, not actually shoes. This is, in fact, a literal placeholder!"
	icon_state = ""
	item_state = ""
	item_color = ""
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL

/obj/item/clothing/shoes/ganymedian/equipped(mob/user, slot)
	if(slot == ITEM_SLOT_FEET)
		ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
		item_flags |= DROPDEL
	return ..()


/mob/living/carbon/human/ex_act(severity, target, origin)
	if(super_leaping || is_ganymede(src))
		return
	return ..()

/datum/component/chasm/droppable(atom/movable/AM)
	. = ..()
	if(is_ganymede(AM))
		return FALSE

/proc/is_ganymede(A)
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(H.dna && istype(H.dna.species, /datum/species/ganymede))
			return TRUE
	return FALSE
