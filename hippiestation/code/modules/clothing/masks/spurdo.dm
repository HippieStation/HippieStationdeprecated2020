/obj/item/clothing/mask/spurdo
	name = "spurdo sparde mask"
	desc = "Made from a rare Gondola hide. Is said to be cursed by the spirits of Space Finland, which speak through the mask when you scream."
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	flags_1 = MASKINTERNALS
	w_class = WEIGHT_CLASS_SMALL
	icon_state = "spurdo"
	item_state = "spurdo"
	icon = 'hippiestation/icons/obj/clothing/masks.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/mask.dmi'
	alternate_screams = list('hippiestation/sound/voice/finnish_1.ogg', 'hippiestation/sound/voice/finnish_2.ogg', 'hippiestation/sound/voice/finnish_3.ogg')
	modifies_speech = TRUE
	// god emperor pyko has lended us his voice for scream sounds

/obj/item/clothing/mask/spurdo/handle_speech(datum/source, list/speech_args)
	if(copytext(speech_args[SPEECH_MESSAGE], 1, 2) != "*")
		speech_args[SPEECH_MESSAGE] = " [speech_args[SPEECH_MESSAGE]]"
		var/list/spurdo_words = strings("hippie_word_replacement.json", "spurdo") // Technically not modular, but unless we want to write an entire function for one damn mask then we'll just have this here.

		for(var/key in spurdo_words)
			var/value = spurdo_words[key]
			if(islist(value))
				value = pick(value)

			speech_args[SPEECH_MESSAGE] = replacetextEx(speech_args[SPEECH_MESSAGE], " [uppertext(key)]", " [uppertext(value)]")
			speech_args[SPEECH_MESSAGE] = replacetextEx(speech_args[SPEECH_MESSAGE], " [capitalize(key)]", " [capitalize(value)]")
			speech_args[SPEECH_MESSAGE] = replacetextEx(speech_args[SPEECH_MESSAGE], " [key]", " [value]")

		speech_args[SPEECH_MESSAGE] = replacetext(speech_args[SPEECH_MESSAGE],"p","b") // This part and the lines below it are doubling down for accent's sake. It's modular.
		speech_args[SPEECH_MESSAGE] = replacetext(speech_args[SPEECH_MESSAGE],"c","g")
		speech_args[SPEECH_MESSAGE] = replacetext(speech_args[SPEECH_MESSAGE],"k","g")
		speech_args[SPEECH_MESSAGE] = replacetext(speech_args[SPEECH_MESSAGE],"z","s")
		speech_args[SPEECH_MESSAGE] = replacetext(speech_args[SPEECH_MESSAGE],"t","d")

	if (prob(50))
		speech_args[SPEECH_MESSAGE] += " :"
		if (prob(50))
			speech_args[SPEECH_MESSAGE] += "-"

		var/smiles = rand(3, 8)

		while (smiles > 0)
			speech_args[SPEECH_MESSAGE] += "D"
			smiles--

		if (prob(50))
			var/exclaim = rand(3, 8)

			while (exclaim > 0)
				speech_args[SPEECH_MESSAGE] += "!"
				exclaim--
	speech_args[SPEECH_MESSAGE] = uppertext(trim(speech_args[SPEECH_MESSAGE]))

/obj/item/clothing/mask/spurdo/equipped(mob/user, slot) //when you put it on
	var/mob/living/carbon/C = user
	if(C.wear_mask == src)
		C.emote("scream")
		C.say("SUOMI PERKELE!", forced = "spurdo mask") // bawb made me do this
	return ..()

obj/item/clothing/mask/spurdo/cursed
	flags_1 =  MASKINTERNALS

obj/item/clothing/mask/spurdo/cursed/Initialize()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
	. = ..()
