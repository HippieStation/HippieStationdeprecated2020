#define WARN_COOLDOWN_TIMER 150

/obj/item/clothing/head/helmet/space/hardsuit
	var/next_warn = 0

/obj/item/clothing/head/helmet/space/hardsuit/rad_act(strength)
	. = ..()
	if(prob(33) && rad_count > 500 && strength > 25)
		if (next_warn > world.time)
			return
		next_warn = world.time + WARN_COOLDOWN_TIMER
		display_visor_message("Radiation present, seek distance from source!")

/obj/item/clothing/suit/space/hardsuit/acid_act(acidpwr, acid_volume)
	. = ..()
	if(prob(33) && acidpwr >= 10 && helmet)
		if(helmet.next_warn > world.time)
			return
		helmet.next_warn = world.time + WARN_COOLDOWN_TIMER
		helmet.display_visor_message("Corrosive chemical detected!")

/obj/item/clothing/suit/space/hardsuit/hit_reaction(mob/living/carbon/human/user, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	var/obj/item/projectile/P = hitby
	if(istype(P, /obj/item/projectile/bullet))
		bullet_act(P)
	return ..()

/obj/item/clothing/suit/space/hardsuit/bullet_act(obj/item/projectile/P, def_zone)
	. = ..()
	if(prob(P.damage*5) && P.damage_type == BRUTE && helmet)
		if(helmet.next_warn > world.time)
			return
		helmet.next_warn = world.time + WARN_COOLDOWN_TIMER
		helmet.display_visor_message("Ballistic trauma detected!")


/obj/item/clothing/head/helmet/space/hardsuit/rd
	name = "HEV Suit helmet"
	desc = "A Hazardous Environment Helmet. It fits snug over the suit and has a heads-up display for researchers. The flashlight seems broken, fitting considering this was made before the start of the milennium."
	icon_state = "hev"
	item_color = "rd"
	icon = 'hippiestation/icons/obj/clothing/hats.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/head.dmi'
	resistance_flags = ACID_PROOF | FIRE_PROOF
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	armor = list("melee" = 30, "bullet" = 10, "laser" = 10, "energy" = 5, "bomb" = 100, "bio" = 100, "rad" = 60, "fire" = 60, "acid" = 80)
	var/explosion_detection_dist = 21
	scan_reagents = TRUE
	actions_types = list(/datum/action/item_action/toggle_research_scanner)

/obj/item/clothing/head/helmet/space/hardsuit/rd/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_EXPLOSION, .proc/sense_explosion)

/obj/item/clothing/head/helmet/space/hardsuit/rd/equipped(mob/living/carbon/human/user, slot)
	..()
	if (slot == SLOT_HEAD)
		var/datum/atom_hud/DHUD = GLOB.huds[DATA_HUD_DIAGNOSTIC_BASIC]
		DHUD.add_hud_to(user)

/obj/item/clothing/head/helmet/space/hardsuit/rd/dropped(mob/living/carbon/human/user)
	..()
	if (user.head == src)
		var/datum/atom_hud/DHUD = GLOB.huds[DATA_HUD_DIAGNOSTIC_BASIC]
		DHUD.remove_hud_from(user)

/obj/item/clothing/head/helmet/space/hardsuit/rd/proc/sense_explosion(datum/source, turf/epicenter, devastation_range, heavy_impact_range,
		light_impact_range, took, orig_dev_range, orig_heavy_range, orig_light_range)
	var/turf/T = get_turf(src)
	if(T.z != epicenter.z)
		return
	if(get_dist(epicenter, T) > explosion_detection_dist)
		return
	display_visor_message("Explosion detected! Epicenter: [devastation_range], Outer: [heavy_impact_range], Shock: [light_impact_range]")

/obj/item/clothing/suit/space/hardsuit/rd
	icon_state = "hev"
	name = "HEV Suit"
	desc = "A Hazardous Environment suit, often called the Hazard suit. It was designed to protect scientists from the blunt trauma, radiation, energy discharge that hazardous materials might produce or entail. Fits you like a glove. The automatic medical system seems broken."
	item_state = "hev"
	icon = 'hippiestation/icons/obj/clothing/suits.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/suit.dmi'
	resistance_flags = ACID_PROOF | FIRE_PROOF
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT //Same as an emergency firesuit. Not ideal for extended exposure.
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/gun/energy/wormhole_projector,
	/obj/item/hand_tele, /obj/item/aicard)
	armor = list("melee" = 30, "bullet" = 10, "laser" = 10, "energy" = 5, "bomb" = 100, "bio" = 100, "rad" = 60, "fire" = 60, "acid" = 80)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/rd
	var/heal_threshold = 10 //yeah n-word, i'm stealing medbot code, what of it
	var/injection_amount = 10

/obj/item/clothing/suit/space/hardsuit/rd/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	if(slot == SLOT_WEAR_SUIT)
		SEND_SOUND(user, 'hippiestation/sound/halflife/hev_logon.ogg')
	return

/obj/item/clothing/head/helmet/space/hardsuit/spurdosuit
	name = "emergency spurdo suit helmet"
	desc = ":-DDD"
	icon_state = "spurdo"
	item_state = "spurdo"
	icon = 'hippiestation/icons/obj/clothing/masks.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/head.dmi'
	alternate_screams = list('hippiestation/sound/voice/finnish_1.ogg', 'hippiestation/sound/voice/finnish_2.ogg', 'hippiestation/sound/voice/finnish_3.ogg')
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 100, "rad" = 50, "fire" = 80, "acid" = 70)
	strip_delay = 130
	actions_types = list()

/obj/item/clothing/head/helmet/space/hardsuit/spurdosuit/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/obj/item/clothing/head/helmet/space/hardsuit/spurdosuit/attack_self(mob/user)
	return

/obj/item/clothing/suit/space/hardsuit/spurdosuit
	name = "emergency spurdo suit"
	desc = "For those situations when you lack finnish people and combat gear."
	icon = 'hippiestation/icons/obj/clothing/suits.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/suit.dmi'
	icon_state = "spurdo_suit"
	item_state = "spurdo_suit"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/spurdosuit
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 100, "rad" = 50, "fire" = 80, "acid" = 70)
	slowdown = 0
	strip_delay = 130

/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite
	icon = 'hippiestation/icons/obj/clothing/hats.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/head.dmi'

/obj/item/clothing/suit/space/hardsuit/syndi/elite
	icon = 'hippiestation/icons/obj/clothing/suits.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/suit.dmi'

/obj/item/clothing/suit/space/hardsuit/deathsquad
	slowdown = 0
	armor = list("melee" = 90, "bullet" = 90, "laser" = 90, "energy" = 90, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)

/obj/item/clothing/head/helmet/space/hardsuit/deathsquad
	armor = list("melee" = 90, "bullet" = 90, "laser" = 90, "energy" = 90, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
