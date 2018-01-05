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

/obj/item/gun/energy/kinetic_accelerator/rocketopaunch
	name = "ROCKET PUNCH"
	desc = "They said the Power-Fist was enough firepower. They were wrong."
	icon_state = "rocketopaunch"
	item_state = "rocketopaunch"
	icon = 'hippiestation/icons/obj/guns/rocketopaunch.dmi'
	//lefthand_file = 'hippiestation/icons/mob/inhands/equipment/rocketpunch_lefthand.dmi' - currently bugged, does not properly update the sprite after reloading and looks janky because of it
	//righthand_file = 'hippiestation/icons/mob/inhands/equipment/rocketpunch_righthand.dmi' - same as above, don't know a fix
	w_class = WEIGHT_CLASS_SMALL
	materials = list(MAT_METAL=4000)
	suppressed = FALSE
	ammo_type = list(/obj/item/ammo_casing/energy/rocketopaunch)
	weapon_weight = WEAPON_LIGHT
	unique_rename = 0
	overheat_time = 30
	holds_charge = TRUE
	unique_frequency = TRUE
	can_flashlight = 0
	max_mod_capacity = 0
	empty_state = null

/obj/item/ammo_casing/energy/rocketopaunch
	projectile_type = /obj/item/projectile/energy/rocketopaunch
	select_name = "glove"
	e_cost = 500
	fire_sound = 'sound/weapons/rocketlaunch.ogg'

/obj/item/projectile/energy/rocketopaunch // local man steals code twice
	name = "glove"
	damage = 30
	damage_type = BRUTE
	nodamage = 0
	knockdown = 2
	speed = 0.8
	armour_penetration = 20
	icon = 'hippiestation/icons/obj/projectiles.dmi'
	icon_state = "rocketopaunch"
	item_state = "rocketopaunch"

/obj/item/projectile/energy/rocketopaunch/on_hit(target)
	.=..()
	if(ishuman(target))
		var/mob/living/carbon/C = target
		playsound(get_turf(C), 'hippiestation/sound/weapons/punch5.ogg', 75, 1)
		var/datum/effect_system/explosion/E = new
		E.set_up(get_turf(C))
		E.start()
		if(ismovableatom(target))
			var/atom/movable/AM = target
			AM.throw_at(get_edge_target_turf(AM,get_dir(src, AM)), 15, 10)

/obj/item/gun/energy/kinetic_accelerator/rocketopaunch/update_icon()
	if(!can_shoot())
		icon_state = "rocketopaunch_empty"
		item_state = "rocketopaunch_empty"
	else
		item_state = "rocketopaunch"
		icon_state = "rocketopaunch"

