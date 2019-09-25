/obj/item/reagent_containers/spray/cleaner
	volume = 250
	list_reagents = list(/datum/reagent/space_cleaner = 250)
	amount_per_transfer_from_this = 5
	stream_amount = 10

/obj/item/reagent_containers/medspray/styptic
	name = "medical spray (styptic powder)"
	desc = "A medical spray bottle, designed for precision application, with an unscrewable cap. This one contains styptic powder, for treating cuts and bruises."
	icon_state = "brutespray"
	list_reagents = list(/datum/reagent/medicine/styptic_powder = 60)

/obj/item/reagent_containers/medspray/silver_sulf
	name = "medical spray (silver sulfadiazine)"
	desc = "A medical spray bottle, designed for precision application, with an unscrewable cap. This one contains silver sulfadiazine, useful for treating burns."
	icon_state = "burnspray"
	list_reagents = list(/datum/reagent/medicine/silver_sulfadiazine = 60)

/obj/item/reagent_containers/medspray/synthflesh
	name = "medical spray (synthflesh)"
	desc = "A medical spray bottle, designed for precision application, with an unscrewable cap. This one contains synthflesh, an apex brute and burn healing agent."
	icon_state = "synthspray"
	list_reagents = list(/datum/reagent/medicine/synthflesh = 60)
	custom_price = 80

/obj/item/reagent_containers/medspray/sterilizine
	name = "sterilizer spray"
	desc = "Spray bottle loaded with non-toxic sterilizer. Useful in preparation for surgery."
	list_reagents = list(/datum/reagent/space_cleaner/sterilizine = 60)
