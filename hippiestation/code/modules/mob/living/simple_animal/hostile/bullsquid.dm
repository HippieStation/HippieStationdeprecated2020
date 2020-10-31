
/mob/living/simple_animal/hostile/bullsquid
	name = "bullsquid"
	desc = "Some highly aggressive alien creature. Thrives in toxic environments."

	icon = 'hippiestation/icons/mob/bullsquid.dmi'
	icon_state = "bullsquid"
	icon_living = "bullsquid"
	icon_dead = "bullsquid_dead"
	icon_gib = null

	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	speak_chance = 1
	speak_emote = list("growls")

	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat = 3)

	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	speed = 2
	turns_per_move = 7

	maxHealth = 75
	health = 75

	obj_damage = 50
	harm_intent_damage = 15
	melee_damage_lower = 12
	melee_damage_upper = 18
	friendly = "licks"
	attacktext = "bites"
	attack_sound = 'sound/weapons/bite.ogg'

	gold_core_spawnable = HOSTILE_SPAWN

	//Since those can survive on Xen, I'm pretty sure they can thrive on any atmosphere
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500

	faction = list("xen")//in Half-Life, bullsquids attack headcrabs, so they shouldn't be of the same faction

/mob/living/simple_animal/hostile/bullsquid/FindTarget()
	. = ..()
	if(.)
		emote("me", 1, "growls at [.]!")
