/datum/outfit/av_hulk
	name = "Hulk"

	uniform = /obj/item/clothing/under/shorts/purple
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/headset_cent/alt
	back = /obj/item/storage/backpack/ert
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	id = /obj/item/card/id/ert

/datum/outfit/av_hulk/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return
	H.fully_replace_character_name(null, "Hulk")
	if(H.dna)
		H.dna.add_mutation(/datum/mutation/human/hulk/avenger)

/datum/outfit/av_nano
	name = "Nano Guy"

	suit =  /obj/item/clothing/suit/space/hardsuit/nano
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/headset_cent/alt
	back = /obj/item/storage/backpack/ert
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	id = /obj/item/card/id/ert

/datum/outfit/av_nano/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return
	var/obj/item/organ/cyberimp/arm/gun/laser/laser_arm = new
	laser_arm.Insert(H)
	H.fully_replace_character_name(null, "Nano Guy")

/datum/outfit/av_cap
	name = "Captain Nanotrasen"

	uniform = /obj/item/clothing/under/rank/centcom_officer
	shoes = /obj/item/clothing/shoes/combat/swat
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/headset_cent/alt
	l_pocket = /obj/item/shield/energy/bananium
	back = /obj/item/storage/backpack/ert
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	id = /obj/item/card/id/ert

/datum/outfit/av_cap/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return
	var/datum/martial_art/cqc/cqc = new
	cqc.teach(H)
	H.fully_replace_character_name(null, "Captain Nanotrasen")

/datum/outfit/av_thor
	name = "Thor"
	uniform = /obj/item/clothing/under/rank/centcom_officer
	shoes = /obj/item/clothing/shoes/combat/swat
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/headset_cent/alt
	back = /obj/item/storage/backpack/ert
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	id = /obj/item/card/id/ert

/datum/outfit/av_thor/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return
	H.fully_replace_character_name(null, "Thor")
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
	H.mind.spell_list += summon_mj
	summon_mj.action.Grant(H)
