
/obj/item/infinity_gauntlet
	name = "Badmin Gauntlet"
	var/locked_on = FALSE
	var/stone_mode = BLUESPACE_STONE
	var/list/stones = list()
	var/static/list/all_stones = list(SYNDIE_STONE, BLUESPACE_STONE, SERVER_STONE, LAG_STONE, CLOWN_STONE, POWERGAME_STONE)

/obj/item/infinity_gauntlet/examine(mob/user)
	. = ..()
	for(var/obj/item/infinity_stone/IS in stones)
		to_chat(user, "<span class='bold notice'>[IS.name] mode</span>")
		IS.ShowExamine(user)

/obj/item/infinity_gauntlet/proc/GetStone(stone_type)
	for(var/obj/item/infinity_stone/I in stones)
		if(I.stone_type == stone_type)
			return I
	return

/obj/item/infinity_gauntlet/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!isliving(user))
		return ..()
	var/obj/item/infinity_stone/IS = GetStone(stone_mode)
	if(!IS || !istype(IS))
		return ..()
	switch(user.a_intent)
		if(INTENT_DISARM)
			IS.DisarmEvent(target, user, proximity_flag)
		if(INTENT_HARM)
			IS.HarmEvent(target, user, proximity_flag)
		if(INTENT_GRAB)
			IS.GrabEvent(target, user, proximity_flag)
		if(INTENT_HELP)
			IS.HelpEvent(target, user, proximity_flag)

/obj/item/infinity_gauntlet/proc/attack_self(mob/living/user)
	if(!istype(user))
		return
	if(!locked_on)
		var/prompt = alert("Would you like to truly wear the Badmin Gauntlet? You will be unable to remove it!", "Confirm", "Yes", "No")
		if (prompt == "Yes")
			if(user.put_in_hands(src))
				add_trait(TRAIT_NODROP, GAUNTLET_TRAIT)
				locked_on = TRUE
				visible_message("<span class='danger bold'>The badmin gauntlet clamps to [user]'s hand!</span>")
			else
				to_chat(user, "<span class='danger'>You do not have an empty hand for the Badmin Gauntlet.</span>")
		return
	if(!LAZYLEN(stones))
		to_chat(user, "<span class='danger'>You have no stones yet.</span>")
		return
	var/list/gauntlet_radial = list()
	for(var/obj/item/infinity_stone/I in stones)
		gauntlet_radial[I.stone_type] = image(icon = I.icon, icon_state = I.icon_state)
	var/chosen = show_radial_menu(user, src, gauntlet_radial, custom_check = CALLBACK(src, .proc/check_menu, user))
	if(!check_menu(user))
		return
	if(chosen)
		stone_mode = chosen

/obj/item/infinity_gauntlet/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/infinity_stone))
		var/obj/item/infinity_stone/IS = I
		if(!GetStone(IS.stone_type))
			user.visible_message("<span class='danger bold'>[user] drops \the [IS] into the Badmin Gauntlet.</span>")
			IS.forceMove(src)
			stones += IS
			return
	return ..()

/obj/item/infinity_gauntlet/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE
