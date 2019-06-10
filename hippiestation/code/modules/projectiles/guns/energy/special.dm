/obj/item/gun/energy/watcherprojector
	name = "watcher projector"
	desc = "A spiny, gruesome tool which reproduces the icy beam of a watcher, shattering rock and freezing individuals."
	icon_state = "watcherprojector"
	icon = 'hippiestation/icons/obj/guns/energy.dmi'
	item_state = "watcherprojector"
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi'
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/watcher)
	attack_verb = list("bashed", "stared down", "whacked", "smashed")
	force = 10
	can_charge = 0
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL

/obj/item/gun/energy/watcherprojector/examine(mob/user)
	..()
	if(cell)
		to_chat(user, "<span class='notice'>[src]'s diamond core is [round(cell.percent())]% energized.</span>")

/obj/item/gun/energy/watcherprojector/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/sheet/mineral/plasma))
		I.use(1)
		cell.give(1000)
		to_chat(user, "<span class='notice'>You feed [I] to [src], recharging it.</span>")
	else if(istype(I, /obj/item/stack/ore/plasma))
		I.use(1)
		cell.give(500)
		to_chat(user, "<span class='notice'>You feed [I] to [src], recharging it.</span>")
	else
		..()

/obj/item/gun/energy/watcherprojector/use(amount)
	return cell.use(amount * 100)

/obj/item/gun/energy/watcherprojector/update_icon()
	return

/obj/item/gun/energy/kinetic_accelerator/hippie_ebow // Prevents teegee changes
	name = "mini energy crossbow"
	desc = "A poisonous crossbow favored by syndicate stealth specialists."
	icon_state = "crossbow"
	item_state = "crossbow"
	w_class = WEIGHT_CLASS_SMALL
	materials = list(MAT_METAL=2000)
	suppressed = TRUE
	ammo_type = list(/obj/item/ammo_casing/energy/hippie_ebolt)
	weapon_weight = WEAPON_LIGHT
	obj_flags = 0
	overheat_time = 350
	holds_charge = TRUE
	unique_frequency = TRUE
	can_flashlight = FALSE
	max_mod_capacity = 0
	clumsy_check = 0

/obj/item/ammo_casing/energy/hippie_ebolt
	projectile_type = /obj/item/projectile/energy/hippie_ebolt
	select_name = "bolt"
	e_cost = 500
	fire_sound = 'sound/weapons/genhit.ogg'

/obj/item/projectile/energy/hippie_ebolt // Doesn't stun on its own, considerably more lethal.
	name = "bolt"
	icon_state = "cbbolt"
	damage = 15
	damage_type = TOX
	nodamage = 0
	stamina = 25
	eyeblur = 15
	slur = 15
	armour_penetration = 100
	var/piercing = TRUE // GUARANTEED HITS

/obj/item/projectile/energy/hippie_ebolt/Initialize()
	. = ..()
	create_reagents(30, NO_REACT)
	reagents.add_reagent("polonium", 5)
	reagents.add_reagent("fentanyl", 5)
	reagents.add_reagent("atomicbomb", 8)
	reagents.add_reagent("toxin", 8)

/obj/item/projectile/energy/hippie_ebolt/on_hit(atom/target, blocked = FALSE)
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		if(blocked != 100) // not completely blocked
			if(M.can_inject(null, FALSE, def_zone, piercing)) // Pass the hit zone to see if it can inject by whether it hit the head or the body.
				..()
				reagents.reaction(M, INJECT)
				reagents.trans_to(M, reagents.total_volume)
				M.adjustBrainLoss(15)
				M.confused += 10
				return BULLET_ACT_HIT
			else
				blocked = 100
				target.visible_message("<span class='danger'>\The [src] was deflected!</span>", \
									   "<span class='userdanger'>You were protected against \the [src]!</span>")

	..(target, blocked)
	DISABLE_BITFIELD(reagents.flags, NO_REACT)
	reagents.handle_reactions()
	return BULLET_ACT_HIT