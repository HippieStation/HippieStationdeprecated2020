/obj/item/reagent_containers/glass/bottle/precision
	name = "bottle"
	desc = "A precision bottle."
	possible_transfer_amounts = list(1,2,5,10,15,25,50)
	volume = 50

/obj/item/reagent_containers/glass/bottle/precision/plasma
	name = "liquid plasma bottle"
	desc = "A precision bottle of liquid plasma. Extremely toxic and reacts with micro-organisms inside blood."
	list_reagents = list(/datum/reagent/toxin/plasma = 50)

/obj/item/reagent_containers/glass/bottle/synaptizine
	name = "synaptizine bottle"
	desc = "A precision bottle of synaptizine."
	list_reagents = list(/datum/reagent/medicine/synaptizine = 50)

/obj/item/reagent_containers/glass/bottle/precision/mutagen
	name = "unstable mutagen bottle"
	desc = "A precision bottle of unstable mutagen. Randomly changes the DNA structure of whoever comes in contact."
	list_reagents = list(/datum/reagent/toxin/mutagen = 50)

/obj/item/reagent_containers/glass/bottle/precision/eznutriment
	name = "bottle of E-Z-Nutrient"
	desc = "A precision bottle of e-z-nutrient. Contains a fertilizer that causes mild mutations with each harvest."
	list_reagents = list(/datum/reagent/plantnutriment/eznutriment = 50)

/obj/item/reagent_containers/glass/bottle/precision/left4zed
	name = "bottle of Left 4 Zed"
	desc = "A precision bottle of left 4 zed. Contains a fertilizer that limits plant yields to no more than one and causes significant mutations in plants."
	list_reagents = list(/datum/reagent/plantnutriment/left4zednutriment = 50)

/obj/item/reagent_containers/glass/bottle/precision/robustharvest
	name = "bottle of Robust Harvest"
	desc = "A precision bottle of robust harvest. Contains a fertilizer that doubles the yield of a plant while causing no mutations."
	list_reagents = list(/datum/reagent/plantnutriment/robustharvestnutriment = 50)

/obj/item/reagent_containers/glass/bottle/precision/ash
	name = "bottle of ash"
	desc = "A precision bottle of ash. Contains a weak fertilizer that very slightly heals the plant while also killing weeds."
	list_reagents = list(/datum/reagent/ash = 50)

/obj/item/reagent_containers/glass/bottle/precision/ammonia
	name = "bottle of ammonia"
	desc = "A precision bottle of ammonia. Contains a fertilizer that slightly heals the plant while also in a sufficient amount able to increase plant yield."
	list_reagents = list(/datum/reagent/ammonia = 50)

/obj/item/reagent_containers/glass/bottle/precision/saltpetre
	name = "bottle of saltpetre"
	desc = "A precision bottle of saltpetre. Contains a chemical that very slightly heals the plant while also in a sufficient amount able to increase plant potency and growth rate."
	list_reagents = list(/datum/reagent/saltpetre = 50)

/obj/item/reagent_containers/glass/bottle/precision/diethylamine
	name = "bottle of diethylamine"
	desc = "A precision bottle of diethylamine. Contains a strong fertilizer that heals the plant while also killing pests and in a sufficient amount able to increase plant yield at double the rate of ammonia."
	list_reagents = list(/datum/reagent/diethylamine = 50)

/////////////////////////////////////////////
/////////	HIPPIE VIRUS BOTTLES	/////////
/////////////////////////////////////////////
//Custom Hippie virus bottles

/obj/item/reagent_containers/glass/bottle/fluxitus	//Please for the love of god only ever spawn this for mega badminbus
	name = "Fluxitus bottle"
	desc = "OOF!"
	spawned_disease = /datum/disease/fluxitus

/obj/item/reagent_containers/glass/bottle/godblood	//Yeah only spawn this for adminbus as well
	name = "Godblood bottle"
	desc = "A mysterious bottle, rumoured to be infused with the blood of fallen gods."
	spawned_disease = /datum/disease/advance/heal/godblood

//////////////////////////////////////
/////////	PORTED FROM TG	 /////////
//////////////////////////////////////
//Bottles that no longer exist in TG

/obj/item/reagent_containers/glass/bottle/epiglottis_virion
	name = "Epiglottis virion culture bottle"
	desc = "A small bottle. Contains Epiglottis virion culture in synthblood medium."
	spawned_disease = /datum/disease/advance/voice_change

/obj/item/reagent_containers/glass/bottle/liver_enhance_virion
	name = "Liver enhancement virion culture bottle"
	desc = "A small bottle. Contains liver enhancement virion culture in synthblood medium."
	spawned_disease = /datum/disease/advance/heal/toxin

/obj/item/reagent_containers/glass/bottle/hallucigen_virion
	name = "Hallucigen virion culture bottle"
	desc = "A small bottle. Contains hallucigen virion culture in synthblood medium."
	spawned_disease = /datum/disease/advance/hallucigen
