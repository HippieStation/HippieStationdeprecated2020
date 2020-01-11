/datum/reagent/toxin/mutagen/reaction_mob(mob/living/W, method=TOUCH, reac_volume, show_message = 1, touch_protection = 0)
	if(!istype(W, /mob/living/carbon))
		return FALSE
	var/mob/living/carbon/M = W
	if(!M.has_dna())
		return FALSE
	if(method==VAPOR)
		if(M.reagents)
			var/modifier = CLAMP((1 - touch_protection), 0, 1)
			var/amount = round(reac_volume*modifier, 0.1)
			if(amount >= 0.5)
				M.reagents.add_reagent(type, amount)
		if(prob(min(33, reac_volume)))
			M.randmuti()
			if(prob(98))
				M.easy_randmut(NEGATIVE + MINOR_NEGATIVE)
			else
				M.easy_randmut(POSITIVE)
			M.updateappearance()
			M.domutcheck()
	else
		M.randmuti()
		if(prob(98))
			M.easy_randmut(NEGATIVE + MINOR_NEGATIVE)
		else
			M.easy_randmut(POSITIVE)
		M.updateappearance()
		M.domutcheck()
	return TRUE

/datum/reagent/toxin/bone_hurting_juice
	name = "Bone Hurting Juice"
	description = "A corrupted form of calcium that reacts horribly with more calcium."
	color = "#DEDEDE" // a horrible shade of off-white grey, also FUG!!!
	toxpwr = 0 //It only hurts your bones

/datum/reagent/toxin/bone_hurting_juice/on_mob_life(mob/living/carbon/M)
	if(prob(20))
		M.say(pick("Oof!", "OUCH!", "Owie!"), forced = "bone hurting juice")

	if(prob(10))
		to_chat(M, "<span class='danger'> Your bones hurt!</span>")

	if(prob(3))
		M.adjustBruteLoss(rand(1,5), 0)//we wanna hurt them, not kill them.
		to_chat(M, "<span class='userdanger'> Your bones really hurt!</span>")

	if(M.dna.species.id == "spookyskeleton")
		if(prob(5))
			M.visible_message("<span class='danger'>[M] rubs their bones, they appear to be hurting!</span>", "<span class='danger'>Your bones are starting to hurt a lot.</span>")
		if(prob(3))
			M.say(pick("This rattles me bones!", "My bones hurt!", "Oof OUCH Owie!"), ignore_spam = TRUE, forced = "bone hurting juice")

	if(M.dna.species.id == "skeleton")
		if(prob(5))
			M.visible_message("<span class='danger'>[M] rubs their bones, they appear to be hurting!</span>", "<span class='danger'>Your bones are starting to hurt a lot.</span>")
			M.adjustBruteLoss(rand(2,8), 0)
		if(prob(3))
			M.say(pick("This rattles me bones!!", "My bones hurt!!", "Oof OUCH Owie!!"), ignore_spam = TRUE, forced = "bone hurting juice") //Something neat, if I put two exclamation points here the mob will yell these lines instead of just saying them. A proper skeleton yells because their bones hurt more.
			M.adjustBruteLoss(rand(5,10), 0)
		if(prob(2))
			M.visible_message("<span class='danger'>[M] bones twist and warp! It looks like it really really hurts!</span>", "<span class='userdanger'>Your bones hurt so much!</span>")
			M.emote("scream")
			M.adjustBruteLoss(rand(10,20), 0)

/datum/reagent/toxin/aus//does work well now
	name = "Ausium"
	description = "You're a roight cant moit!"
	color = "#75AC53"
	toxpwr = 0
	metabolization_rate = 8 * REAGENTS_METABOLISM

/datum/reagent/toxin/aus/on_mob_life(mob/living/carbon/human/M)
	if(istype(M))
		M.name = "Aussie Cant"
		M.real_name = "Aussie Cant"
		M.adjustBrainLoss(min(M.getBrainLoss() + 60, 60))
	..()

/datum/reagent/toxin/emote
	name = "Pure Emotium"
	description = "This shouldn't be difficult to figure out."
	color = "#75AC53"
	toxpwr = 0

/datum/reagent/toxin/emote/on_mob_life(mob/living/M)
	if(prob(25))
		M.emote(pick("fart","flap","aflap","airguitar","blink","shrug","cough","sneeze","shake","twitch", "scream"))
		M.Jitter(2)
	..()

/datum/reagent/toxin/carbonf
	name = "Carbonic fluoride"
	description = "A fairly nasty chemical used to produce potent medicines"
	color = "#A300B3"
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	toxpwr = 2

/datum/reagent/toxin/radgoop
	name = "Radioactive waste"
	description = "A filthy product left over from the production of nuclear materials"
	color = "#000067"
	toxpwr = 0.5

/datum/reagent/toxin/radgoop/on_mob_life(mob/living/M)
	if(prob(30))
		M.apply_effect(3, EFFECT_IRRADIATE, 0)
	..()

/datum/reagent/toxin/goop
	name = "Toxic goop"
	description = "A revolting mixture of toxic byproducts left over from the production of poisons"
	color = "#A20067"
	toxpwr = 1
	metabolization_rate = 1.5 * REAGENTS_METABOLISM

/datum/reagent/toxin/goop/on_mob_life(mob/living/M)
	if(prob(15))
		M.reagents.add_reagent(get_random_toxin_reagent_id(), 1)
	..()

/datum/reagent/toxin/gibemitter
	name = "Unstable gibs"
	description = "This does not smell very nice."
	color = "#FF1111"
	toxpwr = 0

/datum/reagent/toxin/gibemitter/on_mob_life(mob/living/carbon/M)
	if(istype(M))
		if(prob(20))
			new /obj/effect/gibspawner/generic(get_turf(holder.my_atom),null,M.dna)
	..()

/datum/reagent/toxin/bear
	name = "Bearium"
	description = "If you like puns and gibbed monkeys you will like this."
	color = "#CAD15A"
	toxpwr = 0

/datum/reagent/toxin/bear/on_mob_life(mob/living/carbon/M)
	if(istype(M))
		if(prob(25))
			M.visible_message("<span class='danger'>[M.name] growls strangely.</span>")
		switch(current_cycle)
			if(5 to 15)
				if(prob(15))
					M.emote(pick("twitch","blink_r","scream"))
					M.adjustBrainLoss(2)
			if(15 to 40)
				if(prob(15))
					M.vomit(20)
			if(40 to 60)
				if(prob(10))
					M.vomit(20, 0, 4)
					M.adjustBruteLoss(10)
					M.adjustBrainLoss(10)//this gets much more serious
			if(60 to INFINITY)
				if(prob(50))
					M.visible_message("<span class='danger'>[M.name] explodes in a shower of gibs leaving a space bear!</span>")
					new /mob/living/simple_animal/hostile/bear(M.loc)
					M.gib()
					return ..()
	..()

/datum/reagent/toxin/methphos
	name = "Methylphosphonyl difluoride"
	description = "Maybe you could make something really really toxic out of this?"
	color = "#C8A5DC"
	toxpwr = 0.5

/datum/reagent/toxin/sarin_a
	name = "Translucent mixture"
	description = "This mixture has a very light white hint to it but is filled with impurities"
	color = "#AAAACB"
	toxpwr = 1

/datum/reagent/toxin/sarin_a/on_mob_life(mob/living/M)
	M.eye_blurry = max(M.eye_blurry, 1)
	..()

/datum/reagent/toxin/sarin_b
	name = "diluted sarin"
	description = "A very impure form of sarin"
	color = "#CCCCCC"

/datum/reagent/toxin/sarin_b/on_mob_life(mob/living/M)
	M.eye_blurry = max(M.eye_blurry, 3)
	if(prob(15))
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			C.vomit(20)

/datum/reagent/toxin/sarin //causes toxin damage, respiratory failure, blurs eyes and drowsiness, extremely lethal unless countered with atropine
	name = "Sarin"
	description = "A family friendly lethal nerve agent, handle with care!"
	color = "#FFFFFF"
	toxpwr = 0
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/toxin/sarin/on_mob_life(mob/living/M)
	M.Jitter(50)
	M.apply_effect(EFFECT_STUTTER, 5)
	if(current_cycle % 10 == 0)
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			pick(C.vomit(20, stun = FALSE), C.vomit(20,1, stun = FALSE))

	switch(current_cycle)
		if(1 to 12)
			M.adjustToxLoss(2.5)
			M.adjustOxyLoss(2.5)
			M.eye_blurry = max(M.eye_blurry, 2)

		if(12 to 15)
			M.eye_blurry = max(M.eye_blurry, 10)
			M.adjustToxLoss(3.5)
			M.adjustOxyLoss(3.5)
			M.adjustBrainLoss(1)

		if(15 to 25)
			M.adjustStaminaLoss(20)
			M.setStaminaLoss(40)
			M.adjustToxLoss(4.5)
			M.adjustOxyLoss(3.5)
			M.adjustBrainLoss(5)
			M.losebreath++

		if(25 to INFINITY)
			M.Unconscious(30)
			M.adjustToxLoss(6)
			M.adjustOxyLoss(4)
			M.adjustBruteLoss(2)
			M.adjustBrainLoss(15)
			M.losebreath++
	..()

/datum/reagent/toxin/tabun_pa
	name = "Dimethlymine"
	description = "A chemical that is used in the manufacturing of narcotics"
	color = "#CF3600" // rgb: 207, 54, 0

/datum/reagent/toxin/tabun_pb
	name = "Phosphoryll"
	description = "Hmm looks just like water"
	color = "#801E28"

/datum/reagent/toxin/tabun_pc
	name = "Noxious mixture"
	description = "A bubbling mixture"
	color = "#CF3600" // rgb: 207, 54, 0

/datum/reagent/toxin/tabun
	name = "Tabun"
	description = "First generation nerve agent invented by the Nazis, packs impressive toxicity"
	color = "#003333"
	metabolization_rate = 3 * REAGENTS_METABOLISM //goes really quickly but does huge amounts of damage

/datum/reagent/toxin/tabun/on_mob_life(var/mob/living/M as mob)
	M.adjustToxLoss(3*REM)//This stuff is crazily powerful
	M.losebreath += 2
	M.adjustBrainLoss(5)
	M.eye_blurry = max(M.eye_blurry, 2)
	..()

/datum/reagent/toxin/acid/hydrazine//jack of all trades chem, acidic, fairly toxic and can cause firestacks
	name = "Hydrazine"
	description = "Toxic, unstable, flammable and used in rocket fuel. Aim away from face!"
	color = "#CF36AC" // rgb: 207, 54, 0
	toxpwr = 2
	acidpwr = 15
	data = 0
	processes = TRUE

/datum/reagent/toxin/acid/hydrazine/on_mob_life(mob/living/M)
	M.adjust_fire_stacks(1)
	M.dizziness++
	..()

/datum/reagent/toxin/acid/hydrazine/process()
	if(holder)
		data++
		if(prob(2) && data > 40) //randomly creates small explosions or fireballs but has a delay so it doesn't just kill people while they're still mixing
			var/location = get_turf(holder.my_atom)
			holder.remove_reagent(src.type,5,safety = 1)
			switch(prob(50))
				if(TRUE)
					var/datum/effect_system/reagents_explosion/e = new()
					e.set_up(rand(1, 3), location, 0, 0, message = 1)
					e.start()
				if(FALSE)
					for(var/turf/F in range(1,location))
						new /obj/effect/hotspot(F)
	..()

/datum/reagent/toxin/sazide//replacement for cyanide, causes scaling oxyloss followed by sleeping and eye+liver damage
	name = "Sodium Azide"
	description = "A toxic and unstable chemical known for causing respiratory failure and sudden explosions"
	color = "#CF3600" // rgb: 207, 54, 0
	toxpwr = 0
	metabolization_rate = 0.25 * REAGENTS_METABOLISM

/datum/reagent/toxin/sazide/on_mob_life(mob/living/M)
	if(prob(20))
		M.emote("gasp")
	switch(current_cycle)
		if(1 to 5)
			M.adjustOxyLoss(2)
		if(5 to 30)
			M.drowsyness++
			M.losebreath++
			if(prob(33))
				if(iscarbon(M))
					var/mob/living/carbon/C = M
					C.applyLiverDamage(5)
		if(30 to INFINITY)
			M.Sleeping(40,0)
			M.adjust_eye_damage(1)
			M.losebreath++
			if(prob(33))
				if(iscarbon(M))
					var/mob/living/carbon/C = M
					C.applyLiverDamage(15)//liver damage does fuck all but oh well
	..()

/datum/reagent/toxin/bleach
	name = "Bleach"
	description = "Also known as sodium hypochlorite. A potent and toxic cleaning agent"
	color = "#FFFFFF"
	toxpwr = 2

/datum/reagent/toxin/bleach/on_mob_life(mob/living/M)
	if(M && isliving(M) && M.color != initial(M.color))
		M.color = initial(M.color)
	..()

/datum/reagent/toxin/bleach/reaction_mob(mob/living/M, reac_volume)
	if(M && isliving(M) && M.color != initial(M.color))
		M.color = initial(M.color)
	..()

/datum/reagent/toxin/bleach/reaction_obj(obj/O, reac_volume)
	if(O && O.color != initial(O.color))
		O.color = initial(O.color)
	..()

/datum/reagent/toxin/bleach/reaction_turf(turf/T, reac_volume)
	if(T && T.color != initial(T.color))
		T.color = initial(T.color)
	..()

/datum/reagent/toxin/impgluco
	name = "Impure Glucosaryll"
	description = "The incredibly sweet precursor to a frighteningly dangerous substance that Nanotrasen once used to cut costs on soft drink sweetener before it was quietly recalled."
	color = "#EFD6D0"
	taste_description = "dizzying sweetness"
	taste_mult = 2.0

/datum/reagent/toxin/impgluco/on_mob_life(mob/living/M)
	M.reagents.add_reagent(/datum/reagent/consumable/sugar,0.8*REM)
	..()

/datum/reagent/toxin/gluco
	name = "Glucosaryll"
	description = "This revolting sludge smells like the inside of the pillsbury doughboy's ascending colon."
	color = "#F6F1D2"
	taste_description = "ungodly sweetness"
	taste_mult = 5.0

/datum/reagent/toxin/gluco/on_mob_life(mob/living/M)
	M.reagents.add_reagent(/datum/reagent/consumable/sugar, 4*REM)
	if(prob(15))
		to_chat(M, "<span class='danger'>[pick("Your left leg is numb.","You feel tingly.","Everything seems airy.")]</span>")
		M.Dizzy(10)
		M.adjustStaminaLoss(5*REM, 0)
	..()

/datum/reagent/toxin/screech
	name = "Screechisol"
	description = "Stimulates the vocal cords heavily, inducing involuntary yelling."
	color = "#853358"
	taste_description = "salty and sour"

/datum/reagent/toxin/screech/on_mob_life(mob/living/M)
	var/chance = 10
	switch(current_cycle)
		if(11 to 20)
			chance = 25
		if(21 to 30)
			chance = 40
		if(31 to 40)
			chance = 55
		if(41 to INFINITY)
			chance = 80
	if(prob(chance))
		M.emote("scream")
		. = 1
	..()

/datum/reagent/impedrezene/on_mob_life(mob/living/M)
	M.jitteriness = max(M.jitteriness-5,0)
	if(prob(80))
		M.adjustBrainLoss(4*REM)
	if(prob(50))
		M.drowsyness = max(M.drowsyness, 3)
	if(prob(10))
		M.emote("drool")
	if(prob(1))
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			ADD_TRAIT(H, TRAIT_CLUMSY, type)

	..()

/datum/reagent/impedrezene/on_mob_end_metabolize(mob/living/M)
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		REMOVE_TRAIT(H, TRAIT_CLUMSY, type)
	..()

/datum/reagent/toxin/vomit
	name = "Vomit"
	description = "Chunky."
	color = "#f4f442" // rgb(244, 244, 66)
	toxpwr = 0.5
	taste_description = "absolutely disgusting"
	taste_mult = 10

/datum/reagent/toxin/vomit/on_mob_life(mob/living/carbon/M)
	if(prob(10) && istype(M))
		M.vomit(10)
	..()

