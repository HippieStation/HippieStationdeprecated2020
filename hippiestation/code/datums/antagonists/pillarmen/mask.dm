/obj/item/clothing/mask/stone
	name = "stone mask"
	desc = "A spooky stone mask. Something tells you wearing this a horrible idea."
	icon_state = "death"
	var/datum/antagonist/pillarmen/pillarMan

/obj/item/clothing/mask/stone/equipped(mob/M, slot)
	. = ..()
	if(ishuman(M) && slot == SLOT_WEAR_MASK)
		if(M.stat)
			visible_message("<span class='hypnophrase big'>[src] falls off of [M]'s face, they don't have enough life force!</span>")
			M.doUnEquip(src, TRUE)
			return
		INVOKE_ASYNC(src, .proc/do_the_thing, M)

/obj/item/clothing/mask/stone/process()
	set_light(5, null, rgb(rand(1, 127), rand(1, 127), rand(1, 127))) // random bright color?

/obj/item/clothing/mask/stone/proc/do_the_thing(mob/living/carbon/human/H)
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)
	visible_message("<span class='hypnophrase big'>[src] sinks 6 needles into [H]'s head, and begins to glow a brilliant light!</span>")
	START_PROCESSING(SSobj, src)
	to_chat(H, "<span class='danger bold'>Everything... everything hurts.</span>")
	H.SetStun(INFINITY)
	sleep(25)
	to_chat(H, "<span class='danger bold'>You feel kind of hungry...</span>")
	sleep(35)
	to_chat(H, "<span class='danger bold'>Must... consume... must... help... the master... [pillarMan.owner.name]</span>")
	sleep(45)
	H.SetStun(0)
	H.fully_heal()
	H.mind.add_antag_datum(/datum/antagonist/vampire/pillarmen, pillarMan.pillarTeam)
	REMOVE_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)
	STOP_PROCESSING(SSobj, src)
	set_light(0, 0)
	visible_message("<span class='hypnophrase'>[src] falls off of [H], it's needles retracting...</span>")
	H.doUnEquip(src, TRUE)
