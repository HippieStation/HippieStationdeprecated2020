#define MAKESHIFT_BATON_CD 1.5

/obj/item/melee/baton/attack(mob/M, mob/living/carbon/human/user)
	if(is_ganymede(user))
		user.visible_message("<span class='danger'>[user] accidentally crushes [src] in their hand!</span>")
		qdel(src)
		return
	return ..()

/obj/item/melee/baton/stungun
	name = "stungun"
	desc = "A powerful, self-charging electric stun gun, courtesy of Nanotrasen's self-defense implements."
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	icon_state = "stungun"
	item_state = "stungun"
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	force = 0
	throwforce = 5
	stunforce = 70
	hitcost = 100
	throw_hit_chance = 20
	attack_verb = list("poked")
	var/selfcharge = 1
	var/charge_sections = 3
	var/shaded_charge = 1
	var/charge_tick = 0
	var/charge_delay = 10
	preload_cell_type = /obj/item/stock_parts/cell/potato

/obj/item/melee/baton/stungun/Initialize()
	. = ..()
	if(selfcharge)
		START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/melee/baton/stungun/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/screwdriver))
		to_chat(user, "<span class='warning'>That would void the warranty.</span>")
		return

/obj/item/melee/baton/stungun/update_icon()
	..()
	var/ratio = CEILING(CLAMP(cell.charge / cell.maxcharge, 0, 1) * charge_sections, 1)
	cut_overlays()
	var/iconState = "[initial(name)]_charge"
	var/itemState = null
	if(!initial(item_state))
		itemState = icon_state
	if(cell.charge < hitcost)
		add_overlay("[initial(name)]_empty")
	else
		if(!shaded_charge)
			var/mutable_appearance/charge_overlay = mutable_appearance(icon, iconState)
			for(var/i = ratio, i >= 1, i--)
				add_overlay(charge_overlay)
		else
			add_overlay("[initial(name)]_charge[ratio]")
	if(itemState)
		itemState += "[ratio]"
		item_state = itemState

/obj/item/melee/baton/stungun/process()
	..()
	if(selfcharge)
		charge_tick++
		if(charge_tick < charge_delay)
			return
		charge_tick = 0
		if(!cell)
			return
		cell.give(100)
		if(cell && cell.charge < 300)
			playsound(src, 'hippiestation/sound/misc/charge.ogg', 35, FALSE, pressure_affected = FALSE)
			update_icon()

/obj/item/melee/baton/stungun/baton_stun()
	..()
	playsound(loc, 'hippiestation/sound/weapons/stungun.ogg', 75, 1, -1)
	update_icon()

/obj/item/melee/baton
	stunforce = 100

/obj/item/melee/baton/cattleprod/hippie_cattleprod
	stunforce = 7
	var/stamforce = 100
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/melee/baton/cattleprod/hippie_cattleprod/baton_stun(mob/living/L, mob/user)
	if(is_ganymede(user))
		user.visible_message("<span class='danger'>[user] accidentally crushes [src] in their hand!</span>")
		qdel(src)
		return 0
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.check_shields(src, 0, "[user]'s [name]", MELEE_ATTACK)) //No message; check_shields() handles that
			playsound(L, 'sound/weapons/genhit.ogg', 50, 1)
			return 0
	if(iscyborg(loc))
		var/mob/living/silicon/robot/R = loc
		if(!R || !R.cell || !R.cell.use(hitcost))
			return 0
	else
		if(!deductcharge(hitcost))
			return 0

	L.adjustStaminaLoss(stamforce)
	L.apply_effect(EFFECT_STUTTER, stunforce)
	SEND_SIGNAL(L, COMSIG_LIVING_MINOR_SHOCK)
	if(user)
		L.lastattacker = user.real_name
		L.lastattackerckey = user.ckey
		L.visible_message("<span class='danger'>[user] has stunned [L] with [src]!</span>", \
								"<span class='userdanger'>[user] has stunned you with [src]!</span>")
		log_combat(user, L, "stunned")

	playsound(loc, 'sound/weapons/egloves.ogg', 50, 1, -1)

	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.forcesay(GLOB.hit_appends)
