/obj/item/projectile/beam/laser/lasgun
	damage = 5


/obj/item/ammo_casing/energy/lasergun/lasgun
	projectile_type = /obj/item/projectile/beam/laser/lasgun
	e_cost = 25
	select_name = "kill"

/obj/item/gun/energy/laser/retro/face/custom/lasgun
	name = "lasgun"
	icon_state = "lasgun"
	icon = 'face/icons/obj/guns/energy.dmi'
	desc = "The humble (and we mean humble) Lasgun is an outdated model of laser weaponary. Though, some branches of Nanotreasen still like to use it as while it provides less of a punch, it makes up with it with it's large charge."
	ammo_type = list (/obj/item/ammo_casing/energy/lasergun/lasgun)
