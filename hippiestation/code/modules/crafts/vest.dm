/obj/item/clothing/suit/armor/makeshift
	name = "makeshift armor"
	desc = "A hazard vest with metal plate taped on it. It offers minor protection."
	icon = 'hippiestation/icons/obj/armor.dmi'
	alternate_worn_icon = 'hippiestation/icons/obj/armor.dmi'
	icon_state = "makeshiftarmor-worn"
	item_state = "makeshiftarmor"
	w_class = 3
	blood_overlay_type = "armor"
	armor = list("melee" = 30, "bullet" = 10, "laser" = 0, "energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0)

/datum/crafting_recipe/makeshift_armor
	name = "makeshift armor"
	result =  /obj/item/clothing/suit/armor/makeshift
	reqs = list(/obj/item/stack/sheet/metal = 1,
				/obj/item/clothing/suit/hazardvest = 1,
				/obj/item/stack/ducttape = 5)
	time = 80
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/obj/item/clothing/suit/armor/plate_armor/steel
	name = "plate armor"
	desc = "A suit of plate armor. It is so heavy one cannot be pushed down while inside it."
	icon = 'hippiestation/icons/obj/clothing/suits.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/suit.dmi'
	item_state = "plate_armor"
	icon_state = "plate_armor"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/claymore, /obj/item/forged/melee/sword, /obj/item/forged/melee/dagger, /obj/item/twohanded/forged/greatsword, /obj/item/forged/melee/mace,/obj/item/nullrod)
	armor = list("melee" = 50, "bullet" = 15, "laser" = -10, "energy" = -10, "bomb" = 15, "bio" = 25, "rad" = 20, "fire" = -15, "acid" = 80)
	blocks_shove_knockdown = TRUE
	resistance_flags = ACID_PROOF
	w_class = WEIGHT_CLASS_BULKY
	var/padded = FALSE
	strip_delay = 80
	equip_delay_other = 60
	slowdown = 0.6
	var/spikey = FALSE

/obj/item/clothing/suit/armor/plate_armor/steel/Initialize()
	. = ..()
	AddComponent(/datum/component/spraycan_paintable)
	START_PROCESSING(SSobj, src)
	if(prob(25))
		spikey = TRUE
		item_state = "plate_armor_spikey"
		icon_state = "plate_armor_spikey"
		new /obj/item/clothing/head/helmet/plate_armor/spikey(src.loc)
		armor = list("melee" = 50, "bullet" = 10, "laser" = -10, "energy" = -25, "bomb" = 10, "bio" = 25, "rad" = 20, "fire" = -15, "acid" = 80) //this is a menacing plate armor
		desc = "A suit of plate armor. It is so heavy one cannot be pushed down while inside it. It menaces with jagged spikes."
		return
	if(prob(75))
		item_state = "crude_armor"
		icon_state = "crude_armor"
		new /obj/item/clothing/head/helmet/plate_armor/crude(src.loc)
		desc = "A suit of plate armor. It is so heavy one cannot be pushed down while inside it. This one is crap."
		armor = list("melee" = 30, "bullet" = 10, "laser" = -15, "energy" = -15, "bomb" = 0, "bio" = 15, "rad" = 10, "fire" = -15, "acid" = 50) //this is a low quality plate armor
		return
	item_state = "plate_armor"
	icon_state = "plate_armor"
	new /obj/item/clothing/head/helmet/plate_armor(src.loc)
	armor = list("melee" = 40, "bullet" = 20, "laser" = -10, "energy" = -10, "bomb" = 15, "bio" = 25, "rad" = 20, "fire" = -15, "acid" = 80) //this is a +plate armor+
	return

/obj/item/clothing/suit/armor/plate_armor/steel/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/suit/armor/plate_armor/steel/attackby(obj/item/I, mob/user, params)
	..()
	if((istype(I, /obj/item/stack/sheet/cloth)) && (src != padded))
		I.use(10)
		to_chat(user, "You pad the insides of the [src] with [I].")
		src.padded = TRUE
		src.desc += " This one is padded, and thus it is easier to move comfortably while wearing it."
		src.slowdown = 0.1
	else
		to_chat(user, "[src] is already padded")

/obj/item/clothing/suit/armor/plate_armor/steel/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!spikey)
		return 0
	if(attack_type == PROJECTILE_ATTACK)
		return 0
	var/mob/living/carbon/human/H = owner
	if(H.gloves)
		owner.visible_message("<span class='danger'>[hitby] successfully attacked [owner], his gloves protecting him from the spikes of [src]!</span>")
		return 0
	owner.visible_message("<span class='danger'>[hitby] gets visibly wounded by punching [owner]'s [src]!</span>")
	return 1

/obj/item/clothing/head/helmet/plate_armor
	name = "plate armor helm"
	desc = "A solid helm of metal. It is exceedingly heavy and makes your neck ache."
	icon = 'hippiestation/icons/obj/clothing/hats.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/head.dmi'
	icon_state = "metal_helmet"
	item_state = "metal_helmet"
	armor = list("melee" = 40, "bullet" = 15, "laser" = -10,"energy" = -10, "bomb" = 15, "bio" = 25, "rad" = 20, "fire" = -15, "acid" = 80)
	resistance_flags = ACID_PROOF
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	clothing_flags = THICKMATERIAL

/obj/item/clothing/head/helmet/plate_armor/crude
	icon_state = "crude_armor_helmet"
	item_state = "crude_armor_helmet"
	armor = list("melee" = 30, "bullet" = 10, "laser" = -15,"energy" = -15, "bomb" = 10, "bio" = 15, "rad" = 10, "fire" = -15, "acid" = 40)
	desc = "A helm of metal. It is exceedingly heavy and makes your neck ache. This one is crap."

/obj/item/clothing/head/helmet/plate_armor/spikey
	icon_state = "plate_armor_helmet_spikey"
	item_state = "plate_armor_helmet_spikey"
	armor = list("melee" = 40, "bullet" = 10, "laser" = -10,"energy" = -20, "bomb" = 10, "bio" = 25, "rad" = 20, "fire" = -15, "acid" = 80)
	desc = "A solid helm of metal. It is exceedingly heavy and makes your neck ache. It menaces with jagged spikes."

/obj/item/clothing/head/helmet/plate_armor/Initialize()
	. = ..()
	AddComponent(/datum/component/spraycan_paintable)
	START_PROCESSING(SSobj, src)

/obj/item/clothing/head/helmet/plate_armor/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/suit/armor/plate_armor/plasteel
	name = "plasteel plate armor"
	desc = "A suit of plasteel plate armor, it menaces with spikes of light-gray."
	icon = 'hippiestation/icons/obj/clothing/suits.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/suit.dmi'
	item_state = "plate_armor_plasteel"
	icon_state = "plate_armor_plasteel"
	armor = list("melee" = 50, "bullet" = 25, "laser" = 5, "energy" = 5, "bomb" = 25, "bio" = 25, "rad" = 30, "fire" = 10, "acid" = 80)
	blocks_shove_knockdown = TRUE
	strip_delay = 80
	equip_delay_other = 60
	slowdown = 0.6
	var padded = FALSE

/obj/item/clothing/suit/armor/plate_armor/plasteel/attackby(obj/item/I, mob/user, params)
	..()
	if((istype(I, /obj/item/stack/sheet/cloth)) && (src != padded))
		I.use(10)
		to_chat(user, "You pad the insides of the [src] with [I].")
		src.padded = TRUE
		src.desc += " This one is padded, and thus it is easier to move comfortably while wearing it."
		src.slowdown = 0.1
	else
		to_chat(user, "[src] is already padded")

/obj/item/clothing/suit/armor/plate_armor/plasteel/Initialize()
	. = ..()
	AddComponent(/datum/component/spraycan_paintable)
	START_PROCESSING(SSobj, src)
	if(prob(10))
		desc = "A thick suit of plasteel plate armor, it menaces with spikes of light-gray. This one looks very robust"
		item_state = "juggernaut_armor"
		icon_state = "juggernaut_armor"
		new /obj/item/clothing/head/helmet/plate_armor/plasteel/juggernaut(src.loc)
			armor = list("melee" = 65, "bullet" = 35, "laser" = 20, "energy" = 20, "bomb" = 25, "bio" = 25, "rad" = 30, "fire" = 20, "acid" = 80)
	else
		new /obj/item/clothing/head/helmet/plate_armor/plasteel(src.loc)

/obj/item/clothing/head/helmet/plate_armor/plasteel
	name = "plasteel plate armor helm"
	desc = "A solid helm of plasteel. It is exceedingly heavy and makes your neck ache."
	icon = 'hippiestation/icons/obj/clothing/hats.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/head.dmi'
	icon_state = "plasteel_helmet"
	item_state = "plasteel_helmet"
	armor = list("melee" = 50, "bullet" = 25, "laser" = 5,"energy" = 5, "bomb" = 25, "bio" = 25, "rad" = 30, "fire" = 10, "acid" = 80)

/obj/item/clothing/head/helmet/plate_armor/plasteel/juggernaut
	desc = "A solid helm of plasteel. It is exceedingly heavy and makes your neck ache. This one looks very robust."
	icon_state = "juggernaut_armor_helmet"
	item_state = "juggernaut_armor_helmet"
	armor = list("melee" = 65, "bullet" = 35, "laser" = 20,"energy" = 20, "bomb" = 25, "bio" = 25, "rad" = 30, "fire" = 20, "acid" = 80)

/**********************************         **********************************/
/********************************** Recipes **********************************/
/**********************************         **********************************/

/datum/crafting_recipe/plate_armor
	name = "plate armor"
	result =  /obj/item/clothing/suit/armor/plate_armor/steel
	reqs = list(/obj/item/stack/sheet/metal = 50,
				/obj/item/weldingtool)
	time = 30 //time gating is a shit concept
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/plate_armor_plasteel
	name = "plasteel plate armor"
	result =  /obj/item/clothing/suit/armor/plate_armor/plasteel
	reqs = list(/obj/item/stack/sheet/plasteel = 50,
				/obj/item/weldingtool)
	time = 60
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON