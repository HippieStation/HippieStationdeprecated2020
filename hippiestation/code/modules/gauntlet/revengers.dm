/datum/status_effect/agent_pinpointer/revenger
	id = "revenger_pinpointer"
	minimum_range = 1
	range_fuzz_factor = 0
	tick_interval = 10
	alert_type = /obj/screen/alert/status_effect/agent_pinpointer/revenger

/datum/status_effect/agent_pinpointer/revenger/scan_for_target()
	scan_target = locate(/obj/item/badmin_gauntlet) in world

/obj/screen/alert/status_effect/agent_pinpointer/revenger
	name = "Revengers Pinpointer"

///////////////////////
//// NANO GUY SUIT ////
///////////////////////

/obj/item/implant/adrenalin/nanoguy
	uses = 10

/datum/outfit/nanosuit/nanoguy
	name = "Nano Guy (Nanosuit)"
	implants = list(/obj/item/implant/explosive/disintegrate, /obj/item/implant/adrenalin/nanoguy)
	internals_slot = SLOT_S_STORE

/obj/item/clothing/suit/space/hardsuit/nano/nanoguy
	name = "Nanotrasen Nanotech Suit"
	desc = "A state-of-the-art nanotechnology-powered suit."
	alternate_worn_icon = 'hippiestation/icons/mob/nanoguy.dmi'
	icon_state = "ngsuit"
	item_state = "ngsuit"
	outfit = /datum/outfit/nanosuit/nanoguy
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/nano/nanoguy

/obj/item/clothing/head/helmet/space/hardsuit/nano/nanoguy
	name = "Nanotrasen Nanotech Helmet"
	desc = "A state-of-the-art nanotechnology-powered helmet."
	icon = 'hippiestation/icons/obj/nanoguy.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/nanoguy.dmi'
	icon_state = "nghelmet"
	item_state = "nghelmet"

/////////////////////////////
//// NANO GUY NANO-STUFF ////
/////////////////////////////

/obj/item/twohanded/required/nanoshield
	name = "Nano Shield"
	desc = "A powerful shield, powered by nanotechnology"
	icon = 'hippiestation/icons/obj/nanoguy.dmi'
	lefthand_file = 'hippiestation/icons/mob/inhands/equipment/shields_lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/equipment/shields_righthand.dmi'
	icon_state = "ngshield"
	force = 20
	force_wielded = 20
	block_chance = 60
	armor = list("melee" = 80, "bullet" = 45, "laser" = 75, "energy" = 75, "bomb" = 100, "bio" = 0, "rad" = 35, "fire" = 100, "acid" = 100)
	var/power = 10
	var/next_power_regen = 0

/obj/item/twohanded/required/nanoshield/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

/obj/item/twohanded/required/nanoshield/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/twohanded/required/nanoshield/process()
	if(world.time >= next_power_regen)
		power = min(10, power + 1)
		next_power_regen = world.time + 5 SECONDS

/obj/item/twohanded/required/nanoshield/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text, final_block_chance, damage, attack_type)
	if(power > 0)
		power = max(0, power - 1)
		return ..()
	return FALSE

/obj/item/twohanded/required/nanoshield/IsReflect(def_zone)
	if(power > 0)
		power = max(0, power - 1)
		return TRUE
	return FALSE

/obj/item/organ/cyberimp/arm/nanoguy
	name = "nanotech implant"
	contents = newlist(/obj/item/twohanded/required/nanoshield, /obj/item/gun/energy/laser/mounted/nanoguy, /obj/item/nano_punch)

/obj/item/organ/cyberimp/arm/nanoguy/l
	zone = BODY_ZONE_L_ARM

/obj/item/gun/energy/laser/mounted/nanoguy
	name = "nanotech laser gun"
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	icon_state = "nanolaser"
	item_state = ""

/obj/item/nano_punch
	name = "nanotech battering ram"
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi'
	icon_state = "nanoram"
	item_state = "nanoram"
	force = 35

/obj/item/nano_punch/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)


////////////////////
//// THOR STUFF ////
////////////////////

/obj/item/clothing/suit/armor/thor
	name = "Thor's Armor"
	desc = "Armor worthy of the gods... literally."
	alternate_worn_icon = 'hippiestation/icons/mob/suit.dmi'
	icon = 'hippiestation/icons/obj/clothing/suits.dmi'
	icon_state = "thor"
	armor = list("melee" = 50, "bullet" = 30, "laser" = 50, "energy" = 50, "bomb" = 100, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)

//////////////////////////////
//// CAP NANOTRASEN STUFF ////
//////////////////////////////

/obj/item/shield/captain_nt
	name = "Captain Nanotrasen's Shield"
	desc = "A powerful shield constructed of a top-secret alloy, derived in the deepest of Nanotrasen labs."
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi'
	icon_state = "ntshield"
	item_state = "ntshield"
	throw_range = 6
	force = 25
	throwforce = 30
	throw_speed = 3
	attack_verb = list("shoved", "bashed")

/obj/item/shield/captain_nt/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback, force)
	if(iscarbon(thrower))
		var/mob/living/carbon/C = thrower
		C.throw_mode_on() //so they can catch it on the return.
	return ..()

/obj/item/shield/captain_nt/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/caught = hit_atom.hitby(src, FALSE, FALSE, throwingdatum=throwingdatum)
	if(thrownby && !caught)
		sleep(1)
		throw_at(thrownby, throw_range+2, throw_speed, null, TRUE)
