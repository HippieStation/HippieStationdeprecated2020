/obj/item/clothing/suit/apron/chef/scrake
	name = "scrake's apron"
	desc = "An apron used to stop getting the gibs of enemies on your skin."
	allowed = list(/obj/item/tank/internals)
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	clothing_flags = THICKMATERIAL | STOPSPRESSUREDAMAGE
	armor = list("melee" = 70, "bullet" = 45, "laser" = 80, "energy" = 45, "bomb" = 75, "bio" = 0, "rad" = 30, "fire" = 80, "acid" = 100)
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF
	slowdown = 1
	var/rage_cooldown_duration = 600
	var/rage_cooldown = 0
	var/raged = FALSE
	var/red_splash = list(1,0,0,0.8,0.2,0, 0.8,0,0.2,0.1,0,0)
	var/pure_red = list(0,0,0,0,0,0,0,0,0,1,0,0)

/obj/item/clothing/suit/apron/chef/scrake/equipped(mob/living/carbon/human/user, slot)
	if(slot == SLOT_WEAR_SUIT)
		item_flags = NODROP
		user.set_species(/datum/species/scrake)
		user.maxHealth = 250
		user.health = 250

/obj/item/clothing/suit/apron/chef/scrake/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(prob(damage*1.25) && !raged)
		var/mob/living/carbon/human/H = owner
		Rage(H)
		spawn(180)
			H.client.color = initial(H.client.color)
			slowdown = initial(slowdown)
			raged = FALSE
	return 0

/obj/item/clothing/suit/apron/chef/scrake/proc/Rage(mob/living/carbon/human/owner)
	if(world.time < rage_cooldown)
		return
	owner.client.color = pure_red
	animate(owner.client,color = red_splash, time = 10, easing = SINE_EASING|EASE_OUT)
	owner.visible_message("<span class='userdanger'>The scrake looks pissed, run!</span>", \
						"<span class='userdanger'>That HURT! NOW I'M MAD!!</span>")
	playsound(src, 'hippiestation/sound/misc/floor_cluwne_emerge.ogg', 100, 1)
	raged = TRUE
	slowdown = -0.25
	rage_cooldown = world.time + rage_cooldown_duration

/obj/item/clothing/mask/surgical/scrake
	name = "butcher mask"
	desc = "A mask probably used by a serial killer."
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	gas_transfer_coefficient = 0.01
	armor = list("melee" = 70, "bullet" = 45, "laser" = 80, "energy" = 45, "bomb" = 75, "bio" = 0, "rad" = 30, "fire" = 80, "acid" = 100)
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF

/obj/item/clothing/mask/surgical/scrake/equipped(mob/living/carbon/human/user, slot)
	if(slot == SLOT_WEAR_MASK)
		item_flags = NODROP

/obj/item/twohanded/required/scrake_saw
	name = "mounted industrial chainsaw"
	desc = "An industrial chainsaw that has replaced your arm."
	icon_state = "chainsaw_on"
	item_state = "mounted_chainsaw"
	lefthand_file = 'icons/mob/inhands/weapons/chainsaw_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/chainsaw_righthand.dmi'
	hitsound = 'sound/weapons/chainsawhit.ogg'
	force = 50
	armour_penetration = 10
	item_flags = NODROP | ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	sharpness = IS_SHARP
	attack_verb = list("sawed", "torn", "cut", "chopped", "diced")

/obj/item/twohanded/required/scrake_saw/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 30, 100, 0, 'sound/weapons/chainsawhit.ogg', TRUE)

/obj/item/twohanded/required/scrake_saw/attack(mob/living/target, mob/living/user)
	. = ..()
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored && prob(40))
		target.throw_at(throw_target, 1, 3, user, FALSE)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(istype(H.wear_suit, /obj/item/clothing/suit/apron/chef/scrake))
			var/obj/item/clothing/suit/apron/chef/scrake/sc = H.wear_suit
			if(sc.raged)
				H.changeNext_move(CLICK_CD_MELEE * 0.5)//rage