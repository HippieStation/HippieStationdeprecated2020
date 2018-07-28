/obj/item/assembly/flash
	var/overcharge = 0 //If overcharged you set people on fire.. but the bulb burns out on use!
	var/battery_panel = 0 //If it can be modified or not!

/obj/item/assembly/flash/attackby(obj/item/W, mob/user, params)
	..()
	if(istype(W, /obj/item/wirecutters))
		if(battery_panel)
			user.visible_message("<span class='notice'>You push in the pin holding the battery compartment in \the [src].</span>")
			battery_panel = 0
		else
			user.visible_message("<span class='notice'>You pull out the pin holding the battery compartment out of \the [src].</span>")
			battery_panel = 1
	if(battery_panel && !overcharge)
		if(istype(W, /obj/item/stock_parts/cell))
			user.visible_message("<span class='notice'>You jam the cell into the battery compartment on the [src].</span>")
			qdel(W)
			overcharge = 1
			update_icon()

/obj/item/assembly/flash/AOE_flash/(bypass_checks = FALSE, range = 3, power = 5, targeted = FALSE, mob/user)
	var/list/mob/targets = get_flash_targets(get_turf(src), range, FALSE)
	if(user)
		targets -= user
	for(var/mob/living/carbon/C in targets)
		if(C.eye_blind)
			return FALSE
	..()

/obj/item/assembly/flash/flash_carbon/(mob/living/carbon/M, mob/user, power = 15, targeted = TRUE, generic_message = FALSE)
	if(overcharge)
		M.adjust_fire_stacks(2)
		M.IgniteMob()
		burn_out()
		visible_message("<span class='disarm'>[user] uses the overcharged flash on [M]!</span>")
		to_chat(user, "<span class='danger'>You use the overcharged flash on [M]!</span>")
		to_chat(M, "<span class='userdanger'>[user] uses the overcharged flash on you!</span>")
		return FALSE //wont stun, setting somebody on fire AND stunning them at the same time is cheesy, especially if you also grab a toolbox or something
	if(M.eye_blind)
		return FALSE
	..()

/obj/item/assembly/flash/update_icon(flash = FALSE)
	cut_overlays()
	attached_overlays = list()
	if(overcharge)
		add_overlay(image('hippiestation/icons/obj/device.dmi', "overcharge"))
		attached_overlays += (image('hippiestation/icons/obj/device.dmi', "overcharge"))
	if(crit_fail)
		add_overlay("flashburnt")
		attached_overlays += "flashburnt"
	if(flash)
		add_overlay("flash-f")
		attached_overlays += "flash-f"
		addtimer(CALLBACK(src, .proc/update_icon), 5)
	if(holder)
		holder.update_icon()