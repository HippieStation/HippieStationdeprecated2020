/obj/item/stand_arrow
	name = "mysterious arrow"
	desc = "An ancient arrow. You feel poking yourself, or someone else with it would have... <span class='holoparasite'>unpredictable</span> results."
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	icon_state = "standarrow"
	item_state = "standarrow"
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi'
	sharpness = IS_SHARP
	var/kill_chance = 50 // people will still chuck these at the nearest security officer anyways, so who cares
	var/in_use = FALSE
	var/allow_special = FALSE
	var/uses = 3

/obj/item/stand_arrow/Initialize()
	. = ..()
	GLOB.poi_list += src

/obj/item/stand_arrow/Destroy()
	. = ..()
	GLOB.poi_list -= src

/obj/item/stand_arrow/attack(mob/living/M, mob/living/user)
	if(in_use)
		return
	if(!M.client)
		return
	if(!ishuman(M))
		to_chat("<span class='italics warning'>You can't stab [M], it won't work!</span>")
		return
	var/mob/living/carbon/human/H = M
	user.visible_message("<span class='warning'>[user] prepares to stab [H] with \the [src]!</span>", "<span class='notice'>You raise \the [src] into the air.</span>")
	if(do_mob(user, H, 5 SECONDS, uninterruptible=FALSE))
		if(LAZYLEN(H.hasparasites()))
			H.visible_message("<span class='holoparasite'>\The [src] rejects [H]!</span>")
			return
		if(H.mind && H.mind.has_antag_datum(/datum/antagonist/changeling))
			H.visible_message("<span class='holoparasite'>\The [src] rejects [H]!</span>")
			return
		in_use = TRUE
		H.visible_message("<span class='holoparasite'>\The [src] embeds itself into [H], and begins to glow!</span>")
		user.dropItemToGround(src, TRUE)
		forceMove(H)
		sleep(15 SECONDS)
		if(prob(kill_chance))
			H.visible_message("<span class='danger bold'>[H] stares ahead, eyes full of fear, before collapsing lifelessly into ash, \the [src] falling out...</span>")
			forceMove(H.drop_location())
			H.mind.no_cloning_at_all = TRUE
			H.adjustCloneLoss(500)
			H.dust(TRUE)
			in_use = FALSE
		else
			generate_stand(H)
	if(!uses)
		visible_message("<span class='warning'>[src] falls apart!</span>")
		qdel(src)

/obj/item/stand_arrow/proc/generate_stand(mob/living/carbon/human/H)
	var/points = 15
	var/list/categories = list("Damage", "Defense", "Speed", "Potential", "Range") // will be shuffled every iteration
	var/list/majors = allow_special ? (subtypesof(/datum/guardian_ability/major) - /datum/guardian_ability/major/special) : (subtypesof(/datum/guardian_ability/major) - typesof(/datum/guardian_ability/major/special))
	var/list/major_weighted = list()
	for(var/M in majors)
		var/datum/guardian_ability/major/major = new M
		major_weighted[major] = major.arrow_weight
	var/datum/guardian_ability/major/major_ability = pickweight(major_weighted)
	var/datum/guardian_stats/stats = new
	stats.ability = major_ability
	stats.ability.master_stats = stats
	points -= major_ability.cost
	while(points > 0)
		if(!categories.len)
			break
		shuffle_inplace(categories)
		var/cat = pick(categories)
		points--
		switch(cat)
			if("Damage")
				stats.damage++
				if(stats.damage >= 5)
					categories -= "Damage"
			if("Defense")
				stats.defense++
				if(stats.defense >= 5)
					categories -= "Defense"
			if("Speed")
				stats.speed++
				if(stats.speed >= 5)
					categories -= "Speed"
			if("Potential")
				stats.potential++
				if(stats.potential >= 5)
					categories -= "Potential"
			if("Range")
				stats.range++
				if(stats.range >= 5)
					categories -= "Range"
	INVOKE_ASYNC(src, .proc/get_stand, H, stats)

/obj/item/stand_arrow/proc/get_stand(mob/living/carbon/human/H, datum/guardian_stats/stats)
	var/list/mob/dead/observer/candidates = pollGhostCandidates("Do you want to play as the Guardian Spirit of [H.real_name]?", ROLE_PAI, null, FALSE, 100, POLL_IGNORE_HOLOPARASITE)
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		var/mob/living/simple_animal/hostile/guardian/G = new(H, "magic")
		G.summoner = H
		G.key = C.key
		G.mind.enslave_mind_to_creator(H)
		G.stats = stats
		G.stats.Apply(G)
		G.show_detail()
		log_game("[key_name(H)] has summoned [key_name(G)], a holoparasite, via the stand arrow.")
		to_chat(H, "<span class='holoparasite'><font color=\"[G.namedatum.colour]\"><b>[G.real_name]</b></font> has been summoned!</span>")
		H.verbs += /mob/living/proc/guardian_comm
		H.verbs += /mob/living/proc/guardian_recall
		H.verbs += /mob/living/proc/guardian_reset
	else
		addtimer(CALLBACK(src, .proc/get_stand, H, stats), 90 SECONDS) // lmao

/obj/item/stand_arrow/rare
	allow_special = TRUE
