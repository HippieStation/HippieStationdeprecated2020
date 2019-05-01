/obj/item/infinity_stone
	name = "Generic Stone"

/obj/item/infinity_stone/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_AFTERATTACK, .proc/AfterAttackEvent)

/obj/item/infinity_stone/proc/AfterAttackEvent(atom/target, mob/living/user, proximity_flag)
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
