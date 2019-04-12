/mob/living/simple_animal/hostile/true_changeling/adminbus/gibs
	name = "Gibs"
	real_name = "Gibs"
	desc = "Something seems odd about that pile of gibs..."
	scream_sound_near = list('hippiestation/sound/misc/squishy.ogg','hippiestation/sound/misc/crack.ogg','hippiestation/sound/misc/crunch.ogg')
	scream_sound_far = 'sound/spookoween/insane_low_laugh.ogg'
	speak = list("I seek flesh...","You can't hide...","I will gib you!","What am I?")
	speak_chance = 2
	speak_emote = list("squelches")
	emote_hear = list("squelches horribly")
	icon = 'icons/effects/blood.dmi'
	icon_state = "gibdown1"
	icon_living = "gibdown1"
	icon_dead = "gib2"
	blood_volume = INFINITY
	wander = TRUE

/mob/living/simple_animal/hostile/true_changeling/adminbus/gibs/Initialize()
	. = ..()
	qdel(reform)
	icon_state = pick("gibdown1", "gibup1", "gibmid3")
	icon_living = icon_state

/mob/living/simple_animal/hostile/true_changeling/adminbus/gibs/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/redirect, list(COMSIG_COMPONENT_CLEAN_ACT = CALLBACK(src, .proc/hurt_gibs)))

/mob/living/simple_animal/hostile/true_changeling/adminbus/gibs/Move(atom/newloc, direct)
	. = ..()
	if(prob(80))
		add_splatter_floor(src.loc,FALSE)

/mob/living/simple_animal/hostile/true_changeling/adminbus/gibs/proc/hurt_gibs()
	if(prob(40))
		adjustBruteLoss(35)
		visible_message("<span class='warning'>[src] shrivels in reaction to being cleaned!</span>", "<span class='danger'>You can feel your form being disintegrated!.</span>")

/mob/living/simple_animal/hostile/true_changeling/adminbus/gibs/CanAttack(atom/the_target)
	return TRUE

/mob/living/simple_animal/hostile/true_changeling/adminbus/gibs/AttackingTarget()
	if(prob(50))
		if(isliving(target))
			var/mob/living/lunch = target
			if(lunch)
				devouring = TRUE
				visible_message("<span class='warning'>[src] begins ripping apart and feasting on [lunch]!</span>", \
					"<span class='danger'>We begin to feast upon [lunch]...</span>")
				if(!do_mob(src, 10, target = lunch))
					devouring = FALSE
					return FALSE
				devouring = FALSE
				if(lunch.getBruteLoss() + lunch.getFireLoss() >= 200) //OK, ok. this change was actually super rad hippiestation  i like it -Armhulen
					visible_message("<span class='warning'>[lunch] is completely devoured by [src]!</span>", \
							"<span class='danger'>You completely devour [lunch]!</span>")
					lunch.gib() //hell yes.
				else
					lunch.adjustBruteLoss(60)
					visible_message("<span class='warning'>[src] tears a chunk from [lunch]'s flesh!</span>", \
							"<span class='danger'>We tear a chunk of flesh from [lunch] and devour it!</span>")
					to_chat(lunch, "<span class='userdanger'>[src] takes a huge bite out of you!</span>")
					var/obj/effect/decal/cleanable/blood/gibs/G = new(get_turf(lunch))
					step(G, pick(GLOB.alldirs)) //Make some gibs spray out for dramatic effect
					playsound(lunch, 'sound/effects/splat.ogg', 50, 1)
					playsound(lunch, 'hippiestation/sound/misc/tear.ogg', 50, 1)
					lunch.emote("scream")
					adjustBruteLoss(-50)
	. = ..()
