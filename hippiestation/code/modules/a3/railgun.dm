/obj/item/gun/energy/beam_rifle/railgun
	name = "MM-3 Railgun"
	lefthand_file = null
	righthand_file = null
	item_state = null
	cell_type = /obj/item/stock_parts/cell/infinite
	ammo_type = list(/obj/item/ammo_casing/energy/beam_rifle/hitscan/railgun)
	aiming_time_increase_user_movement = 0
	can_zoom = FALSE

/obj/item/gun/energy/beam_rifle/railgun/update_icon()
	return

/obj/item/gun/energy/beam_rifle/railgun/handle_pins(mob/living/user)
	return TRUE

/obj/item/ammo_casing/energy/beam_rifle/hitscan/railgun
	projectile_type = /obj/item/projectile/beam/beam_rifle/hitscan/railgun

/obj/item/projectile/beam/beam_rifle/hitscan/railgun
	tracer_type = /obj/effect/projectile/tracer/tracer/beam_rifle/railgun

/obj/effect/projectile/tracer/tracer/beam_rifle/railgun
	icon = 'hippiestation/icons/obj/projectiles_tracer.dmi'
	icon_state = "railgun"
