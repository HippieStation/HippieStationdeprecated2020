/*
 * Biowaste Bag of Holding (xenobiologists get an upgrade)
 */

/obj/item/storage/bag/bio/holding
	name = "Bio Bag of Holding"
	icon = 'face/icons/obj/chemical.dmi'
	icon_state = "biobagH"
	desc = "A bag for the safe transportation and disposal of biowaste and other biological materials. This bag has more storage compared to the regular bio bag."
	w_class = WEIGHT_CLASS_TINY


/obj/item/storage/bag/bio/holding/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 200
	STR.max_items = 100
	STR.insert_preposition = "in"
	STR.can_hold = typecacheof(list(/obj/item/slime_extract, /obj/item/reagent_containers/syringe, /obj/item/reagent_containers/dropper, /obj/item/reagent_containers/glass/beaker, /obj/item/reagent_containers/glass/bottle, /obj/item/reagent_containers/blood, /obj/item/reagent_containers/hypospray/medipen, /obj/item/reagent_containers/food/snacks/deadmouse, /obj/item/reagent_containers/food/snacks/monkeycube))

