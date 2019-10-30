/* Crowbar Shoes */

/obj/item/clothing/shoes/crowbar //basic syndicate combat boots for nuke ops and mob corpses
	name = "crowbar shoes"
	desc = "They're just shoes with some crowbars tacked on at the heels."
	alternate_worn_icon = 'hippiestation/icons/mob/feet.dmi'
	icon = 'hippiestation/icons/obj/clothing/shoes.dmi'
	icon_state = "crowbarshoes"
	item_state = "crowbarshoes"
	strip_delay = 50
	resistance_flags = NONE
	permeability_coefficient = 0.05
	usesound = 'sound/items/crowbar.ogg'

/obj/item/clothing/shoes/crowbar/step_action()
	var/turf/open/floor/t_loc = get_turf(loc)
	if(istype(t_loc))																																/*
		t_loc.pry_tile(src, loc, TRUE)																																			*/
		t_loc.pry_tile(src, usr, TRUE)


/* Lube Banana Peel */


/obj/item/grown/bananapeel/lube
	seed = null
	name = "lubanana peel"
	icon = 'hippiestation/icons/obj/hydroponics/harvest.dmi'
	desc = "An enhanced banana peel, from clown hell. It's extremely slippery."
	icon_state = "banana_peel_lube"

/obj/item/grown/bananapeel/lube/Initialize(AM)
    . = ..()
    AddComponent(/datum/component/slippery, 80, SLIDE)


 /* Energy Mop */


/obj/item/mop/advanced/energy
	name = "energy mop"
	desc = "A mop of legend, purportedly once owned by the bald man of cleaning himself.<span class ='notice'><br><b>Alt-click</b> to turn the condenser switch on or off.</span>"
	icon = 'hippiestation/icons/obj/janitor.dmi'
	lefthand_file = 'hippiestation/icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/equipment/custodial_righthand.dmi'
	icon_state = "energymop_0"
	item_state = "energymop_0"
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_TINY
	hitsound = "swing_hit"
	item_flags = NONE
	force = 0
	force_string = "very robust... against germs"
	mopspeed = 3
	mopcap = 30
	refill_rate = 2
	attack_verb = list("tapped", "poked")
	var/on = FALSE

/obj/item/mop/advanced/AltClick(mob/user)
	refill_enabled = !refill_enabled
	if(refill_enabled)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj,src)
	to_chat(user, "<span class='notice'>You set the condenser switch to the '[refill_enabled ? "ON" : "OFF"]' position.</span>")
	playsound(user, 'sound/machines/click.ogg', 30, 1)

/obj/item/mop/advanced/energy/attack_self(mob/user)
	on = !on
	if(on)
		extend(user)
	else
		retract(user)

	playsound(user, on ? 'sound/weapons/saberon.ogg' : 'sound/weapons/saberoff.ogg', 35, 1)
	add_fingerprint(user)

/obj/item/mop/advanced/energy/afterattack(atom/A, mob/user, proximity)
	if(!on)
		return
	. = ..()

/obj/item/mop/advanced/energy/proc/extend(user)
	to_chat(user, "<span class ='warning'>You activate the [src], allowing you to clean the station's sins.</span>")
	icon_state = "energymop_1"
	item_state = "energymop_1"
	w_class = WEIGHT_CLASS_BULKY
	hitsound = "sound/weapons/blade1.ogg"
	attack_verb = list("ferociously cleaned", "mopped up")
	force = 23

/obj/item/mop/advanced/energy/proc/retract(user)
	to_chat(user, "<span class ='notice'>You disable the [src], allowing it to be concealed.</span>")
	icon_state = "energymop_0"
	item_state = "energymop_0"
	w_class = WEIGHT_CLASS_TINY
	hitsound = "swing_hit"
	attack_verb = list("tapped", "poked")
	force = 0


/* Blood Debt */


/obj/item/blood_debt
	name = "blood debt"
	desc = "Makes you serve a good life sentence."
	force = 0
	icon = 'hippiestation/icons/obj/guns/projectile.dmi'
	icon_state = "blood_debt"
	item_state = "gun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	item_flags = ABSTRACT | DROPDEL

/obj/item/blood_debt/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)


/obj/item/blood_debt_granter
	name = "mysterious arm attachment"
	desc = "It's a makeshift grey thing, clearly meant to be used to hold something."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "c20r45-0"

/obj/item/blood_debt_granter/attack_self(mob/living/carbon/human/user)
	if(!istype(user) || !user)
		return
	var/message = "<span class='notice'>You know how to use the Blood Debt! When in critical condition, pull it out and fire one last instant gib shot! Using it will also kill you, \
	so make that shot count!</span>"
	to_chat(user, message)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/aimed/blood_debt)
	user.dropItemToGround(user.get_active_held_item())
	visible_message("<span class='warning'>[usr] puts the [src] on. It's covered in ash.</span>")
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	qdel(src)

/obj/effect/proc_holder/spell/aimed/blood_debt
	name = "Blood Debt"
	desc = "A one-use, instant kill blast from a hidden weapon. Can only be used in critical condition, and will kill you upon firing."
	charge_max = 999
	clothes_req = FALSE
	staff_req = FALSE
	invocation = "HURP DURP"
	invocation_type = null
	range = 20
	cooldown_min = 999 // Not possible to fire it again to begin with.
	projectile_type = /obj/item/projectile/magic/aoe/blood_debt
	sound = 'hippiestation/sound/weapons/blood_debt.ogg'
	active_msg = "You grab the Blood Debt. Make the shot count!"
	deactive_msg = "You decide against shooting."
	active = FALSE
	stat_allowed = TRUE
	var/gun_path = /obj/item/blood_debt
	var/obj/item/blood_debt/attached_gun = null

/obj/effect/proc_holder/spell/aimed/blood_debt/Click()
	var/mob/living/user = usr
	if(!user.stat)
		to_chat(user, "<span class = 'warning'>You can't use the blood debt outside of critical condition!</span>")
		return
	if(user.stat == DEAD)
		to_chat(user, "<span class = 'notice'>Your revenge has been cut short by an untimely death.</span>")
		remove_ranged_ability()
		on_deactivation(user)
		return
	. = ..()

/obj/effect/proc_holder/spell/aimed/blood_debt/proc/remove_hand(recharge = FALSE) // Look ma! Copypasted spell code just to let someone shoot in crit! Maintainers are going to have an aneurysm!
	QDEL_NULL(attached_gun)
	if(recharge)
		charge_counter = charge_max

/obj/effect/proc_holder/spell/aimed/blood_debt/on_activation(mob/living/carbon/user)
	attached_gun = new gun_path(src)
	if(!user.put_in_hands(attached_gun))
		remove_ranged_ability()
		on_deactivation(user)
		if (user.get_num_arms() <= 0)
			to_chat(user, "<span class='warning'>You dont have any usable hands!</span>")
		else
			to_chat(user, "<span class='warning'>Your hands are full!</span>")
		return FALSE
	user.visible_message("<span class='danger'><b>[user] pulls out a Blood Debt!</b></span>")
	return TRUE

/obj/effect/proc_holder/spell/aimed/blood_debt/on_deactivation(mob/living/carbon/user)
	remove_hand(TRUE)
	return

/obj/item/projectile/magic/aoe/blood_debt
	name = "HOLY SHIT"
	desc = "You probably should be running away instead of gawking at this thing."
	icon_state = "fireball"
	damage = 10
	damage_type = BRUTE
	nodamage = FALSE

/obj/item/projectile/magic/aoe/blood_debt/on_hit(target)
	. = ..()
	var/turf/T = get_turf(target)
	explosion(T, -1, 2, 3, 6, 0, flame_range = 4)
	if(ismob(target))
		var/mob/living/M = target
		priority_announce("[firer], age 45, gave themselves up to authorities after blowing up [target]. They are now serving a life sentence.","Blood Debt!", 'hippiestation/sound/misc/lubricator.ogg')
		M.gib(1, 1, 1) //dead

/obj/effect/proc_holder/spell/aimed/blood_debt/perform(list/targets, recharge = 1, mob/living/carbon/human/user = usr)
	if(!user.stat)
		to_chat(user, "<span class = 'notice'>You holster the Blood Debt.</span>")
		remove_ranged_ability()
		on_deactivation(user)
		return FALSE
	if(user.stat == DEAD)
		to_chat(user, "<span class = 'notice'>Your revenge has been cut short by an untimely death.</span>")
		revert_cast(user)
		return FALSE
	user.visible_message("<span class='userdanger'>[user] fires the Blood Debt!</span>")
	user.adjustOxyLoss(200)
	..()
