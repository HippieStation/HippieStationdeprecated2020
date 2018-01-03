/obj/item/clothing/gloves/monkeybands
	name = "monkeyman's wristbands"
	desc = "They're tattered, reek of sweat, and look like they haven't been washed in ages. Said to contain the soul of a braindamaged martial artist monkey." //also known as the thing teamstab pulls out of his closet when his wife and kid aren't around
	icon = 'hippiestation/icons/obj/clothing/gloves.dmi'
	icon_state = "monkeybands"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	flags_1 = NODROP_1 | DROPDEL_1

/obj/item/clothing/gloves/monkeybands/equipped(mob/user, slot)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(slot == slot_gloves)
		H.dna.add_mutation(MONKEYMANMUT)
		H.apply_status_effect(STATUS_EFFECT_MONKEYMAN_CURSE)
		var/message = "<span class='sciradio'>You have been possessed by the ghost of the Monkeyman! Your hand-to-hand combat has become all-powerful, and you are now able to deflect any projectiles \
		directed toward you. Your brain, however, has completely melted away and you are now incapable of using ranged weapons and suffer from similar disabilities as the Clown does. \ You can learn more about your newfound art by using the Recall Training verb in the Monkeyman tab. Don't try to cure your disabilities!</span>"
		to_chat(user, message)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/aimed/monkey_fireball)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/monkey_rage_spell/)
		var/datum/martial_art/the_monkeyman/theMonkeyMan = new(null)
		theMonkeyMan.teach(user)
	return

/obj/item/clothing/gloves/monkeybands/Touch(mob/living/target,proximity = TRUE)
	var/mob/living/M = loc

	if(M.a_intent == INTENT_HARM || M.a_intent == INTENT_DISARM)
		M.changeNext_move(CLICK_CD_RAPID)
	.= FALSE

#define SUPER_WRIST_WRENCH_COMBO "DD"
#define BACK_BREAK_COMBO "HG"
#define STOMACH_PUNCH_COMBO "GH"
#define ATOMIC_HEADBUTT_COMBO "DHH"
#define GOD_FIST_COMBO "HHHHHD"


/datum/martial_art/the_monkeyman
	name = "The Ghost of the Monkeyman"
	deflection_chance = 100
	no_guns = TRUE
	allow_temp_override = FALSE
	help_verb = /mob/living/carbon/human/proc/monkeyman_help

/datum/martial_art/the_monkeyman/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	A.hud_used.combo_object.update_icon(streak, 60)
	if(findtext(streak,SUPER_WRIST_WRENCH_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		superwristWrench(A,D)
		return 1
	if(findtext(streak,BACK_BREAK_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		backBreak(A,D)
		return 1
	if(findtext(streak,STOMACH_PUNCH_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		stomachPunch(A,D)
		return 1
	if(findtext(streak,ATOMIC_HEADBUTT_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		atomicHeadbutt(A,D)
		return 1
	if(findtext(streak,GOD_FIST_COMBO))
		streak = ""
		A.hud_used.combo_object.update_icon(streak)
		godFist(A,D)
		return 1
	return 0

/datum/martial_art/the_monkeyman/proc/superwristWrench(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat && !D.IsStun() && D.IsKnockdown())
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		D.visible_message("<span class='warning'>[A] swiftly slaps [D] across the face!</span>", \
						  "<span class='userdanger'>[A] slaps you so hard that you get dazed!</span>")
		playsound(get_turf(D), 'sound/weapons/slap.ogg', 65, 1, -1)
		D.dropItemToGround(D.get_active_held_item())
		D.apply_damage(5, BRUTE, ("head")) // I beg of you, do not remove the second parenthesis. It will break the entire game.
		D.Stun(40)
		add_logs(A, D, "slapped (Monkeyman)")
	else
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		D.visible_message("<span class='warning'>[A] backhands [D] across the face like a bitch!</span>", \
						  "<span class='userdanger'>[A] slaps you with the back of their hand! It hurts like a bitch!</span>")
		playsound(get_turf(D), 'sound/weapons/slap.ogg', 50, 1, -1)
		playsound(get_turf(D), pick('sound/items/toysqueak1.ogg', 'sound/items/toysqueak2.ogg', 'sound/items/toysqueak3.ogg'), 50, 1, -1)
		D.apply_damage(8, BRUTE, ("head")) // I beg of you, do not remove the second parenthesis. It will break the entire game.
		D.dropItemToGround(D.get_active_held_item())
		add_logs(A, D, "bitchslapped (Monkeyman)")
		return TRUE
	return basic_hit(A,D)

/datum/martial_art/the_monkeyman/proc/backBreak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat && !D.IsStun() && D.IsKnockdown())
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		D.visible_message("<span class='warning'>[A] slams [D] in the back with full strength!</span>", \
						  "<span class='userdanger'>[A] punches you in the back, and you collapse!</span>")
		step_to(D,get_step(D,D.dir),1)
		D.Knockdown(25)
		D.apply_damage(25, BRUTE, "chest")
		D.emote("scream")
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 50, 1, -1)
		playsound(get_turf(A), 'sound/creatures/gorilla.ogg', 75, 0, -1)
		add_logs(A, D, "back-broke (Monkeyman)")
		return TRUE
	return basic_hit(A,D)

/datum/martial_art/the_monkeyman/proc/stomachPunch(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat && !D.IsKnockdown())
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		D.visible_message("<span class='warning'>[A] punches [D] in the stomach so hard they cough up blood!</span>", \
						  "<span class='userdanger'>[A] slams your stomach! You choke up blood!</span>")
		D.audible_message("<b>[D]</b> chokes!")
		D.losebreath += 5
		D.Stun(50)
		D.apply_damage(15, BRUTE, "chest")
		D.vomit(blood = TRUE)
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 50, 1, -1)
		playsound(get_turf(A), 'sound/creatures/gorilla.ogg', 75, 0, -1)
		add_logs(A, D, "stomach punched (Monkeyman)")
		return TRUE
	return basic_hit(A,D)

/datum/martial_art/the_monkeyman/proc/atomicHeadbutt(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat)
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		D.visible_message("<span class='warning'>[A] headbutts [D] with such power that it shatters an atom!</span>", \
						  "<span class='userdanger'>[A] headbutts you with atom-shattering strength!</span>")
		D.apply_damage(40, BRUTE, "head")
		A.apply_damage(13, BRUTE, "head")
		playsound(get_turf(D), 'sound/effects/meteorimpact.ogg', 120, 1, -1)
		playsound(get_turf(A), 'sound/creatures/gorilla.ogg', 75, 0, -1)
		D.AdjustUnconscious(8)
		D.adjustBrainLoss(30)
		var/datum/effect_system/explosion/E = new
		E.set_up(get_turf(D))
		E.start()
		add_logs(A, D, "atomic headbutted (Monkeyman)")
	else
		A.do_attack_animation(D, ATTACK_EFFECT_KICK)
		D.visible_message("<span class='warning'><b>[A] annihilates [D] with an Atomic Headbutt!<b></span>", \
						  "<span class='userdanger'><b>[A] sends you to Hell!</b></span>")
		var/datum/effect_system/explosion/E = new
		E.set_up(get_turf(D))
		E.start()
		playsound(get_turf(D), 'sound/magic/wandodeath.ogg', 165, 1, -1)
		A.reagents.add_reagent("omnizine", 5)
		D.gib() //It's like the plasma fist if it was less obnoxious!
		add_logs(A, D, "annihilated (Monkeyman)")
		return TRUE
	return basic_hit(A,D)

/datum/martial_art/the_monkeyman/proc/godFist(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat)
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		D.visible_message("<span class='warning'>[A] channels energy into their fist and drives it into [D]'s cheek!</span>", \
						  "<span class='userdanger'>[A] blasts you away with a charged fist!</span>")
		D.apply_damage(30, BRUTE, "head")
		A.apply_damage(7, BRUTE, pick("l_arm", "r_arm"))
		var/datum/effect_system/explosion/E = new
		E.set_up(get_turf(D))
		E.start()
		var/atom/throw_target = get_edge_target_turf(D, get_dir(D, get_step_away(D, A)))
		playsound(get_turf(A), 'sound/weapons/zapbang.ogg', 50, 1)
		D.throw_at(throw_target, 25, 2,A)
		add_logs(A, D, "monkey-fisted (Monkeyman)")
	else
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		D.visible_message("<span class='warning'><b>[A] channels a boatload of energy into their fist and blasts [D] away in a single punch!<b></span>", \
						  "<span class='userdanger'>[A] sends you flying with a legendary Wizard Fist!</span>")
		D.apply_damage(600, BRUTE, "head", "l_arm", "r_arm", "l_leg", "r_leg", "chest") // Just for flair, the combo would kill you regardless
		A.apply_damage(15, BRUTE, pick("l_arm", "r_arm"))
		var/datum/effect_system/explosion/E = new
		E.set_up(get_turf(D))
		E.start()
		var/atom/throw_target = get_edge_target_turf(D, get_dir(D, get_step_away(D, A)))
		playsound(get_turf(A), 'sound/magic/staff_chaos.ogg', 50, 1)
		playsound(get_turf(A), 'sound/weapons/resonator_blast.ogg', 50, 1)
		D.throw_at(throw_target, 200, 5,A)
		D.weakfist_casted = TRUE
		add_logs(A, D, "WIZARD-FISTED (Monkeyman)")
		A.say("You shouldn't be seeing this text!") //The monkeyman's mask replaces text.
		return TRUE
	return basic_hit(A,D)

/datum/martial_art/the_monkeyman/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("G",D)
	if(check_streak(A,D))
		return 1
	if(A.grab_state >= GRAB_AGGRESSIVE)
		D.grabbedby(A, 1)
	else
		A.start_pulling(D, 1)
		if(A.pulling)
			D.drop_all_held_items()
			D.stop_pulling()
			if(A.a_intent == INTENT_GRAB)
				add_logs(A, D, "grabbed", addition="aggressively")
				A.grab_state = GRAB_AGGRESSIVE //Instant aggressive grab
			else
				add_logs(A, D, "grabbed", addition="passively")
				A.grab_state = GRAB_PASSIVE
	return 1

/datum/martial_art/the_monkeyman/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("H",D)
	if(check_streak(A,D))
		return 1
	A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
	var/attack_verb = "attacked (Monkeyman)"
	if(A.has_status_effect(STATUS_EFFECT_MONKEY_RAGE))
		var/atk_verb = pick("pounds", "slams", "mudamudas", "wrecks", "pulverizes")
		D.visible_message("<span class='danger'>[A] [atk_verb] [D]!</span>", \
			"<span class='userdanger'>[A] [atk_verb] you!</span>")
		D.apply_damage(rand(17,21), BRUTE)
		playsound(get_turf(D), 'sound/effects/pop_expl.ogg', 225, 1, -1)
	else
		var/atk_verb = pick("jabs", "kicks", "oraoras", "hooks", "slams")
		D.visible_message("<span class='danger'>[A] [atk_verb] [D]!</span>", \
			"<span class='userdanger'>[A] [atk_verb] you!</span>")
		D.apply_damage(rand(12,16), BRUTE)
		playsound(get_turf(D), 'sound/effects/pop_expl.ogg', 175, 1, -1)
	if(prob(D.getBruteLoss()) && !D.lying)
		D.visible_message("<span class='warning'>[D] stumbles and falls!</span>", "<span class='userdanger'>The blow sends you to the ground!</span>")
		D.Knockdown(40)
	add_logs(A, D, "[attack_verb]")
	return 1


/datum/martial_art/the_monkeyman/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("D",D)
	if(check_streak(A,D))
		return 1
	return ..()

/mob/living/carbon/human/proc/monkeyman_help()
	set name = "Recall Training"
	set desc = "Remember the techniques of the Monkeyman's ghost."
	set category = "Monkeyman"

	to_chat(usr, "<b><i>The Ghost of the Monkeyman floods your thoughts with his old skills...</i></b>")

	to_chat(usr, "<span class='notice'>Bitchslap/Stunslap</span>: Disarm Disarm. Forces opponent to drop item in hand. Will sometimes stun. Good for annoying people to death.") // Only stuns sometimes because Wrist Wrench code is a nightmare.
	to_chat(usr, "<span class='notice'>Back Break</span>: Harm Grab. Deals considerable damage. Knocks down.")
	to_chat(usr, "<span class='notice'>Stomach Knee</span>: Grab Harm. Causes the opponent to choke up blood and stuns.")
	to_chat(usr, "<span class='notice'>Atomic Headbutt</span>: Disarm Harm Harm. Huge damage, knocks out opponent for a short time and gives them brain damage, but damages yourself as well. Gibs the target and gives you Omnizine if the opponent is in crit or dead.")
	to_chat(usr, "<span class='notice'>Monkey Fist</span>: Harm Harm Harm Harm Harm Disarm. Deals huge damage, and sends the opponent flying. Damages yourself very slightly upon use. Becomes Wizard Fist on opponents who are in critical condition.")
	to_chat(usr, "<span class='notice'>Wizard Fist</span>: Use Monkey Fist on an opponent currently in critical condition. Instantly kills the victim, and launches the victim's corpse away. Damages yourself upon use. <span class+'warning'>Do not use too close to a wall!</span>")
