// adds bio bag of holding to applied bluespace
/datum/techweb_node/practical_bluespace
	design_ids = list("bs_rped","minerbag_holding", "bluespacebeaker", "bluespacesyringe", "bluespacebodybag", "phasic_scanning", "roastingstick", "ore_silo", "biobag_holding")


//TG coders manage to fuck botany research wew
/datum/techweb_node/botany
	id = "botany"
	display_name = "Botanical Engineering"
	description = "Highly advanced tools for botanists."
	prereq_ids = list("cloning", "adv_engi")
	design_ids = list("diskplantgene", "portaseeder", "plantgenes", "flora_gun", "hydro_tray", "biogenerator", "seed_extractor")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	export_price = 5000