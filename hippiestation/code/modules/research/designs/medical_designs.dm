/datum/design/implant_adrenalin //This should overwrite the adrenal implant in the Protolathe
	name = "Combat Stimulant Implant"
	desc = "A glass case containing an implant."
	id = "implant_adrenalin"
	req_tech = list("biotech" = 6, "combat" = 6, "syndicate" = 6)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 1000, MAT_GLASS = 500, MAT_GOLD = 500, MAT_URANIUM = 600, MAT_DIAMOND = 600)
	build_path = /obj/item/implantcase/comstimm
	category = list("Medical Designs")
	
/datum/design/autosurgeon
	name = "Autosurgeon"
	desc = "A device that automatically inserts an implant or organ into the user without the hassle of extensive surgery. It has a slot to insert implants/organs and a screwdriver slot for removing accidentally added items."
	id = "autosurgeon"
	req_tech = list("biotech" = 7, "materials" = 5, "engineering" = 5, "programming" = 5)
	build_path = /obj/item/device/autosurgeon
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 5000, MAT_SILVER = 3000)
	category = list("Medical Designs")
