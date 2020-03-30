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

/obj/item/clothing/head/helmet/space/hardsuit/syndi
	name = "blood-red spacesuit helmet"
	icon = 'hippiestation/icons/obj/clothing/sechats.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/sechead.dmi'
	var/flushed_name = "old blood-red hardsuit helmet"

/obj/item/clothing/suit/space/hardsuit/syndi
	name = "blood-red spacesuit"
	desc = "An advanced spacesuit with a built in helmet and energy shielding."
	icon = 'hippiestation/icons/obj/clothing/secsuits.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/secsuit.dmi'
	var/flushed_name = "old blood-red hardsuit"
	var/flushed = 0
	var/can_be_flushed = 1

/obj/item/clothing/head/helmet/space/hardsuit/syndi/toggle_hardsuit_mode(mob/user)
	. = ..()
	if(linkedsuit.flushed)
		name = flushed_name
		desc = "It seems both expensive and antique."
		icon = 'icons/obj/clothing/hats.dmi'
		alternate_worn_icon = null
		linkedsuit.name = linkedsuit.flushed_name
		linkedsuit.desc = "It's both a blast to the past, and strangely futuristic."
		linkedsuit.alternate_worn_icon = null

/obj/item/clothing/suit/space/hardsuit/syndi/elite
	flushed_name = "old elite syndicate hardsuit"

/obj/item/clothing/head/helmet/space/hardsuit/syndi
	flushed_name = "old elite hardsuit helmet"

/obj/item/clothing/suit/space/hardsuit/syndi/elite/blastco
	can_be_flushed = 0

/obj/structure/toilet/attackby(obj/item/I, mob/living/user, params) // SURPRISE TOILET CODE
	if(!cistern && istype(I, /obj/item/clothing/suit/space/hardsuit/syndi))
		var/obj/item/clothing/suit/space/hardsuit/syndi/S = I
		if(S.can_be_flushed)
			S.icon = 'icons/obj/clothing/suits.dmi'
			S.name = "old blood-red hardsuit"
			S.flushed = 1
			S.alternate_worn_icon = null
			to_chat(user, "<span class = 'notice'>You flush the spacesuit down the toilet, and it changes?</span>")
	. = ..()

/obj/item/clothing/suit/space/hardsuit/deathsquad
	slowdown = 0
	armor = list("melee" = 90, "bullet" = 90, "laser" = 90, "energy" = 90, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)

/obj/item/clothing/head/helmet/space/hardsuit/deathsquad
	armor = list("melee" = 90, "bullet" = 90, "laser" = 90, "energy" = 90, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
