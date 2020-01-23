// Handles updating the human hands icons.
// Redefined to apply species offsets to anything the human is holding.
/mob/living/carbon/human/update_inv_hands()
	..()
	var/list/L = overlays_standing[HANDS_LAYER]
	for(var/i in L)
		var/mutable_appearance/hands_overlay = i
		if(OFFSET_HANDS in dna.species.offset_features)
			hands_overlay.pixel_x += dna.species.offset_features[OFFSET_HANDS][1]
			hands_overlay.pixel_y += dna.species.offset_features[OFFSET_HANDS][2]
