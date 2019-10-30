/obj/item/clothing/shoes/magboots/advance
	slowdown_active = 1

/obj/item/clothing/shoes/magboots/antigrav
	name = "Anti-gravity boots"
	desc = "Boots that let you walk in zero G."
	var/can_toggle = FALSE
	var/obj/item/stock_parts/cell/upgraded/cell //What type of power cell this uses

/obj/item/clothing/shoes/magboots/antigrav/toggle()
	name = "Toggle Antigrav"

/obj/item/clothing/shoes/magboots/antigrav/Initialize()
	. = ..()
	cell = new(src)
	START_PROCESSING(SSobj, src)

/obj/item/clothing/shoes/magboots/antigrav/get_cell()
	return cell

/obj/item/clothing/shoes/magboots/antigrav/emp_act(severity)
	cell.emp_act(severity)

/obj/item/clothing/shoes/magboots/antigrav/process()
	if(!cell?.charge)
		return PROCESS_KILL
	if(!magpulse)
		return
	cell.use(10)

/obj/item/clothing/shoes/magboots/antigrav/examine(mob/user)
	..()
	if(cell)
		to_chat(user, "<span class='notice'>Cell charge:[cell.percent()]%.</span>")
	else
		to_chat(user, "<span class='warning'>No cell detected.</span>")

/obj/item/clothing/shoes/magboots/antigrav/equipped(mob/user, slot)
	..()
	if(slot == SLOT_SHOES && cell?.charge)
		can_toggle = TRUE

/obj/item/clothing/shoes/magboots/antigrav/dropped(mob/user)
	..()
	can_toggle = FALSE
	magpulse = FALSE
	icon_state = initial(icon_state)
	if(user.movement_type & FLYING)
		user.setMovetype(user.movement_type & ~FLYING)

/obj/item/clothing/shoes/magboots/antigrav/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(cell)
	var/mob/user
	if(iscarbon(loc))
		user = loc
		if(user.movement_type & FLYING)
			user.setMovetype(user.movement_type & ~FLYING)
	can_toggle = FALSE
	return ..()

/obj/item/clothing/shoes/magboots/antigrav/attack_self(mob/user)
	if(!can_toggle)
		to_chat(user, "You must be wearing [src] to turn them on.")
		return
	magpulse = !magpulse
	if(magpulse)
		user.setMovetype(user.movement_type | FLYING)
	else
		if(user.movement_type & FLYING)
			user.setMovetype(user.movement_type & ~FLYING)
	icon_state = "[magboot_state][magpulse]"
	to_chat(user, "<span class='notice'>You [magpulse ? "enable" : "disable"] the anti-grav system.</span>")
	user.update_inv_shoes()	//so our mob-overlays update
	//user.update_gravity(user.has_gravity())
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()