/obj/item/extinguisher/attack_obj(obj/O, mob/living/user)
	if(attempt_refill_hippie(O, user))
		refilling = TRUE
		return FALSE
	else
		return ..()

/obj/item/extinguisher/proc/attempt_refill_hippie(atom/target, mob/user)
	if(istype(target, /obj/structure/reagent_dispensers) && target.Adjacent(user))
		var/safety_save = safety
		safety = TRUE
		if(reagents.total_volume == reagents.maximum_volume)
			to_chat(user, "<span class='warning'>\The [src] is already full!</span>")
			safety = safety_save
			return 1
		var/obj/structure/reagent_dispensers/watertank/W = target
		var/transferred = W.reagents.trans_to(src, max_water)
		if(transferred > 0)
			to_chat(user, "<span class='notice'>\The [src] has been refilled by [transferred] units.</span>")
			playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
			for(var/datum/reagent/water/R in reagents.reagent_list)
				R.cooling_temperature = cooling_power
		else
			to_chat(user, "<span class='warning'>\The [W] is empty!</span>")
		safety = safety_save
		return 1
	else
		return 0

/obj/item/extinguisher/attackby(obj/O, mob/user)	//I tried working with what was up above but the code is so abysmally shit this was WAY easier to do
	if(istype(O, /obj/item/reagent_containers))
		if(!safety)
			if(reagents.total_volume == reagents.maximum_volume)
				to_chat(user, "<span class='warning'>\The [src] is already full!</span>")
				return
			var/transferred = O.reagents.trans_to(src, max_water)	//Might as well auto-fill right
			if(transferred > 0)
				to_chat(user, "<span class='notice'>\The [src] has been refilled by [transferred] units.</span>")
				for(var/datum/reagent/water/R in reagents.reagent_list)
					R.cooling_temperature = cooling_power
			else
				to_chat(user, "<span class='warning'>\The [O] is empty!</span>")
				return
		else
			to_chat(user, "<span class='warning'>You need to take off the safety before you can refill the [src]!</span>")

	..()