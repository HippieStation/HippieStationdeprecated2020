//Turret that fires freezing projectiles, designed for the Merchant Freighter. Original code in code/game/machinery/porta_turret/portable_turret.dm

/obj/machinery/porta_turret/centcom_shuttle/merchant
	name = "Freezer Turret"
	desc = "A mostly non-lethal turret designed to fire freezing beams to dissuage sabotauge rather than outright kill."
	stun_projectile = /obj/item/projectile/temp/cryo
	lethal_projectile = /obj/item/projectile/temp/cryo
	lethal_projectile_sound = 'sound/weapons/pulse3.ogg'
	stun_projectile_sound = 'sound/weapons/pulse3.ogg'
