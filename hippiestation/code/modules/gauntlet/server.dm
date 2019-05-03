/obj/item/infinity_stone/server
	name = "Server Stone"
	desc = "The very essence of Hippie. Smells of basement."
	spell_types = list (/obj/effect/proc_holder/spell/spacetime_dist/server_stone)
	ability_text = list("DISARM/HELP/GRAB INTENT: Fire a bolt of animation", "HARM INTENT: Fire a bolt of chaos", "Use on a material to use 25 sheets of it for a golem. 2 minute cooldown!")
	var/next_golem = 0

/obj/item/infinity_stone/server/DisarmEvent(atom/target, mob/living/user, proximity_flag)
	if(!HandleGolem(user, target))
		FireProjectile(/obj/item/projectile/magic/animate, target)

/obj/item/infinity_stone/server/HarmEvent(atom/target, mob/living/user, proximity_flag)
	if(!HandleGolem(user, target))
		FireProjectile(pick(list(/obj/item/projectile/magic/change, /obj/item/projectile/magic/animate, /obj/item/projectile/magic/resurrection,
		/obj/item/projectile/magic/death, /obj/item/projectile/magic/teleport, /obj/item/projectile/magic/door, /obj/item/projectile/magic/aoe/fireball,
		/obj/item/projectile/magic/spellblade, /obj/item/projectile/magic/arcane_barrage, /obj/item/projectile/magic/locker, /obj/item/projectile/magic/flying,
		/obj/item/projectile/magic/bounty, /obj/item/projectile/magic/antimagic, /obj/item/projectile/magic/fetch, /obj/item/projectile/magic/sapping,
		/obj/item/projectile/magic/necropotence, /obj/item/projectile/magic, /obj/item/projectile/temp/chill, /obj/item/projectile/magic/wipe)), target)

/obj/item/infinity_stone/server/GrabEvent(atom/target, mob/living/user, proximity_flag)
	if(!HandleGolem(user, target))
		FireProjectile(/obj/item/projectile/magic/animate, target)

/obj/item/infinity_stone/server/HelpEvent(atom/target, mob/living/user, proximity_flag)
	if(!HandleGolem(user, target))
		FireProjectile(/obj/item/projectile/magic/animate, target)


/obj/item/infinity_stone/server/proc/HandleGolem(mob/living/user, atom/target)
	if(world.time < next_golem)
		to_chat(user, "<span class='notice'>You need to wait [DisplayTimeText(world.time-next_golem)] before you can make another golem.</span>")
		return TRUE
	var/static/list/golem_shell_species_types = list(
		/obj/item/stack/sheet/metal	                = /datum/species/golem,
		/obj/item/stack/sheet/glass 	            = /datum/species/golem/glass,
		/obj/item/stack/sheet/plasteel 	            = /datum/species/golem/plasteel,
		/obj/item/stack/sheet/mineral/sandstone	    = /datum/species/golem/sand,
		/obj/item/stack/sheet/mineral/plasma	    = /datum/species/golem/plasma,
		/obj/item/stack/sheet/mineral/diamond	    = /datum/species/golem/diamond,
		/obj/item/stack/sheet/mineral/gold	        = /datum/species/golem/gold,
		/obj/item/stack/sheet/mineral/silver	    = /datum/species/golem/silver,
		/obj/item/stack/sheet/mineral/uranium	    = /datum/species/golem/uranium,
		/obj/item/stack/sheet/mineral/bananium	    = /datum/species/golem/bananium,
		/obj/item/stack/sheet/mineral/titanium	    = /datum/species/golem/titanium,
		/obj/item/stack/sheet/mineral/plastitanium	= /datum/species/golem/plastitanium,
		/obj/item/stack/sheet/mineral/abductor	    = /datum/species/golem/alloy,
		/obj/item/stack/sheet/mineral/wood	        = /datum/species/golem/wood,
		/obj/item/stack/sheet/bluespace_crystal	    = /datum/species/golem/bluespace,
		/obj/item/stack/sheet/runed_metal	        = /datum/species/golem/runic,
		/obj/item/stack/medical/gauze	            = /datum/species/golem/cloth,
		/obj/item/stack/sheet/cloth	                = /datum/species/golem/cloth,
		/obj/item/stack/sheet/mineral/adamantine	= /datum/species/golem/adamantine,
		/obj/item/stack/sheet/plastic	            = /datum/species/golem/plastic,
		/obj/item/stack/tile/brass					= /datum/species/golem/clockwork,
		/obj/item/stack/tile/bronze					= /datum/species/golem/bronze,
		/obj/item/stack/sheet/cardboard				= /datum/species/golem/cardboard,
		/obj/item/stack/sheet/leather				= /datum/species/golem/leather,
		/obj/item/stack/sheet/bone					= /datum/species/golem/bone,
		/obj/item/stack/sheet/cloth/durathread		= /datum/species/golem/durathread,
		/obj/item/stack/sheet/cotton/durathread		= /datum/species/golem/durathread,
		/obj/item/stack/sheet/capitalisium			= /datum/species/golem/capitalist,
		/obj/item/stack/sheet/stalinium				= /datum/species/golem/soviet)
	if(istype(target, /obj/item/stack))
		var/obj/item/stack/O = target
		var/species = golem_shell_species_types[O.merge_type]
		if(species)
			if(O.use(25))
				to_chat(user, "<span class='notice'>You materialize a golem with 25 sheets of [O].</span>")
				new /obj/item/golem_shell/servant(get_turf(target), species, user)
				next_golem = world.time + 2 MINUTES
				return TRUE
	return FALSE

/////////////////////////////////////////////
/////////////////// SPELLS //////////////////
/////////////////////////////////////////////

/obj/effect/proc_holder/spell/spacetime_dist/server_stone
	name = "Reality Distortion"
	clothes_req = FALSE
	human_req = FALSE
	staff_req = FALSE
