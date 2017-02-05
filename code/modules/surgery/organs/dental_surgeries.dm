/datum/surgery/teeth_reinsertion
	name = "teeth reinsertion"
	steps = list(/datum/surgery_step/handle_teeth)
	possible_locs = list("mouth")

//handle cavity
/datum/surgery_step/handle_teeth
	accept_hand = 1
	accept_any_item = 1
	time = 64

/datum/surgery_step/handle_teeth/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/stack/teeth/T, datum/surgery/surgery)
	var/obj/item/bodypart/head/O = locate(/obj/item/bodypart/head) in target.bodyparts
	if(!O)
		user.visible_message("<span class='notice'>What the... [target] has no head!</span>")
		return -1
	if(istype(T))
		if(O.get_teeth() >= O.max_teeth)
			user << "<span class='notice'>All of [target]'s teeth are intact."
			return -1
		user.visible_message("<span class='notice'>[user] begins to insert [T] into [target]'s [target_zone].</span>")
	else
		user.visible_message("<span class='notice'>[user] checks for teeth in [target]'s [target_zone].</span>")

/datum/surgery_step/handle_teeth/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/stack/teeth/T, datum/surgery/surgery)
	var/obj/item/bodypart/head/O = locate(/obj/item/bodypart/head) in target.bodyparts
	if(!O)
		user.visible_message("<span class='notice'>What the... [target] has no head!</span>")
		return -1
	if(istype(T))
		if(O.get_teeth()) //Has teeth, check if they need "refilling"
			if(O.get_teeth() >= O.max_teeth)
				user.visible_message("<span class='notice'>[user] can't seem to fit [T] in [target]'s [target_zone].</span>", "<span class='notice'>All of [target]'s teeth are intact.</span>")
				return 0
			var/obj/item/stack/teeth/F = locate(T.type) in O.teeth_list //Look for same type of teeth inside target's mouth for merging
			var/amt = T.amount
			if(F)
				amt = T.merge(F) //Try to merge provided teeth into person's teeth.
			else
				amt = min(T.amount, O.max_teeth-O.get_teeth())
				T.use(amt)
				var/obj/item/stack/teeth/E = new T.type(target, amt)
				O.teeth_list += E
				// E.loc = target
				T = E
			user.visible_message("<span class='notice'>[user] inserts [amt] [T] into [target]'s [target_zone]!</span>")
			return 1
		else //No teeth to speak of.
			var/amt = min(T.amount, O.max_teeth)
			T.use(amt)
			var/obj/item/stack/teeth/F = new T.type(target, amt)
			O.teeth_list += F
			// F.loc = target
			T = F
			user.visible_message("<span class='notice'>[user] inserts [amt] [T] into [target]'s [target_zone]!</span>")
			return 1
	else
		if(O.teeth_list.len)
			user.visible_message("<span class='notice'>[user] pulls all teeth out of [target]'s [target_zone]!</span>")
			for(var/obj/item/stack/teeth/F in O.teeth_list)
				O.teeth_list -= F
				F.loc = get_turf(target)
			return 1
		else
			user.visible_message("<span class='notice'>[user] doesn't find anything in [target]'s [target_zone].</span>")
			return 0

