/obj/item/infinity_stone/ghost
	name = "Ghost Stone"
	desc = "Salts your food very well."
	color = "#e429f2"
	ability_text = list("HELP INTENT: Transmutate ghosts into a random simplemob.", 
		"DISARM INTENT: Fire a bolt that scales based on how many ghosts orbit you.")
	stone_type = GHOST_STONE
	spell_types = list(/obj/effect/proc_holder/spell/targeted/infinity/cluwne_rise_up,
		/obj/effect/proc_holder/spell/self/infinity/scrying_orb)
	var/summon_cooldown = 0
	var/list/mob/dead/observer/spirits = list()

/obj/item/infinity_stone/ghost/HelpEvent(atom/target, mob/living/user, proximity_flag)
	if(!isobserver(target))
		to_chat(user, "<span class='notice'>You can only transmutate ghosts!</span>")
		return
	var/mob/dead/observer/O = target
	var/simplemob = pick(/mob/living/simple_animal/hostile/carp,
		/mob/living/simple_animal/hostile/bear,
		/mob/living/simple_animal/hostile/mushroom,
		/mob/living/simple_animal/hostile/statue,
		/mob/living/simple_animal/hostile/retaliate/bat,
		/mob/living/simple_animal/hostile/retaliate/goat,
		/mob/living/simple_animal/parrot,
		/mob/living/simple_animal/pet/dog/corgi,
		/mob/living/simple_animal/crab,
		/mob/living/simple_animal/pet/dog/pug,
		/mob/living/simple_animal/pet/cat,
		/mob/living/simple_animal/mouse,
		/mob/living/simple_animal/chicken,
		/mob/living/simple_animal/cow,
		/mob/living/simple_animal/hostile/lizard,
		/mob/living/simple_animal/pet/fox,
		/mob/living/simple_animal/butterfly,
		/mob/living/simple_animal/pet/cat/cak,
		/mob/living/simple_animal/chick)
	var/mob/living/simple_animal/SA = new simplemob(get_turf(O))
	O.visible_message("<span class='danger'>The ghost of [O] turns into [SA]!</span>")
	SA.ckey = O.ckey
	to_chat(SA, "<span class='userdanger'>[user] is your master. Protect them at all costs.</span>")
	SA.add_memory("<b>[user] is your master. Protect them at all costs</b>")
	qdel(O)

/obj/item/infinity_stone/ghost/GrabEvent(atom/target, mob/living/user, proximity_flag)


/obj/item/infinity_stone/ghost/DisarmEvent(atom/target, mob/living/user, proximity_flag)
	var/total_spirits = ghost_check()
	FireProjectile(/obj/item/projectile/magic/spirit_fist, target, CLAMP(total_spirits*2.5, 3, 25))
	user.changeNext_move(CLICK_CD_RANGE)


/obj/item/infinity_stone/ghost/GiveAbilities(mob/living/L, gauntlet = FALSE)
	. = ..()
	ADD_TRAIT(L, TRAIT_SIXTHSENSE, GHOST_STONE_TRAIT)
	ADD_TRAIT(L, TRAIT_XRAY_VISION, GHOST_STONE_TRAIT)
	L.see_invisible = SEE_INVISIBLE_OBSERVER
	L.update_sight()

/obj/item/infinity_stone/ghost/RemoveAbilities(mob/living/L, gauntlet = FALSE)
	. = ..()
	REMOVE_TRAIT(L, TRAIT_SIXTHSENSE, GHOST_STONE_TRAIT)
	REMOVE_TRAIT(L, TRAIT_XRAY_VISION, GHOST_STONE_TRAIT)
	L.see_invisible = initial(L.see_invisible)
	L.update_sight()

// Spectral Sword Copypaste
/obj/item/infinity_stone/ghost/Initialize()
	. = ..()
	notify_ghosts("The Ghost Stone has been formed!",
		enter_link="<a href=?src=[REF(src)];orbit=1>(Click to orbit)</a>",
		source = src, action=NOTIFY_ORBIT, ignore_key = POLL_IGNORE_SPECTRAL_BLADE)
	START_PROCESSING(SSobj, src)

/obj/item/infinity_stone/ghost/Destroy()
	for(var/mob/dead/observer/G in spirits)
		G.invisibility = GLOB.observer_default_invisibility
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/infinity_stone/ghost/attack_self(mob/user)
	if(summon_cooldown > world.time)
		to_chat(user, "You just recently called out for aid. You don't want to annoy the spirits.")
		return
	to_chat(user, "You call out for aid, attempting to summon spirits to your side.")
	notify_ghosts("[user] is clenching [user.p_their()] [src], calling for your help!",
		enter_link="<a href=?src=[REF(src)];orbit=1>(Click to help)</a>",
		source = user, action=NOTIFY_ORBIT, ignore_key = POLL_IGNORE_SPECTRAL_BLADE)
	summon_cooldown = world.time + 60 SECONDS

/obj/item/infinity_stone/ghost/Topic(href, href_list)
	if(href_list["orbit"])
		var/mob/dead/observer/ghost = usr
		if(istype(ghost))
			ghost.ManualFollow(src)

/obj/item/infinity_stone/ghost/process()
	ghost_check()

/obj/item/infinity_stone/ghost/proc/ghost_check()
	var/ghost_counter = 0
	var/turf/T = get_turf(src)
	var/mob/dead/observer/current_spirits = list()
	for(var/thing in T.GetAllContents())
		var/atom/A = thing
		A.transfer_observers_to(src)

	for(var/i in orbiters?.orbiters)
		if(!isobserver(i))
			continue
		var/mob/dead/observer/G = i
		ghost_counter++
		G.invisibility = 0
		current_spirits |= G

	for(var/mob/dead/observer/G in spirits - current_spirits)
		G.invisibility = GLOB.observer_default_invisibility

	spirits = current_spirits

	return ghost_counter

/////////////////////////////////////////////
/////////////////// SPELLS //////////////////
/////////////////////////////////////////////

/obj/effect/proc_holder/spell/self/infinity/scrying_orb
	name = "Ghost Stone: Scrying Detachment"
	desc = "Detach your soul from your body, going into the realm of the ghosts."
	action_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_icon_state = "scrying"

/obj/effect/proc_holder/spell/self/infinity/scrying_orb/cast(list/targets, mob/user)
	. = ..()
	user.visible_message("<span class='notice'>[user] stares into the Ghost Stone, and the Ghost Stone stares back.</span>")
	user.ghostize(TRUE)

/obj/effect/proc_holder/spell/targeted/infinity/cluwne_rise_up
	name = "Ghost Stone: Cluwne Rise"
	desc = "Rise a corpse as a subservient, magical cluwne. You may only have 1 magical cluwne alive."
	action_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_icon_state = "cluwnerise"
	charge_max = 900
	var/mob/living/carbon/cluwne

/obj/effect/proc_holder/spell/targeted/infinity/cluwne_rise_up/InterceptClickOn(mob/living/caller, params, atom/t)
	. = ..()
	if(!.)
		return FALSE
	if(ishuman(t))
		if(istype(cluwne) && cluwne && cluwne.stat != DEAD && !cluwne.InCritical())
			to_chat(caller, "<span class='danger'>You still have a magical cluwne alive.</span>")
			return FALSE
		var/mob/living/carbon/human/H = t
		if(H.stat != DEAD && !H.InFullCritical())
			to_chat(caller, "<span class='danger'>They aren't dead enough yet.</span>")
			revert_cast()
			return
		H.revive(TRUE, TRUE)
		H.grab_ghost()
		H.cluwneify()
		cluwne = H
		H.add_memory("<b>[caller] is your master. Follow their orders at all costs.</b>")
		H.bloodcrawl = BLOODCRAWL_EAT
		H.bloodcrawl_allow_items = TRUE
		H.AddSpell(new /obj/effect/proc_holder/spell/targeted/turf_teleport/blink/infinity_cluwne)
		H.AddSpell(new /obj/effect/proc_holder/spell/targeted/ethereal_jaunt/shift/infinity_cluwne)
		H.AddSpell(new /obj/effect/proc_holder/spell/bloodcrawl)
		var/obj/item/kitchen/knife/butcher/BK = new(get_turf(H))
		ADD_TRAIT(BK, TRAIT_NODROP, "ghost_stone_cluwne")
		BK.name = "cluwne's cursed knife"
		H.put_in_hands(BK, TRUE)
		H.visible_message("<span class='danger'>[H] struggles back up, now a cluwne!</span>")
		to_chat(H, "<span class='userdanger'>You are risen from the dead as a cluwne. [caller] is your master. Follow their orders at all costs.</span>")
	else
		revert_cast()

/obj/effect/proc_holder/spell/targeted/turf_teleport/blink/infinity_cluwne
	name = "Cluwne Blink"
	clothes_req = FALSE
	human_req = FALSE
	staff_req = FALSE

/obj/effect/proc_holder/spell/targeted/ethereal_jaunt/shift/infinity_cluwne // un-stuns you so you can move
	name = "Cluwne Jaunt"
	clothes_req = FALSE
	human_req = FALSE
	staff_req = FALSE
	jaunt_duration = 100

/////////////////////////////////////////////
///////////////// PROJECTILE ////////////////
/////////////////////////////////////////////

/obj/item/projectile/magic/spirit_fist
	name = "spiritual fist"
	icon_state = "bounty" // kind of looks like a hand
	damage = 3
	damage_type = BRUTE
