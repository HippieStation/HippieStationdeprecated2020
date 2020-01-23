#define RIPPLE_BEAT_COMBO "DD"
#define ZOOM_PUNCH_COMBO "HH"
#define SENDO_WAVE_KICK_COMBO "GH"
#define TORNADO_OVERDRIVE_COMBO "HG"
#define SUNLIGHT_YELLOW_OVERDRIVE_COMBO "HDHDH"

/datum/martial_art/hamon
	name = "Hamon"
	deflection_chance = 70
	allow_temp_override = FALSE
	help_verb = /mob/living/carbon/human/proc/hamon_help

/datum/martial_art/hamon/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(findtext(streak,RIPPLE_BEAT_COMBO))
		streak = ""
		rippleBeat(A,D)
		return 1
	if(findtext(streak,ZOOM_PUNCH_COMBO))
		streak = ""
		zoomPunch(A,D)
		return 1
	if(findtext(streak,SENDO_WAVE_KICK_COMBO))
		streak = ""
		sendoWaveKick(A,D)
		return 1
	if(findtext(streak,TORNADO_OVERDRIVE_COMBO))
		streak = ""
		tornadoOverdrive(A,D)
		return 1
	if(findtext(streak,SUNLIGHT_YELLOW_OVERDRIVE_COMBO))
		streak = ""
		sunlightYellowOverdrive(A,D)
		return 1
	return 0

/datum/martial_art/hamon/proc/rippleBeat(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat && !D.IsStun() && !D.IsParalyzed())
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		A.say("Ripple Beat!")
		D.visible_message("<span class='warning'>[A] chops [D]'s hand with a hamon infused palm!</span>", \
						  "<span class='userdanger'>[A] chops at your hand with a palm surrounded by yellow sparks!</span>")
		playsound(get_turf(A), 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		D.emote("scream")
		D.dropItemToGround(D.get_active_held_item())
		D.apply_damage(5, BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		D.Stun(20)
		return 1
	log_combat(A, D, "used ripple beat (hamon)")
	return basic_hit(A,D)

/datum/martial_art/hamon/proc/zoomPunch(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat && !D.IsStun() && !D.IsParalyzed())
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		A.say("Zoom Punch!")
		D.visible_message("<span class='warning'>[A] extends his arm and punches [D] with a hamon infused fist!</span>", \
						  "<span class='userdanger'>[A]'s arm suddenly crunches and extends towards you at an alarming speed!</span>")
		playsound(get_turf(A), 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		D.emote("scream")
		D.apply_damage(10, BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_CHEST))
		return 1
	log_combat(A, D, "used zoom punch (hamon)")
	return basic_hit(A,D)


/datum/martial_art/hamon/proc/sendoWaveKick(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat && !D.IsParalyzed())
		A.do_attack_animation(D, ATTACK_EFFECT_KICK)
		D.visible_message("<span class='warning'>[A] focuses ripple in his knee and knees [D] in the stomach!</span>", \
						  "<span class='userdanger'>[A] winds you with a knee in the stomach!</span>")
		A.emote("scream")
		A.say("Sendo Wave Kick!")
		D.audible_message("<b>[D]</b> gags!")
		D.losebreath += 3
		D.Stun(40)
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 50, 1, -1)
		D.apply_damage(10, BRUTE, BODY_ZONE_CHEST)
		return 1
	log_combat(A, D, "sendo wave kicked (hamon)")
	return basic_hit(A,D)

/datum/martial_art/hamon/proc/tornadoOverdrive(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(A.dir == D.dir && !D.stat && !D.IsParalyzed())
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		D.visible_message("<span class='warning'>[A] leaps forward, spins in midair, and slams their legs into [D]'s back!</span>", \
						  "<span class='userdanger'>[A] kicks you in the back, slamming you into the ground!</span>")
		step_to(D,get_step(D,D.dir),1)
		A.say("Tornado Overdrive!")
		D.Paralyze(80)
		D.apply_damage(10, BRUTE, BODY_ZONE_CHEST)
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 50, 1, -1)
		return 1
	log_combat(A, D, "tornado overdrived (hamon)")
	return basic_hit(A,D)

/datum/martial_art/hamon/proc/sunlightYellowOverdrive(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!(D.mobility_flags & MOBILITY_STAND))
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		D.visible_message("<span class='warning'>[A]'s arms glow a bright yellow before they suddenly pummel [D] with an extremely powerful blow!</span>", \
						  "<span class='userdanger'>[A] shoves their fist straight through your chest!</span>")
		A.say("Sunlight Yellow Overdrive!")
		D.say("Noooooooo!")
		if(D.stat)
			D.death() //FINISH HIM!
		D.apply_damage(50, BRUTE, BODY_ZONE_CHEST)
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 75, 1, -1)
		return 1
	log_combat(A, D, "sunlight yellow overdrived (hamon)")
	return basic_hit(A,D)

/datum/martial_art/hamon/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("G",D)
	if(check_streak(A,D))
		return 1
	if(A.grab_state >= GRAB_AGGRESSIVE)
		D.grabbedby(A, 1)
	else
		A.start_pulling(D, supress_message = TRUE)
		if(A.pulling)
			D.drop_all_held_items()
			D.stop_pulling()
			if(A.a_intent == INTENT_GRAB)
				log_combat(A, D, "grabbed", addition="aggressively")
				D.visible_message("<span class='warning'>[A] violently grabs [D]!</span>", \
				  "<span class='userdanger'>[A] violently grabs you!</span>")
				A.grab_state = GRAB_AGGRESSIVE //Instant aggressive grab
			else
				log_combat(A, D, "grabbed", addition="passively")
				A.grab_state = GRAB_PASSIVE
	return 1

/datum/martial_art/hamon/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("H",D)
	if(check_streak(A,D))
		return 1
	A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
	var/atk_verb = pick("punches", "kicks", "chops", "hits", "slams")
	D.visible_message("<span class='danger'>[A] [atk_verb] [D]!</span>", \
					  "<span class='userdanger'>[A] [atk_verb] you!</span>")
	D.apply_damage(rand(10,15), BRUTE)
	playsound(get_turf(D), 'sound/weapons/punch1.ogg', 25, 1, -1)
	if(prob(D.getBruteLoss()) && (D.mobility_flags & MOBILITY_STAND))
		D.visible_message("<span class='warning'>[D] stumbles and falls!</span>", "<span class='userdanger'>The blow sends you to the ground!</span>")
		D.Paralyze(80)
	log_combat(A, D, "[atk_verb] (hamon)")
	return 1


/datum/martial_art/hamon/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("D",D)
	if(check_streak(A,D))
		return 1
	return ..()

/mob/living/carbon/human/proc/hamon_help()
	set name = "Recall Teachings"
	set desc = "Remember the secrets of Hamon."
	set category = "Hamon"

	to_chat(usr, "<b><i>You close your eyes and focus on your breathing...</i></b>")

	to_chat(usr, "<span class='notice'>Ripple Beat</span>: Disarm Disarm. A hamon infused chop, forcing the opponent to drop what they're holding.")
	to_chat(usr, "<span class='notice'>Zoom Punch</span>: Harm Harm. An insanely fast punch made possible by dislocating the joints in the arm to quickly attack the enemy with a hamon infused fist.")
	to_chat(usr, "<span class='notice'>Sendo Wave Kick</span>: Grab Harm. A ripple infused strike with the knee that leaves the opponent breathless and stuns them.")
	to_chat(usr, "<span class='notice'>Tornado Overdrive</span>: Harm Grab. A dive bomb attack made possible by channeling hamon into the legs and striking the opponents head, forces the opponent to drop item in hand. They must be facing away from you.")
	to_chat(usr, "<span class='notice'>Sunlight Yellow Overdrive</span>: Harm Disarm Harm Disarm Harm. Opponent must be on the ground. A devastating and extremely strong hamon-infused strike with power comparable to the sun. Instantly kills anyone in critical condition.")




