/obj/item/clothing/gloves/color/yellow/palpatine
	special_name = "Powermaster"
	special_desc = "Drains more stamina and possibly causes burn damage the longer it is used."
	special_cost = 0
	actions_types = list(/datum/action/item_action/special_attack)
	var/next_shock = 0
	var/shock_delay = 40
	var/unlimited_power = FALSE
	var/specialing = FALSE

/obj/item/clothing/gloves/color/yellow/palpatine/do_special_attack(atom/target, mob/living/carbon/user)
	if(user.gloves != src || specialing)
		return FALSE
	var/obj/structure/cable/C
	for(var/turf/T in range(2, user))
		C = locate() in T
		if(C && istype(C))
			break
	if(!C || !istype(C))
		return FALSE
	. = ..()
	specialing = TRUE
	user.emote("scream")
	while(do_after_mob(user, user, 15, TRUE))
		if(user.incapacitated() || user.InCritical())
			break
		var/list/targets = list()
		for(var/mob/living/L in view(5, user))
			if(L == user || L.stat == DEAD)
				continue
			targets += L
		playsound(user, 'sound/magic/lightningbolt.ogg', 40, TRUE)	
		var/lt = length(targets)
		for(var/mob/living/L in targets)
			to_chat(L, "<span class='danger bold'>You're hit by lightning!</span>")
			user.Beam(L, icon_state="red_lightning", time=15)
			L.adjustFireLoss(13 / lt)
		if(prob(30))
			var/list/machines = list()
			for(var/obj/machinery/M in view(world.view, user))
				machines += M
			for(var/i = 1 to rand(3, 7))
				if(!LAZYLEN(machines))
					break
				var/obj/machinery/M = pick_n_take(machines)
				user.Beam(M, icon_state="purple_lightning", time=15)
				M.emp_act(EMP_HEAVY)
		user.adjustStaminaLoss(15)
		if(prob(20))
			user.adjustFireLoss(4 * lt)
	specialing = FALSE
	special_attack = FALSE

/obj/item/clothing/gloves/color/yellow/palpatine/equipped(mob/user, slot)
	. = ..()
	if(slot == SLOT_GLOVES)
		RegisterSignal(user, COMSIG_MOB_CLICKON, .proc/Zap)

/obj/item/clothing/gloves/color/yellow/palpatine/dropped(mob/user)
	. = ..()
	UnregisterSignal(user, COMSIG_MOB_CLICKON)

/obj/item/clothing/gloves/color/yellow/palpatine/proc/Zap(mob/user, atom/target, params)
	if(target == user || !iscarbon(user) || user.incapacitated(ignore_grab = TRUE) || specialing)
		return
	var/mob/living/carbon/CL = user
	if(CL.gloves != src)
		return
	if(special_attack)
		INVOKE_ASYNC(src, .proc/do_special_attack, target, user)
		return COMSIG_MOB_CANCEL_CLICKON
	if(!(user.a_intent in list(INTENT_HARM, INTENT_DISARM)) || !(target in view(world.view, user)) || !(isliving(target) || isobj(target)))
		return
	if(next_shock > world.time)
		to_chat(user, "<span class='warning'>You must wait [DisplayTimeText(next_shock - world.time)] until you can shock again.</span>")
		return
	var/turf/UT = get_turf(user)
	var/obj/structure/cable/C = locate() in UT
	if(!unlimited_power)
		if(!C || !istype(C))
			to_chat(user, "<span class='warning'>There is no cable here to power the gloves.</span>")
			return
	if(isliving(target))
		target.visible_message("<span class='danger'>A bolt of electricity erupts from [user]'s hands, electrocuting [target]!</span>", "<span class='userdanger'>A bolt of electricity erupts from [user]'s hands, electrocuting you!</span>", "<i>You hear a <b>ZAP!</b></i>")
		user.Beam(target, icon_state="red_lightning", time=10)
	else
		target.visible_message("<span class='danger'>A bolt of electricity erupts from [user]'s hands, zapping [target]!</span>")
		user.Beam(target, icon_state="purple_lightning", time=10)
	playsound(user, 'sound/magic/lightningbolt.ogg', 40, TRUE)	
	if(isliving(target))
		var/mob/living/L = target
		if(user.a_intent == INTENT_DISARM)
			L.Paralyze(50)
		else
			if(unlimited_power)
				L.electrocute_act(1000, src, safety = TRUE, override = TRUE) //Just kill them
			else
				electrocute_mob(L, C, src)
	else if(isobj(target))
		target.emp_act(EMP_HEAVY)
	next_shock = world.time + shock_delay
	return COMSIG_MOB_CANCEL_CLICKON
