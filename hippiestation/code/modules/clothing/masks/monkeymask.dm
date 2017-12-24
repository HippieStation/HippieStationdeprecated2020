/obj/item/clothing/mask/monkeymask_cursed
	name = "monkey face"
	desc = "Your face has been replaced entirely with a monkey's face!"
	flags_1 = MASKINTERNALS_1 | NODROP_1 | DROPDEL_1
	icon_state = "monkeymask"
	item_state = "monkeymask"
	flags_cover = MASKCOVERSEYES
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	flags_inv = HIDEHAIR|HIDEFACIALHAIR
	var/voicechange = TRUE
	var/last_sound = 0
	var/delay = 15


/obj/item/clothing/mask/monkeymask_cursed/proc/play_ook()
	if(world.time - delay > last_sound)
		playsound (src, 'sound/creatures/gorilla.ogg', 65, 0)
		last_sound = world.time

/obj/item/clothing/mask/monkeymask_cursed/equipped(mob/user, slot) //when you put it on
	var/mob/living/carbon/C = user
	if((C.wear_mask == src) && (voicechange))
		play_ook()
	return ..()

/obj/item/clothing/mask/monkeymask_cursed/attack_self(mob/user)
	voicechange = !voicechange
	to_chat(user, "<span class='notice'>You turn the voice box [voicechange ? "on" : "off"]!</span>")

/obj/item/clothing/mask/monkeymask_cursed/speechModification(message)
	if(voicechange)
		if(prob(25))
			message = pick("AND THIS IS SUPER MONKEY 3!!","OOK OOK AAK AAK!!","I FAINTED FROM SCREAMING SO LOUD ONCE!!", "LET'S TRAIN!!", "HUUUUUUAAAAAAAAAAAAAAAAAAAAGH!!" ,"MY POWER IS MAXIMUM!!", "I-I'M NOT A WEEABOO, B-BAKA!!")
			play_ook()
		else
			message = pick("HAAAAAA!!!", "HEY, IT'S ME, MONKEYMAN!!","GOSH I'M STARVIN!!","HAAAAAAAAAAAAAA!!") //but its usually just angry gibberish,
			play_ook()
	return message