/datum/component/rot
	var/amount = 1

/datum/component/rot/Initialize(new_amount)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	if(new_amount)
		amount = new_amount

	START_PROCESSING(SSprocessing, src)

/datum/component/rot/process()
	var/atom/A = parent

	var/turf/open/T = get_turf(A)
	if(!istype(T))
		return

	var/datum/gas_mixture/air = T.return_air()
	var/list/cached_gases = air.gases

	ASSERT_GAS(/datum/gas/miasma, air)
	cached_gases[/datum/gas/miasma][MOLES] += amount
	T.air_update_turf()

/datum/component/rot/corpse
	amount = MIASMA_CORPSE_MOLES

/datum/component/rot/corpse/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()

/datum/component/rot/corpse/process()
	var/mob/living/carbon/human/H = parent
	if(H.stat != DEAD)
		qdel(src)
		return

	// Wait a bit before decaying
	if(world.time - H.timeofdeath < 2 MINUTES)
		return

	// Properly stored corpses shouldn't create miasma
	if(istype(H.loc, /obj/structure/closet/crate/coffin)|| istype(H.loc, /obj/structure/closet/body_bag) || istype(H.loc, /obj/structure/bodycontainer))
		return

	// No decay if formaldehyde in corpse or when the corpse is charred
	if(H.reagents.has_reagent("formaldehyde", 15) || H.has_trait(TRAIT_HUSK))
		return

	// Also no decay if corpse chilled or not organic/undead
	if(H.bodytemperature <= T0C-10 || (!(MOB_ORGANIC in H.mob_biotypes) && !(MOB_UNDEAD in H.mob_biotypes)))
		return

	..()

/datum/component/rot/gibs
	amount = MIASMA_GIBS_MOLES
