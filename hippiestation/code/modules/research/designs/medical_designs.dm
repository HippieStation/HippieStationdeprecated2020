/datum/design/bluespacebeaker
	materials = list(/datum/material/glass = 3000, /datum/material/plasma = 3000, /datum/material/diamond = 250, /datum/material/bluespace = 250) // reverts bluespace beaker's nerf

/datum/design/implant_adrenalin //This should overwrite the adrenal implant in the Protolathe
	name = "Combat Stimulant Implant"
	desc = "A glass case containing an implant."
	id = "implant_adrenalin"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 500, /datum/material/gold = 500, /datum/material/uranium = 600, /datum/material/diamond = 600)
	build_path = /obj/item/implantcase/comstimm
	category = list("Medical Designs")
