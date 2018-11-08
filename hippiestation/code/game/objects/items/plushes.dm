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
	if (prob(25) && !target)
		var/list/targets_to_pick_from = list()
		for(var/mob/living/carbon/C in view(7, src))
			targets_to_pick_from += C
		if (targets_to_pick_from.len == 0)
			return
		target = pick(targets_to_pick_from)
		src.visible_message("<span class='notice'>[src] stares at [target].</span>")
	if (target && !(obj_flags & EMAGGED))
		ram()
	if (target && (obj_flags & EMAGGED))
		super_ram()
/obj/item/toy/plush/goatplushie/proc/ram()
	if(prob(90) && isturf(src.loc) && considered_alive(target.mind))
		src.throw_at(target, 10, 10)
		src.visible_message("<span class='danger'>[src] rams [target]!</span>")	
		target.apply_damage(1)
		sleep(2000)
	target = null
	src.visible_message("<span class='notice'>[src] looks disinterested.</span>")
/obj/item/toy/plush/goatplushie/proc/super_ram()
	src.visible_message("<span class='danger'>[src] looks pissed..</span>")
	if(prob(98) && isturf(src.loc) && considered_alive(target.mind))
		src.throw_at(target, 10, 10)
		src.visible_message("<span class='danger'>[src] rams [target]!</span>")	
		target.apply_damage(20)
		sleep(500)
	target = null
	src.visible_message("<span class='notice'>[src] looks disinterested.</span>")

/obj/item/toy/plush/goatplushie/emag_act(mob/user)
	if ((obj_flags&EMAGGED))
		return
	obj_flags |= EMAGGED

/obj/item/toy/plush/goatplushie/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()