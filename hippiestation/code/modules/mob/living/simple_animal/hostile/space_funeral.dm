/mob/living/simple_animal/hostile/space_funeral
	name = "creature"
	desc = "A sanity-destroying otherthing."
	icon = 'hippiestation/icons/mob/spacefuneral.dmi'
	speak_emote = list("gibbers")
	icon_state = "bloodhound"
	icon_living = "bloodhound"
	icon_dead = "bloodhound-dead"
	health = 1
	maxHealth = 1
	melee_damage_lower = 1
	melee_damage_upper = 2
	attacktext = "pokes"
	attack_sound = 'sound/weapons/bite.ogg'
	faction = list("funeral")
	gold_core_spawnable = 1
	minbodytemp = 0

/mob/living/simple_animal/hostile/space_funeral/philip
	name = "crier"
	desc = "A sanity-destroying otherthing. It seems sad."
	speak_emote = list("wails")
	icon_state = "philip"
	icon_living = "philip"
	icon_dead = "philip-dead"
	health = 300
	maxHealth = 300
	melee_damage_lower = 24
	melee_damage_upper = 25
	attacktext = "wallops"
	attack_sound = 'hippiestation/sound/creatures/philip.ogg'

/mob/living/simple_animal/hostile/space_funeral/bloodhound
	name = "bloodhound"
	desc = "A sanity-destroying otherthing. It seems upset."
	icon_state = "bloodhound"
	icon_living = "bloodhound"
	icon_dead = "bloodhound-dead"
	health = 50
	maxHealth = 50
	melee_damage_lower = 8
	melee_damage_upper = 10
	attacktext = "bites"
	attack_sound = 'sound/weapons/bite.ogg'

/mob/living/simple_animal/hostile/space_funeral/bloodflea
	name = "bloodflea"
	desc = "A small sanity-destroying otherthing. It seems weak."
	icon_state = "bloodflea"
	icon_living = "bloodflea"
	icon_dead = "bloodflea-dead"
	health = 5
	maxHealth = 5
	melee_damage_lower = 1
	melee_damage_upper = 2
	attacktext = "bites"
	attack_sound = 'sound/weapons/bite.ogg'

/mob/living/simple_animal/hostile/space_funeral/leghorse
	name = "leghorse"
	desc = "A sanity-destroying otherthing. It seems happy."
	icon_state = "horselegs"
	icon_living = "horselegs"
	icon_dead = "horselegs-dead"
	health = 100
	maxHealth = 100
	melee_damage_lower = 11
	melee_damage_upper = 20
	attacktext = "kicks"
	attack_sound = 'hippiestation/sound/creatures/leghorse.ogg'
