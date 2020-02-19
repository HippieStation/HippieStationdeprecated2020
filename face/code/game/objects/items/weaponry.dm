/obj/item/melee/unicycle
	name = "Unicycle"
	desc = "You're gonna want to use your taint as a fulcrum to get on this badboy."
	icon = 'face/icons/obj/uni.dmi'
	icon_state = "unihold"
	item_state = "unicycle"
	force = 5 // it's a fucking wheel on a stick.
	throwforce = 9 // It's light
	w_class = WEIGHT_CLASS_BULKY // it's a fucking big ol wheel what do you expect
	attack_verb = list("smacked", "whacked", "slammed", "smashed")

/obj/item/melee/unicycle/attack_self(mob/user)
	new /obj/vehicle/ridden/scooter/skateboard/unicycle(get_turf(user))
	qdel(src)