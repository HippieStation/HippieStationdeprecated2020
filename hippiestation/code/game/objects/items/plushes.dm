/obj/item/toy/plush/goatplushie
	name = "goat plushie"
	icon = 'hippiestation/icons/obj/toy.dmi'
	icon_state = "goat"
	desc = "Despite its cuddly appearance and plush nature, it will beat you up all the same. Goats never change."
	var/mob/living/carbon/target
/obj/item/toy/plush/goatplushie/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)
/obj/item/toy/plush/goatplushie/process()
	. = ..()
	if (prob(25) && !target)
		var/list/targets_to_pick_from = list()
		for(var/mob/living/carbon/C in orange(2))
			targets_to_pick_from += C
		if (targets_to_pick_from.len == 0)
			return
		target = pick(targets_to_pick_from)
		src.visible_message("<span class='notice'>[src] stares at [target].</span>")
	if (target)
		ram()
/obj/item/toy/plush/goatplushie/proc/ram()
	if(prob(90) && isturf(src.loc))
		src.throw_at(target, 10, 10)
		src.visible_message("<span class='danger'>[src] rams [target]!</span>")	
		target.apply_damage(1)
		sleep(2000)
	target = null
	src.visible_message("<span class='notice'>[src] looks disinterested.</span>")
/obj/item/toy/plush/goatplushie/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()