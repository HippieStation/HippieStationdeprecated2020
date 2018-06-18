/obj/item/projectile/energy/electrode
	stun = 0
	knockdown = 0
	stamina = 60

/obj/item/projectile/energy/electrode/on_hit(atom/target, blocked = 0)
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(prob(50))
			C.dropItemToGround(C.get_active_held_item())
		..()

/obj/item/projectile/beam/disabler
	speed = 0.7
	damage = 26 //it should take about four shots to down someone, but seeing as people regen stamina all the time, setting it to 25 means you would need 5 shots.

/obj/item/projectile/plasma/watcher
	name = "freezing blast"
	icon_state = "ice_2"
	damage = 10
	flag = "energy"
	damage_type = BURN
	range = 4
	mine_range = 0
	var/temperature = -100
	dismemberment = FALSE

/obj/item/projectile/plasma/watcher/on_hit(atom/target, blocked = 0)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		L.adjust_bodytemperature(L.bodytemperature + (((100-blocked)/100)*(temperature - L.bodytemperature)))