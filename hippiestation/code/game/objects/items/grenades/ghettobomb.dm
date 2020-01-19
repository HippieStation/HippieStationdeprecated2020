/obj/item/grenade/iedcasing/prime() //buffs IEDs
	update_mob()
	explosion(src.loc,-1,1,2, flame_range = 2)
	qdel(src)