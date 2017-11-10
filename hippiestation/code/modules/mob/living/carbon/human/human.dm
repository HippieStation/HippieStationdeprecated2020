/mob/living/carbon/human/create_internal_organs()
  internal_organs += new /obj/item/organ/butt
  return ..()

/mob/living/carbon/human/canSuicide()
	var/datum/mutation/human/HM = GLOB.mutations_list[CLUWNEMUT]
	if(dna.species.id == "tarajan" || dna.species.id == "meeseeks" || HM in dna.mutations)
		return FALSE
	else
		return ..()

/mob/living/carbon/human/canSuccumb()
	var/datum/mutation/human/HM = GLOB.mutations_list[CLUWNEMUT]
	if(dna.species.id == "tarajan" || dna.species.id == "meeseeks" || HM in dna.mutations)
		return FALSE
	else
		return ..()

/mob/living/carbon/human/canGhost()
	var/datum/mutation/human/HM = GLOB.mutations_list[CLUWNEMUT]
	if(dna.species.id == "tarajan" || dna.species.id == "meeseeks" || HM in dna.mutations)
		return FALSE
	else
		return ..()

/mob/living/carbon/human/show_inv(mob/user)
	user.set_machine(src)
	var/has_breathable_mask = istype(wear_mask, /obj/item/clothing/mask)
	var/list/obscured = check_obscured_slots()
	var/list/dat = list()

	dat += "<table>"
	for(var/i in 1 to held_items.len)
		var/obj/item/I = get_item_for_held_index(i)
		dat += "<tr><td><B>[get_held_index_name(i)]:</B></td><td><A href='?src=[REF(src)];item=[slot_hands];hand_index=[i]'>[(I && !(I.flags_1 & ABSTRACT_1)) ? I : "<font color=grey>Empty</font>"]</a></td></tr>"
	dat += "<tr><td>&nbsp;</td></tr>"

	dat += "<tr><td><B>Back:</B></td><td><A href='?src=[REF(src)];item=[slot_back]'>[(back && !(back.flags_1&ABSTRACT_1)) ? back : "<font color=grey>Empty</font>"]</A>"
	if(has_breathable_mask && istype(back, /obj/item/tank))
		dat += "&nbsp;<A href='?src=[REF(src)];internal=[slot_back]'>[internal ? "Disable Internals" : "Set Internals"]</A>"

	dat += "</td></tr><tr><td>&nbsp;</td></tr>"

	dat += "<tr><td><B>Head:</B></td><td><A href='?src=[REF(src)];item=[slot_head]'>[(head && !(head.flags_1&ABSTRACT_1)) ? head : "<font color=grey>Empty</font>"]</A></td></tr>"

	if(slot_wear_mask in obscured)
		dat += "<tr><td><font color=grey><B>Mask:</B></font></td><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><B>Mask:</B></td><td><A href='?src=[REF(src)];item=[slot_wear_mask]'>[(wear_mask && !(wear_mask.flags_1&ABSTRACT_1)) ? wear_mask : "<font color=grey>Empty</font>"]</A></td></tr>"

	if(slot_neck in obscured)
		dat += "<tr><td><font color=grey><B>Neck:</B></font></td><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><B>Neck:</B></td><td><A href='?src=[REF(src)];item=[slot_neck]'>[(wear_neck && !(wear_neck.flags_1&ABSTRACT_1)) ? wear_neck : "<font color=grey>Empty</font>"]</A></td></tr>"

	if(slot_glasses in obscured)
		dat += "<tr><td><font color=grey><B>Eyes:</B></font></td><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><B>Eyes:</B></td><td><A href='?src=[REF(src)];item=[slot_glasses]'>[(glasses && !(glasses.flags_1&ABSTRACT_1))	? glasses : "<font color=grey>Empty</font>"]</A></td></tr>"

	if(slot_ears in obscured)
		dat += "<tr><td><font color=grey><B>Ears:</B></font></td><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><B>Ears:</B></td><td><A href='?src=[REF(src)];item=[slot_ears]'>[(ears && !(ears.flags_1&ABSTRACT_1))		? ears		: "<font color=grey>Empty</font>"]</A></td></tr>"

	dat += "<tr><td>&nbsp;</td></tr>"

	dat += "<tr><td><B>Exosuit:</B></td><td><A href='?src=[REF(src)];item=[slot_wear_suit]'>[(wear_suit && !(wear_suit.flags_1&ABSTRACT_1)) ? wear_suit : "<font color=grey>Empty</font>"]</A></td></tr>"
	if(wear_suit)
		dat += "<tr><td>&nbsp;&#8627;<B>Suit Storage:</B></td><td><A href='?src=[REF(src)];item=[slot_s_store]'>[(s_store && !(s_store.flags_1&ABSTRACT_1)) ? s_store : "<font color=grey>Empty</font>"]</A>"
		if(has_breathable_mask && istype(s_store, /obj/item/tank))
			dat += "&nbsp;<A href='?src=[REF(src)];internal=[slot_s_store]'>[internal ? "Disable Internals" : "Set Internals"]</A>"
		dat += "</td></tr>"
	else
		dat += "<tr><td><font color=grey>&nbsp;&#8627;<B>Suit Storage:</B></font></td></tr>"

	if(slot_shoes in obscured)
		dat += "<tr><td><font color=grey><B>Shoes:</B></font></td><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><B>Shoes:</B></td><td><A href='?src=[REF(src)];item=[slot_shoes]'>[(shoes && !(shoes.flags_1&ABSTRACT_1))		? shoes		: "<font color=grey>Empty</font>"]</A></td></tr>"

	if(slot_gloves in obscured)
		dat += "<tr><td><font color=grey><B>Gloves:</B></font></td><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><B>Gloves:</B></td><td><A href='?src=[REF(src)];item=[slot_gloves]'>[(gloves && !(gloves.flags_1&ABSTRACT_1))		? gloves	: "<font color=grey>Empty</font>"]</A></td></tr>"

	if(slot_w_uniform in obscured)
		dat += "<tr><td><font color=grey><B>Uniform:</B></font></td><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><B>Uniform:</B></td><td><A href='?src=[REF(src)];item=[slot_w_uniform]'>[(w_uniform && !(w_uniform.flags_1&ABSTRACT_1)) ? w_uniform : "<font color=grey>Empty</font>"]</A></td></tr>"

	if((w_uniform == null && !(dna && dna.species.nojumpsuit)) || (slot_w_uniform in obscured))
		dat += "<tr><td><font color=grey>&nbsp;&#8627;<B>Pockets:</B></font></td></tr>"
		dat += "<tr><td><font color=grey>&nbsp;&#8627;<B>ID:</B></font></td></tr>"
		dat += "<tr><td><font color=grey>&nbsp;&#8627;<B>Belt:</B></font></td></tr>"
	else
		dat += "<tr><td>&nbsp;&#8627;<B>Belt:</B></td><td><A href='?src=[REF(src)];item=[slot_belt]'>[(belt && !(belt.flags_1&ABSTRACT_1)) ? belt : "<font color=grey>Empty</font>"]</A>"
		if(has_breathable_mask && istype(belt, /obj/item/tank))
			dat += "&nbsp;<A href='?src=[REF(src)];internal=[slot_belt]'>[internal ? "Disable Internals" : "Set Internals"]</A>"
		dat += "</td></tr>"
		dat += "<tr><td>&nbsp;&#8627;<B>Pockets:</B></td><td><A href='?src=[REF(src)];pockets=left'>[(l_store && !(l_store.flags_1&ABSTRACT_1)) ? "Left (Full)" : "<font color=grey>Left (Empty)</font>"]</A>"
		dat += "&nbsp;<A href='?src=[REF(src)];pockets=right'>[(r_store && !(r_store.flags_1&ABSTRACT_1)) ? "Right (Full)" : "<font color=grey>Right (Empty)</font>"]</A></td></tr>"
		dat += "<tr><td>&nbsp;&#8627;<B>ID:</B></td><td><A href='?src=[REF(src)];item=[slot_wear_id]'>[(wear_id && !(wear_id.flags_1&ABSTRACT_1)) ? wear_id : "<font color=grey>Empty</font>"]</A></td></tr>"

	if(handcuffed)
		dat += "<tr><td><B>Handcuffed:</B> <A href='?src=[REF(src)];item=[slot_handcuffed]'>Remove</A></td></tr>"
	if(legcuffed)
		dat += "<tr><td><A href='?src=[REF(src)];item=[slot_legcuffed]'>Legcuffed</A></td></tr>"

	for(var/I in bodyparts)
		if(istype(I, /obj/item/bodypart))
			var/obj/item/bodypart/L = I

			for(var/obj/item/J in L.embedded_objects)
				dat += "<tr><td><a href='byond://?src=\ref[src];embedded_object=\ref[J];embedded_limb=\ref[L]'>Embedded in [L]: [J] [J.pinned ? "(Pinned down)" : ""]</a><br></td></tr>"

	dat += {"</table>
	<A href='?src=[REF(user)];mach_close=mob[REF(src)]'>Close</A>
	"}

	var/datum/browser/popup = new(user, "mob[REF(src)]", "[src]", 440, 510)
	popup.set_content(dat.Join())
	popup.open()


/mob/living/carbon/human/Topic(href, href_list)
	if(usr.canUseTopic(src, BE_CLOSE, NO_DEXTERY))
		if(href_list["embedded_object"])
			var/obj/item/bodypart/L = locate(href_list["embedded_limb"]) in bodyparts
			if(!L)
				return
			var/obj/item/I = locate(href_list["embedded_object"]) in L.embedded_objects
			if(!I || I.loc != src) //no item, no limb, or item is not in limb or in the person anymore
				return
			var/time_taken = I.embedded_unsafe_removal_time*I.w_class

			if (I.pinned)
				time_taken += 10 // Increase time since you're pinned down

			usr.visible_message("<span class='warning'>[usr] attempts to remove [I] from their [L.name].</span>","<span class='notice'>You attempt to remove [I] from your [L.name]... (It will take [DisplayTimeText(time_taken)].)</span>")
			if(do_after(usr, time_taken, needhand = 1, target = src))
				if(!I || !L || I.loc != src || !(I in L.embedded_objects))
					return
				L.embedded_objects -= I
				L.receive_damage(I.embedded_unsafe_removal_pain_multiplier*I.w_class)//It hurts to rip it out, get surgery you dingus.

				if (I.pinned)
					do_pindown(src.pinned_to, 0)
					src.pinned_to = null
					src.anchored = 0
					update_canmove()
					I.pinned = null

				// Don't move stacks because it could merge items still embedded
				if (!istype(I, /obj/item/stack))
					I.forceMove(get_turf(src))

				usr.put_in_hands(I)
				emote("scream")

				visible_message("[usr] successfully rips \the [I] out of [usr == src ? "their" : name + "'s"] [L.name]!",\
								"<span class='notice'>You successfully remove \the [I] from [usr == src ? "your" : name + "'s"] [L.name].</span>")
				if(!has_embedded_objects())
					clear_alert("embeddedobject")
			return

		if(href_list["item"])
			var/slot = text2num(href_list["item"])
			if(slot in check_obscured_slots())
				to_chat(usr, "<span class='warning'>You can't reach that! Something is covering it.</span>")
				return

		if(href_list["pockets"])
			var/pocket_side = href_list["pockets"]
			var/pocket_id = (pocket_side == "right" ? slot_r_store : slot_l_store)
			var/obj/item/pocket_item = (pocket_id == slot_r_store ? r_store : l_store)
			var/obj/item/place_item = usr.get_active_held_item() // Item to place in the pocket, if it's empty

			var/delay_denominator = 1
			if(pocket_item && !(pocket_item.flags_1&ABSTRACT_1))
				if(pocket_item.flags_1 & NODROP_1)
					to_chat(usr, "<span class='warning'>You try to empty [src]'s [pocket_side] pocket, it seems to be stuck!</span>")
				to_chat(usr, "<span class='notice'>You try to empty [src]'s [pocket_side] pocket.</span>")
			else if(place_item && place_item.mob_can_equip(src, usr, pocket_id, 1) && !(place_item.flags_1&ABSTRACT_1))
				to_chat(usr, "<span class='notice'>You try to place [place_item] into [src]'s [pocket_side] pocket.</span>")
				delay_denominator = 4
			else
				return

			if(do_mob(usr, src, POCKET_STRIP_DELAY/delay_denominator)) //placing an item into the pocket is 4 times faster
				if(pocket_item)
					if(pocket_item == (pocket_id == slot_r_store ? r_store : l_store)) //item still in the pocket we search
						dropItemToGround(pocket_item)
				else
					if(place_item)
						if(place_item.mob_can_equip(src, usr, pocket_id, FALSE, TRUE))
							usr.temporarilyRemoveItemFromInventory(place_item, TRUE)
							equip_to_slot(place_item, pocket_id, TRUE)
						//do nothing otherwise

				// Update strip window
				if(usr.machine == src && in_range(src, usr))
					show_inv(usr)
			else
				// Display a warning if the user mocks up
				to_chat(src, "<span class='warning'>You feel your [pocket_side] pocket being fumbled with!</span>")

		..()
