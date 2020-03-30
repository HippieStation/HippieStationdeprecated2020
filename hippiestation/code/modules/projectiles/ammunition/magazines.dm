// contender

/obj/item/ammo_box/magazine/internal/shot/contender
	name = "contender internal magazine"
	caliber = "all"
	ammo_type = /obj/item/ammo_casing
	start_empty = TRUE
	max_ammo = 2
	multiload = 0 // thou must load every shot individually

/obj/item/ammo_box/magazine/ak922
	name = "AK-922 magazine (7.62x39)"
	icon = 'hippiestation/icons/obj/ammo/ammo.dmi'
	icon_state = "AKMag"
	ammo_type = /obj/item/ammo_casing/a762x39
	caliber = "7.62x39"
	max_ammo = 30

/obj/item/ammo_box/magazine/ak922/update_icon()
	..()
	icon_state = "[initial(icon_state)]-[CEILING(ammo_count(0)/30, 1)*30]"

// abzats & L6 spritestuffs

/obj/item/ammo_box/magazine
	var/box_opened = FALSE

/obj/item/ammo_box/magazine/mm712x82
	icon = 'hippiestation/icons/obj/ammo/ammo.dmi'
	icon_state = "a762-unopened"

/obj/item/ammo_box/magazine/mbox12g
	name = "box magazine (12 gauge buckshot)"
	icon = 'hippiestation/icons/obj/ammo/ammo.dmi'
	icon_state = "box12g-unopened"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	caliber = "shotgun"
	max_ammo = 40
	var/ammo_icon = "box12g" // for adding future ammo types

/obj/item/ammo_box/magazine/mbox12g/update_icon()
	..()
	if(box_opened)
		icon_state = "[ammo_icon]-[round(ammo_count(),10)]" 
