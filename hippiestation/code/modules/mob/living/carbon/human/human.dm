/mob/living/carbon/human/create_internal_organs()
  internal_organs += new /obj/item/organ/butt
  return ..()

/mob/living/Life()
	. = ..()
	if(client && client.prefs && client.prefs.anti_gay_music)
		stop_sound_channel(CHANNEL_GAY)
