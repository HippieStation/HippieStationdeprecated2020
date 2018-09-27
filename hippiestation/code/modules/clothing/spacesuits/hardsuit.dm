/obj/item/clothing/head/helmet/space/hardsuit
	var/next_warn_rad = 0
	var/warn_rad_cooldown = 180

/obj/item/clothing/suit/space/hardsuit
	var/next_warn_acid = 0
	var/warn_acid_cooldown = 150

/obj/item/clothing/head/helmet/space/hardsuit/rad_act(severity)
	.=..()
	if (prob(33) && rad_count > 500 && severity > 25)
		if (next_warn_rad > world.time)
			return
		next_warn_rad = world.time + warn_rad_cooldown
		display_visor_message("Radiation present, seek distance from source!")

/obj/item/clothing/suit/space/hardsuit/acid_act(acidpwr, acid_volume)
	.=..()
	if (prob(33) && acidpwr >= 10)
		if(helmet)
			if(next_warn_acid > world.time)
				return
			next_warn_acid = world.time + warn_acid_cooldown
			helmet.display_visor_message("Corrosive Chemical Detected!")

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
	item_flags = NODROP

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