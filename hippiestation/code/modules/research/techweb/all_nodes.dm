/datum/techweb_node/bluebutt
	id = "bluebutt"
	display_name = "Butt Of Holding"
	description = "This butt has bluespace properties, letting you store more items in it. Four tiny items, or two small ones, or one normal one can fit."
	prereq_ids = list("micro_bluespace")
	design_ids = list("bluebutt")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	export_price = 10000

/datum/techweb_node/nanite_harmonic
	design_ids = list("fakedeath_nanites","aggressive_nanites","defib_nanites","regenerative_plus_nanites","brainheal_plus_nanites","purging_plus_nanites")

/datum/techweb_node/adv_datatheory
	id = "adv_datatheory"
	display_name = "Advanced Data Theory"
	description = "Better insight into programming and data."
	prereq_ids = list("datatheory")
	design_ids = list("icprinter", "icupgadv", "icupgclo")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	export_price = 5000

/datum/techweb_node/engineering
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/high_efficiency
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/practical_bluespace
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/emp_adv
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/emp_super
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/adv_bluetravel
	id = "advanced_bluetravel"
	display_name = "Advanced Bluespace Travel"
	description = "Using superior knowledge of bluespace, you can develop more finely-controlled teleportation equipment."
	prereq_ids = list("micro_bluespace", "bluespace_travel")
	design_ids = list("telepad", "telesci_console")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)
	export_price = 5000
	
//Because TG removed them
/datum/techweb_node/mech_taser	
	id = "mech_taser"	
	display_name =  "Exosuit Weapon (PBT \"Pacifier\" Mounted Taser)"	
	description = "A basic piece of mech weaponry"	
	prereq_ids = list("electronic_weapons")	
	design_ids = list("mech_taser")	
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)	
	export_price = 5000
	
/datum/techweb_node/adv_beam_weapons
	design_ids = list()
