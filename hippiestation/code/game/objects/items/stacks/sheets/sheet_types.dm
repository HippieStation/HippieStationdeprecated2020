/obj/item/stack/sheet/mineral/reagent
	name = "reagent ingots"
	desc = "Ingots made out of treated solidified reagents"
	singular_name = "reagent ingot"
	icon_state = "sheet-silver"
	materials = list(MAT_REAGENT=MINERAL_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/mineral/reagent
	amount = 1
	max_amount = 50
	var/datum/reagent/reagent_type


/obj/item/stack/sheet/mineral/reagent/change_stack(mob/user,amount)
	var/obj/item/stack/sheet/mineral/reagent/F = new(user, amount, FALSE)
	if(!isnull(reagent_type))
		F.reagent_type = reagent_type
		F.name = "[reagent_type.name] ingots"
		F.singular_name = "[reagent_type.name] ingot"
		F.add_atom_colour(reagent_type.color, FIXED_COLOUR_PRIORITY)

	F.copy_evidences(src)
	user.put_in_hands(F)
	add_fingerprint(user)
	F.add_fingerprint(user)
	use(amount, TRUE)


/obj/item/stack/sheet/mineral/reagent/merge(obj/item/stack/S) //Merge src into S, as much as possible
	if(!istype(S, /obj/item/stack/sheet/mineral/reagent))
		return
	var/obj/item/stack/sheet/mineral/reagent/R = S
	if(QDELETED(S) || QDELETED(src) || S == src || !R.reagent_type || !reagent_type || R.reagent_type.id != reagent_type.id) //amusingly this can cause a stack to consume itself, let's not allow that.
		return

	var/transfer = get_amount()

	if(S.is_cyborg)
		transfer = min(transfer, round((S.source.max_energy - S.source.energy) / S.cost))
	else
		transfer = min(transfer, S.max_amount - S.amount)

	if(pulledby)
		pulledby.start_pulling(S)

	S.copy_evidences(src)
	use(transfer, TRUE)
	S.add(transfer)