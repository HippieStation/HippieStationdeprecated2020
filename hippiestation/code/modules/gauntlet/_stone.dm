/obj/item/infinity_stone
	name = "Generic Stone"
	var/list/ability_types = list()
	var/list/abilities = list()
	var/mob/living/current_holder

/obj/item/infinity_stone/Initialize()
	. = ..()
	for(var/T in ability_types)
		abilities += new T
	RegisterSignal(src, COMSIG_ITEM_PICKUP, .proc/UpdateHolder)
	RegisterSignal(src, COMSIG_ITEM_DROPPED, .proc/UpdateHolder)
	RegisterSignal(src, COMSIG_ITEM_EQUIPPED, .proc/UpdateHolder)

/obj/item/infinity_stone/proc/GiveAbilities(mob/living/L)
	for(var/datum/action/A in abilities)
		A.Grant(L)

/obj/item/infinity_stone/proc/RemoveAbilities(mob/living/L)
	for(var/datum/action/A in abilities)
		A.Remove(L)

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
