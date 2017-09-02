/obj/structure/blob/attack_hand(mob/M)
	. = ..()
	if(M.a_intent == INTENT_HELP)
		M.changeNext_move(CLICK_CD_MELEE)
		var/a = pick("gently stroke", "nuzzle", "affectionatly pet", "cuddle")
		M.visible_message("<span class='notice'>[M] [a]s [src]!</span>", "<span class='notice'>You [a] [src]!</span>")
		if(overmind.acceptLove)
			to_chat(overmind, "<span class='notice'>[M] [a]s you!</span>")
		playsound(src, 'sound/effects/blobattack.ogg', 50, 1) //SQUISH SQUISH
