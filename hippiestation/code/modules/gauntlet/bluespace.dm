//Originally coded for HippieStation by Steamp0rt, shared under the AGPL license.

/obj/item/badmin_stone/bluespace
	name = "Bluespace Stone"
	desc = "Stare into the abyss, and the abyss stares back..."
	color = "#266ef6"
	stone_type = BLUESPACE_STONE
	ability_text = list("HELP INTENT: teleport target to safe location. Only works every 75 seconds.", 
		"GRAB INTENT: teleport to specified location", 
		"DISARM INTENT: steal item someone is holding")
	spell_types = list(/obj/effect/proc_holder/spell/self/infinity/bluespace_stone_shield, 
		/obj/effect/proc_holder/spell/targeted/ethereal_jaunt/bluespace_stone)
	var/next_help = 0

/obj/item/badmin_stone/bluespace/DisarmEvent(atom/target, mob/living/user, proximity_flag)
	if(isliving(target))
		var/mob/living/L = target
		var/obj/O = L.get_active_held_item()
		if(O && !istype(O, /obj/item/badmin_stone) && !istype(O, /obj/item/badmin_gauntlet) && L.dropItemToGround(O))
			L.visible_message("<span class='danger'>[L]'s [O] disappears from their hands!</span>", "<span class='danger'>Our [O] disappears!</span>")
			O.forceMove(get_turf(user))
			user.equip_to_slot(O, SLOT_IN_BACKPACK)	
			user.changeNext_move(CLICK_CD_CLICK_ABILITY)

/obj/item/badmin_stone/bluespace/HelpEvent(atom/target, mob/living/user, proximity_flag)
	if(next_help > world.time)
		to_chat("<span class='danger'>You need to wait [DisplayTimeText(next_help - world.time)] to do that again!")
		return
	if(proximity_flag && isliving(target))
		if(do_after(user, 25, target = target))
			target.visible_message("<span class='danger'>[target] warps away!</span>", "<span class='notice'>We warp [target == user ? "ourselves" : target] to a safe location.</span>")
			var/turf/potential_T = find_safe_turf(extended_safety_checks = TRUE)
			do_teleport(target, potential_T, channel = TELEPORT_CHANNEL_BLUESPACE)
			next_help = world.time + 75 SECONDS

/obj/item/badmin_stone/bluespace/GrabEvent(atom/target, mob/living/user, proximity_flag)	
	var/turf/to_teleport = get_turf(target)
	if(do_after(user, 3, target = user))
		var/turf/start = get_turf(user)
		user.adjustStaminaLoss(15)
		user.visible_message("<span class='danger'>[user] warps away!</span>", "<span class='notice'>We warp ourselves to our desired location.</span>")
		user.forceMove(to_teleport)
		start.Beam(to_teleport, "bsa_beam", time=25)
		user.changeNext_move(CLICK_CD_CLICK_ABILITY)


/////////////////////////////////////////////
/////////////////// SPELLS //////////////////
/////////////////////////////////////////////

/obj/effect/proc_holder/spell/self/infinity/bluespace_stone_shield
	name = "Bluespace Stone: Portal Shield"
	desc = "Summon a portal shield which sends all projectiles into nullspace. Lasts for 15 seconds, or 5 hits."
	charge_max = 200
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "bluespace"

/obj/effect/proc_holder/spell/self/infinity/bluespace_stone_shield/cast(list/targets, mob/user = usr)
	var/obj/item/shield/bluespace_stone/BS = new
	if(user.put_in_hands(BS, TRUE))
		user.visible_message("<span class='danger'>A portal manifests in [user]'s hands!</span>")
	else
		revert_cast()

/obj/effect/proc_holder/spell/targeted/ethereal_jaunt/bluespace_stone // un-stuns you so you can move
	name = "Bluespace Stone: Bluespace Jaunt"
	clothes_req = FALSE
	human_req = FALSE
	staff_req = FALSE
	antimagic_allowed = TRUE
	jaunt_duration = 100
	invocation_type = "none"
	action_background_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_background_icon_state = "bluespace"

/obj/effect/proc_holder/spell/targeted/ethereal_jaunt/bluespace_stone/cast(list/targets,mob/user = usr)
	for(var/mob/living/target in targets)
		target.SetAllImmobility(0)
	return ..()

/////////////////////////////////////////////
/////////////////// ITEMS ///////////////////
/////////////////////////////////////////////

/obj/item/shield/bluespace_stone
	name = "bluespace energy shield"
	icon = 'hippiestation/icons/obj/infinity.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/shields_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/shields_righthand.dmi'
	icon_state = "portalshield"
	item_state = "eshield1"
	var/hits = 0

/obj/item/shield/bluespace_stone/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, BLUESPACE_STONE_TRAIT)
	QDEL_IN(src, 150)

/obj/item/shield/bluespace_stone/IsReflect()
	return TRUE

/obj/item/shield/bluespace_stone/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	hits += 1
	if (hits > 5)
		to_chat(owner, "<span class='danger'>[src] disappears!</span>")
		qdel(src)
	return FALSE
