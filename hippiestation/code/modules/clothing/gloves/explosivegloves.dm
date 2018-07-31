/obj/item/clothing/gloves/exbracelet
	name = "explosive bracelet"
	desc = "A bracelet, ready to lock on your arm."
	icon = 'hippiestation/icons/obj/clothing/gloves.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/hands.dmi'
	actions_types = list(/datum/action/item_action/hands_free/exbracelet)
	icon_state = "exbracelet_unequipped"
	item_state = "exbracelet_right"
	var/armed = FALSE
	var/wrist = "right"

/obj/item/clothing/gloves/exbracelet/Initialize()
	. = ..() //i still dont know what the . = is for lmao
	wrist = pick("right", "left")
	item_state = "exbracelet_[wrist]"
	desc = "A bracelet, likely locked to your [wrist] hand already."

/obj/item/clothing/gloves/exbracelet/equipped(mob/user, slot)
	..()
	if(slot == SLOT_GLOVES)
		icon_state = "exbracelet_unarmed"
		to_chat(user, "<span class='warning'>5 seconds until [src] is armed!</span>")
		addtimer(CALLBACK(src, .proc/activate, user), 50)

/obj/item/clothing/gloves/exbracelet/proc/activate(mob/user)
	item_flags = NODROP
	to_chat(user, "<span class='boldwarning'>You feel your [wrist] wrist tighten as [src] locks in!</span>")
	playsound(user.loc, 'sound/machines/triple_beep.ogg', 50, 1)
	icon_state = "exbracelet_armed"
	armed = TRUE
	desc = "A bracelet, likely locked to your [wrist] hand already. <span class='boldwarning'>It looks active.</span>"

/obj/item/clothing/gloves/exbracelet/ui_action_click(mob/living/carbon/user, action)
	if(!isliving(user))
		return
	if(!istype(user.get_item_by_slot(SLOT_GLOVES), /obj/item/clothing/gloves/exbracelet))
		to_chat(user, "<span class='warning'>[src] is not armed nor equipped!</span>")
		return
	if(!armed)
		to_chat(user, "<span class='warning'>[src] is still not armed!</span>")
		return
	user.visible_message("<span class='warning'>[user]'s [wrist] wrist begins to beep loudly!</span>") // gotta give sec SOME warning
	playsound(user.loc, 'sound/items/timer.ogg', 40, 0)
	sleep(15)
	playsound(user.loc, 'sound/items/timer.ogg', 40, 0)
	sleep(15)
	playsound(user.loc, 'sound/items/timer.ogg', 40, 0)
	sleep(15)
	to_chat(user, "<span class='bold'>Kiss your [wrist] arm a goodbye and say hello to freedom!</span>")
	var/obj/item/bodypart/arm
	if(wrist == "left")
		arm = user.get_bodypart("l_arm")
	else
		arm = user.get_bodypart("r_arm")
	arm.dismember()
	user.apply_damage(10, BRUTE, "chest") //because the explosion or whatever
	user.Knockdown(10)
	user.flash_act()
	for(var/mob/living/X in orange(4,user))
		X.flash_act()
	playsound(user.loc,'sound/effects/bang.ogg', 50, 1)
	qdel(src)