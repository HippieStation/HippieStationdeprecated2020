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
	display_name = "Exosuit Weapon (PBT \"Pacifier\" Mounted Taser)"
	description = "A basic piece of mech weaponry"
	prereq_ids = list("electronic_weapons")
	design_ids = list("mech_taser")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	export_price = 5000

/datum/techweb_node/adv_beam_weapons
	design_ids = list()

///GAUSS RIFLE///
/*
/datum/techweb_node/electromagnetic_weapons
	id = "gauss_rifle"
	display_name = "Electromagnetic Weaponry(Gauss Rifle MK1)"
	description = "The gauss rifle, electromagnetic weaponry at its finest. You won't regret researching this."
	prereq_ids = list("adv_weaponry", "emp_adv")
	design_ids = list("gaussrifle")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	export_price = 5000
*/

/datum/techweb_node/adv_chem
	id = "adv_chem"
	display_name = "Advanced Chemistry"
	description = "Advanced chemical processing machines."
	prereq_ids = list("biotech")
	design_ids = list("lcass_pressure", "lcass_centrifuge", "lcass_radioactive", "lcass_bluespace")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	export_price = 5000

/datum/techweb_node/autodoc
	id = "autodoc"
	display_name = "Complex Anatomical Automation"
	description = "Advanced automation and complex anatomical knowhow combined to make advanced surgical things!"
	prereq_ids = list("exp_surgery", "bio_process", "adv_datatheory", "adv_engi", "high_efficiency")
	design_ids = list("autodoc")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 15000)
	export_price = 10000

/datum/techweb_node/clown
	design_ids = list("air_horn", "honker_main", "honker_peri", "honker_targ", "honk_chassis", "honk_head", "honk_torso", "honk_left_arm", "honk_right_arm",
	"honk_left_leg", "honk_right_leg", "mech_banana_mortar", "mech_mousetrap_mortar", "mech_honker", "mech_punching_face", "implant_trombone", "borg_transform_clown", "rubberducky")
