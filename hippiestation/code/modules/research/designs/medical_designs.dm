/datum/design/bluespacebeaker
	materials = list(MAT_GLASS = 3000, MAT_PLASMA = 3000, MAT_DIAMOND = 250, MAT_BLUESPACE = 250) // reverts bluespace beaker's nerf

/datum/design/implant_adrenalin //This should overwrite the adrenal implant in the Protolathe
	name = "Combat Stimulant Implant"
	desc = "A glass case containing an implant."
	id = "implant_adrenalin"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 1000, MAT_GLASS = 500, MAT_GOLD = 500, MAT_URANIUM = 600, MAT_DIAMOND = 600)
	build_path = /obj/item/implantcase/comstimm
	category = list("Medical Designs")
	
/datum/design/autosurgeon
	name = "Autosurgeon"
	desc = "A device capable of automatically and painlessly insering implants into the user's body."
	id = "autosurgeon"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 2500, MAT_GOLD = 1000, MAT_DIAMOND = 1000, MAT_TITANIUM = 1000, MAT_URANIUM = 1500)
	build_path = /obj/item/autosurgeon
	category = list("Medical Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE
