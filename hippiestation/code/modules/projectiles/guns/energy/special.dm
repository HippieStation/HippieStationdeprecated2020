/obj/item/gun/energy/watcherprojector
	name = "watcher projector"
	desc = "A tool reproducing the icy beam of a watcher. You could freeze humans down then horribly murder them! Or, you know, mine stuff. Can also be used to melt down ores."
	icon_state = "watcherprojector"
	icon = 'hippiestation/icons/obj/guns/energy.dmi'
	item_state = "watcherprojector"
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi'
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/watcher)
	flags_1 = CONDUCT_1
	attack_verb = list("bashed", "stared down", "whacked")
	force = 15
	sharpness = IS_SHARP
	can_charge = 0

	usesound = list('sound/items/welder.ogg', 'sound/items/welder2.ogg')
	tool_behaviour = TOOL_WELDER
	toolspeed = 0.7 //can smelt ores and break down walls with it

/obj/item/gun/energy/watcherprojector/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 25, 105, 0, 'sound/weapons/pierce.ogg')

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

/obj/item/gun/energy/watcherprojector/tool_use_check(mob/living/user, amount)
	if(cell.charge >= amount * 100)
		return TRUE

	to_chat(user, "<span class='warning'>You need more charge to complete this task!</span>")
	return FALSE

/obj/item/gun/energy/watcherprojector/use(amount)
	return cell.use(amount * 100)

/obj/item/gun/energy/watcherprojector/update_icon()
	return

/obj/item/ammo_casing/energy/plasma/watcher
	projectile_type = /obj/item/projectile/plasma/watcher
	select_name = "freezing blast shot"
	fire_sound = 'sound/weapons/pierce.ogg'
	delay = 15
	e_cost = 100

/obj/item/projectile/plasma/watcher
	name = "freezing blast"
	icon_state = "ice_2"
	damage = 5
	flag = "energy"
	damage_type = BURN
	range = 4
	mine_range = 0
	var/temperature = -50
	dismemberment = FALSE

/obj/item/projectile/plasma/watcher/on_hit(atom/target, blocked = 0)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		L.adjust_bodytemperature(L.bodytemperature + (((100-blocked)/100)*(temperature - L.bodytemperature))) // the new body temperature is adjusted by 100-blocked % of the delta between body temperature and the bullet's effect temperature