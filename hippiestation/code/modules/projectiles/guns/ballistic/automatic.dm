// L6 SAW

/obj/item/gun/ballistic/automatic/l6_saw
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'
	alternate_worn_icon = 'hippiestation/icons/obj/guns/worn_guns.dmi'
	slot_flags = ITEM_SLOT_BACK
	item_state = null
	lefthand_file = 'hippiestation/icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/weapons/guns_righthand.dmi'
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/l6_saw/attackby(obj/item/A, mob/user, params)
	. = ..()
	if(istype(A, mag_type))
		var/obj/item/ammo_box/magazine/M = A
		M.box_opened = TRUE



/obj/item/gun/ballistic/automatic/c20r
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'

/obj/item/gun/ballistic/automatic/wt550
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'

/obj/item/gun/ballistic/automatic/mini_uzi
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'

/obj/item/gun/ballistic/automatic/l6_saw
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'

/obj/item/gun/ballistic/automatic/ar
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'

/obj/item/gun/ballistic/automatic/tommygun
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'

/obj/item/gun/ballistic/automatic/gyropistol
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'

/obj/item/gun/ballistic/automatic/sniper_rifle
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'
	
/obj/item/gun/ballistic/automatic/laser
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'

/obj/item/gun/ballistic/automatic/l6_saw/attack_self(mob/living/user)
	if(!internal_magazine && magazine)
		if(!cover_open)
			to_chat(user, "<span class='warning'>[src]'s cover is closed! Open it before trying to remove the magazine!</span>")
			return
		eject_magazine(user)
		return
	if (recent_rack > world.time)
		return
	recent_rack = world.time + rack_delay
	rack(user)

// AK 922

/obj/item/gun/ballistic/automatic/ak922
	name = "AK-922"
	desc = "A New-Russia standard-issue battle rifle chambered in 7.62x39mm. Packs a punch and is built out of strong materials with an old yet reliable build."
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'
	icon_state = "AK"
	item_state = "AK"
	mag_type = /obj/item/ammo_box/magazine/ak922
	fire_delay = 1
	burst_size = 3
	pin = /obj/item/firing_pin/implant/pindicate
	can_flashlight = 1
	flight_x_offset = 18
	flight_y_offset = 12
	can_bayonet = TRUE
	knife_x_offset = 18
	knife_y_offset = 12
	mag_display = TRUE
	mag_display_ammo = TRUE
	empty_indicator = TRUE
	spread = 10
	fire_sound = 'hippiestation/sound/weapons/handcannon.ogg'
	lefthand_file = 'hippiestation/icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/weapons/guns_righthand.dmi'

/obj/item/gun/ballistic/automatic/ak922/unrestricted
	pin = /obj/item/firing_pin

/obj/item/ammo_casing/a762x39
	name = "762x39 bullet casing"
	desc = "An 762x39 bullet casing."
	caliber = "762x39"
	projectile_type = /obj/item/projectile/bullet/heavybullet

/obj/item/projectile/bullet/heavybullet
	damage = 35
	armour_penetration = 25

/obj/item/gun/ballistic/automatic/ak922/gold
	name = "golden AK-922"
	desc = "Damn son! Now that's a nice gun!"
	icon_state = "goldAK"
	item_state = "goldAK"

/obj/item/gun/ballistic/automatic/ak922/gold/unrestricted
	pin = /obj/item/firing_pin
	desc = "You see, Mr. Powers..." 
