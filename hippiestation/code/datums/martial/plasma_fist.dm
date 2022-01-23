#define KNOCKOUT_COMBO "GGH"
#define TORNADO_COMBO "HHD"
#define THROWBACK_COMBO "DHD"
#define PLASMA_COMBO "HDDDH"

/datum/martial_art/plasma_fist
	name = "Plasma Fist"
	help_verb = /mob/living/carbon/human/proc/plasma_fist_help


/datum/martial_art/plasma_fist/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	A.hud_used.combo_object.update_icon(streak, 60)
	if(findtext(streak,KNOCKOUT_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		Knockout(A,D)
		return TRUE
	if(findtext(streak,TORNADO_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		Tornado(A,D)
		return TRUE
	if(findtext(streak,THROWBACK_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		Throwback(A,D)
		return TRUE
	if(findtext(streak,PLASMA_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		Plasma(A,D)
		return TRUE
	return FALSE

/datum/martial_art/plasma_fist/proc/TornadoAnimate(mob/living/carbon/human/A)
	set waitfor = FALSE
	for(var/i in list(NORTH,SOUTH,EAST,WEST,EAST,SOUTH,NORTH,SOUTH,EAST,WEST,EAST,SOUTH))
		if(!A)
			break
		A.setDir(i)
		playsound(A.loc, 'sound/weapons/punch1.ogg', 15, 1, -1)
		sleep(1)

/datum/martial_art/plasma_fist/proc/Tornado(mob/living/carbon/human/A, mob/living/carbon/human/D)
	A.say("TORNADO SWEEP!", forced = "plasma fist")
	TornadoAnimate(A)
	var/obj/effect/proc_holder/spell/aoe_turf/repulse/R = new(null)
	var/list/turfs = list()
	for(var/turf/T in range(1,A))
		turfs.Add(T)
	R.cast(turfs)
	log_combat(A, D, "tornado sweeped (Plasma Fist)")
	return

/datum/martial_art/plasma_fist/proc/Knockout(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	log_combat(A, D, "knockouted (Plasma Fist)")
	D.visible_message("<span class='danger'>[A] has knocked down [D] with a kick!</span>", \
								"<span class='userdanger'>[A] has knocked down [D] with a kick!</span>")
	playsound(D.loc, 'sound/weapons/punch1.ogg', 50, 1)
	D.adjustBruteLoss(6) //Decentish damage. It racks up to 16 if the victim hits a wall.
	D.Paralyze(40)
	var/atom/throw_target = get_edge_target_turf(D, get_dir(D, get_step_away(D, A)))
	D.throw_at(throw_target, 2, 2)
	A.say("KNOCKOUT KICK!", forced = "plasma fist")
	return

/datum/martial_art/plasma_fist/proc/Throwback(mob/living/carbon/human/A, mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] has hit [D] with Throwback Punch!</span>", \
								"<span class='userdanger'>[A] has hit [D] with Throwback Punch!</span>")
	playsound(D.loc, 'sound/weapons/punch1.ogg', 50, 1, -1)
	var/atom/throw_target = get_edge_target_turf(D, get_dir(D, get_step_away(D, A)))
	playsound(get_turf(A), 'sound/magic/blink.ogg', 50, 1)
	D.throw_at(throw_target, 200, 4,A)
	A.say("THROWBACK PUNCH!", forced = "plasma fist")
	log_combat(A, D, "threw back (Plasma Fist)")
	return

/datum/martial_art/plasma_fist/proc/Plasma(mob/living/carbon/human/A, mob/living/carbon/human/D)
	A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
	playsound(D.loc, 'sound/weapons/punch1.ogg', 50, 1, -1)
	A.say("PLASMA FIST!", forced = "plasma fist")
	D.visible_message("<span class='danger'>[A] has hit [D] with THE PLASMA FIST TECHNIQUE!</span>", \
								"<span class='userdanger'>[A] has hit [D] with THE PLASMA FIST TECHNIQUE!</span>")
	D.gib()
	log_combat(A, D, "gibbed (Plasma Fist)")
	return

/datum/martial_art/plasma_fist/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("H",D)
	if(check_streak(A,D))
		return TRUE
	basic_hit(A,D)
	return TRUE

/datum/martial_art/plasma_fist/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("D",D)
	if(check_streak(A,D))
		return TRUE
	basic_hit(A,D)
	return TRUE

/datum/martial_art/plasma_fist/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("G",D)
	if(check_streak(A,D))
		return TRUE
	basic_hit(A,D)
	return 1

/mob/living/carbon/human/proc/plasma_fist_help()
	set name = "Recall Teachings"
	set desc = "Remember the martial techniques of the Plasma Fist."
	set category = "Plasma Fist"

	to_chat(usr, "<b><i>You clench your fists and have a flashback of knowledge...</i></b>")
	to_chat(usr, "<span class='notice'>KNOCKOUT KICK</span>: Grab, Grab, Harm. Knocks down the target with a kick.")
	to_chat(usr, "<span class='notice'>TORNADO SWEEP</span>: Harm Harm Disarm. Repulses target and everyone back.")
	to_chat(usr, "<span class='notice'>THROWBACK PUNCH</span>: Disarm Harm Disarm. Throws the target and an item at them.")
	to_chat(usr, "<span class='notice'>PLASMA FIST</span>: Harm Disarm Disarm Disarm Harm. Knocks the brain out of the opponent and gibs their body.")

/obj/item/plasma_fist_scroll
	name = "frayed scroll"
	desc = "An aged and frayed scrap of paper written in shifting runes. There are hand-drawn illustrations of pugilism."
	icon = 'icons/obj/wizard.dmi'
	icon_state ="scroll2"
	var/used = 0

/obj/item/plasma_fist_scroll/attack_self(mob/user)
	if(!ishuman(user))
		return
	if(!used)
		var/mob/living/carbon/human/H = user
		var/datum/martial_art/plasma_fist/F = new/datum/martial_art/plasma_fist(null)
		F.teach(H)
		to_chat(H, "<span class='boldannounce'>You have learned the ancient martial art of Plasma Fist.</span>")
		used = TRUE
		desc = "It's completely blank."
		name = "empty scroll"
		icon_state = "blankscroll"
