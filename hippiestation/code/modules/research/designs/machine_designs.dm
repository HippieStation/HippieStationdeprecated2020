/datum/design/board/telepad
	name = "Machine Design (Telepad Board)"
	desc = "The circuit board for a telescience telepad."
	id = "telepad"
	build_path = /obj/item/circuitboard/machine/telesci_pad
	category = list ("Teleportation Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/telesci_console
	name = "Computer Design (Telepad Control Console Board)"
	desc = "Allows for the construction of circuit boards used to build a telescience console."
	id = "telesci_console"
	build_path = /obj/item/circuitboard/computer/telesci_console
	category = list("Teleportation Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/sleeper
	name = "Machine Design (Sleeper Board)"
	desc = "The circuit board for a sleeper."
	id = "sleeper"
	build_path = /obj/item/circuitboard/machine/sleeper
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_MEDICAL
	category = list ("Medical Machinery")

/datum/design/board/lcass_pressure
	name = "Machine Design (Pessurized Reaction Vessel Board)"
	desc = "The circuit board for a pressurized reaction vessel."
	id = "lcass_pressure"
	build_path = /obj/item/circuitboard/machine/pressure
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_MEDICAL
	category = list ("Medical Machinery")

/datum/design/board/lcass_centrifuge
	name = "Machine Design (Centrifuge Board)"
	desc = "The circuit board for a centrifuge."
	id = "lcass_centrifuge"
	build_path = /obj/item/circuitboard/machine/centrifuge
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_MEDICAL
	category = list ("Medical Machinery")

/datum/design/board/lcass_radioactive
	name = "Machine Design (Radioactive Molecular Reassembler Board)"
	desc = "The circuit board for a radioactive molecular reassembler."
	id = "lcass_radioactive"
	build_path = /obj/item/circuitboard/machine/radioactive
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_MEDICAL
	category = list ("Medical Machinery")

/datum/design/board/lcass_bluespace
	name = "Machine Design (Bluespace Recombobulator Board)"
	desc = "The circuit board for a bluespace recombobulator."
	id = "lcass_bluespace"
	build_path = /obj/item/circuitboard/machine/bluespace
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_MEDICAL
	category = list ("Medical Machinery")

/datum/design/board/autodoc
	name = "Machine Design (Auto-Doc Mark IX)"
	desc = "Allows for the construction of circuit boards used to build a Auto-Doc Mark IX."
	id = "autodoc"
	build_path = /obj/item/circuitboard/machine/autodoc
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_MEDICAL
	category = list ("Medical Machinery")
