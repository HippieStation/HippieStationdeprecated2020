/obj/item/toy/plush/goatplushie
	name = "goat plushie"
	icon = 'hippiestation/icons/obj/toy.dmi'
	icon_state = "goat"
	desc = "Despite its cuddly appearance and plush nature, it will beat you up all the same. Goats never change."
	var/mob/living/carbon/target
	var/cooldown = 0
	var/cooldown_modifier = 20
/obj/item/toy/plush/goatplushie/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	
/obj/item/toy/plush/goatplushie/process()
	if (prob(25) && !target)
		var/list/targets_to_pick_from = list()
		for(var/mob/living/carbon/C in view(7, src))
			targets_to_pick_from += C
		if (!targets_to_pick_from.len)
			return
		target = pick(targets_to_pick_from)
		visible_message("<span class='notice'>[src] stares at [target].</span>")
	if (world.time > cooldown)
		if (target && !(obj_flags & EMAGGED))
			ram()
		if (target && (obj_flags & EMAGGED))
			super_ram()
	
/obj/item/toy/plush/goatplushie/proc/ram()
	if(prob(90) && isturf(src.loc) && considered_alive(target.mind))
		throw_at(target, 10, 10)
		visible_message("<span class='danger'>[src] rams [target]!</span>")	
		target.apply_damage(1)
		cooldown = world.time + cooldown_modifier
	target = null
	visible_message("<span class='notice'>[src] looks disinterested.</span>")
	
/obj/item/toy/plush/goatplushie/proc/super_ram()
	visible_message("<span class='danger'>[src] looks pissed..</span>")
	if(prob(98) && isturf(src.loc) && considered_alive(target.mind))
		throw_at(target, 10, 10)
		visible_message("<span class='danger'>[src] rams [target]!</span>")	
		target.apply_damage(20)
		cooldown = world.time + cooldown_modifier
	target = null
	visible_message("<span class='notice'>[src] looks disinterested.</span>")

/obj/item/toy/plush/goatplushie/emag_act(mob/user)
	if (obj_flags&EMAGGED)
		cooldown_modifier = 5
		visible_message("<span class='notice'>[src] already looks angry enough, you shouldn't anger it more.</span>")
		return
	obj_flags |= EMAGGED
	visible_message("<span class='danger'>[src] stares at [user] angrily before going docile.</span>")	

/obj/item/toy/plush/goatplushie/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()
