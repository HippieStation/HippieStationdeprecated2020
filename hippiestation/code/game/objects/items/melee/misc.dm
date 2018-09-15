/obj/item/melee/sabre/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	..()
	user.changeNext_move(CLICK_CD_CLICK_ABILITY)