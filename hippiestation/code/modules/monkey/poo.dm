////MONKEY POO DECAL

//Poo (sorry -MRTY)
/obj/effect/decal/cleanable/poo
	name = "poo"
	desc = "A pile of poo. Gross!"
	icon = 'hippiestation/icons/effects/poo.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")

/obj/effect/decal/cleanable/poo/attack_hand(mob/user)
	user.visible_message("<span class='danger'>[user] puts their hand in the poo! Gross!</span>", "<span class='danger'>You put your hand in the poo, and immediatly regret it</span>")
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/mutable_appearance/poohands = mutable_appearance('hippiestation/icons/effects/poo.dmi', "poohands")
		H.add_overlay(poohands)

/obj/effect/decal/cleanable/poo/Crossed(atom/movable/O)
	. = ..()
	playsound(loc, pick('hippiestation/sound/effects/squish1.ogg', 'hippiestation/sound/effects/squish2.ogg'), 50, 1)

/obj/effect/decal/cleanable/poo/Initialize()
	..()
	reagents.add_reagent("poo", 5)

/obj/effect/decal/cleanable/poo/can_bloodcrawl_in()
	return FALSE

//MONKEY POO THROWING PROC
/mob/living/carbon/monkey/proc/throw_stuff(atom/target)
	if(get_dist(src, target) >= 2 && prob(18))
		visible_message("<span class='danger'>[src] throws poo at [target]!</span>", "You throw poo at [target]!")
		var/turf/proj_turf = get_turf(src)
		if(!isturf(proj_turf))
			return FALSE
		var/obj/item/projectile/monkey/F = new /obj/item/projectile/monkey(proj_turf)
		F.preparePixelProjectile(target, src)
		F.firer = src
		F.fire()
		playsound(src, 'hippiestation/sound/voice/scream_monkey.ogg', 100, 1)
		return TRUE
	return FALSE


////MONKEY POO PROJECTILE
/obj/item/projectile/monkey
	name = "monkey poo"
	icon_state = "monkey"
	damage = 5
	damage_type = TOX
	icon = 'hippiestation/icons/obj/projectiles.dmi'

/obj/item/projectile/monkey/on_hit(atom/target, blocked = FALSE)
	. = ..()
	new /obj/effect/decal/cleanable/poo(get_turf(target))
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/mutable_appearance/pooface = mutable_appearance('hippiestation/icons/effects/poo.dmi', "maskpoo")
		H.add_overlay(pooface)
	return TRUE

////MONKEY POO REAGENT
/datum/reagent/poo
	name = "poo"
	id = "poo"
	description = "it's poo."
	color = "#443a07" //Brown (RGB 68, 58, 7)
	metabolization_rate = 0.75 //lel

/datum/reagent/poo/on_mob_life(mob/living/M)
	if(prob(10))
		M.adjustToxLoss(-1)

/datum/reagent/poo/reaction_turf(turf/open/T, reac_volume)
	if (!istype(T))
		return
	if(reac_volume >= 1)
		for(var/obj/effect/decal/cleanable/poo/P in T.contents) //don't stack poo
			return
		new /obj/effect/decal/cleanable/poo(T)