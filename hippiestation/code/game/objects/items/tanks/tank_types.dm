/obj/item/tank/internals/dwarf
	alternate_worn_icon = 'hippiestation/icons/mob/belt.dmi' // by the way, why do we put alternate_worn_icon first?
	name = "carbon dioxide internals tank"
	desc = "Your personal quick ticket to hell, unless you're a Dwarf."
	icon = 'hippiestation/icons/obj/tank.dmi' // yeah I used the old oxygen sprite. what are you gonna do about it?
	icon_state = "dwarftank"
	item_state = "dwarftank"
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	force = 4
	distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE
	volume = 8


/obj/item/tank/internals/dwarf/populate_gas()
	air_contents.assert_gas(/datum/gas/carbon_dioxide)
	air_contents.gases[/datum/gas/carbon_dioxide][MOLES] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)