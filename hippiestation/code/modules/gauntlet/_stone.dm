/obj/item/infinity_stone
	name = "Generic Stone"
	var/mob/living/current_holder
	var/list/ability_text = list()
	var/list/spells = list()
	var/list/spell_types = list()

/obj/item/infinity_stone/Initialize()
	. = ..()
	for(var/T in spell_types)
		spells += new T(src)
	RegisterSignal(src, COMSIG_ITEM_PICKUP, .proc/UpdateHolder)
	RegisterSignal(src, COMSIG_ITEM_DROPPED, .proc/UpdateHolder)
	RegisterSignal(src, COMSIG_ITEM_EQUIPPED, .proc/UpdateHolder)

/obj/item/infinity_stone/examine(mob/user)
	. = ..()
	to_chat(user, "<span class='bold notice'>[name]</span>")
	ShowExamine(user)

/obj/item/infinity_stone/proc/ShowExamine(mob/user) // a seperate thing for the gauntlet
	for(var/A in ability_text)
		to_chat(user, "<span class='notice'>[A]</span>")

/obj/item/infinity_stone/proc/GiveAbilities(mob/living/L)
	for(var/obj/effect/proc_holder/spell/A in spells)
		L.AddSpell(A)

/obj/item/infinity_stone/proc/RemoveAbilities(mob/living/L)
	for(var/obj/effect/proc_holder/spell/A in spells)
		spells -= A
		spells += new A.type(src)
		L.RemoveSpell(A)


/obj/item/infinity_stone/proc/GetHolder()
	var/atom/movable/A = loc
	if(!istype(A))
		return
	if(isliving(A))
		return A
	for (A; isloc(A.loc) && !isliving(A.loc); A = A.loc);
	return A;

/obj/item/infinity_stone/proc/UpdateHolder()
	var/mob/living/new_holder = GetHolder()
	if (new_holder != current_holder)
		if(isliving(current_holder))
			RemoveAbilities(current_holder)
		if(isliving(new_holder))
			GiveAbilities(new_holder)
			current_holder = new_holder
		else
			current_holder = null

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

////////////////////////////////////////////////////////////////////////////////

/obj/effect/proc_holder/spell/self/infinity
	human_req = FALSE
	clothes_req = FALSE

/obj/effect/proc_holder/spell/targeted/infinity //copypaste from shadowling
	ranged_mousepointer = 'icons/effects/cult_target.dmi'
	human_req = FALSE
	clothes_req = FALSE
	var/obj/item/infinity_stone/stone
	var/mob/living/user
	var/mob/living/target

/obj/effect/proc_holder/spell/targeted/infinity/New(linked_stone)
	. = ..()
	stone = linked_stone

/obj/effect/proc_holder/spell/targeted/infinity/Click()
	var/mob/living/user = usr
	if(!istype(user))
		return
	var/msg
	if(!can_cast(user))
		msg = "<span class='warning'>You can no longer cast [name]!</span>"
		remove_ranged_ability(msg)
		return
	if(active)
		remove_ranged_ability()
	else
		add_ranged_ability(user, null, TRUE)

	if(action)
		action.UpdateButtonIcon()


/obj/effect/proc_holder/spell/targeted/infinity/InterceptClickOn(mob/living/caller, params, atom/t)
	if(!isliving(t))
		to_chat(caller, "<span class='warning'>You may only use this ability on living things!</span>")
		revert_cast()
		return FALSE
	user = caller
	target = t
	if(!istype(target))
		revert_cast()
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/targeted/infinity/revert_cast()
	. = ..()
	remove_ranged_ability()
	user = null
	target = null

/obj/effect/proc_holder/spell/targeted/infinity/start_recharge()
	. = ..()
	if(action)
		action.UpdateButtonIcon()
