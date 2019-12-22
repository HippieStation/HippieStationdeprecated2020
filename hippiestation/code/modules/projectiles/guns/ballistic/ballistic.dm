/obj/item/gun/ballistic/can_shoot()
	return (chambered || magazine || magazine?.ammo_count(FALSE))



