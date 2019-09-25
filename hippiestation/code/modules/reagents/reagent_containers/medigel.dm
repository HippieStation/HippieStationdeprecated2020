// just to avoid editing maps

/obj/item/reagent_containers/medigel/libital
	name = "medical gel (styptic)"
	desc = "A medical gel applicator bottle, designed for precision application, with an unscrewable cap. This one contains styptic powder, for treating cuts and bruises."
	icon_state = "brutegel"
	list_reagents = list(/datum/reagent/medicine/styptic_powder = 20)

/obj/item/reagent_containers/medigel/aiuri
	name = "medical gel (silver sulf)"
	desc = "A medical gel applicator bottle, designed for precision application, with an unscrewable cap. This one contains silver sulf, useful for treating burns."
	icon_state = "burngel"
	list_reagents = list(/datum/reagent/medicine/silver_sulfadiazine = 20)

/obj/item/reagent_containers/medigel/instabitaluri
	name = "medical gel (synthflesh)"
	desc = "A medical gel applicator bottle, designed for precision application, with an unscrewable cap. This one contains synthflesh, a brute and burn healing agent."
	icon_state = "synthgel"
	list_reagents = list(/datum/reagent/medicine/synthflesh = 60)
	custom_price = 80
