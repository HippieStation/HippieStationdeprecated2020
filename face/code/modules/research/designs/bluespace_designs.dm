/datum/design/biobag_holding
	name = "Bio Bag of Holding"
	desc = "A bag for the safe transportation and disposal of biowaste and other biological materials. This bag has more storage compared to the regular bio bag."
	id = "biobag_holding"
	build_type = PROTOLATHE
	materials = list(MAT_GOLD = 250, MAT_URANIUM = 500) //quite cheap, for more convenience
	build_path = /obj/item/storage/bag/bio/holding
	category = list("Bluespace Designs")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SERVICE