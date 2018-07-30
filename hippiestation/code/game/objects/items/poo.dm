/obj/item/poo
	name = "poo"
	desc = "Comes out of your anus. Do not throw at others"
	force = 1
	icon = 'hippiestation/icons/obj/poopy.dmi'
	icon_state = "turd"
	hitsound = 'hippiestation/sound/effects/poo.ogg'
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL
	sharpness = IS_BLUNT
	var/magic = FALSE
	var/bomb = FALSE
	var/GIGA = FALSE

/obj/item/poo/giga
	name = "giga poo"
	desc = "A gigantic pile of shit."
	GIGA = TRUE
	force = 7
	throwforce = 10

/obj/item/poo/lizturd
	name = "mysterious green fecal matter"
	desc = "Excreted out of an anal orifice of either an abomination, or a scalie. Especially do not throw at others."
	icon_state = "lizturd"

/obj/item/poo/giga/lizturd
	name = "gigantic green destroyer of good smells"
	desc = "Excreted out of an anal orifice of an abomination who hasn't taken a shit in too long."
	icon_state = "lizturd"

/obj/item/poo/skeleturd
	name = "perfectly square cube of calcium"
	desc = "The exact kind of thing you'd find in your kidneys on a bad day, except square."
	icon_state = "skeleturd"

/obj/item/poo/giga/skeleturd
	name = "box of solidified milk"
	desc = "If you found this anywhere in your body, any day would become an especially bad one."
	icon_state = "skeleturd"

/obj/item/poo/refuse
	name = "oily fecal matter"
	desc = "When you have no stercobilin, oil becomes the next best thing. Why do robots need to digest food is a whole 'nother question."
	icon_state = "refuse"

/obj/item/poo/giga/refuse
	name = "gas station compost"
	desc = "The true secret of how Saudi Arabia got all of their oil those many generations ago."
	icon_state = "refuse"

/obj/item/poo/clownbrownie
	name = "clown brownie"
	desc = "All those years of partying and doing all sorts of drugs has wreaked havoc on this poor clown's colon."
	icon_state = "clown-brownie"

/obj/item/poo/giga/clownbrownie
	name = "clown cake"
	desc = "All those years of partying, doing all sorts of drugs, and holding it all in so the police won't know what those drugs were have wreaked havoc on this stupid clown."
	icon_state = "clown-brownie"

/obj/item/poo/wizturd
	name = "wizturd"
	desc = "When there's no bathroom in sight, you can't GITTAH WEIGH, and you've had EI NATH, this is the result." // I'm so sorry.
	icon_state = "wizturd"

/obj/item/poo/giga/wizturd
	name = "spell-infused poo of the gods"
	desc = "The wizard thought to himself, 'I sure do wonder what BIRUZ BENNAR does to my digestive tract!' He regretted his curiosity and life decisions moments later."
	icon_state = "wizturd"

/obj/item/poo/dropped_bomb
	name = "dropped bomb"
	desc = "The special implants that the Deathsquad have been given were recalled hundreds of years ago for their... strange effects on a soldiers' stool. \
	Whether the Ops were even aware of the side effects, or if they thought of it as a last resort weapon, is a discussion that should never be had..."
	icon_state = "dropped-bomb"
	bomb = TRUE

/obj/item/poo/giga/dropped_bomb
	name = "tactical nuke"
	desc = "I guess we have our answer to the original question, then."
	icon_state = "dropped-bomb"
	bomb = TRUE
	GIGA = TRUE

/obj/item/poo/mystery
	name = "mystery shit"
	desc = "The poo of a cursed beast, or a lost soul."
	icon_state = "mystery-shit"

/obj/item/poo/giga/mystery
	name = "coder's mistake"
	desc = "A being that should not exist, but for whatever reason does, has laid this terrible seed of destruction upon this previously holy world. Tainting it, desecrating it, annihilating it."
	icon_state = "mystery-shit"


/obj/item/poo/throw_impact(atom/hit_atom)
	. = ..()
	if(!.) //if we're not being caught
		splat(hit_atom)

/obj/item/poo/proc/splat(atom/movable/hit_atom)
	if(isliving(loc)) //someone caught us!
		return
	var/turf/T = get_turf(hit_atom)
	new/obj/effect/decal/cleanable/poo(T)
	if(ishuman(hit_atom))
		var/mob/living/carbon/human/H = hit_atom
		var/mutable_appearance/poooverlay = mutable_appearance('hippiestation/icons/effects/poo.dmi')
		if(H.dna.species.limbs_id == "lizard")
			poooverlay.icon_state = "poopie_lizard"
		else
			poooverlay.icon_state = "poopie_human"
		//terrible code to support combinations inbound. if you know a way to shorten this please tell me.
		if(!magic && !bomb && !GIGA) // IF: REGULAR POO
			H.Knockdown(15) //splat!
			H.adjust_blurriness(1)
			H.visible_message("<span class='warning'>[H] is hit in the face by [src]!</span>", "<span class='userdanger'>You've been covered in shit by [src]!</span>")
		if(!magic && !bomb && GIGA) // IF: GIGA REGULAR POO
			H.AdjustUnconscious(25)
			H.adjust_blurriness(3)
			H.visible_message("<span class='warning'>[H] is smashed by [src]!</span>", "<span class='userdanger'>You've been knocked out cold by [src]!</span>")
			new /obj/effect/decal/cleanable/poo(get_turf(H))
		if(!magic && bomb && !GIGA) //IF: BOMB POO
			var/turf/G = get_turf(H)
			explosion(G, -1, 0, 1, 1, 0, 0)
			new /obj/effect/decal/cleanable/poo(get_turf(H))
		if(!magic && bomb && GIGA) //IF: GIGA BOMB POO
			var/turf/J = get_turf(H)
			explosion(J, -1, 0, 1, 1, 4, 2)
			new /obj/effect/decal/cleanable/poo(get_turf(H))
		if(magic && !bomb && !GIGA) //IF: MAGIC POO
			switch(rand(1,4))
				if(1) // Stops time.
					var/turf/Z = get_turf(H)
					for(var/turf/turf in range(0,Z))
					new /obj/effect/timestop/wizard(Z, H)
				if(2) // Bomb Poo
					var/turf/B = get_turf(H)
					explosion(B, -1, 0, 1, 1, 0, 0)
				if(3) // Teleports
					playsound(get_turf(H), 'sound/effects/phasein.ogg', 100, 1, -1)
					do_teleport(H, H, 20)
				if(4) // Spawns a cookie
					var/obj/item/reagent_containers/food/snacks/cookie/S = new /obj/item/reagent_containers/food/snacks/cookie(get_turf(H))
					S.name = "Pookie"
					playsound(H, "sound/effects/pray_chaplain.ogg", 50, TRUE)
		playsound(H, "desceration", 50, TRUE)
		if(!H.creamed) // no breaking with clown pies please
			H.add_overlay(poooverlay)
			H.creamed = TRUE
			SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "creampie", /datum/mood_event/creampie) // Do we honestly need this? Leaving it here just in case.
	qdel(src)