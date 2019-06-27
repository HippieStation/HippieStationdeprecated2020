/datum/reagent/consumable
	boiling_point = 373


/datum/reagent/consumable/berryjuice/on_mob_life(mob/living/M)
	if(prob(25))
		M.reagents.add_reagent(/datum/reagent/consumable/nutriment/vitamin,0.8)
	..()

/datum/reagent/consumable/watermelonjuice/on_mob_life(mob/living/M)
	M.adjustCloneLoss(-0.4, 0) //pretty slow, you're really better off using cryox/clonex
	. = 1
	..()

/datum/reagent/consumable/potato_juice/on_mob_life(mob/living/M)
	M.adjustStaminaLoss(-0.5*REM, 0)
	..()

/datum/reagent/consumable/cherryshake/on_mob_life(mob/living/M)
	M.reagents.add_reagent(/datum/reagent/consumable/sugar,1.2)
	..()

/datum/reagent/consumable/bluecherryshake/reaction_mob(mob/living/M)
	M.reagents.add_reagent(/datum/reagent/consumable/sugar,2)
	..()

/datum/reagent/consumable/gibbfloats/on_mob_life(mob/living/M)
	M.dizziness = max(0,M.dizziness-5)
	M.drowsyness = max(0,M.drowsyness-3)
	M.AdjustSleeping(-40, FALSE)
	if (M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (8 * TEMPERATURE_DAMAGE_COEFFICIENT))
	..()
	. = 1

/datum/reagent/consumable/triple_citrus/on_mob_life(mob/living/M)
	if(M.getOxyLoss() && prob(75))
		M.adjustOxyLoss(-1, 0)
	if(M.getFireLoss() && prob(75))
		M.adjustFireLoss(-1, 0)
	if(M.getBruteLoss() && prob(75))
		M.adjustBruteLoss(-1, 0)
	. = 1
	..()

/datum/reagent/consumable/lean
	name = "Lean"
	description = "A bubbly, neon purple antitussive syrup"
	color = "#de72f9" //rgb: rgb(222, 103, 252)
	taste_description = "purple"
	glass_icon_state = "lean"
	glass_desc = "A huge cup full of drank."
	glass_name = "lean cup"
	var/list/leanTalk = list("Sipping on some sizzurp, sip, sipping on some, sip..", "I'M LEANIN!!", "Drop some syrup in it, get on my waffle house!", "Dat purple stuff..", "We wuz.. sippin...", "Bup-bup-bup-bup...", "ME AND MY DRANK, ME AND MY DRANK!!!", "Pour you a glass, mane..", "...purple...", "Can't nobody sip mo' than me!")
	var/list/syrup_message = list("You feel relaxed.", "You feel calmed.","You feel like melting into the floor.","The world moves slowly..")
	var/old_skin_tone
	var/old_hair_style

/datum/reagent/consumable/lean/on_mob_metabolize(mob/living/L)
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		old_skin_tone = H.skin_tone
		old_hair_style = H.hair_style

/datum/reagent/consumable/lean/on_mob_end_metabolize(mob/living/L)
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.skin_tone = old_skin_tone
		H.hair_style = old_hair_style
		H.update_body()
		H.update_hair()

/datum/reagent/consumable/lean/on_mob_life(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.adjustBruteLoss(-2*REM)
		H.adjust_drugginess(5)
		if(prob(2))
			playsound(get_turf(H), 'hippiestation/sound/misc/syrupSippin.ogg', 50, 1)
		if(prob(8))
			H.say(pick(leanTalk), forced = "lean")
		if(prob(1))
			var/syrup_feeling = pick(syrup_message)
			to_chat(H,"<span class='notice'>[syrup_feeling]</span>")
		if(prob(3))
			H.skin_tone = "african1"
			H.hair_style = "Big Afro"
			H.update_body()
			H.update_hair()

	..()

/datum/reagent/consumable/soymilk
	var/soyyed = FALSE

/datum/reagent/consumable/soymilk/on_mob_life(mob/living/M)
	if(M.getBruteLoss() && prob(20))
		M.heal_bodypart_damage(1,0, 0)
		. = 1
	if(current_cycle > 30 && prob(3) && !soyyed && ishuman(M))
		var/mob/living/carbon/human/H = M
		soy(H)
	..()

/datum/reagent/consumable/soymilk/proc/soy(mob/living/carbon/human/Soylet)
	soyyed = TRUE
	var/prefix = ""
	if(Soylet.gender == FEMALE)
		prefix = "fe"
		Soylet.hair_style = "Kusanagi Hair"
	else
		Soylet.hair_style = "Balding Hair"
		Soylet.facial_hair_style = "Hipster Beard"

	Soylet.dropItemToGround(Soylet.glasses)
	Soylet.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular/hipster(Soylet), SLOT_GLASSES)

	Soylet.update_hair()
	to_chat(Soylet, "<span class='notice'>You feel like a new [prefix]male!</span>")
	Soylet.say("Wow!", forced = "soy")

/datum/reagent/consumable/grey_bull
	name = "Reuben Blast"
	description = "Formerly Grey Bull, now rebranded as Reuben Blast due to a very controversial murder case. It gives you gloves!"
