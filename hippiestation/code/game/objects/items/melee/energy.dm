/obj/item/melee/transforming/energy/sword/saber/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/melee/transforming/energy/sword/saber))
		if(W == src)
			to_chat(user, "<span class='notice'>You try to attach the end of the energy sword to... itself. You're not very smart, are you?</span>")
			user.playsound_local(src, 'hippiestation/sound/effects/whistlefail.ogg', 50, 0)
			if(ishuman(user))
				user.adjustBrainLoss(25)
		else
			to_chat(user, "<span class='notice'>You attach the ends of the two energy swords, making a single double-bladed weapon! You're cool.</span>")
			var/obj/item/melee/transforming/energy/sword/saber/other_esword = W
			var/obj/item/twohanded/dualsaber/newSaber = new(user.loc)
			if(hacked || other_esword.hacked)
				newSaber.hacked = TRUE
				newSaber.item_color = "rainbow"
			qdel(W)
			qdel(src)
			user.put_in_hands(newSaber)
	else if(istype(W, /obj/item/multitool))
		var/color = input(user, "Select a color!", "Esword color") as null|anything in list("red", "green", "blue", "purple", "rainbow")
		if(!color)
			return
		item_color = color

		if(active)
			icon_state = "sword[color]"
			user.update_inv_hands()
	else
		..()
