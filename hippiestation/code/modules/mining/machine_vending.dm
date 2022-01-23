
/obj/machinery/mineral/equipment_vendor/RedeemVoucher(obj/item/mining_voucher/voucher, mob/redeemer)
	var/items = list("Survival Capsule and Explorer's Webbing", "Resonator and Advanced Scanner", "Mining Drone", "Extraction and Rescue Kit", "Crusher Kit", "Mining Conscription Kit", "Mecha Plasma Cutter")

	var/selection = input(redeemer, "Pick your equipment", "Mining Voucher Redemption") as null|anything in items
	if(!selection || !Adjacent(redeemer) || QDELETED(voucher) || voucher.loc != redeemer)
		return
	switch(selection)
		if("Survival Capsule and Explorer's Webbing")
			new /obj/item/storage/belt/mining/vendor(src.loc)
		if("Resonator and Advanced Scanner")
			new /obj/item/resonator(src.loc)
			new /obj/item/t_scanner/adv_mining_scanner(src.loc)
		if("Mining Drone")
			new /mob/living/simple_animal/hostile/mining_drone(src.loc)
			new /obj/item/weldingtool/hugetank(src.loc)
			new /obj/item/clothing/glasses/welding(src.loc)
		if("Extraction and Rescue Kit")
			new /obj/item/extraction_pack(loc)
			new /obj/item/fulton_core(loc)
			new /obj/item/stack/marker_beacon/thirty(loc)
		if("Crusher Kit")
			new /obj/item/twohanded/required/kinetic_crusher(loc)
			new /obj/item/storage/belt/mining/alt(loc)
			new /obj/item/extinguisher/mini(loc)
		if("Mining Conscription Kit")
			new /obj/item/storage/backpack/duffelbag/mining_conscript(loc)
		if("Mecha Plasma Cutter")
			new /obj/item/mecha_parts/mecha_equipment/weapon/energy/plasma(loc)
			new /obj/item/weldingtool/hugetank(src.loc)
			new /obj/item/clothing/glasses/welding(src.loc)

	SSblackbox.record_feedback("tally", "mining_voucher_redeemed", 1, selection)
	qdel(voucher)


/obj/machinery/mineral/equipment_vendor/ui_interact(mob/user)
	. = ..()
	var/dat
	dat +="<div class='statusDisplay'>"
	if(istype(inserted_id))
		dat += "You have [inserted_id.mining_points] mining points collected. <A href='?src=[REF(src)];choice=eject'>Eject ID.</A><br>"
	else
		dat += "No ID inserted.  <A href='?src=[REF(src)];choice=insert'>Insert ID.</A><br>"
	dat += "</div>"
	dat += "<br><b>Equipment point cost list:</b><BR><table border='0' width='300'>"
	for(var/datum/data/mining_equipment/prize in prize_list)
		dat += "<tr><td>[prize.equipment_name]</td><td>[prize.cost]</td><td><A href='?src=[REF(src)];purchase=[REF(prize)]'>Purchase</A></td></tr>"
	dat += "</table>"

	var/datum/browser/popup = new(user, "miningvendor", "Mining Equipment Vendor", 400, 350)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/mineral/equipment_vendor/Topic(href, href_list)
	if(..())
		return
	if(href_list["choice"])
		if(istype(inserted_id))
			if(href_list["choice"] == "eject")
				to_chat(usr, "<span class='notice'>You eject the ID from [src]'s card slot.</span>")
				inserted_id.forceMove(loc)
				inserted_id.verb_pickup()
				inserted_id = null
		else if(href_list["choice"] == "insert")
			var/obj/item/card/id/I = usr.get_active_held_item()
			if(istype(I))
				if(!usr.transferItemToLoc(I, src))
					return
				inserted_id = I
				to_chat(usr, "<span class='notice'>You insert the ID into [src]'s card slot.</span>")
			else
				to_chat(usr, "<span class='warning'>Error: No valid ID!</span>")
				flick(icon_deny, src)
	if(href_list["purchase"])
		if(istype(inserted_id))
			var/datum/data/mining_equipment/prize = locate(href_list["purchase"]) in prize_list
			if (!prize || !(prize in prize_list))
				to_chat(usr, "<span class='warning'>Error: Invalid choice!</span>")
				flick(icon_deny, src)
				return
			if(prize.cost > inserted_id.mining_points)
				to_chat(usr, "<span class='warning'>Error: Insufficient points for [prize.equipment_name]!</span>")
				flick(icon_deny, src)
			else
				inserted_id.mining_points -= prize.cost
				to_chat(usr, "<span class='notice'>[src] clanks to life briefly before vending [prize.equipment_name]!</span>")
				new prize.equipment_path(src.loc)
				SSblackbox.record_feedback("nested tally", "mining_equipment_bought", 1, list("[type]", "[prize.equipment_path]"))
		else
			to_chat(usr, "<span class='warning'>Error: Please insert a valid ID!</span>")
			flick(icon_deny, src)
	updateUsrDialog()
	return

/obj/item/card/mining_point_card
	name = "mining points card"
	desc = "A small card preloaded with mining points. Swipe your ID card over it to transfer the points, then discard."
	icon_state = "data_1"
	var/points = 500

/obj/item/card/mining_point_card/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/card/id))
		if(points)
			var/obj/item/card/id/C = I
			C.mining_points += points
			to_chat(user, "<span class='info'>You transfer [points] points to [C].</span>")
			points = 0
		else
			to_chat(user, "<span class='info'>There's no points left on [src].</span>")
	..()

/obj/item/card/mining_point_card/examine(mob/user)
	. = ..()
	. += "<span class='notice>There's [points] point\s on the card.</span>"
