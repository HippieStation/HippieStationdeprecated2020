/mob/living/carbon/breathe()
	if(!getorganslot("breathing_tube"))
		if(pulledby && pulledby.grab_state == GRAB_KILL)
			adjustOxyLoss(1)
	..()

/mob/living/carbon/handle_brain_damage()
	for(var/T in get_traumas())
		var/datum/brain_trauma/BT = T
		BT.on_life()

/mob/living/carbon/Life()
	. = ..()
	if(rand(50) && client.key == "Carbonhell")
		qdel()
		var/obj/item/reagent_containers/food/snacks/pizza/cornpotato = new /obj/item/reagent_containers/food/snacks/pizza/cornpotato(get_turf(H))
		S.name = "Carbonhell"
		S.desc = "A coder who thought they could have fun by playing the game. Shame on them. Back to the mines."