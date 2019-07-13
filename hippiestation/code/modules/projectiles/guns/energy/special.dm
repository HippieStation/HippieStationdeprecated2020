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
	reagents.add_reagent(/datum/reagent/toxin/polonium, 5)
	reagents.add_reagent(/datum/reagent/toxin/fentanyl, 5)
	reagents.add_reagent(/datum/reagent/consumable/ethanol/atomicbomb, 8)
	reagents.add_reagent(/datum/reagent/toxin, 8)

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

/obj/item/gun/energy/printer
	icon_state = "l6closed100"

/////Gauss rifle/////
/obj/item/gun/energy/gauss
	multistate = 1
	var/ammo = 50
	name = "gauss rifle"
	icon_state = "gauss"
	w_class = 4
	item_state = "gauss"
	desc = "A seriously powerful rifle with an electromagnetic acceleration core, capable of blowing limbs off. It has 50 rods left."
	ammo_type = list(/obj/item/ammo_casing/energy/gauss_low, /obj/item/ammo_casing/energy/gauss_normal, /obj/item/ammo_casing/energy/gauss_overdrive)
	cell_type = /obj/item/stock_parts/cell/gauss
	slot_flags = SLOT_BELT

/obj/item/gun/energy/gauss/attackby(obj/item/I, mob/user)
	var/maxrods = 50
	if(istype(I, /obj/item/stack/rods))
		if(ammo < maxrods)
			var/obj/item/stack/rods/R = I
			var/amt = maxrods - ammo
			if(R.amount < amt)
				amt = R.amount
			R.amount -= amt
			if (R.amount <= 0)
				qdel(R)
			ammo += amt
			update_icon()
			playsound(user, 'hippiestation/sound/weapons/rodgun_reload.ogg', 50, 1)
			user << "<span class='notice'>You insert [amt] rods in \the [src]. Now it contains [ammo] rods."
			src.desc = "A seriously powerful rifle with an electromagnetic acceleration core, capable of blowing limbs off. It has [ammo] rods left."
		else
			user << "<span class='notice'>\The [src] is already full!</span>"

/obj/item/gun/energy/gauss/process_chamber()
	if(chambered && !chambered.BB) //if BB is null, i.e the shot has been fired...
		var/obj/item/ammo_casing/energy/shot = chambered
		cell.use(shot.e_cost)//... drain the power_supply cell
		if(ammo != -1 && ammo > 0)
			ammo = ammo - 1
			if(ammo < 0)
				ammo = 0 //Just ensuring this never goes below 1 if it has ammo.
			if(ammo < 1)
				playsound(src.loc, 'sound/weapons/smg_empty_alarm.ogg', 60, 1)
		if(select == 3)
			canshoot = 0
			spawn(10)
				canshoot = 1
				if(cell.charge >= shot.e_cost && ammo > 0)
					playsound(src.loc, 'sound/weapons/kenetic_reload.ogg', 60, 1)
	chambered = null //either way, released the prepared shot
	recharge_newshot()
	src.desc = "A seriously powerful rifle with an electromagnetic acceleration core, capable of blowing limbs off. It has [src.ammo] rods left."
	return

/obj/item/gun/energy/gauss/afterattack(mob/living/user)
	if(ammo <= 0)
		shoot_with_empty_chamber(user)
	else
		..()

/obj/item/gun/energy/gauss/handle_suicide(mob/living/carbon/human/user, mob/living/carbon/human/target, params, bypass_timer)
	if(!ishuman(user) || !ishuman(target))
		return

	if(semicd)
		return

	if(user == target)
		target.visible_message("<span class='warning'>[user] sticks [src] in [user.p_their()] mouth, ready to pull the trigger...</span>", \
			"<span class='userdanger'>You stick [src] in your mouth, ready to pull the trigger...</span>")
	else
		target.visible_message("<span class='warning'>[user] points [src] at [target]'s head, ready to pull the trigger...</span>", \
			"<span class='userdanger'>[user] points [src] at your head, ready to pull the trigger...</span>")

	semicd = TRUE

	if(!bypass_timer && (!do_mob(user, target, 120) || user.zone_selected != BODY_ZONE_PRECISE_MOUTH))
		if(user)
			if(user == target)
				user.visible_message("<span class='notice'>[user] decided not to shoot.</span>")
			else if(target && target.Adjacent(user))
				target.visible_message("<span class='notice'>[user] has decided to spare [target]</span>", "<span class='notice'>[user] has decided to spare your life!</span>")
		semicd = FALSE
		return

	semicd = FALSE

	target.visible_message("<span class='warning'>[user] pulls the trigger!</span>", "<span class='userdanger'>[(user == target) ? "You pull" : "[user] pulls"] the trigger!</span>")

	if(chambered && chambered.BB)
		chambered.BB.damage *= 5

	process_fire(target, user, TRUE, params)
	if(chambered && chambered.BB)
		var/obj/item/bodypart/BP = target.get_bodypart(BODY_ZONE_HEAD)
		BP.dismember() //FUN EXECUTION/SUICIDE!