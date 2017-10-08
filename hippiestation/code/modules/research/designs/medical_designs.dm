/datum/design/implant_adrenalin //This should overwrite the adrenal implant in the Protolathe
	name = "Combat Stimulant Implant"
	desc = "A glass case containing an implant."
	id = "implant_adrenalin"
	req_tech = list("biotech" = 6, "combat" = 6, "syndicate" = 6)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 1000, MAT_GLASS = 500, MAT_GOLD = 500, MAT_URANIUM = 600, MAT_DIAMOND = 600)
	build_path = /obj/item/implantcase/comstimm
	category = list("Medical Designs")

/datum/design/autoimplanter
	name = "Autosurgeon"
	desc = "An automatic surgeon"
	id = "autosurgeon"
	req_tech = list("biotech" = 5, "medical" = 6
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 1000, MAT_GLASS = 500, MAT_SILVER = 1500)
	build_path = /obj/item/device/autosurgeon
	category = list("Medical Designs")
