/obj/item/pneumatic_cannon/dildo
	name = "dildo cannon"
	desc = "Load with dildos for optimal results"
	force = 10
	icon_state = "dildocannon"
	gasPerThrow = 0
	checktank = FALSE
	range_multiplier = 3
	fire_mode = PCANNON_FIFO
	throw_amount = 1
	maxWeightClass = 100
	clumsyCheck = FALSE
	w_class = 4 //So it can hold dildos

/obj/item/pneumatic_cannon/dildo/can_load_item(obj/item/I, mob/user)
	if(istype(I, /obj/item/dragon/canine))
		return ..()
	to_chat(user, "<span class='warning'>[src] only accepts dildos!</span>")
	return FALSE

/obj/item/pneumatic_cannon/dildo/selfcharge
	automatic = TRUE
	var/charge_amount = 1
	var/charge_ticks = 1
	var/charge_tick = 0
	maxWeightClass = 200
	w_class = 4 //So it can hold dildos

/obj/item/pneumatic_cannon/dildo/selfcharge/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/pneumatic_cannon/dildo/selfcharge/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/pneumatic_cannon/dildo/selfcharge/process()
	if(++charge_tick >= charge_ticks)
		fill_with_type(/obj/item/dragon/canine, charge_amount)

/obj/item/pneumatic_cannon/dildo/admin
	automatic = TRUE
	var/charge_amount = 10
	var/charge_ticks = 1
	var/charge_tick = 0
	maxWeightClass = 9999
	w_class = 4 //So it can hold dildos

/obj/item/pneumatic_cannon/dildo/admin/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/pneumatic_cannon/dildo/admin/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/pneumatic_cannon/dildo/admin/process()
	if(++charge_tick >= charge_ticks)
		fill_with_type(/obj/item/dragon/canine, charge_amount)
