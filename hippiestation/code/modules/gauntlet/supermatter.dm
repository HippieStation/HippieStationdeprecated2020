/obj/item/infinity_stone/supermatter
	name = "Supermatter Stone"
	desc = "Don't touch, it's hot! Oh yeah, and it bends reality."
	stone_type = SUPERMATTER_STONE
	color = "#ECF332"
	spell_types = list (/obj/effect/proc_holder/spell/spacetime_dist/supermatter_stone)
	ability_text = list("HELP/GRAB INTENT: Fire a burning-hot crystal spray", 
		"DISARM INTENT: Fire a short-range fire blast, that'll set people on fire and knock them back.", 
		"Use on a material to use 25 sheets of it for a golem. 2 minute cooldown!")
	var/next_golem = 0

/obj/item/infinity_stone/supermatter/DisarmEvent(atom/target, mob/living/user, proximity_flag)
	if(!HandleGolem(user, target))
		FireProjectile(/obj/item/projectile/forcefire, target)
		user.changeNext_move(CLICK_CD_RANGE)

/obj/item/infinity_stone/supermatter/GrabEvent(atom/target, mob/living/user, proximity_flag)
	if(!proximity_flag || !HandleGolem(user, target))
		FireProjectile(/obj/item/projectile/supermatter_stone, target)
		user.changeNext_move(CLICK_CD_RANGE)

/obj/item/infinity_stone/supermatter/HelpEvent(atom/target, mob/living/user, proximity_flag)
	if(!proximity_flag || !HandleGolem(user, target))
		FireProjectile(/obj/item/projectile/supermatter_stone, target)
		user.changeNext_move(CLICK_CD_RANGE)


/obj/item/infinity_stone/supermatter/proc/HandleGolem(mob/living/user, atom/target)
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

/obj/effect/proc_holder/spell/spacetime_dist/supermatter_stone
	name = "Supermatter Stone: Reality Distortion"
	desc = "Bend reality until it's unrecognizable for a short time."
	action_icon = 'hippiestation/icons/obj/infinity.dmi'
	action_icon_state = "reality"
	clothes_req = FALSE
	human_req = FALSE
	staff_req = FALSE
	invocation_type = "none"

/////////////////////////////////////////////
/////////////////// STUFF ///////////////////
/////////////////////////////////////////////

/obj/item/projectile/supermatter_stone
	name = "burning crystal"
	icon_state = "guardian"
	damage = 15
	damage_type = BURN
	color = "#ECF332"
	armour_penetration = 100

/obj/item/projectile/forcefire
	name = "forcefire"
	icon_state = "plasma"
	damage = 10
	damage_type = BURN
	range = 5
	var/knockback = 3

/obj/item/projectile/forcefire/on_hit(atom/target, blocked = FALSE)
	if(ismovableatom(target))
		var/atom/movable/AM = target
		if(!AM.anchored)
			if(isliving(AM))
				var/mob/living/L = AM
				L.adjust_fire_stacks(2)
				L.IgniteMob()
			AM.throw_at(get_edge_target_turf(AM, get_dir(src, AM)), knockback, 4)
