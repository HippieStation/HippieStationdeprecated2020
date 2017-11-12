/obj/item/reagent_containers/food/snacks/attack(mob/M, mob/user, def_zone)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(!eatverb)
		eatverb = pick("bite","chew","nibble","gnaw","gobble","chomp")
	if(!reagents.total_volume)						//Shouldn't be needed but it checks to see if it has anything left in it.
		to_chat(user, "<span class='notice'>None of [src] left, oh no!</span>")
		qdel(src)
		return 0
	if(iscarbon(M))
		if(!canconsume(M, user))
			return 0

		var/fullness = M.nutrition + 10
		for(var/datum/reagent/consumable/C in M.reagents.reagent_list) //we add the nutrition value of what we're currently digesting
			fullness += C.nutriment_factor * C.volume / C.metabolization_rate

		if(M == user)								//If you're eating it yourself.
			if(junkiness && M.satiety < -150 && M.nutrition > NUTRITION_LEVEL_STARVING + 50 )
				to_chat(M, "<span class='notice'>You don't feel like eating any more junk food at the moment.</span>")
				return 0
			else if(fullness <= 50)
				to_chat(M, "<span class='notice'>You hungrily [eatverb] some of \the [src] and gobble it down!</span>")
			else if(fullness > 50 && fullness < 150)
				to_chat(M, "<span class='notice'>You hungrily begin to [eatverb] \the [src].</span>")
			else if(fullness > 150 && fullness < 500)
				to_chat(M, "<span class='notice'>You [eatverb] \the [src].</span>")
			else if(fullness > 500 && fullness < 600)
				to_chat(M, "<span class='notice'>You unwillingly [eatverb] a bit of \the [src].</span>")
			else if(fullness > (600 * (1 + M.overeatduration / 2000)))	// The more you eat - the more you can eat
				to_chat(M, "<span class='warning'>You cannot force any more of \the [src] to go down your throat!</span>")
				return 0
		else
			if(!isbrain(M))		//If you're feeding it to someone else.
				if(fullness <= (600 * (1 + M.overeatduration / 1000)))
					M.visible_message("<span class='danger'>[user] attempts to feed [M] [src].</span>", \
										"<span class='userdanger'>[user] attempts to feed [M] [src].</span>")
				else
					M.visible_message("<span class='warning'>[user] cannot force any more of [src] down [M]'s throat!</span>", \
										"<span class='warning'>[user] cannot force any more of [src] down [M]'s throat!</span>")
					return 0

				if(!do_mob(user, M))
					return
				add_logs(user, M, "fed", reagentlist(src))
				M.visible_message("<span class='danger'>[user] forces [M] to eat [src].</span>", \
									"<span class='userdanger'>[user] forces [M] to eat [src].</span>")

			else
				to_chat(user, "<span class='warning'>[M] doesn't seem to have a mouth!</span>")
				return

		if(reagents)								//Handle ingestion of the reagent.
			if(M.satiety > -200)
				M.satiety -= junkiness
			var/eatsound = pick('hippiestation/sound/items/eat_01.ogg', 'hippiestation/sound/items/eat_02.ogg', 'hippiestation/sound/items/eat_03.ogg', 'hippiestation/sound/items/eat_04.ogg', 'hippiestation/sound/items/eat_05.ogg', 'hippiestation/sound/items/eat_06.ogg', 'sound/items/eatfood.ogg') //people are going to HATE this
			playsound(M.loc, eatsound, rand(40,60), 0)
			if(reagents.total_volume)
				var/fraction = min(bitesize / reagents.total_volume, 1)
				reagents.reaction(M, INGEST, fraction)
				reagents.trans_to(M, bitesize)
				bitecount++
				On_Consume()
				checkLiked(fraction, M)
				return 1

	return 0