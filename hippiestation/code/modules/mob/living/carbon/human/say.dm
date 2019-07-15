/mob/living/carbon/human/proc/forcesay_allowcomms(append)
	if(stat == CONSCIOUS)
		if(client)
			//var/virgin = 1	//has the text been modified yet?
			var/temp = winget(client, "input", "text")
			if(findtextEx(temp, "Say \"", 1, 7) && length(temp) > 5)	//"case sensitive means

				/*temp = replacetext(temp, ";", "")	//general radio

				if(findtext(trim_left(temp), ":", 6, 7))	//dept radio
					temp = copytext(trim_left(temp), 8)
					virgin = 0*/

				//if(virgin)
				temp = copytext(trim_left(temp), 6)	//normal speech
				//virgin = 0

				/*while(findtext(trim_left(temp), ":", 1, 2))	//dept radio again (necessary)
					temp = copytext(trim_left(temp), 3)*/

				if(findtext(temp, "*", 1, 2))	//emotes
					return

				var/trimmed = trim_left(temp)
				if(length(trimmed))
					say("[temp][append]")
				winset(client, "input", "text=[null]")
