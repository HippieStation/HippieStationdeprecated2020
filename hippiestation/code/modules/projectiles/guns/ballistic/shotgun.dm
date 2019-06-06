//Contender, made by ArcLumin.

/obj/item/gun/ballistic/shotgun/doublebarrel/contender
	desc = "The Contender G13, a favorite amongst space hunters. An easily modified bluespace barrel and break action loading means it can use any ammo available.\
	The side has an engraving which reads 'Made by ArcWorks'"
	name = "Contender G13"
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'
	icon_state = "contender-s"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/contender
	weapon_weight = WEAPON_MEDIUM
	w_class = WEIGHT_CLASS_NORMAL
	materials = list(MAT_METAL=10000)
	obj_flags = UNIQUE_RENAME
	unique_reskin = 0

// Abzats, complete with its copypasted L6 SAW code. No, really, it legitimately just had copypasted L6 SAW code.

/obj/item/gun/ballistic/automatic/l6_saw/abzats
	name = "abzats machineshotgun"
	desc = "An old friend. Enough firepower to splatter the Captain across two star systems in one shot."
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'
	icon_state = "abzats"
	item_state = "abzats"
	slot_flags = null
	bolt_type = BOLT_TYPE_OPEN
	w_class = WEIGHT_CLASS_HUGE
	mag_type = /obj/item/ammo_box/magazine/mbox12g
	weapon_weight = WEAPON_HEAVY
	spawnwithmagazine = FALSE
	fire_sound = 'hippiestation/sound/weapons/shotgun_big_shoot.ogg'
	rack_sound = 'sound/weapons/chunkyrack.ogg'
	burst_size = 2
	fire_delay = 1
	spread = 15
	lefthand_file = 'hippiestation/icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/weapons/guns_righthand.dmi'
	pin = /obj/item/firing_pin/implant/pindicate

/obj/item/gun/ballistic/automatic/l6_saw/abzats/unrestricted
	pin = /obj/item/firing_pin

// Bulldog

/obj/item/gun/ballistic/shotgun/bulldog
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'

/obj/item/ammo_box/magazine/m12g
	icon = 'hippiestation/icons/obj/ammo/ammo.dmi'

/obj/item/ammo_box/magazine/m12g/update_icon()
	..()
	icon_state = "[initial(icon_state)]-[CEILING(ammo_count(FALSE)/2, 1)*2]"

/obj/item/gun/ballistic/shotgun/bulldog/afterattack(atom/target as mob|obj|turf, mob/living/user as mob|obj, flag, params)
	. = ..()
	if(magazine)
		magazine.update_icon()