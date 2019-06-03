#define SLAM_COMBO "GH"
#define KICK_COMBO "HH"
#define RESTRAIN_COMBO "GG"
#define PRESSURE_COMBO "DG"
#define CONSECUTIVE_COMBO "DDH"

/datum/martial_art/cqc
	name = "CQC"
	help_verb = /mob/living/carbon/human/proc/CQC_help
	block_chance = 75
	var/just_a_cook = FALSE
	var/static/list/areas_under_siege = typecacheof(list(/area/crew_quarters/kitchen,
	                                                     /area/crew_quarters/cafeteria,
														 /area/crew_quarters/bar))

/datum/martial_art/cqc/under_siege
	name = "Close Quarters Cooking" // Original name "Culinary School Training"
	just_a_cook = TRUE

/datum/martial_art/cqc/proc/drop_restraining()
	restraining = 0
	
/datum/martial_art/cqc/proc/can_cook(mob/living/carbon/human/A)
	if(just_a_cook)
		var/A_area = get_area(A)
		if (!is_type_in_typecache(A_area, areas_under_siege))
			return FALSE

/datum/martial_art/cqc/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	A.hud_used.combo_object.update_icon(streak, 60)
	if(findtext(streak,SLAM_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		Slam(A,D)
		return TRUE
	if(findtext(streak,KICK_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		Kick(A,D)
		return TRUE
	if(findtext(streak,RESTRAIN_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		Restrain(A,D)
		return TRUE
	if(findtext(streak,PRESSURE_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		Pressure(A,D)
		return TRUE
	if(findtext(streak,CONSECUTIVE_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		Consecutive(A,D)
	return FALSE

/datum/martial_art/cqc/proc/Slam(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat || !D.IsParalyzed())
		D.visible_message("<span class='warning'>[A] slams [D] into the ground!</span>", \
						  	"<span class='userdanger'>[A] slams you into the ground!</span>")
		playsound(get_turf(A), 'sound/weapons/slam.ogg', 50, 1, -1)
		D.apply_damage(10, BRUTE)
		D.Paralyze(120)
		log_combat(A, D, "cqc slammed")
	return TRUE

/datum/martial_art/cqc/proc/Kick(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat || !D.IsParalyzed())
		D.visible_message("<span class='warning'>[A] kicks [D] back!</span>", \
							"<span class='userdanger'>[A] kicks you back!</span>")
		playsound(get_turf(A), 'sound/weapons/cqchit1.ogg', 50, 1, -1)
		var/atom/throw_target = get_edge_target_turf(D, A.dir)
		D.throw_at(throw_target, 1, 14, A)
		D.apply_damage(10, BRUTE)
		log_combat(A, D, "cqc kicked")
	if(D.IsParalyzed() && !D.stat)
		D.visible_message("<span class='warning'>[A] kicks [D]'s head, knocking them out!</span>", \
					  		"<span class='userdanger'>[A] kicks your head, knocking you out!</span>")
		playsound(get_turf(A), 'sound/weapons/genhit1.ogg', 50, 1, -1)
		D.SetSleeping(300)
		D.adjustBrainLoss(25)
	return TRUE

/datum/martial_art/cqc/proc/Pressure(mob/living/carbon/human/A, mob/living/carbon/human/D)
	D.visible_message("<span class='warning'>[A] forces their arm on [D]'s neck!</span>")
	D.adjustStaminaLoss(60)
	playsound(get_turf(A), 'sound/weapons/cqchit1.ogg', 50, 1, -1)
	return TRUE

/datum/martial_art/cqc/proc/Restrain(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(restraining)
		return
	if(!D.stat)
		D.visible_message("<span class='warning'>[A] locks [D] into a restraining position!</span>", \
							"<span class='userdanger'>[A] locks you into a restraining position!</span>")
		D.adjustStaminaLoss(20)
		D.Stun(100)
		restraining = TRUE
		addtimer(CALLBACK(src, .proc/drop_restraining), 50, TIMER_UNIQUE)
	return TRUE

/datum/martial_art/cqc/proc/Consecutive(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat)
		D.visible_message("<span class='warning'>[A] strikes [D]'s abdomen, neck and back consecutively</span>", \
							"<span class='userdanger'>[A] strikes your abdomen, neck and back consecutively!</span>")
		playsound(get_turf(D), 'sound/weapons/cqchit2.ogg', 50, 1, -1)
		var/obj/item/I = D.get_active_held_item()
		if(I && D.dropItemToGround(I))
			A.put_in_hands(I)
		D.adjustStaminaLoss(50)
		D.apply_damage(25, BRUTE)
	return TRUE

/datum/martial_art/cqc/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_cook(A))
		return
	add_to_streak("G",D)
	if(check_streak(A,D))
		return TRUE
	if(A.grab_state >= GRAB_AGGRESSIVE)
		D.grabbedby(A, TRUE)
	else
		A.start_pulling(D, TRUE)
		if(A.pulling)
			D.stop_pulling()
			log_combat(A, D, "grabbed", addition="aggressively")
			A.grab_state = GRAB_AGGRESSIVE //Instant aggressive grab

	return TRUE

/datum/martial_art/cqc/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_cook(A))
		return
	add_to_streak("H",D)
	if(check_streak(A,D))
		return TRUE
	log_combat(A, D, "CQC'd")
	A.do_attack_animation(D)
	var/picked_hit_type = pick("CQC'd", "Big Bossed")
	var/bonus_damage = 13
	if(D.IsParalyzed() || D.resting || D.lying)
		bonus_damage += 5
		picked_hit_type = "stomps on"
	D.apply_damage(bonus_damage, BRUTE)
	if(picked_hit_type == "kicks" || picked_hit_type == "stomps on")
		playsound(get_turf(D), 'sound/weapons/cqchit2.ogg', 50, 1, -1)
	else
		playsound(get_turf(D), 'sound/weapons/cqchit1.ogg', 50, 1, -1)
	D.visible_message("<span class='danger'>[A] [picked_hit_type] [D]!</span>", \
					  "<span class='userdanger'>[A] [picked_hit_type] you!</span>")
	log_combat(A, D, "[picked_hit_type] with CQC")
	if(A.resting && !D.stat && !D.IsParalyzed())
		D.visible_message("<span class='warning'>[A] leg sweeps [D]!", \
							"<span class='userdanger'>[A] leg sweeps you!</span>")
		playsound(get_turf(A), 'sound/effects/hit_kick.ogg', 50, 1, -1)
		D.apply_damage(10, BRUTE)
		D.Paralyze(60)
		log_combat(A, D, "cqc sweeped")
	return TRUE

/datum/martial_art/cqc/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_cook(A))
		return
	add_to_streak("D",D)
	var/obj/item/I = null
	if(check_streak(A,D))
		return TRUE
	if(prob(65))
		if(!D.stat || !D.IsParalyzed() || !restraining)
			I = D.get_active_held_item()
			D.visible_message("<span class='warning'>[A] strikes [D]'s jaw with their hand!</span>", \
								"<span class='userdanger'>[A] strikes your jaw, disorienting you!</span>")
			playsound(get_turf(D), 'sound/weapons/cqchit1.ogg', 50, 1, -1)
			if(I && D.dropItemToGround(I))
				A.put_in_hands(I)
			D.Jitter(2)
			D.apply_damage(5, BRUTE)
	else
		D.visible_message("<span class='danger'>[A] attempted to disarm [D]!</span>", \
							"<span class='userdanger'>[A] attempted to disarm [D]!</span>")
		playsound(D, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
	log_combat(A, D, "disarmed with CQC", "[I ? " grabbing \the [I]" : ""]")
	if(restraining && A.pulling == D)
		D.visible_message("<span class='danger'>[A] puts [D] into a chokehold!</span>", \
							"<span class='userdanger'>[A] puts you into a chokehold!</span>")
		D.SetSleeping(400)
		restraining = 0
		if(A.grab_state < GRAB_NECK)
			A.grab_state = GRAB_NECK
	else
		restraining = 0
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/CQC_help()
	set name = "Remember The Basics"
	set desc = "You try to remember some of the basics of CQC."
	set category = "CQC"

	to_chat(usr, "<b><i>You try to remember some of the basics of CQC.</i></b>")

	to_chat(usr, "<span class='notice'>Slam</span>: Grab Harm. Slam opponent into the ground, knocking them down.")
	to_chat(usr, "<span class='notice'>CQC Kick</span>: Harm Disarm Harm. Knocks opponent away. Knocks out stunned or knocked down opponents.")
	to_chat(usr, "<span class='notice'>Restrain</span>: Grab Grab. Locks opponents into a restraining position, disarm to knock them out with a choke hold.")
	to_chat(usr, "<span class='notice'>Pressure</span>: Disarm Grab. Decent stamina damage.")
	to_chat(usr, "<span class='notice'>Consecutive CQC</span>: Disarm Disarm Harm. Mainly offensive move, huge damage and decent stamina damage.")

	to_chat(usr, "<b><i>In addition, by having your throw mode on when being attacked, you enter an active defense mode where you have a chance to block and sometimes even counter attacks done to you.</i></b>")

/obj/item/cqc_manual
	name = "old manual"
	desc = "A small, black manual. There are drawn instructions of tactical hand-to-hand combat."
	icon = 'icons/obj/library.dmi'
	icon_state ="cqcmanual"

/obj/item/cqc_manual/attack_self(mob/living/carbon/human/user)
	if(!istype(user) || !user)
		return
	to_chat(user, "<span class='boldannounce'>You remember the basics of CQC.</span>")
	var/datum/martial_art/cqc/D = new(null)
	D.teach(user)
	user.dropItemToGround(src)
	visible_message("<span class='warning'>[src] beeps ominously, and a moment later it bursts up in flames.</span>")
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	qdel(src)
