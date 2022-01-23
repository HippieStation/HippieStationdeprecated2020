#define FEAR_DURATION 100

/mob/living/simple_animal/pet/hedgehog
	name = "hedgehog"
	desc = "A spiky hog. Looking at it fills you with a strange feeling of reverence."
	gender = MALE
	icon = 'hippiestation/icons/mob/animal.dmi'
	icon_state = "Hedgehog"
	icon_living = "Hedgehog"
	icon_dead = "Hedgehog_dead"
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 2)
	minbodytemp = 200
	maxbodytemp = 400
	response_help  = "cautiously pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	turns_per_move = 5
	gold_core_spawnable = FRIENDLY_SPAWN
	var/scared = FALSE
	var/scared_time = 0

/mob/living/simple_animal/pet/hedgehog/Bernie
	name = "Bernie"
	desc = "A spiky hog belonging to the captain. Looking at it fills you with a strange feeling of reverence."

/mob/living/simple_animal/pet/hedgehog/proc/stop_being_scared_lil_boi()
	scared = FALSE
	icon_state = "Hedgehog"
	icon_living = "Hedgehog"
	mobility_flags |= MOBILITY_MOVE
	update_mobility()

/mob/living/simple_animal/pet/hedgehog/attacked_by(obj/item/I, mob/living/user)
	..()
	if(stat != DEAD)
		scared = TRUE
		visible_message("<span class = 'notice'> [src] curls up into a ball. </span>")
		icon_state = "Hedgehog_ball"
		icon_living = "Hedgehog_ball"
		mobility_flags &= ~MOBILITY_MOVE
	addtimer(CALLBACK(src, .proc/stop_being_scared_lil_boi), FEAR_DURATION, TIMER_OVERRIDE|TIMER_UNIQUE)

/mob/living/simple_animal/pet/hedgehog/attack_hand(mob/living/user)
	if(..())
		if(scared)
			user.visible_message("<span class = 'warning'> [user] pricks their finger on [src]'s quills!</span>")
			user.adjustBruteLoss(8)
		scared = TRUE
		mobility_flags &= ~MOBILITY_MOVE
		addtimer(CALLBACK(src, .proc/stop_being_scared_lil_boi), FEAR_DURATION, TIMER_OVERRIDE|TIMER_UNIQUE)

#undef FEAR_DURATION
