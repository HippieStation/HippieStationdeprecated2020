/obj/item/melee/sabre
	force = 10

/obj/item/melee/sabre/get_dismemberment_chance(obj/item/bodypart/affecting)
	return 30

/obj/item/melee/sabre/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	..()
	user.changeNext_move(CLICK_CD_CLICK_ABILITY)
