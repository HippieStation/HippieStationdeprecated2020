/obj/effect/proc_holder/spell/self/pillar_blade
	name = "Light Blade"
	desc = "Extend or retract a shining, powerful blade from your arm."
	action_icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	action_icon_state = "lightblade"
	action_background_icon = 'hippiestation/icons/mob/actions/backgrounds.dmi'
	action_background_icon_state = "bg_pillar"
	clothes_req = FALSE
	charge_max = 0

/obj/effect/proc_holder/spell/self/pillar_blade/cast(list/targets, mob/user)
	if(!pillarmen_check(user))
		revert_cast()
		return FALSE
	var/obj/item/held = user.get_active_held_item()
	for(var/obj/item/I in user.held_items)
		if(istype(I, /obj/item/melee/pillar_blade))
			user.temporarilyRemoveItemFromInventory(I, TRUE) //DROPDEL will delete the item
			user.update_inv_hands()
			return FALSE
	if(held && !user.dropItemToGround(held))
		to_chat(user, "<span class='warning'>[held] is stuck to your hand, you cannot form a light blade over it!</span>")
		revert_cast()
		return FALSE
	user.put_in_hands(new /obj/item/melee/pillar_blade(user))

//armblade copypaste
/obj/item/melee/pillar_blade
	name = "light blade"
	desc = "A grotesque blade made out of bone and flesh that cleaves through people as a hot knife through butter."
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	icon_state = "lightblade"
	item_state = "lightblade"
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi'
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	force = 22.5
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	hitsound = 'sound/weapons/blade1.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	sharpness = IS_SHARP

/obj/item/melee/pillar_blade/Initialize(mapload,silent,synthetic)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)
	if(ismob(loc))
		loc.visible_message("<span class='warning'>A shining blade forms around [loc.name]\'s arm!</span>")
	AddComponent(/datum/component/butchering, 60, 80)

/obj/item/melee/pillar_blade/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(istype(target, /obj/structure/table))
		var/obj/structure/table/T = target
		T.deconstruct(FALSE)

	else if(istype(target, /obj/machinery/computer))
		var/obj/machinery/computer/C = target
		C.attack_alien(user) //muh copypasta

	else if(istype(target, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/A = target

		if((!A.requiresID() || A.allowed(user)) && A.hasPower()) //This is to prevent stupid shit like hitting a door with an arm blade, the door opening because you have acces and still getting a "the airlocks motors resist our efforts to force it" message, power requirement is so this doesn't stop unpowered doors from being pried open if you have access
			return
		if(A.locked)
			to_chat(user, "<span class='warning'>The airlock's bolts prevent it from being forced!</span>")
			return

		if(A.hasPower())
			user.visible_message("<span class='warning'>[user] jams [src] into the airlock and starts prying it open!</span>", "<span class='warning'>We start forcing the [A] open.</span>", \
			"<span class='italics'>You hear a metal screeching sound.</span>")
			playsound(A, 'sound/machines/airlock_alien_prying.ogg', 100, 1)
			if(!do_after(user, 100, target = A))
				return
		//user.say("Heeeeeeeeeerrre's Johnny!")
		user.visible_message("<span class='warning'>[user] forces the airlock to open with [user.p_their()] [src]!</span>", "<span class='warning'>We force the [A] to open.</span>", \
		"<span class='italics'>You hear a metal screeching sound.</span>")
		A.open(2)
