/datum/species/ugandan_warrior // i hope this doesn't get merged
	name = "Ugandan warrior"
	id = "ugandan_warrior"
	say_mod = "clucks"
	default_color = "0000FF"
	sexes = FALSE
	blacklisted = FALSE
	species_traits = list(NO_UNDERWEAR)
	attack_verb = "spit"
	attack_sound = 'hippiestation/sound/voice/ugandan_warrior/spit.ogg'
	miss_sound = 'hippiestation/sound/voice/ugandan_warrior/cluck.ogg'
	offset_features = list(OFFSET_SHOES = list(0,3), OFFSET_FACE = list(0, -1), OFFSET_HEAD = list(0, -1), OFFSET_FACEMASK = list(0, -1), OFFSET_EARS = list(-1, -1))

/datum/species/ugandan_warrior/check_roundstart_eligible()
	return TRUE