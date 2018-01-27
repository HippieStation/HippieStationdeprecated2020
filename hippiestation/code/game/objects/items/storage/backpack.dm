/obj/item/storage/backpack/duffelbag/syndie/med/bioterrorbundle
	desc = "A large duffel bag containing deadly chemicals, a chemical spray, a toxic foam grenade, a nerve gas grenade, a Donksoft assault rifle, riot grade darts, a minature syringe gun, and a box of syringes"

/obj/item/storage/backpack/duffelbag/syndie/med/bioterrorbundle/PopulateContents()
	new /obj/item/reagent_containers/spray/chemsprayer/bioterror(src)
	new /obj/item/storage/box/syndie_kit/chemical(src)
	new /obj/item/gun/syringe/syndicate(src)
	new /obj/item/gun/ballistic/automatic/c20r/toy(src)
	new /obj/item/storage/box/syringes(src)
	new /obj/item/ammo_box/foambox/riot(src)
	new /obj/item/grenade/chem_grenade/bioterrorfoam(src)
	new /obj/item/grenade/chem_grenade/saringas(src)
	
/obj/item/storage/backpack/duffelbag/syndie/surgery/PopulateContents()
	new /obj/item/scalpel/syndicate(src)
	new /obj/item/hemostat/syndicate(src)
	new /obj/item/retractor/syndicate(src)
	new /obj/item/circular_saw/syndicate(src)
	new /obj/item/surgicaldrill/syndicate(src)
	new /obj/item/cautery/syndicate(src)
	new /obj/item/surgical_drapes(src)
	new /obj/item/clothing/suit/straight_jacket(src)
	new /obj/item/clothing/mask/muzzle(src)
	new /obj/item/device/mmi/syndie(src)

/obj/item/storage/backpack/duffelbag
	slowdown = 1
	max_combined_w_class = 30
	var/adjusted = FALSE
	var/adjusted_max_combined_w_class = 21
	var/adjusted_slowdown = 0
	actions_types = list(/datum/action/item_action/adjust_bag)
	
/obj/item/storage/backpack/duffelbag/verb/adjust_bag(mob/living/user)
	set name = "Adjust Duffel Bag"
	set category = "Object"
	if (adjusted == FALSE)
		var/sum_w_class = 0
		for(var/obj/item/I in contents)
			sum_w_class += I.w_class
		if( sum_w_class > max_combined_w_class)
		to_chat(usr, "<span class='warning'>There's too many things in there to properly adjust the [src]!</span>")
		return 0
	else
		adjusted = !adjusted
		to_chat(user, "You adjust the [src], [adjusted ? "leaving less space, but making it easier to carry around" : "allowing you to carry more stuff, but slowing you down"]")
		slowdown = adjusted ? adjusted_slowdown : initial(slowdown)
		max_combined_w_class = adjusted ? adjusted_max_combined_w_class : initial(max_combined_w_class)
