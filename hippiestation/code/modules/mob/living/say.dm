/mob/living/say(message, bubble_type,var/list/spans = list(), sanitize = TRUE, datum/language/language = null)
	if(findtext(message, "rouge"))
		if(!issilicon(src))
			to_chat(src, "<span class='boldwarning'>You feel like a fucking moron.</span>")
			adjustBrainLoss(60)
			src.playsound_local(get_turf(src), 'hippiestation/sound/misc/slidewhistle_down.ogg', 100, FALSE, pressure_affected = FALSE)
		else
			to_chat(src, "<span class='boldwarning'>Your own stupidity overloads your sensors.</span>")
			src.Knockdown(rand(80,120))
			src.confused += 5
			src.flash_act(affect_silicon = 1)
			src.playsound_local(get_turf(src), 'hippiestation/sound/misc/slidewhistle_down.ogg', 100, FALSE, pressure_affected = FALSE)
		..()
