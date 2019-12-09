/obj/item/clothing/suit/apron/chef/scrake
	name = "scrake's apron"
	desc = "An apron used to stop getting the gibs of enemies on your skin."
	allowed = list(/obj/item/tank/internals)
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	clothing_flags = THICKMATERIAL | STOPSPRESSUREDAMAGE
	armor = list("melee" = 70, "bullet" = 40, "laser" = 40, "energy" = 45, "bomb" = 75, "bio" = 0, "rad" = 30, "fire" = 80, "acid" = 100)
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF
	alternate_screams = list('hippiestation/sound/creatures/zombiegrowl1.ogg')
	slowdown = 0.5
	var/rage_cooldown_duration = 600
	var/rage_cooldown = 0
	var/raged = FALSE

/obj/item/clothing/suit/apron/chef/scrake/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_WEAR_SUIT)
		ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
		item_flags |= DROPDEL
		user.set_species(/datum/species/scrake)
		user.maxHealth = 250
		user.health = 250
		user.hair_style = "Short Hair"
		user.facial_hair_style = "Shaved"
		user.hair_color = "000"
		user.regenerate_icons()
		user.name = "Scrake"
		var/datum/component/footstep/FS = user.GetComponent(/datum/component/footstep)
		FS.volume = 2.0 //big stomper

/obj/item/clothing/suit/apron/chef/scrake/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(prob(damage*1.2) && !raged)
		Rage(owner)
	return ..()

/obj/item/clothing/suit/apron/chef/scrake/proc/Rage(mob/living/carbon/human/owner)
	if(world.time < rage_cooldown)
		return
	if(!owner)
		return
	owner.client.color = COLOR_RED
	animate(owner.client,color = COLOR_RED_LIGHT, time = 10, easing = SINE_EASING|EASE_OUT)
	owner.visible_message("<span class='userdanger'>The scrake looks pissed, run!</span>", \
						"<span class='userdanger'>That HURT! NOW I'M MAD!!</span>")
	playsound(src, 'hippiestation/sound/misc/floor_cluwne_emerge.ogg', 100, 1)
	raged = TRUE
	slowdown = -0.25
	rage_cooldown = world.time + rage_cooldown_duration
	addtimer(CALLBACK(src, .proc/rage_reset, owner), 180)

/obj/item/clothing/suit/apron/chef/scrake/proc/rage_reset(mob/living/carbon/human/owner)
	owner.client.color = initial(owner.client.color)
	slowdown = initial(slowdown)
	raged = FALSE

/obj/item/clothing/mask/surgical/scrake
	name = "butcher mask"
	desc = "A mask probably used by a serial killer."
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	gas_transfer_coefficient = 0.01
	armor = list("melee" = 70, "bullet" = 40, "laser" = 40, "energy" = 45, "bomb" = 75, "bio" = 0, "rad" = 30, "fire" = 80, "acid" = 100)
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF

/obj/item/clothing/mask/surgical/scrake/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_WEAR_MASK)
		item_flags |= DROPDEL
		ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

/obj/item/twohanded/required/chainsaw/scrake_saw
	name = "mounted industrial chainsaw"
	desc = "An industrial chainsaw that has replaced your arm."
	force = 15
	force_on = 40
	armour_penetration = 10
	item_flags = DROPDEL
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	var/onsound = 'hippiestation/sound/weapons/echainsawon.ogg'
	var/offsound = 'hippiestation/sound/weapons/echainsawoff.ogg'

/obj/item/twohanded/required/chainsaw/scrake_saw/equipped(mob/living/user, slot)
	. = ..()
	attack_self(user)

/obj/item/twohanded/required/chainsaw/scrake_saw/attack_self(mob/user)
	. = ..()
	playsound(user, on ? onsound : offsound , 50, 1)

/obj/item/twohanded/required/chainsaw/scrake_saw/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

/obj/item/twohanded/required/chainsaw/scrake_saw/attack(mob/living/target, mob/living/user)
	. = ..()
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored && prob(40))
		target.throw_at(throw_target, 1, 3, user, FALSE)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(istype(H.wear_suit, /obj/item/clothing/suit/apron/chef/scrake))
			var/obj/item/clothing/suit/apron/chef/scrake/sc = H.wear_suit
			if(sc.raged)
				H.changeNext_move(CLICK_CD_CLICK_ABILITY)//rage attack, hit 25% faster

/datum/outfit/scrake
	name = "Scrake outfit"
	mask = /obj/item/clothing/mask/surgical/scrake
	suit = /obj/item/clothing/suit/apron/chef/scrake
	l_hand = /obj/item/twohanded/required/chainsaw/scrake_saw
