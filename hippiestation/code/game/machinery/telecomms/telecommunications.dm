/obj/machinery/telecomms
	icon_hippie = 'hippiestation/icons/obj/machines/telecomms.dmi'

/obj/machinery/telecomms/ui_interact(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.dna && istype(H.dna.species, /datum/species/ganymede))
			to_chat(H, "<span class='warning'>Your enormous hands can't possibly fiddle with that!</span>")
			return
	return ..()
