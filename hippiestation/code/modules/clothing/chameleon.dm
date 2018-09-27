/datum/action/item_action/chameleon/change/update_item(obj/item/picked_item, obj/item/target = src.target) // hippie -- add support for cham hardsuits
	..()
	if(istype(target, /obj/item/clothing/suit/space/hardsuit/infiltration))
		var/obj/item/clothing/suit/space/hardsuit/infiltration/I = target
		var/obj/item/clothing/suit/space/hardsuit/HS = new picked_item
		var/obj/item/clothing/head/helmet/space/hardsuit/HH = new HS.helmettype
		update_item(HS.helmettype, I.head_piece)
		I.head_piece.basestate = initial(HH.basestate)
		I.head_piece.item_color = initial(HH.item_color)
		I.head_piece.icon_state = "[I.head_piece.basestate][I.head_piece.on]-[I.head_piece.item_color]"
		var/mob/living/M = owner
		if(istype(M))
			M.update_inv_head()
		qdel(HS)
		qdel(HH)