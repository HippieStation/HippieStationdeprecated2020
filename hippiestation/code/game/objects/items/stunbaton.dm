#define MAKESHIFT_BATON_CD 1.5

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
	var/ratio = CEILING((cell.charge / cell.maxcharge) * charge_sections, 1)
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
	stunforce = 40
	w_class = WEIGHT_CLASS_NORMAL