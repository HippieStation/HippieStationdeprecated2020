//This file exists purely to assign mass assign density values to reagents for use with the reagent forge without making a ton of unwanted references in our other reagent files
//assign any value that isn't density or a special effect in here and there will be space hell to pay


//BASE TYPES

/datum/reagent
	var/density = 2
	var/list/special_traits

/datum/reagent/toxin//ahaha no you can't have high force and traitorchem effects
	density = 1

/datum/reagent/consumable//meh
	density = 1.5

/datum/reagent/drug//drugs are on average less lethal than toxins
	density = 1.8

/datum/reagent/medicine//good man
	density = 0.5

//METALS

/datum/reagent/iron
	density = 6
	special_traits = list(SPECIAL_TRAIT_METALLIC, SPECIAL_TRAIT_SHARP)

/datum/reagent/uranium
	density = 12
	special_traits = list(SPECIAL_TRAIT_METALLIC)