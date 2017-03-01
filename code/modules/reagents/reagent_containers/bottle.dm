//Not to be confused with /obj/item/weapon/reagent_containers/food/drinks/bottle

/obj/item/weapon/reagent_containers/glass/bottle
	name = "bottle"
	desc = "A small bottle."
	icon_state = "bottle"
	item_state = "atoxinbottle"
	possible_transfer_amounts = list(5,10,15,25,30)
	volume = 30


/obj/item/weapon/reagent_containers/glass/bottle/New()
	..()
	if(!icon_state)
		icon_state = "bottle"
	src.pixel_x = rand(-5, 5)
	src.pixel_y = rand(-5, 5)
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/update_icon()
	cut_overlays()
	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]-10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)
				filling.icon_state = "[icon_state]-10"
			if(10 to 29)
				filling.icon_state = "[icon_state]25"
			if(30 to 49)
				filling.icon_state = "[icon_state]50"
			if(50 to 69)
				filling.icon_state = "[icon_state]75"
			if(70 to INFINITY)
				filling.icon_state = "[icon_state]100"

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		add_overlay(filling)

/obj/item/weapon/reagent_containers/glass/bottle/epinephrine
	name = "epinephrine bottle"
	desc = "A small bottle. Contains epinephrine - used to stabilize patients."
	list_reagents_fill = list("epinephrine")

/obj/item/weapon/reagent_containers/glass/bottle/toxin
	name = "toxin bottle"
	desc = "A small bottle of toxins. Do not drink, it is poisonous."
	list_reagents_fill = list("toxin")

/obj/item/weapon/reagent_containers/glass/bottle/cyanide
	name = "cyanide bottle"
	desc = "A small bottle of cyanide. Bitter almonds?"
	list_reagents_fill = list("cyanide")

/obj/item/weapon/reagent_containers/glass/bottle/morphine
	name = "morphine bottle"
	desc = "A small bottle of morphine."
	list_reagents_fill = list("morphine")

/obj/item/weapon/reagent_containers/glass/bottle/chloralhydrate
	name = "choral hydrate bottle"
	desc = "A small bottle of choral hydrate. Mickey's Favorite!"
	list_reagents_fill = list("chloralhydrate")

/obj/item/weapon/reagent_containers/glass/bottle/antitoxin
	name = "anti-toxin bottle"
	desc = "A small bottle of anti-toxin. Heals toxin damage and removes toxins in the bloodstream. Overdose causes toxin damage."
	list_reagents_fill = list("antitoxin")

/obj/item/weapon/reagent_containers/glass/bottle/charcoal
	name = "charcoal bottle"
	desc = "A small bottle of charcoal. Heals toxin damage as well as slowly removing any other chemicals the patient has in their bloodstream."
	list_reagents_fill = list("charcoal")

/obj/item/weapon/reagent_containers/glass/bottle/cryoxadone
	name = "cryoxadone bottle"
	desc = "A small bottle of cryoxadone."
	list_reagents_fill = list("cryoxadone")

/obj/item/weapon/reagent_containers/glass/bottle/mutagen
	name = "unstable mutagen bottle"
	desc = "A small bottle of unstable mutagen. Randomly changes the DNA structure of whoever comes in contact."
	list_reagents_fill = list("mutagen")

/obj/item/weapon/reagent_containers/glass/bottle/plasma
	name = "liquid plasma bottle"
	desc = "A small bottle of liquid plasma. Extremely toxic and reacts with micro-organisms inside blood."
	list_reagents_fill = list("plasma")

/obj/item/weapon/reagent_containers/glass/bottle/synaptizine
	name = "synaptizine bottle"
	desc = "A small bottle of synaptizine."
	list_reagents_fill = list("synaptizine")

/obj/item/weapon/reagent_containers/glass/bottle/ammonia
	name = "ammonia bottle"
	desc = "A small bottle of ammonia."
	list_reagents_fill = list("ammonia")

/obj/item/weapon/reagent_containers/glass/bottle/diethylamine
	name = "diethylamine bottle"
	desc = "A small bottle of diethylamine."
	list_reagents_fill = list("diethylamine")

/obj/item/weapon/reagent_containers/glass/bottle/facid
	name = "fluorosulfuric acid Bottle"
	desc = "A small bottle. Contains a small amount of fluorosulfuric acid"
	list_reagents_fill = list("facid")

/obj/item/weapon/reagent_containers/glass/bottle/adminordrazine
	name = "adminordrazine bottle"
	desc = "A small bottle. Contains the liquid essence of the gods."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "holyflask"
	list_reagents_fill = list("adminordrazine")

/obj/item/weapon/reagent_containers/glass/bottle/capsaicin
	name = "capsaicin bottle"
	desc = "A small bottle. Contains hot sauce."
	list_reagents_fill = list("capsaicin")

/obj/item/weapon/reagent_containers/glass/bottle/frostoil
	name = "frost oil bottle"
	desc = "A small bottle. Contains cold sauce."
	list_reagents_fill = list("frostoil")

/obj/item/weapon/reagent_containers/glass/bottle/traitor
	name = "syndicate bottle"
	desc = "A small bottle. Contains a random nasty chemical."
	var/extra_reagent = null

/obj/item/weapon/reagent_containers/glass/bottle/traitor/New()
	..()
	extra_reagent = pick("polonium", "histamine", "formaldehyde", "venom", "neurotoxin2", "cyanide")
	reagents.add_reagent("[extra_reagent]", 3)

/obj/item/weapon/reagent_containers/glass/bottle/polonium
	name = "polonium bottle"
	desc = "A small bottle. Contains Polonium."
	list_reagents_fill = list("polonium")

/obj/item/weapon/reagent_containers/glass/bottle/venom
	name = "venom bottle"
	desc = "A small bottle. Contains Venom."
	list_reagents_fill = list("venom")

/obj/item/weapon/reagent_containers/glass/bottle/neurotoxin2
	name = "neurotoxin bottle"
	desc = "A small bottle. Contains Neurotoxin."
	list_reagents_fill = list("neurotoxin2")

/obj/item/weapon/reagent_containers/glass/bottle/formaldehyde
	name = "formaldehyde bottle"
	desc = "A small bottle. Contains Formaldehyde."
	list_reagents_fill = list("formaldehyde")

/obj/item/weapon/reagent_containers/glass/bottle/initropidril
	name = "initropidril bottle"
	desc = "A small bottle. Contains initropidril."
	list_reagents_fill = list("initropidril")

/obj/item/weapon/reagent_containers/glass/bottle/pancuronium
	name = "pancuronium bottle"
	desc = "A small bottle. Contains pancuronium."
	list_reagents_fill = list("pancuronium")

/obj/item/weapon/reagent_containers/glass/bottle/sodium_thiopental
	name = "sodium thiopental bottle"
	desc = "A small bottle. Contains sodium thiopental."
	list_reagents_fill = list("sodium_thiopental")

/obj/item/weapon/reagent_containers/glass/bottle/coniine
	name = "coniine bottle"
	desc = "A small bottle. Contains coniine."
	list_reagents_fill = list("coniine")

/obj/item/weapon/reagent_containers/glass/bottle/curare
	name = "curare bottle"
	desc = "A small bottle. Contains curare."
	list_reagents_fill = list("curare")

/obj/item/weapon/reagent_containers/glass/bottle/amanitin
	name = "amanitin bottle"
	desc = "A small bottle. Contains amanitin."
	list_reagents_fill = list("amanitin")

/obj/item/weapon/reagent_containers/glass/bottle/histamine
	name = "histamine bottle"
	desc = "A small bottle. Contains Histamine."
	list_reagents_fill = list("histamine")

/obj/item/weapon/reagent_containers/glass/bottle/diphenhydramine
	name = "antihistamine bottle"
	desc = "A small bottle of diphenhydramine."
	list_reagents_fill = list("diphenhydramine")

/obj/item/weapon/reagent_containers/glass/bottle/potass_iodide
	name = "anti-radiation bottle"
	desc = "A small bottle of potassium iodide."
	list_reagents_fill = list("potass_iodide")

/obj/item/weapon/reagent_containers/glass/bottle/salglu_solution
	name = "saline-glucose solution bottle"
	desc = "A small bottle of saline-glucose solution."
	list_reagents_fill = list("salglu_solution")

/obj/item/weapon/reagent_containers/glass/bottle/atropine
	name = "atropine bottle"
	desc = "A small bottle of atropine."
	list_reagents_fill = list("atropine")

/obj/item/weapon/reagent_containers/glass/bottle/romerol
	name = "romerol bottle"
	desc = "A small bottle of Romerol. The REAL zombie powder."
	list_reagents_fill = list("romerol")

/obj/item/weapon/reagent_containers/glass/bottle/flu_virion
	name = "flu virion culture bottle"
	desc = "A small bottle. Contains H13N1 flu virion culture in synthblood medium."
	spawned_disease = /datum/disease/advance/flu

/obj/item/weapon/reagent_containers/glass/bottle/epiglottis_virion
	name = "epiglottis virion culture bottle"
	desc = "A small bottle. Contains Epiglottis virion culture in synthblood medium."
	spawned_disease = /datum/disease/advance/voice_change

/obj/item/weapon/reagent_containers/glass/bottle/liver_enhance_virion
	name = "liver enhancement virion culture bottle"
	desc = "A small bottle. Contains liver enhancement virion culture in synthblood medium."
	spawned_disease = /datum/disease/advance/heal

/obj/item/weapon/reagent_containers/glass/bottle/hullucigen_virion
	name = "hullucigen virion culture bottle"
	desc = "A small bottle. Contains hullucigen virion culture in synthblood medium."
	spawned_disease = /datum/disease/advance/hullucigen

/obj/item/weapon/reagent_containers/glass/bottle/pierrot_throat
	name = "pierrot's Throat culture bottle"
	desc = "A small bottle. Contains H0NI<42 virion culture in synthblood medium."
	spawned_disease = /datum/disease/pierrot_throat

/obj/item/weapon/reagent_containers/glass/bottle/cold
	name = "rhinovirus culture bottle"
	desc = "A small bottle. Contains XY-rhinovirus culture in synthblood medium."
	spawned_disease = /datum/disease/advance/cold

/obj/item/weapon/reagent_containers/glass/bottle/retrovirus
	name = "retrovirus culture bottle"
	desc = "A small bottle. Contains a retrovirus culture in a synthblood medium."
	spawned_disease = /datum/disease/dna_retrovirus

/obj/item/weapon/reagent_containers/glass/bottle/gbs
	name = "GBS culture bottle"
	desc = "A small bottle. Contains Gravitokinetic Bipotential SADS+ culture in synthblood medium."//Or simply - General BullShit
	amount_per_transfer_from_this = 5
	spawned_disease = /datum/disease/gbs

/obj/item/weapon/reagent_containers/glass/bottle/fake_gbs
	name = "GBS culture bottle"
	desc = "A small bottle. Contains Gravitokinetic Bipotential SADS- culture in synthblood medium."//Or simply - General BullShit
	icon_state = "bottle3"
	spawned_disease = /datum/disease/fake_gbs

/obj/item/weapon/reagent_containers/glass/bottle/brainrot
	name = "brainrot culture bottle"
	desc = "A small bottle. Contains Cryptococcus Cosmosis culture in synthblood medium."
	spawned_disease = /datum/disease/brainrot

/obj/item/weapon/reagent_containers/glass/bottle/magnitis
	name = "magnitis culture bottle"
	desc = "A small bottle. Contains a small dosage of Fukkos Miracos."
	spawned_disease = /datum/disease/magnitis

/obj/item/weapon/reagent_containers/glass/bottle/wizarditis
	name = "wizarditis culture bottle"
	desc = "A small bottle. Contains a sample of Rincewindus Vulgaris."
	spawned_disease = /datum/disease/wizarditis

/obj/item/weapon/reagent_containers/glass/bottle/anxiety
	name = "severe anxiety culture bottle"
	desc = "A small bottle. Contains a sample of Lepidopticides."
	spawned_disease = /datum/disease/anxiety

/obj/item/weapon/reagent_containers/glass/bottle/beesease
	name = "beesease culture bottle"
	desc = "A small bottle. Contains a sample of invasive Apidae."
	spawned_disease = /datum/disease/beesease

/obj/item/weapon/reagent_containers/glass/bottle/fluspanish
	name = "spanish flu culture bottle"
	desc = "A small bottle. Contains a sample of Inquisitius."
	spawned_disease = /datum/disease/fluspanish

/obj/item/weapon/reagent_containers/glass/bottle/tuberculosis
	name = "fungal tuberculosis culture bottle"
	desc = "A small bottle. Contains a sample of Fungal Tubercle bacillus."
	spawned_disease = /datum/disease/tuberculosis

/obj/item/weapon/reagent_containers/glass/bottle/tuberculosiscure
	name = "BVAK bottle"
	desc = "A small bottle containing Bio Virus Antidote Kit."
	list_reagents = list("atropine" = 5, "epinephrine" = 5, "salbutamol" = 10, "spaceacillin" = 10)

/obj/item/weapon/reagent_containers/glass/bottle/precision
	name = "bottle"
	desc = "A precision bottle."
	possible_transfer_amounts = list(1,2,5,10,15,25,50)
	volume = 50

/obj/item/weapon/reagent_containers/glass/bottle/precision/plasma
	name = "liquid plasma bottle"
	desc = "A precision bottle of liquid plasma. Extremely toxic and reacts with micro-organisms inside blood."
	list_reagents_fill = list("plasma")

/obj/item/weapon/reagent_containers/glass/bottle/synaptizine
	name = "synaptizine bottle"
	desc = "A precision bottle of synaptizine."
	list_reagents_fill = list("synaptizine")

/obj/item/weapon/reagent_containers/glass/bottle/precision/mutagen
	name = "unstable mutagen bottle"
	desc = "A precision bottle of unstable mutagen. Randomly changes the DNA structure of whoever comes in contact."
	list_reagents_fill = list("mutagen")

/obj/item/weapon/reagent_containers/glass/bottle/precision/eznutriment
	name = "bottle of E-Z-Nutrient"
	desc = "A precision bottle of e-z-nutrient. Contains a fertilizer that causes mild mutations with each harvest."
	list_reagents_fill = list("eznutriment")

/obj/item/weapon/reagent_containers/glass/bottle/precision/left4zednutriment
	name = "bottle of Left 4 Zed"
	desc = "A precision bottle of left 4 zed. Contains a fertilizer that limits plant yields to no more than one and causes significant mutations in plants."
	list_reagents_fill = list("left4zednutriment")

/obj/item/weapon/reagent_containers/glass/bottle/precision/robustharvestnutriment
	name = "bottle of Robust Harvest"
	desc = "A precision bottle of robust harvest. Contains a fertilizer that doubles the yield of a plant while causing no mutations."
	list_reagents_fill = list("robustharvestnutriment")

/obj/item/weapon/reagent_containers/glass/bottle/precision/plantbgone
	name = "bottle of plant-b-gone"
	desc = "A precision bottle of plant-b-gone. Contains a chemical toxic to plants kills them fast."
	list_reagents_fill = list("plantbgone")

/obj/item/weapon/reagent_containers/glass/bottle/precision/weedkiller
	name = "bottle of weed killer"
	desc = "A precision bottle of weed killer. Contains a herbicide."
	list_reagents_fill = list("weedkiller")

/obj/item/weapon/reagent_containers/glass/bottle/precision/pestkiller
	name = "bottle of pest killer"
	desc = "A precision bottle of pest killer. Contains a pesticide."
	list_reagents_fill = list("pestkiller")

/obj/item/weapon/reagent_containers/glass/bottle/precision/ash
	name = "bottle of ash"
	desc = "A precision bottle of ash. Contains a weak fertilizer that very slightly heals the plant while also killing weeds."
	list_reagents_fill = list("ash")

/obj/item/weapon/reagent_containers/glass/bottle/precision/ammonia
	name = "bottle of ammonia"
	desc = "A precision bottle of ammonia. Contains a fertilizer that slightly heals the plant while also in a sufficient amount able to increase plant yield."
	list_reagents_fill = list("ammonia")

/obj/item/weapon/reagent_containers/glass/bottle/precision/saltpetre
	name = "bottle of saltpetre"
	desc = "A precision bottle of saltpetre. Contains a chemical that very slightly heals the plant while also in a sufficient amount able to increase plant potency and growth rate."
	list_reagents_fill = list("saltpetre")

/obj/item/weapon/reagent_containers/glass/bottle/precision/diethylamine
	name = "bottle of diethylamine"
	desc = "A precision bottle of diethylamine. Contains a strong fertilizer that heals the plant while also killing pests and in a sufficient amount able to increase plant yield at double the rate of ammonia."
	list_reagents_fill = list("diethylamine")