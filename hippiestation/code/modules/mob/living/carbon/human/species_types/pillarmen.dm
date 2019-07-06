
/datum/species/pillarmen
	name = "Pillar Man"
	id = "pillarmen"
	species_traits = list(NOTRANSSTING, NOZOMBIE, NO_DNA_COPY, NO_DNA_COPY, NOFLASH, EYECOLOR, HAIR, FACEHAIR)
	inherent_traits = list(TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_IGNORESLOWDOWN, TRAIT_SLEEPIMMUNE, TRAIT_XRAY_VISION, TRAIT_NOSOFTCRIT, 
							TRAIT_NOGUNS, TRAIT_VIRUSIMMUNE, TRAIT_PIERCEIMMUNE, TRAIT_SHOCKIMMUNE, TRAIT_RADIMMUNE, TRAIT_NOHUNGER,
							TRAIT_NOLIMBDISABLE)
	inherent_biotypes = list(MOB_HUMANOID)
	damage_overlay_type = "" //they won't show signs of damage until they're dead.
	changesource_flags = MIRROR_BADMIN
	sexes = FALSE

/datum/species/pillarmen/on_species_gain(mob/living/carbon/human/H, datum/species/old_species)
	..()
	H.draw_hippie_parts()
	H.ventcrawler = VENTCRAWLER_ALWAYS
	H.grant_all_languages(omnitongue=TRUE)

	//Grant all huds, maximum knowledge
	for(var/hudtype in list(DATA_HUD_SECURITY_ADVANCED, DATA_HUD_MEDICAL_ADVANCED, DATA_HUD_DIAGNOSTIC_ADVANCED)) // add data huds
		var/datum/atom_hud/A = GLOB.huds[hudtype]
		A.add_hud_to(H)

/datum/species/pillarmen/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	C.draw_hippie_parts(TRUE)
