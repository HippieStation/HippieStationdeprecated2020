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

/obj/item/projectile/energy/bolt
	damage = 15
	damage_type = TOX
	nodamage = 0
	knockdown = 0
	stun = 50
	stutter = 100 //H-H-HELP I-IN-N-N MA-A-AI-NT-T
	slur = 100 //HCCH-HH-HEELHP I-INU-HN-NNGH... MA-A-AIH-NT-T

/obj/item/projectile/energy/bolt/on_hit(atom/target, blocked = 0)
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		C.dropItemToGround(C.get_active_held_item())
		..()
