/obj/item/clothing/mask/gas/clown_hat
	alternate_screams = list('sound/voice/human/manlaugh1.ogg', 'sound/voice/human/manlaugh2.ogg')

/obj/item/clothing/mask/gas/sexyclown
	alternate_screams = list('sound/voice/human/manlaugh1.ogg', 'sound/voice/human/manlaugh2.ogg')

/obj/item/clothing/mask/gas/mime
	alternate_screams = list('sound/misc/null.ogg')

/obj/item/clothing/mask/gas/sexymime
	alternate_screams = list('sound/misc/null.ogg')

/obj/item/clothing/mask/gas/monkeymask
	alternate_screams = list('hippiestation/sound/voice/scream_monkey.ogg')

/obj/item/clothing/mask/gas/cyborg 
	alternate_screams = list('hippiestation/sound/voice/scream_silicon.ogg')

/obj/item/clothing/mask/gas/clown_hat/ui_action_click(mob/user)
	if(..())
		switch(icon_state)
			if("chaos")
				alternate_screams = list('hippiestation/sound/voice/jevil1.ogg', 'hippiestation/sound/voice/jevil2.ogg', 'hippiestation/sound/voice/jevil3.ogg', 'hippiestation/sound/voice/jevil4.ogg')
			else
				alternate_screams = list('sound/voice/human/manlaugh1.ogg', 'sound/voice/human/manlaugh2.ogg')
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.reindex_screams()