/obj/effect/meteor/standarrow
	name = "mysterious meteor"
	icon_state = "glowing"
	heavy = 1
	meteordrop = list(/obj/item/guardiancreator/standarrow)
	dropamt = 1
	threat = 15

/obj/effect/meteor/standarrow/meteor_effect()
	..()
	explosion(src.loc, 0, 0, 4, 3, 0)
	new /obj/effect/decal/cleanable/greenglow(get_turf(src))