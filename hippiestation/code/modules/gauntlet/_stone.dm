/obj/item/infinity_stone
	name = "Generic Stone"

/obj/item/infinity_stone/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!isliving(user))
		return
	switch(user.a_intent)
		if(INTENT_DISARM)
			DisarmEvent(target, user, proximity_flag)
		if(INTENT_HARM)
			HarmEvent(target, user, proximity_flag)
		if(INTENT_GRAB)
			GrabEvent(target, user, proximity_flag)
		if(INTENT_HELP)
			HelpEvent(target, user, proximity_flag)

/obj/item/infinity_stone/proc/DisarmEvent(atom/target, mob/living/user, proximity_flag)

/obj/item/infinity_stone/proc/HarmEvent(atom/target, mob/living/user, proximity_flag)

/obj/item/infinity_stone/proc/GrabEvent(atom/target, mob/living/user, proximity_flag)

/obj/item/infinity_stone/proc/HelpEvent(atom/target, mob/living/user, proximity_flag)
