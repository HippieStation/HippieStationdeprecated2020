GLOBAL_LIST_INIT(autodoc_supported_surgery_steps, typecacheof(list(
	/datum/surgery_step/incise,
	/datum/surgery_step/clamp_bleeders,
	/datum/surgery_step/close,
	/datum/surgery_step/saw,
	/datum/surgery_step/fix_brain,
	/datum/surgery_step/sever_limb,
	/datum/surgery_step/heal,
	/datum/surgery_step/extract_implant,
	/datum/surgery_step/manipulate_organs,
	/datum/surgery_step/remove_fat,
	/datum/surgery_step/replace_limb,
	/datum/surgery_step/remove_object,
	/datum/surgery_step/add_prosthetic,
	/datum/surgery_step/drill,
	/datum/surgery_step/retract_skin,
	/datum/surgery_step/insert_pill,
	/datum/surgery_step/fix_eyes,
	/datum/surgery_step/replace,
	/datum/surgery_step/revive,
	/datum/surgery_step/pacify,
	/datum/surgery_step/thread_veins,
//	/datum/surgery_step/splice_nerves,
	/datum/surgery_step/ground_nerves,
	/datum/surgery_step/muscled_veins,
	/datum/surgery_step/reinforce_ligaments,
	/datum/surgery_step/reshape_ligaments,
	/datum/surgery_step/mechanic_open,
	/datum/surgery_step/mechanic_unwrench,
	/datum/surgery_step/prepare_electronics,
	/datum/surgery_step/mechanic_wrench,
	/datum/surgery_step/open_hatch,
	/datum/surgery_step/mechanic_close
)))

/obj/machinery/autodoc
	name = "Auto-Doc Mark IX"
	desc = "A fully stationary automated surgeon! Fun for the whole family!"
	circuit = /obj/item/circuitboard/machine/autodoc
	icon = 'hippiestation/icons/obj/machines/autodoc.dmi'
	icon_state = "autodoc_base"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_WINDOW_LAYER
	use_power = IDLE_POWER_USE
	idle_power_usage = 50
	active_power_usage = 300
	pixel_x = -16
	var/speed_mult = 1
	var/max_storage = 1
	var/list/valid_surgeries = list()
	var/datum/surgery/target_surgery
	var/datum/surgery/active_surgery
	var/datum/surgery_step/active_step
	var/target_zone = "chest"
	var/in_use = FALSE
	var/caesar = FALSE
	var/message_cooldown = 0
	var/mutable_appearance/top_overlay

/obj/machinery/autodoc/examine(mob/user)
	. = ..()
	if(occupant)
		. += "<span class='notice'>You see <b>[occupant]</b> inside.</span>"
	. += "<span class='notice'><b>Ctrl-Click</b> to access the internal storage.</span>"

/obj/machinery/autodoc/CanPass(atom/movable/mover, turf/target)
	if(get_dir(src, mover) == NORTH || get_dir(src, target) == NORTH)
		return FALSE
	return ..()

/obj/machinery/autodoc/Initialize()
	. = ..()
	top_overlay = mutable_appearance(icon, "autodoc_top", ABOVE_MOB_LAYER)
	occupant_typecache = GLOB.typecache_living
	update_icon()
	for(var/datum/surgery/S in GLOB.surgeries_list)
		var/valid = TRUE
		if((ispath(S.replaced_by) && S.replaced_by != S.type) || !LAZYLEN(S.steps)) // the autodoc only uses the BEST versions of a surgery
			valid = FALSE
		else
			for(var/step in S.steps)
				if(!is_type_in_typecache(step, GLOB.autodoc_supported_surgery_steps))
					valid = FALSE
					break
		if(valid)
			valid_surgeries += S

/obj/machinery/autodoc/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = LoadComponent(/datum/component/storage/concrete/autodoc)
	STR.cant_hold = typecacheof(list(/obj/item/card/emag))

/obj/machinery/autodoc/RefreshParts()
	var/list/P = list()
	var/avg = 1
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		P += M.get_part_rating()
	avg = round(list_avg(P), 1)
	switch(avg)
		if(2)
			speed_mult = 0.75
		if(3)
			speed_mult = 0.5
		if(4)
			speed_mult = 0.25
		else
			speed_mult = 1
	for(var/obj/item/stock_parts/matter_bin/M in component_parts)
		P += M.get_part_rating()
	max_storage = round(list_avg(P), 1)
	var/datum/component/storage/STR = LoadComponent(/datum/component/storage/concrete/autodoc)
	STR.max_items = max_storage
	STR.cant_hold = typecacheof(list(/obj/item/card/emag))

/obj/machinery/autodoc/CtrlClick(mob/user)
	if(in_use && isliving(user))
		playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
		return
	var/datum/component/storage/ST = GetComponent(/datum/component/storage/concrete/autodoc)
	if (user.active_storage)
		user.active_storage.close(user)
	ST.orient2hud(user)
	ST.show_to(user)

/obj/machinery/autodoc/ui_act(action, list/params)
	if(..())
		return
	switch(action)
		if("target")
			if(!in_use && (params["part"] in list(BODY_ZONE_CHEST, BODY_ZONE_HEAD, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_PRECISE_EYES, BODY_ZONE_PRECISE_EYES, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)))
				target_zone = params["part"]
		if("surgery")
			if(!in_use)
				var/path = text2path(params["path"])
				for(var/datum/surgery/S in valid_surgeries)
					if((S.type == path) && S.possible_locs.Find(target_zone))
						target_surgery = S
						return
		if("start")
			INVOKE_ASYNC(src, .proc/surgery_time, usr)

/obj/machinery/autodoc/Destroy()
	if(active_surgery)
		active_surgery.complete()
	open_machine()
	return ..()

/obj/machinery/autodoc/proc/mcdonalds(mob/living/carbon/victim)
	for(var/obj/item/bodypart/BP in victim.bodyparts)
		if(BP.body_part != HEAD && BP.body_part != CHEST && BP.dismemberable)
			playsound(src, 'sound/weapons/circsawhit.ogg', 50, TRUE)
			BP.drop_limb()
			victim.emote("scream")
			BP.forceMove(get_turf(src))
			BP.throw_at(get_edge_target_turf(src, pick(GLOB.alldirs)), INFINITY, 5, spin = TRUE)
			sleep(10)
	var/list/organs = list()
	for(var/obj/item/organ/OR in victim.internal_organs)
		if(!istype(OR, /obj/item/organ/brain) && !istype(OR, /obj/item/organ/heart))
			organs += OR
	if(LAZYLEN(organs))
		var/obj/item/organ/O = pick(organs)
		O.Remove(victim)
		O.forceMove(get_turf(src))
		victim.emote("scream")
		O.throw_at(get_edge_target_turf(src, pick(GLOB.alldirs)), INFINITY, 5, spin = TRUE)
	// this is just a big ol' middle finger to the victim
	victim.slurring = 300
	victim.dizziness = 300
	victim.jitteriness = 300
	victim.setBrainLoss(max(135, victim.getBrainLoss()))
	caesar = FALSE
	playsound(src, 'sound/weapons/circsawhit.ogg', 50, TRUE)

/obj/machinery/autodoc/proc/surgery_time(mob/living/doer)
	var/mob/living/carbon/patient
	if(in_use)
		say("Auto-Doc currently in use!")
		playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
		return
	if(!target_surgery || !target_zone)
		say("Invalid configuration!")
		playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
		if(!state_open)
			open_machine()
		return
	if(state_open)
		close_machine()
	update_icon()
	for(var/mob/living/carbon/C in src)
		patient = C
		break
	if(!patient)
		say("No patient inside!")
		playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
		if(!state_open)
			open_machine()
		return
	var/obj/item/bodypart/affecting = patient.get_bodypart(check_zone(target_zone))
	if(affecting)
		if(!target_surgery.requires_bodypart)
			playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
			if(!state_open)
				open_machine()
			return
		if(target_surgery.requires_bodypart_type && affecting.status != target_surgery.requires_bodypart_type)
			say("The Auto-Doc cannot perform that surgery on that bodypart!")
			playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
			if(!state_open)
				open_machine()
			return
		if(target_surgery.requires_real_bodypart && affecting.is_pseudopart)
			playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
			if(!state_open)
				open_machine()
			return
	else if(patient && target_surgery.requires_bodypart) //mob with no limb in surgery zone when we need a limb
		playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
		if(!state_open)
			open_machine()
		return
	log_combat(doer, patient, "began [target_surgery] surgery", src)
	for(var/surgery_type in target_surgery.steps)
		var/datum/surgery_step/SS = new surgery_type
		if(!SS.autodoc_check(target_zone, src, FALSE, patient))
			qdel(SS)
			playsound(src, 'sound/machines/buzz-two.ogg', 50, FALSE)
			if(!state_open)
				open_machine()
			return
		qdel(SS)
	in_use = TRUE
	var/datum/component/storage/ST = GetComponent(/datum/component/storage/concrete/autodoc)
	ST.close_all()
	ST.locked = TRUE
	update_icon()
	active_surgery = new target_surgery.type(patient, target_zone, affecting)
	while(active_surgery.status <= active_surgery.steps.len)
		if(caesar)
			mcdonalds(patient)
			break
		var/datum/surgery_step/next_step = active_surgery.get_surgery_next_step()
		if(!next_step)
			break
		active_step = next_step
		active_surgery.step_in_progress = TRUE
		active_surgery.status++
		if(next_step.repeatable || next_step.ad_repeatable)
			while(next_step.autodoc_check(target_zone, src, TRUE, patient))
				sleep((next_step.time * speed_mult) / 2)
				playsound(src, 'sound/weapons/circsawhit.ogg', 50, TRUE)
				sleep((next_step.time * speed_mult) / 2)
				playsound(src, 'sound/weapons/circsawhit.ogg', 50, TRUE)
				next_step.autodoc_success(patient, target_zone, active_surgery, src)
		else
			sleep((next_step.time * speed_mult) / 2)
			playsound(src, 'sound/weapons/circsawhit.ogg', 50, TRUE)
			sleep((next_step.time * speed_mult) / 2)
			playsound(src, 'sound/weapons/circsawhit.ogg', 50, TRUE)
			next_step.autodoc_success(patient, target_zone, active_surgery, src)
		active_surgery.step_in_progress = FALSE
	active_surgery.complete()
	active_surgery = null
	active_step = null
	in_use = FALSE
	ST.locked = FALSE
	if(!state_open)
		open_machine()
	update_icon()

/obj/machinery/autodoc/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, \
									datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "autodoc", name, 455, 440, master_ui, state)
		ui.open()

/obj/machinery/autodoc/ui_data(mob/user)
	. = list()
	if(in_use)
		.["mode"] = 2
		.["s_name"] = target_surgery.name
		.["steps"] = list()
		for(var/s in target_surgery.steps)
			var/datum/surgery_step/S = s
			.["steps"] += list(list(
				"name" = initial(S.name),
				"current" = active_step ? (active_step.type == s) : FALSE
			))
		
	else
		.["mode"] = 1
		.["target"] = target_zone
		.["surgeries"] = list()
		for(var/datum/surgery/S in valid_surgeries)
			if(S.possible_locs.Find(target_zone))
				.["surgeries"] += list(list(
					"name" = S.name,
					"selected" = (S == target_surgery),
					"path" = "[S.type]",
				))

/obj/machinery/autodoc/MouseDrop_T(mob/target, mob/user)
	if(!QDELETED(occupant) && istype(occupant))
		return
	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK) || !Adjacent(target) || !user.Adjacent(target) || !iscarbon(target))
		return
	if(close_machine(target))
		log_combat(user, target, "inserted", null, "into [src].")
	add_fingerprint(user)

/obj/machinery/autodoc/emag_act(mob/user)
	if(caesar)
		to_chat(user, "<span class='notice'>\The [src]'s safeties are already corrupted!</span>")
		return
	log_combat(user, src, "emagged")
	to_chat(user, "<span class='notice'>You discretely emag \the [src], corrupting it's safeties.</span>")
	add_fingerprint(user)
	caesar = TRUE

/obj/machinery/autodoc/update_icon()
	cut_overlays()
	add_overlay(top_overlay)
	if(!(stat & (NOPOWER|BROKEN)))
		if(in_use)
			add_overlay("auto_doc_lights_working")
		else
			add_overlay("auto_doc_lights_on")
	if(occupant)
		add_overlay("autodoc_door_closed")
	else
		add_overlay("autodoc_door_open")

/obj/machinery/autodoc/proc/toggle_open(mob/user)
	if(panel_open)
		to_chat(user, "<span class='notice'>Close the maintenance panel first.</span>")
		return
	if(state_open)
		close_machine(null, user)
		return
	else if(in_use)
		to_chat(user, "<span class='notice'>The bolts are locked down, securing the door shut.</span>")
		return
	open_machine()

/obj/machinery/autodoc/open_machine()
	if(state_open)
		return FALSE
	..(FALSE)
	if(occupant)
		occupant.forceMove(get_turf(src))
	update_icon()
	return TRUE

/obj/machinery/autodoc/relaymove(mob/user as mob)
	if(user.stat || in_use)
		if(message_cooldown <= world.time)
			message_cooldown = world.time + 50
			to_chat(user, "<span class='warning'>[src]'s door won't budge!</span>")
		return
	open_machine()
