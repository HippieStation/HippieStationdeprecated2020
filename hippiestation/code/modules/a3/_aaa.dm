/obj/item/a3
	name = "A3 Powered Suit"
	icon = 'hippiestation/icons/obj/Exopack.dmi'
	alternate_worn_icon = 'hippiestation/icons/obj/Exopack.dmi'
	icon_state = "exopack"
	item_state = "exopack"
	worn_x_dimension = 25
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = FIRE_PROOF | ACID_PROOF | UNACIDABLE | FREEZE_PROOF | LAVA_PROOF
	actions_types = list(/datum/action/item_action/aaa)
	var/list/guns = list(
		"beam_rifle" = /obj/item/gun/energy/beam_rifle/railgun,
		"gatling_spin" = /obj/item/gun/ballistic/a3/gatling,
		"rocketpod" = /obj/item/gun/ballistic/a3/rocketpods,
		"nanothorn" = /obj/item/melee/nanothorn
	)
	var/online = FALSE
	var/onlining = FALSE
	var/list/gun_overlays = list()
	var/overlay_sprite
	var/datum/effect_system/trail_follow/ion/a3/ion_trail

/obj/item/a3/Initialize()
	. = ..()
	AddComponent(/datum/component/anti_magic, TRUE, FALSE, FALSE, ITEM_SLOT_BACK, FALSE)
	var/list/G = guns.Copy()
	guns.Cut()
	for(var/sprite in G)
		var/gun = G[sprite]
		var/obj/item/gun/AG = new gun(src)
		AG.resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | LAVA_PROOF | UNACIDABLE | ACID_PROOF
		ADD_TRAIT(AG, TRAIT_NODROP, A3_TRAIT)
		RegisterSignal(AG, COMSIG_ITEM_DROPPED, .proc/recover_item)
		guns[sprite] = AG
		if(sprite in icon_states(icon))
			var/mutable_appearance/MA = mutable_appearance(icon, sprite, BACK_LAYER)
			MA.pixel_x = 3
			MA.pixel_y = -1
			gun_overlays[sprite] = MA
	ion_trail = new
	ion_trail.set_up(src)

/obj/item/a3/Destroy()
	for(var/A in guns)
		qdel(guns[A])
	for(var/A in gun_overlays)
		qdel(gun_overlays[A])
	qdel(ion_trail)
	return ..()

/obj/item/a3/equipped(mob/user, slot)
	. = ..()
	if(slot == SLOT_BACK)
		Hello(user)

/obj/item/a3/dropped(mob/user)
	. = ..()
	Goodbye(user)

/obj/item/a3/proc/Hello(mob/user)
	ADD_TRAIT(src, TRAIT_NODROP, A3_TRAIT)
	if(!(user.movement_type & FLYING))
		user.setMovetype(user.movement_type | FLYING)
	update_mob_overlays(user)
	ion_trail.start()
	user.add_movespeed_modifier(MOVESPEED_ID_A3, priority=100, multiplicative_slowdown=-0.25, movetypes=FLOATING, conflict=MOVE_CONFLICT_JETPACK)
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, .proc/OnMove)
	if(!online && !onlining)
		onlining = TRUE
		to_chat(user, "<span class='notice'>A3 Powered Suit initializing...</span>")
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, user, "<span class='notice'>Integrity: <b>OK</b></span>"), 1 SECONDS)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, user, "<span class='notice'>Core Systems: <b>OK</b></span>"), 2 SECONDS)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, user, "<span class='notice'>Weapons Systens: <b>OK</b></span>"), 3 SECONDS)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, user, "<span class='notice'>A3 Powered Suit initialized. All systems <b>OK</b>.</span>"), 5 SECONDS)
		addtimer(VARSET_CALLBACK(src, online, TRUE), 5 SECONDS)
		addtimer(VARSET_CALLBACK(src, onlining, FALSE), 5 SECONDS)

/obj/item/a3/proc/Goodbye(mob/user)
	online = FALSE
	cut_mob_overlays(user)
	REMOVE_TRAIT(src, TRAIT_NODROP, A3_TRAIT)
	if(user.movement_type & FLYING)
		user.setMovetype(user.movement_type & ~FLYING)
	UnregisterSignal(user, COMSIG_MOVABLE_MOVED)

/obj/item/a3/proc/OnMove(mob/mover, dir)
	ion_trail.generate_effect()

/obj/item/a3/ui_action_click(mob/user, var/datum/action/A)
	if(istype(A, /datum/action/item_action/aaa))
		if(!online)
			to_chat(user, "<span class='notice italics'>Not online!</span>")
			return
		overlay_sprite = null
		update_mob_overlays(user)
		for(var/sprite in guns)
			var/obj/item/gun/I = guns[sprite]
			if(user.is_holding(I))
				I.forceMove(src)
				user.visible_message("<span class='notice'>\The [I] retracts back into \the [src].</span>")
		var/list/choice_list = list()
		for(var/P in guns)
			choice_list[P] = image(guns[P])
		var/choice = show_radial_menu(user, user, choice_list)
		if(choice)
			var/obj/item/gun = guns[choice]
			if(!user.put_in_hands(gun))
				to_chat(user, "<span class='warning'>Your hands are full!</span?")
				return
			user.swap_hand(user.get_held_index_of_item(gun))
			user.visible_message("<span class='notice'>\The [gun] extends from \the [src]!</span>")
			if(gun_overlays[choice])
				overlay_sprite = choice
			update_mob_overlays(user)
	else
		return ..()

/obj/item/a3/proc/cut_mob_overlays(mob/living/L)
	for(var/MA in gun_overlays)
		L.cut_overlay(gun_overlays[MA])

/obj/item/a3/proc/update_mob_overlays(mob/living/L)
	cut_mob_overlays(L)
	if(overlay_sprite && gun_overlays[overlay_sprite])
		L.add_overlay(gun_overlays[overlay_sprite])

/obj/item/a3/item_action_slot_check(slot, mob/user)
	if(slot == user.getBackSlot())
		return TRUE

/obj/item/a3/proc/recover_item(obj/item/source)
	if(source.loc == src)
		return
	if(guns[overlay_sprite] == source)
		overlay_sprite = null
	source.forceMove(src)
	if(isliving(loc))
		update_mob_overlays(loc)

// other stuff

/mob/living/carbon/Process_Spacemove(movement_dir = 0)
	. = ..()
	if(istype(back, /obj/item/a3))
		return TRUE

/datum/effect_system/trail_follow/ion/a3
	nograv_required = FALSE
	auto_process = FALSE

/datum/effect_system/trail_follow/ion/a3/set_dir(obj/effect/particle_effect/ion_trails/I)
	if(istype(holder, /obj/item/a3))
		var/obj/item/a3/F = holder
		if(isliving(F.loc))
			I.setDir(F.loc.dir)

/mob/living/carbon/human/Stat()
	..()
	if(istype(back, /obj/item/a3))
		var/obj/item/a3/A3 = back
		var/datum/gas_mixture/environment = loc?.return_air()
		var/pressure = environment.return_pressure()
		if(statpanel("A3"))
			stat("A3 Status : [A3.online ? "Online" : "Offline"]")
			if(A3.online)
				stat("Weapon:", "[A3.overlay_sprite ? "[A3.guns[A3.overlay_sprite]]" : "None"]")
				stat("Overall Status:", "[health]% healthy")
				stat("Nutrition Status:", "[nutrition]")
				stat("Oxygen Loss:", "[getOxyLoss()]")
				stat("Toxin Levels:", "[getToxLoss()]")
				stat("Burn Severity:", "[getFireLoss()]")
				stat("Brute Trauma:", "[getBruteLoss()]")
				stat("Cellular Damage:", "[getCloneLoss()]")
				stat("Stamina:", "[100 - getStaminaLoss()]%")
				stat("Radiation Levels:","[radiation] rads")
				stat("Body Temperature:", "[bodytemperature-T0C] degrees C ([bodytemperature*1.8-459.67] degrees F)")
				stat("Atmospheric Pressure:","[pressure] kPa")
				stat("Atmoshperic Temperature:","<span class='[environment.temperature > FIRE_IMMUNITY_MAX_TEMP_PROTECT?"alert":"info"]'>[round(environment.temperature-T0C, 0.01)] &deg;C ([round(environment.temperature, 0.01)] K)</span>")
				stat("Atmospheric Thermal Energy:","THERMAL_ENERGY(environment)/1000] kJ")
