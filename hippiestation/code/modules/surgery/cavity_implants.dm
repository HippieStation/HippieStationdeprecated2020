/datum/surgery_step/handle_cavity/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/electronic_assembly/EA = tool
	if(istype(EA) && EA.combat_circuits && tool.w_class > WEIGHT_CLASS_SMALL)
		to_chat(user, "<span class='warning'>[tool] is too dangerous to put in [target]'s [target_zone]! Maybe if it was smaller...</span>")
		return FALSE
	return(..(user, target, target_zone, tool, surgery))
