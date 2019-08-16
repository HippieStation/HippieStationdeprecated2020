/obj/item/loudnigramagicmissilerainbowridebeesremastered
	name = "big red button"
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "bigred"
	item_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY

/obj/item/loudnigramagicmissilerainbowridebeesremastered/attack_self(mob/user)
	do_sparks(2, FALSE, src)
	message_admins("[key_name_admin(user)] has activated LOUD NIGRA RAINBOW RIDE MAGIC MISSILE BEES!")
	log_game("[key_name_admin(user)] has activated LOUD NIGRA RAINBOW RIDE MAGIC MISSILE BEES!")
	SEND_SOUND(world, sound('hippiestation/sound/misc/OHGOD.ogg'))
