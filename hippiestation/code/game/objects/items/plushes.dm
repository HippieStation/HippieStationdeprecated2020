/obj/item/toy/plush/goatplushie
	name = "goat plushie"
	icon = 'hippiestation/icons/obj/toy.dmi'
	icon_state = "goat"
	desc = "Despite its cuddly appearance and plush nature, it will beat you up all the same. Goats never change."
	var/mob/living/carbon/target
	force = 5
/obj/item/toy/plush/goatplushie/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)
/obj/item/toy/plush/goatplushie/process()
	. = ..()
	if (prob(1) && target)
		var/list/targets_to_pick_from = list()
		for(var/mob/living/carbon/C in oview(2))
			targets_to_pick_from += C
		target = pick(targets_to_pick_from)

/obj/item/toy/plush/goatplushie/attack()
	if (target)
		src.visible_message("<span class='notice'>[src] stares at [target].</span>")
		while(prob(90) || not on floor)
			src.throw_at(target, 10, 10)
			src.visible_message("<span class='warning'>[src] lunges at [target]!</span>")	
/obj/item/toy/plush/goatplushie/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()