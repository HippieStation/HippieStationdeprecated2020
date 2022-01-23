/datum/borer_chem
	var/chemname
	var/chem_desc = "This is a chemical"
	var/chemuse = 30
	var/quantity = 10

/datum/borer_chem/epinephrine
	chemname = /datum/reagent/medicine/epinephrine
	chem_desc = "Stabilizes critical condition and slowly restores oxygen damage. If overdosed, it will deal toxin and oxyloss damage."

/datum/borer_chem/leporazine
	chemname = /datum/reagent/medicine/leporazine
	chem_desc = "This keeps a patient's body temperature stable. High doses can allow short periods of unprotected EVA."
	chemuse = 75

/datum/borer_chem/mannitol
	chemname = /datum/reagent/medicine/mannitol
	chem_desc = "Heals brain damage."

/datum/borer_chem/bicaridine
	chemname = /datum/reagent/medicine/bicaridine
	chem_desc = "Heals brute damage."

/datum/borer_chem/kelotane
	chemname = /datum/reagent/medicine/kelotane
	chem_desc = "Heals burn damage."

/datum/borer_chem/charcoal
	chemname = /datum/reagent/medicine/charcoal
	chem_desc = "Slowly heals toxin damage, will also slowly remove any other chemicals."

/datum/borer_chem/methamphetamine
	chemname = /datum/reagent/drug/methamphetamine
	chem_desc = "Reduces stun times, increases stamina and run speed while dealing brain damage. If overdosed it will deal toxin and brain damage."
	chemuse = 50
	quantity = 9

/datum/borer_chem/salbutamol
	chemname = /datum/reagent/medicine/salbutamol
	chem_desc = "Heals suffocation damage."

/datum/borer_chem/spacedrugs
	chemname = /datum/reagent/drug/space_drugs
	chem_desc = "Get your host high as a kite."
	chemuse = 75

/datum/borer_chem/creagent
	chemname = /datum/reagent/colorful_reagent/crayonpowder
	chem_desc = "Change the colour of your host."
	chemuse = 5 //le epic meme colourchange - no point in having it so high since its just a meme

/datum/borer_chem/ethanol
	chemname = /datum/reagent/consumable/ethanol
	chem_desc = "The most potent alcoholic 'beverage', with the fastest toxicity."
	chemuse = 50

/datum/borer_chem/rezadone
	chemname = /datum/reagent/medicine/rezadone
	chem_desc = "Heals cellular damage."
