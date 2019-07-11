/datum/guardian_ability/major/healing
	name = "Healing"
	desc = "The power to heal anything, living or inanimate, by touch."
	cost = 4
	has_mode = TRUE
	mode_on_msg = "<span class='danger'><B>You switch to healing mode.</span></B>"
	mode_off_msg = "<span class='danger'><B>You switch to combat mode.</span></B>"

/datum/guardian_ability/major/healing/Apply(mob/living/simple_animal/hostile/guardian/guardian)
	var/datum/atom_hud/medsensor = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	medsensor.add_hud_to(guardian)

/datum/guardian_ability/major/healing/Attack(mob/living/simple_animal/hostile/guardian/guardian, atom/target)
	if(mode)
		if(isliving(target))
			var/mob/living/L = target
			guardian.do_attack_animation(L)
			L.adjustBruteLoss(-5)
			L.adjustFireLoss(-5)
			L.adjustOxyLoss(-5)
			L.adjustToxLoss(-5)
			var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal(get_turf(L))
			if(guardian.namedatum)
				H.color = guardian.namedatum.colour
			if(L == guardian.summoner)
				guardian.update_health_hud()
				guardian.med_hud_set_health()
				guardian.med_hud_set_status()
			return TRUE
		else if(isobj(target))
			var/obj/O = target
			guardian.do_attack_animation(O)
			O.obj_integrity = min(O.obj_integrity + (O.max_integrity * 0.1), O.max_integrity)
			var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal(get_turf(O))
			if(guardian.namedatum)
				H.color = guardian.namedatum.colour
			return TRUE
