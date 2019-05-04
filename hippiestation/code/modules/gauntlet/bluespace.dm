/obj/item/infinity_stone/bluespace
	name = "Bluespace Stone"
	desc = "Stare into the abyss, and the abyss stares back..."
	icon = 'hippiestation/icons/obj/infinity.dmi'
	icon_state = "bluespace"
	stone_type = BLUESPACE_STONE
	ability_text = list("HELP INTENT: teleport target to safe location", 
		"HARM INTENT: teleport to specified location", 
		"DISARM INTENT: steal item someone is holding", 
		"GRAB INTENT: toggle intangibility")
	spell_types = list(/obj/effect/proc_holder/spell/self/infinity/bluespace_stone_shield, 
		/obj/effect/proc_holder/spell/targeted/turf_teleport/blink/bluespace_stone,
		/obj/effect/proc_holder/spell/targeted/ethereal_jaunt/bluespace_stone)

/obj/item/infinity_stone/bluespace/GiveAbilities(mob/living/L)
	. = ..()
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		C.gain_trauma_type(/datum/brain_trauma/special/bluespace_prophet, TRAUMA_RESILIENCE_ABSOLUTE)

/obj/item/infinity_stone/bluespace/RemoveAbilities(mob/living/L)
	. = ..()
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		C.cure_trauma_type(/datum/brain_trauma/special/bluespace_prophet, TRAUMA_RESILIENCE_ABSOLUTE)

/obj/item/infinity_stone/bluespace/DisarmEvent(atom/target, mob/living/user, proximity_flag)
	if(isliving(target))
		var/mob/living/L = target
		var/obj/O = L.get_active_held_item()
		if(O && !istype(O, /obj/item/infinity_stone) && L.dropItemToGround(O))
			L.visible_message("<span class='danger'>[L]'s [O] disappears from their hands!</span>", "<span class='danger'>Our [O] disappears!</span>")
			O.forceMove(get_turf(user))
			user.equip_to_slot(O, SLOT_IN_BACKPACK)	

/obj/item/infinity_stone/bluespace/HelpEvent(atom/target, mob/living/user, proximity_flag)
	if(proximity_flag && isliving(target))
		target.visible_message("<span class='danger'>[target] warps away!</span>", "<span class='notice'>We warp [target == user ? "ourselves" : target] to a safe location.</span>")
		var/turf/potential_T = find_safe_turf(extended_safety_checks = TRUE)
		do_teleport(target, potential_T, channel = TELEPORT_CHANNEL_MAGIC)

/obj/item/infinity_stone/bluespace/HarmEvent(atom/target, mob/living/user, proximity_flag)	
	var/turf/to_teleport = get_turf(target)
	user.adjustStaminaLoss(15)
	target.visible_message("<span class='danger'>[target] warps away!</span>", "<span class='notice'>We warp ourselves to our desired location.</span>")
	do_teleport(user, to_teleport, channel = TELEPORT_CHANNEL_MAGIC)

/obj/item/infinity_stone/bluespace/GrabEvent(atom/target, mob/living/user, proximity_flag)
	if(user.incorporeal_move)
		user.incorporeal_move = 0
		user.visible_message("<span class='danger'>[user] becomes tangible again!</span>")
		user.remove_trait(TRAIT_PUSHIMMUNE, BLUESPACE_STONE_TRAIT)
		user.remove_trait(TRAIT_IGNOREDAMAGESLOWDOWN, BLUESPACE_STONE_TRAIT)
		user.remove_trait(TRAIT_STUNIMMUNE, BLUESPACE_STONE_TRAIT)
		user.remove_trait(TRAIT_SLEEPIMMUNE, BLUESPACE_STONE_TRAIT)
		user.remove_trait(TRAIT_PACIFISM, BLUESPACE_STONE_TRAIT)
		user.remove_movespeed_modifier(BLUESPACE_STONE_TRAIT)
		animate(user, alpha = 255, time = 15)
	else
		user.incorporeal_move = INCORPOREAL_MOVE_BASIC
		user.add_trait(TRAIT_PUSHIMMUNE, BLUESPACE_STONE_TRAIT)
		user.add_trait(TRAIT_IGNOREDAMAGESLOWDOWN, BLUESPACE_STONE_TRAIT)
		user.add_trait(TRAIT_STUNIMMUNE, BLUESPACE_STONE_TRAIT)
		user.add_trait(TRAIT_SLEEPIMMUNE, BLUESPACE_STONE_TRAIT)
		user.add_trait(TRAIT_PACIFISM, BLUESPACE_STONE_TRAIT) // just so this doesn;t get abused to fire guns while invincible
		user.add_movespeed_modifier(BLUESPACE_STONE_TRAIT, update=TRUE, priority=100, multiplicative_slowdown=-2, blacklisted_movetypes=(FLYING|FLOATING))
		user.visible_message("<span class='danger'>[user] becomes intangible!</span>")
		animate(user, alpha = 100, time = 15)

/obj/item/infinity_stone/bluespace/dropped(mob/living/user)
	. = ..()
	if(user.incorporeal_move)
		user.incorporeal_move = 0
		user.visible_message("<span class='danger'>[user] becomes tangible again!</span>")
		user.remove_trait(TRAIT_PUSHIMMUNE, BLUESPACE_STONE_TRAIT)
		user.remove_trait(TRAIT_IGNOREDAMAGESLOWDOWN, BLUESPACE_STONE_TRAIT)
		user.remove_trait(TRAIT_STUNIMMUNE, BLUESPACE_STONE_TRAIT)
		user.remove_trait(TRAIT_SLEEPIMMUNE, BLUESPACE_STONE_TRAIT)
		user.remove_trait(TRAIT_PACIFISM, BLUESPACE_STONE_TRAIT)
		user.remove_movespeed_modifier(BLUESPACE_STONE_TRAIT)
		animate(user, alpha = 255, time = 15)

/////////////////////////////////////////////
/////////////////// SPELLS //////////////////
/////////////////////////////////////////////

/obj/effect/proc_holder/spell/self/infinity/bluespace_stone_shield
	name = "Portal Shield"
	desc = "Summon a portal shield which sends all projectiles into nullspace. Lasts for 15 seconds, or 5 hits."
	charge_max = 200

/obj/effect/proc_holder/spell/self/infinity/bluespace_stone_shield/cast(list/targets, mob/user = usr)
	var/obj/item/shield/bluespace_stone/BS = new
	if(user.put_in_hands(BS, TRUE))
		user.visible_message("<span class='danger'>A portal manifests in [user]'s hands!</span>")
	else
		revert_cast()

/obj/effect/proc_holder/spell/targeted/turf_teleport/blink/bluespace_stone
	name = "Bluespace Blink"
	outer_tele_radius = 17
	clothes_req = FALSE
	human_req = FALSE
	staff_req = FALSE

/obj/effect/proc_holder/spell/targeted/ethereal_jaunt/bluespace_stone // un-stuns you so you can move
	name = "Bluespace Jaunt"
	clothes_req = FALSE
	human_req = FALSE
	staff_req = FALSE
	jaunt_duration = 100

/obj/effect/proc_holder/spell/targeted/ethereal_jaunt/bluespace_stone/cast(list/targets,mob/user = usr)
	for(var/mob/living/target in targets)
		if(target.incorporeal_move == INCORPOREAL_MOVE_BASIC)
			target.incorporeal_move = 0
			target.visible_message("<span class='danger'>[target] becomes tangible again!</span>")
			target.remove_trait(TRAIT_PUSHIMMUNE, BLUESPACE_STONE_TRAIT)
			target.remove_trait(TRAIT_IGNOREDAMAGESLOWDOWN, BLUESPACE_STONE_TRAIT)
			target.remove_trait(TRAIT_STUNIMMUNE, BLUESPACE_STONE_TRAIT)
			target.remove_trait(TRAIT_SLEEPIMMUNE, BLUESPACE_STONE_TRAIT)
			target.remove_trait(TRAIT_PACIFISM, BLUESPACE_STONE_TRAIT)
			target.remove_movespeed_modifier(BLUESPACE_STONE_TRAIT)
			animate(target, alpha = 255, time = 15)
		target.SetStun(0)
		target.SetKnockdown(0)
		target.SetUnconscious(0)
		target.SetParalyzed(0)
		target.SetImmobilized(0)
	return ..()

/////////////////////////////////////////////
/////////////////// ITEMS ///////////////////
/////////////////////////////////////////////

/obj/item/shield/bluespace_stone
	name = "bluespace energy shield"
	var/hits = 0

/obj/item/shield/bluespace_stone/Initialize()
	. = ..()
	add_trait(TRAIT_NODROP, BLUESPACE_STONE_TRAIT)
	QDEL_IN(src, 150)

/obj/item/shield/bluespace_stone/IsReflect()
	return TRUE

/obj/item/shield/bluespace_stone/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	hits += 1
	if (hits > 5)
		to_chat(owner, "<span class='danger'>[src] disappears!</span>")
		qdel(src)
	return FALSE
