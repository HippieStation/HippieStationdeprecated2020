/obj/effect/proc_holder/changeling/weapon/arm_blade
	dna_cost = 4

/*
	Hippiestation changeling mutations
	Contains:
		Revamped Tentacle
		Chitinous Suit
		Arm Cannon
		Tesla Arm
*/

/***************************************\
|****TENTACLE 2: NOT TERRIBLE EDITION****|
\****************************************/

//Apologies for the copy/pasted code, it was a necessity.

/obj/effect/proc_holder/changeling/weapon/tentacle
	name = "Tentacle"
	desc = "We ready a tentacle to grab items or victims with."
	helptext = "We can use it once to retrieve a distant item. If used on living creatures, the effect depends on the intent: \
	Help will simply drag them closer, Disarm will grab whatever they're holding instead of them, Grab will put the victim in our hold after catching it, \
	and Harm will stun it, and stab it if we're also holding a sharp weapon. Cannot be used while in lesser form."
	chemical_cost = 20
	dna_cost = 2
	req_human = 1
	weapon_type = /obj/item/gun/magic/hippietentacle
	weapon_name_simple = "tentacle"
	silent = FALSE

/obj/item/gun/magic/hippietentacle
	name = "tentacle"
	desc = "A versatile tentacle made out of our own flesh. Attacks change depending on our intent"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "tentacle"
	item_state = "tentacle"
	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
	flags_1 = ABSTRACT_1 | NODROP_1 | DROPDEL_1
	w_class = WEIGHT_CLASS_HUGE
	ammo_type = /obj/item/ammo_casing/magic/hippietentacle
	fire_sound = 'sound/effects/splat.ogg'
	force = 15 // considerably better damage
	max_charges = 1
	throwforce = 0 //I don't know why this is here, but it was in the original tentacle code.
	throw_range = 0
	throw_speed = 0

/obj/item/gun/magic/hippietentacle/Initialize(mapload, silent)
	. = ..()
	if(ismob(loc))
		if(!silent)
			loc.visible_message("<span class='warning'>[loc.name]\'s arm starts stretching inhumanly!</span>", "<span class='warning'>Our arm twists and mutates, transforming it into a tentacle.</span>", "<span class='italics'>You hear organic matter ripping and tearing!</span>")
		else
			to_chat(loc, "<span class='notice'>You prepare to extend a tentacle.</span>")


/obj/item/gun/magic/hippietentacle/shoot_with_empty_chamber(mob/living/user as mob|obj)
	to_chat(user, "<span class='warning'>Our arm is sore from the abuse of the [name]. Wait a second.</span>")

/obj/item/gun/magic/hippietentacle/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] coils [src] tightly around [user.p_their()] neck! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return (OXYLOSS)


/obj/item/ammo_casing/magic/hippietentacle
	name = "tentacle"
	desc = "A tentacle."
	projectile_type = /obj/item/projectile/tentacle
	caliber = "tentacle"
	icon_state = "tentacle_end"
	firing_effect_type = null
	var/obj/item/gun/magic/tentacle/gun //the item that shot it

/obj/item/ammo_casing/magic/tentacle/Initialize()
	gun = loc
	. = ..()

/obj/item/ammo_casing/magic/hippietentacle/Destroy()
	gun = null
	return ..()

/obj/item/projectile/hippietentacle
	name = "tentacle"
	icon_state = "tentacle_end"
	pass_flags = PASSTABLE
	damage = 0
	damage_type = BRUTE
	range = 8
	hitsound = 'sound/weapons/thudswoosh.ogg'
	var/chain
	var/obj/item/ammo_casing/magic/tentacle/source //the item that shot it

/obj/item/projectile/hippietentacle/Initialize()
	source = loc
	. = ..()

/obj/item/projectile/hippietentacle/fire(setAngle)
	if(firer)
		chain = firer.Beam(src, icon_state = "tentacle", time = INFINITY, maxdistance = INFINITY, beam_sleep_time = 1)
	..()

/obj/item/projectile/hippietentacle/proc/reset_throw(mob/living/carbon/human/H)
	if(H.in_throw_mode)
		H.throw_mode_off() //Don't annoy the changeling if he doesn't catch the item

/obj/item/projectile/hippietentacle/proc/tentacle_grab(mob/living/carbon/human/H, mob/living/carbon/C)
	if(H.Adjacent(C))
		C.grabbedby(H) // removed instant aggro grab to compensate for the increased damage

/obj/item/projectile/hippietentacle/proc/tentacle_stab(mob/living/carbon/human/H, mob/living/carbon/C)
	if(H.Adjacent(C))
		for(var/obj/item/I in H.held_items)
			if(I.is_sharp())
				C.visible_message("<span class='danger'>[H] impales [C] with [H.p_their()] [I.name]!</span>", "<span class='userdanger'>[H] impales you with [H.p_their()] [I.name]!</span>")
				C.apply_damage(I.force, BRUTE, "chest")
				H.do_item_attack_animation(C, used_item = I)
				H.add_mob_blood(C)
				playsound(get_turf(H),I.hitsound,75,1)
				return

/obj/item/projectile/hippietentacle/on_hit(atom/target, blocked = FALSE)
	var/mob/living/carbon/human/H = firer // removed the delete, tentacle now lasts FOREVER
	if(blocked >= 100)
		return 0
	if(isitem(target))
		var/obj/item/I = target
		if(!I.anchored)
			to_chat(firer, "<span class='notice'>You pull [I] towards yourself.</span>")
			H.throw_mode_on()
			I.throw_at(H, 10, 2)
			. = 1

	else if(isliving(target))
		var/mob/living/L = target
		if(!L.anchored && !L.throwing)//avoid double hits
			if(iscarbon(L))
				var/mob/living/carbon/C = L
				switch(firer.a_intent)
					if(INTENT_HELP)
						C.visible_message("<span class='danger'>[L] is pulled by [H]'s tentacle!</span>","<span class='userdanger'>A tentacle grabs you and pulls you towards [H]!</span>")
						C.throw_at(get_step_towards(H,C), 8, 2)
						C.Knockdown(5)
						return 1

					if(INTENT_DISARM)
						var/obj/item/I = C.get_active_held_item()
						if(I)
							if(C.dropItemToGround(I))
								C.visible_message("<span class='danger'>[I] is yanked off [C]'s hand by [src]!</span>","<span class='userdanger'>A tentacle pulls [I] away from you!</span>")
								on_hit(I) //grab the item as if you had hit it directly with the tentacle
								return 1
							else
								to_chat(firer, "<span class='danger'>You can't seem to pry [I] off [C]'s hands!</span>")
								return 0
						else
							to_chat(firer, "<span class='danger'>[C] has nothing in hand to disarm!</span>")
							return 0

					if(INTENT_GRAB)
						C.visible_message("<span class='danger'>[L] is grabbed by [H]'s tentacle!</span>","<span class='userdanger'>A tentacle grabs you and pulls you towards [H]!</span>")
						C.throw_at(get_step_towards(H,C), 8, 2, H, TRUE, TRUE, callback=CALLBACK(src, .proc/tentacle_grab, H, C))
						C.Knockdown(5)
						return 1

					if(INTENT_HARM)
						C.visible_message("<span class='danger'>[L] is thrown towards [H] by a tentacle!</span>","<span class='userdanger'>A tentacle grabs you and throws you towards [H]!</span>")
						C.throw_at(get_step_towards(H,C), 8, 2, H, TRUE, TRUE, callback=CALLBACK(src, .proc/tentacle_stab, H, C))
						C.Knockdown(5)
						return 1
			else
				L.visible_message("<span class='danger'>[L] is pulled by [H]'s tentacle!</span>","<span class='userdanger'>A tentacle grabs you and pulls you towards [H]!</span>")
				L.throw_at(get_step_towards(H,L), 8, 2)
				. = 1

/obj/item/projectile/hippietentacle/Destroy()
	qdel(chain)
	source = null
	return ..()


/***************************************\
|************CHITINOUS SUIT!************|
\***************************************/

/obj/effect/proc_holder/changeling/suit/chitinous_suit
	name = "Chitinous Suit"
	desc = "We form a suit to protect ourselves from both attacks, and space. Requires a chemical upkeep."
	helptext = "We create a suit that will protect ourselves from space, and attacks from enemy lifeforms. It will reduce our chemical recharge rate while active."
	chemical_cost = 15
	dna_cost = 2
	req_human = 1
	recharge_slowdown = 0.60 // running around in a full suit w/ armblade is gonna be really costly now

	suit_type = /obj/item/clothing/suit/armor/changeling
	helmet_type = /obj/item/clothing/head/helmet/changeling
	suit_name_simple = "armor"
	helmet_name_simple = "helmet"

/obj/item/clothing/suit/armor/changeling
	flags_1 = NODROP_1 | DROPDEL_1 | STOPSPRESSUREDMAGE_1
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/device/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/oxygen)
	armor = list("melee" = 40, "bullet" = 40, "laser" = 20, "energy" = 20, "bomb" = 10, "bio" = 4, "rad" = 0, "fire" = 0, "acid" = 90)
	flags_inv = HIDEJUMPSUIT
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT

/obj/item/clothing/suit/armor/changeling/Initialize()
	. = ..()
	if(ismob(loc))
		loc.visible_message("<span class='warning'>[loc.name]\'s flesh turns black, quickly transforming into a hard, chitinous mass!</span>", "<span class='warning'>We harden our flesh, creating a suit of armor!</span>", "<span class='italics'>You hear organic matter ripping and tearing!</span>")
	START_PROCESSING(SSobj, src)

/obj/item/clothing/suit/armor/changeling/process()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.reagents.add_reagent("salbutamol", REAGENTS_METABOLISM) // you'll be able to breathe in SPACE, sort've not really.

/obj/item/clothing/head/helmet/changeling
	desc = "A tough, hard covering of black chitin with translucent chitin in front."
	icon_state = "lingarmorhelmet"
	flags_1 = NODROP_1 | DROPDEL_1 | STOPSPRESSUREDMAGE_1
	armor = list("melee" = 40, "bullet" = 40, "laser" = 20, "energy" = 20, "bomb" = 10, "bio" = 4, "rad" = 0, "fire" = 0, "acid" = 90)
	flags_inv = HIDEEARS|HIDEHAIR|HIDEEYES|HIDEFACIALHAIR|HIDEFACE
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT

/***************************************\
|***************ARM CANNON**************|
\***************************************/

/obj/effect/proc_holder/changeling/weapon/armcannon
	name = "Arm Cannon"
	desc = "We transform our arm into a ballistic weapon. Devours our chemicals, and has a rather slow recharge rate."
	helptext = "You shoot at people and they die. Cannot be used in lesser form."
	chemical_cost = 35
	dna_cost = 3
	req_human = 1
	weapon_type = /obj/item/gun/magic/ling_armcannon
	weapon_name_simple = "armcannon"
	silent = FALSE

/obj/item/gun/magic/ling_armcannon
	name = "armcannon"
	desc = "A ballistic weapon comparable to a Stetchkin Pistol, made out of our own arm. It stirs and mixes chemicals to create its ammunition."
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	icon_state = "gun_arm"
	item_state = "gun_arm"
	lefthand_file = 'hippiestation/icons/mob/inhands/changeling_lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/changeling_righthand.dmi'
	flags_1 = ABSTRACT_1 | NODROP_1 | DROPDEL_1
	w_class = WEIGHT_CLASS_HUGE
	ammo_type = /obj/item/ammo_casing/magic/ling_armcannon
	fire_sound = 'sound/effects/splat.ogg'
	force = 7 // if you really have to hit someone.
	max_charges = 8
	throwforce = 0 //I don't know why this is here, but it was in the original tentacle code. Keeping it here, too.
	throw_range = 0
	throw_speed = 0
	recharge_rate = 3

/obj/item/gun/magic/ling_armcannon/Initialize(mapload, silent)
	. = ..()
	if(ismob(loc))
		if(!silent)
			loc.visible_message("<span class='warning'>[loc.name]\'s arm twists and contorts into a cannon!</span>", "<span class='warning'>Our arm twists and mutates, transforming it into a cannon.</span>", "<span class='italics'>You hear organic matter ripping and tearing!</span>")
		else
			to_chat(loc, "<span class='notice'>Your Arm Cannon begins to shake, it's ready to fire!</span>")

/obj/item/ammo_casing/magic/ling_armcannon
	name = "gelatinous bullet"
	desc = "A bullet formed out of some jelly-like mass."
	projectile_type = /obj/item/projectile/bullet/c9mm/changeling
	caliber = "cornpotato pizza" // Is this var ever actually used?
	icon_state = "tentacle_end"
	firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect

/obj/item/projectile/bullet/c9mm/changeling
	name = "gelatinous bullet"
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	icon = 'hippiestation/icons/obj/projectiles.dmi'
	icon_state = "changeling_bullet"