/datum/magic/invoke
	var/list/possible_words = list()
	var/list/phrase_list = list()
	var/phrase

/datum/magic/invoke/setup()
	var/done = FALSE
	if(!LAZYLEN(possible_words))
		return
	while(!done)
		var/list/words = possible_words.Copy()
		var/new_phrase = ""
		var/new_phrase_list = list()
		for(var/i = 1 to complexity)
			var/word = pick_n_take(words)
			new_phrase = "[new_phrase][word] "
			new_phrase_list += word
		new_phrase = trim_right(new_phrase)
		if(length(new_phrase))
			var/cont = TRUE
			for(var/datum/magic/invoke/IM in SSmagic.loaded_magic)
				if(IM.phrase == new_phrase)
					cont = FALSE
					break
			if(cont)
				phrase = new_phrase
				phrase_list = new_phrase_list
				to_chat(world, "magic [name] has phrase \"[phrase]\"")
				return
