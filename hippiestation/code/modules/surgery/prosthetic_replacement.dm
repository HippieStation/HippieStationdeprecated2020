datum/surgery_step/add_prosthetic/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(istype(tool, /obj/item/organ_storage))
		tool.icon_state = initial(tool.icon_state)
		tool.desc = initial(tool.desc)
		tool.cut_overlays()
		tool = tool.contents[1]
	if(istype(tool, /obj/item/bodypart) && user.temporarilyRemoveItemFromInventory(tool))
		var/obj/item/bodypart/L = tool
		L.attach_limb(target)
		if(organ_rejection_dam)
			target.adjustToxLoss(organ_rejection_dam)
		user.visible_message("[user] successfully replaces [target]'s [parse_zone(target_zone)]!", "<span class='notice'>You succeed in replacing [target]'s [parse_zone(target_zone)].</span>")
		return 1
	else
		var/obj/item/bodypart/L = target.newBodyPart(target_zone, FALSE, FALSE)
		L.is_pseudopart = TRUE
		L.attach_limb(target)
		user.visible_message("[user] finishes attaching [tool]!", "<span class='notice'>You attach [tool].</span>")
		qdel(tool)
		if(istype(tool, /obj/item/twohanded/required/chainsaw/energy)) //HIPPIE CODE -START- differenciates betwen esaws and normal saws
			var/obj/item/mounted_energy_chainsaw/new_arm = new(target) //HIPPIECODE
			target_zone == "BODY_ZONE_R_ARM" ? target.put_in_r_hand(new_arm) : target.put_in_l_hand(new_arm) //HIPPIECODE
			return 1 //HIPPIECODE
		else if(istype(tool, /obj/item/twohanded/required/chainsaw))
			var/obj/item/mounted_chainsaw/new_arm = new(target)
			target_zone == BODY_ZONE_R_ARM ? target.put_in_r_hand(new_arm) : target.put_in_l_hand(new_arm)
			return 1
		else if(istype(tool, /obj/item/melee/synthetic_arm_blade))
			var/obj/item/melee/arm_blade/new_arm = new(target,TRUE,TRUE)
			target_zone == BODY_ZONE_R_ARM ? target.put_in_r_hand(new_arm) : target.put_in_l_hand(new_arm)
			return 1
