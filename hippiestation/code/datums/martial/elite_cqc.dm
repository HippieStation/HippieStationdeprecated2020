#define KNOCKOUT_COMBOEC "HHG"
#define EXHAUSTION_COMBO "DDG"
#define GIB_COMBO "DHHHH"

/datum/martial_art/elite_cqc
	name = "Elite CQC"
	help_verb = /mob/living/carbon/human/proc/elite_cqc_help

/datum/martial_art/elite_cqc/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(findtext(streak,KNOCKOUT_COMBOEC))
		streak = ""
		Knockout(A,D)
		return TRUE
	if(findtext(streak,EXHAUSTION_COMBO))
		streak = ""
		Exhaustion(A,D)
		return TRUE
	if(findtext(streak,GIB_COMBO))
		streak = ""
		Gib(A,D)
		return TRUE
	return FALSE


/datum/martial_art/elite_cqc/proc/Gib(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if (D.stat)
		D.visible_message("<span class='danger'>[A] stomps and slams [D]!</span>", \
		"<span class='userdanger'>[A] stomps and slams you!</span>")
		D.adjustBruteLoss(90)
		log_combat(A, D, "stomped (Elite CQC)")
		return FALSE
	D.visible_message("<span class='danger'>[A] tears [D] in half and stomps on them, gibbing them!</span>", \
	"<span class='userdanger'>[A] tears you in half and stomps on you, gibbing you!</span>")
	D.gib()
	log_combat(A, D, "gibbed (Elite CQC)")
	return TRUE

/datum/martial_art/elite_cqc/proc/Knockout(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if (!D.stat)
		return FALSE
	D.visible_message("<span class='danger'>[A] grabs [D] and slams them on the neck, knocking them out!</span>", \
	"<span class='userdanger'>[A] grabs you and slams you on the neck, knocking you out!</span>")
	D.SetSleeping(2000)
	log_combat(A, D, "knocked out (Elite CQC)")
	return TRUE

/datum/martial_art/elite_cqc/proc/Exhaustion(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if (!D.stat)
		return FALSE
	D.visible_message("<span class='danger'>[A] subdues [D] and squeezes pressure points on their neck, exhausting them!</span>", \
	"<span class='userdanger'>[A] grabs you and spressure points on your neck, exhausting you!</span>")
	D.adjustStaminaLoss(100)
	return TRUE

/datum/martial_art/elite_cqc/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("G",D)
	if(check_streak(A,D))
		return TRUE
	if(A.grab_state >= GRAB_NECK)
		D.grabbedby(A, 1)
	else
		A.start_pulling(D)
		if(A.pulling)
			D.stop_pulling()
			log_combat(A, D, "grabbed", addition="by the neck")
			A.grab_state = GRAB_NECK
	return TRUE

/datum/martial_art/elite_cqc/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("H",D)
	if(check_streak(A,D))
		return TRUE
	if (!D.IsParalyzed())
		D.visible_message("<span class='danger'>[A] slams their hands into [D], knocking them down!</span>", \
		"<span class='userdanger'>[A] slams their hands into you, knocking you down!</span>")
		D.Paralyze(60)
	else
		basic_hit(A,D)
	return TRUE

/datum/martial_art/elite_cqc/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("D",D)
	if(check_streak(A,D))
		return TRUE
	if(!D.stat || !D.IsParalyzed() || !restraining)
		var/obj/item/I = D.get_active_held_item()
		D.visible_message("<span class='warning'>[A] disarms [D]!</span>", \
							"<span class='userdanger'>[A] disarms you!</span>")
		if(I && D.temporarilyRemoveItemFromInventory(I))
			A.put_in_hands(I)
		D.Jitter(2)
		D.apply_damage(5, BRUTE)

/mob/living/carbon/human/proc/elite_cqc_help()
	set name = "Remember The Basics"
	set desc = "You try to remember some of the basics of Elite CQC."
	set category = "Elite CQC"
	to_chat(usr, "<b><i>You try to remember your training.</i></b>")

	to_chat(usr, "<span class='notice'>Stomp and Slam</span>: Disarm Harm Harm Harm Harm. Stomp and slams the opponent, dealing major damage and gibbing if dead.")
	to_chat(usr, "<span class='notice'>Subdue</span>: Disarm Grab Grab. Subdues the opponent, stunning and dealing stamina damage.")
	to_chat(usr, "<span class='notice'>Knockout</span>: Harm Harm Grab. Knocks out the opponent.")
