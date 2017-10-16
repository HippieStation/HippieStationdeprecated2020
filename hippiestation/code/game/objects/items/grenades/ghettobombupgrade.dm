
/obj/item/grenade/iedcasing/upgrade
	name = "improved improvised firebomb"
	desc = "A stringer, improvised incendiary device."

/obj/item/grenade/iedcasing/upgrade/prime() //Blowing that can up
	update_mob()
	explosion(src.loc,-1,0,4, flame_range = 6)	// bigger explosion, plus a very large fireball.
	qdel(src)

