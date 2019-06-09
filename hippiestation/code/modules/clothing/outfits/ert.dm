/datum/outfit/avenger
	name = "Avenger"
	uniform = /obj/item/clothing/under/syndicate/tacticool
	shoes = /obj/item/clothing/shoes/combat/swat
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/headset_cent/alt
	back = /obj/item/storage/backpack/ert
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	id = /obj/item/card/id/ert
	r_pocket = /obj/item/reagent_containers/hypospray/combat

/datum/outfit/avenger/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return
	if(name)
		H.fully_replace_character_name(null, name)
	var/obj/item/card/id/W = H.wear_id
	W.icon_state = "centcom"
	W.access = get_ert_access("commander")
	W.assignment = "Avenger"
	W.registered_name = H.real_name
	W.update_label()
	H.apply_status_effect(/datum/status_effect/agent_pinpointer/avenger)
	H.flags_1 |= TESLA_IGNORE_1 // just so they don't get lightning blasted by Thor

/datum/outfit/avenger/hulk
	name = "Hulk"
	uniform = /obj/item/clothing/under/shorts/purple

/datum/outfit/avenger/hulk/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return
	if(H.dna)
		H.dna.add_mutation(/datum/mutation/human/hulk/avenger)
	var/datum/martial_art/wrestling/wrestling = new
	wrestling.teach(H)

/datum/outfit/avenger/nano
	name = "Nano Guy"
	suit = /obj/item/clothing/suit/space/hardsuit/nano/nanoguy

/datum/outfit/avenger/nano/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return
	var/obj/item/organ/cyberimp/chest/reviver/reviver = new
	reviver.Insert(H)
	var/obj/item/organ/cyberimp/brain/anti_stun/cns = new
	cns.Insert(H)
	var/obj/item/organ/cyberimp/arm/nanoguy/nano_r = new
	nano_r.Insert(H)
	var/obj/item/organ/cyberimp/arm/nanoguy/l/nano_l = new
	nano_l.Insert(H)

/datum/outfit/avenger/captain
	name = "Captain Nanotrasen"
	l_pocket = /obj/item/shield/energy/bananium

/datum/outfit/avenger/captain/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return
	H.worthiness = 1
	var/datum/martial_art/cqc/cqc = new
	cqc.teach(H)

/datum/outfit/avenger/thor
	name = "Thor"

/datum/outfit/avenger/thor/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return
	H.worthiness = 100
	if(prob(50))
		var/obj/item/reagent_containers/food/drinks/beer/beer = new(get_turf(H))
		H.put_in_hands(beer)
		H.nutrition = NUTRITION_LEVEL_FAT // lmao
	var/obj/item/twohanded/mjollnir/MJ = new(get_turf(H))
	H.put_in_hands(MJ)

	var/obj/effect/proc_holder/spell/targeted/summonitem/summon_mj = new
	summon_mj.charge_max = 0
	summon_mj.marked_item = MJ
	summon_mj.name = "Recall [MJ]"
	H.mind.AddSpell(summon_mj)

	var/obj/effect/proc_holder/spell/aimed/lightningbolt/lightning = new
	lightning.clothes_req = FALSE
	H.mind.AddSpell(lightning)
