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

/obj/item/gun/ballistic/shotgun/doublebarrel/contender/sawoff(mob/user)
	to_chat(user, "<span class='warning'>Why would you mutilate this work of art?</span>")
	return

/obj/item/gun/ballistic/shotgun
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'

/obj/item/gun/ballistic/shotgun/riot
	desc = "I used the shotgun. You know why? Cause the shot gun doesn't miss, and unlike the shitty hybrid taser it stops \
	a criminal in their tracks in two hits. Bang, bang, and they're fucking done. I use four shots just to make damn sure. \
	Because, once again, I'm not there to coddle a buncha criminal scum sucking faggots, I'm there to 1) Survive the fucking round. \
	2) Guard the armory. So you can absolutely get fucked. If I get unbanned, which I won't, you can guarantee I will continue to use \
	the shotgun to apprehend criminals. Because it's quick, clean and effective as fuck. Why in the seven hells would I fuck around \
	with the disabler shots, which take half a clip just to bring someone down, or with the tazer bolts which are slow as balls, \
	impossible to aim and do about next to jack shit, fuck all. The shotgun is the superior law enforcement weapon. Because it stops crime. \
	And it stops crime by reducing the number of criminals roaming the fucking halls."

/obj/item/gun/ballistic/shotgun/triplebarrel
	name = "triple-barreled shotgun"
	desc = "Say goobye to your wrists, knucklehead."
	mag_type = /obj/item/ammo_box/magazine/internal/shot/triplebarrel
	fire_sound_volume = 150
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'
	icon_state = "triplethreat"
	load_sound = 'sound/weapons/shotguninsert.ogg'
	rack_sound_volume = 0
	burst_size = 3
	fire_delay = 0
	semi_auto = TRUE
	bolt_type = BOLT_TYPE_NO_BOLT

obj/item/gun/ballistic/shotgun/triplebarrel/sawoff(mob/user)
	to_chat(user, "<span class='warning'>You're not stupid enough to try sawing off this cursed weapon, are ya?</span>")
	return

/obj/item/ammo_box/magazine/internal/shot/triplebarrel
	name = "triple-barrel shotgun internal magazine"
	max_ammo = 3
