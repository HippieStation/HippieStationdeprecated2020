/obj/item/clothing/mask/facehugger/attackby(obj/item/O, mob/user, params)
	if(!istype(O, /obj/item/slimepotion/genderchange))
		return O.attack_obj(src, user)

	if(stat == DEAD)
		to_chat(user, "<span class='warning'>The potion can only be used if the creature is alive!</span>")
		return

	if(sterile)
		user.visible_message("<span class='danger'>[src] grows a proboscis!</span>", "<span class='danger'>[src] grows a proboscis!</span>")
		sterile = 0
	else
		user.visible_message("<span class='danger'>[src]'s proboscis shrivels up and drops off!</span>", "<span class='danger'>[src]'s proboscis shrivels up and drops off!</span>")
		sterile = 1

		qdel(O)
		log_admin("[key_name(user)] used a gender change potion on a facehugger at [get_turf(user)]")

		return
