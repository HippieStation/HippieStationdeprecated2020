/datum/outfit/wizard
	l_hand = /obj/item/gun/magic/staff
	backpack_contents = list(/obj/item/storage/box/survival=1)

/datum/outfit/wizard/apprentice
	l_hand = /obj/item/gun/magic/staff
	backpack_contents = list(/obj/item/storage/box/survival=1)

/datum/outfit/death_commando
	r_pocket = /obj/item/shield/energy/deathsquad
	implants = list(/obj/item/implant/explosive/macro/deathsquad)
	
/datum/outfit/death_commando/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	H.set_species(/datum/species/corporate)
	. = ..()
	var/obj/item/organ/cyberimp/brain/anti_drop/nodrop_imp = new/obj/item/organ/cyberimp/brain/anti_drop(H)
	nodrop_imp.Insert(H)
	var/obj/item/organ/cyberimp/brain/anti_stun/cns_imp = new/obj/item/organ/cyberimp/brain/anti_stun(H)
	cns_imp.stun_cap_amount = 20
	cns_imp.Insert(H)
	var/datum/martial_art/elite_cqc/cqc = new/datum/martial_art/elite_cqc()
	cqc.teach(H)
	to_chat(H, "<span class='boldannounce'>You know Elite CQC. Make sure you use it.</span>")