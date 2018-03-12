// This should not be free.

/obj/effect/proc_holder/changeling/regenerate
	name = "Regenerate"
	desc = "Allows us to regrow and restore missing external limbs, and \
		vital internal organs, as well as removing shrapnel and restoring \
		blood volume."
	helptext = "Will alert nearby crew if any external limbs are \
		regenerated. Can be used while unconscious."
	chemical_cost = 10
	dna_cost = 1
	req_dna = 1
	req_stat = UNCONSCIOUS
	always_keep = FALSE