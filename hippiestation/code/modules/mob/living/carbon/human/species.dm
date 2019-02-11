/datum/species/
	var/hurt_sound_cd = 0
	sound/attack_sound = 'hippiestation/sound/weapons/punch1.ogg'
	sound/miss_sound = 'hippiestation/sound/weapons/punchmiss.ogg'

/datum/species/proc/queue_hurt_sound(mob/living/carbon/human/H)
	if (hurt_sound_cd > world.time)
		return

	if (H.stat)
		return

	if (H.is_muzzled())
		return

	if (H.mind)
		if (H.mind.miming)
			return

	hurt_sound_cd = world.time + 30
	addtimer(CALLBACK(src, .proc/play_hurt_sound, H), 5)

/datum/species/proc/play_hurt_sound(mob/living/carbon/human/H)
	// The sound frequency is set to 11,025 and I want to vary it by 25% both ways
	playsound(H, "male_hurt", 75, 1, frequency = rand(11025*0.75, 11025*1.25))