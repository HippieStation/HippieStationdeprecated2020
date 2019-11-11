/obj/item/blastco_spawner
	name = "BlastCo beacon"
	desc = "Summons a BlastCo(tm) equipment drop onto your location."
	icon = 'icons/obj/device.dmi'
	icon_state = "gangtool-red"
	item_state = "radio"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	var/used = FALSE

/obj/item/blastco_spawner/attack_hand(mob/user)
	if(!user || !user.mind || !user.mind.has_antag_datum(/datum/antagonist/nukeop))
		to_chat(user, "<span class='danger'>Access denied.</span>")
		return
	var/choice = input(user, "Choose your BlastCo(tm) loadout!", "Choose your BlastCo(tm) loadout!") as anything in list("BlastCo(tm) RUSH B", "BlastCo(tm) BALANCED", "BlastCo(tm) WAR CRIMINAL", "BlastCo(tm) PYRO", "BlastCo(tm) EXPLOSIVE")
	if(!choice)
		to_chat(user, "<span class='notice'>Ah, waiting to choose?</span>")
		return
	if(QDELETED(src) || used)
		return
	switch(choice)
		if("BlastCo(tm) RUSH B") // this is just the "run in and kill everyone in your way" loadout
			send_loadout(user, list(
				/obj/item/clothing/under/syndicate/soviet,
				/obj/item/storage/belt/military,
				/obj/item/gun/ballistic/revolver/grenadelauncher/mgl,
				/obj/item/gun/ballistic/automatic/m90,
				/obj/item/ammo_casing/a40mm,
				/obj/item/ammo_casing/a40mm,
				/obj/item/ammo_casing/a40mm,
				/obj/item/ammo_casing/a40mm,
				/obj/item/ammo_casing/a40mm,
				/obj/item/ammo_casing/a40mm,
				/obj/item/ammo_casing/a40mm,
				/obj/item/ammo_casing/a40mm,
				/obj/item/ammo_casing/a40mm,
				/obj/item/ammo_box/magazine/m556,
				/obj/item/ammo_box/magazine/m556,
				/obj/item/ammo_box/magazine/m556,
				/obj/item/ammo_box/magazine/m556,
				/obj/item/ammo_box/magazine/m556,
				/obj/item/ammo_box/magazine/m556,
				/obj/item/card/emag,
				/obj/item/sbeacondrop/bomb,
				/obj/item/grenade/spawnergrenade/manhacks,
				/obj/item/grenade/spawnergrenade/manhacks))
		if("BlastCo(tm) BALANCED") // equal offense and defense, i guess
			send_loadout(user, list(
				/obj/item/gun/ballistic/automatic/c20r,
				/obj/item/storage/backpack/duffelbag/syndie/ammo/smg,
				/obj/item/shield/energy,
				/obj/item/melee/transforming/energy/sword/saber,
				/obj/item/storage/backpack/duffelbag/syndie/c4,
				/obj/item/grenade/clusterbuster/soap,
				/obj/item/grenade/clusterbuster/soap,
				/obj/item/clothing/shoes/chameleon/noslip,
				/obj/item/autosurgeon/anti_stun,
				/obj/item/autosurgeon/reviver
			))
		if("BlastCo(tm) WAR CRIMINAL") // lmao
			send_loadout(user, list(
				/obj/item/twohanded/required/chainsaw/energy,
				/obj/item/reagent_containers/spray/chemsprayer/bioterror,
				/obj/item/gun/energy/kinetic_accelerator/crossbow,
				/obj/item/storage/belt/grenade/full,
				/obj/item/storage/box/syndie_kit/tuberculosisgrenade,
				/obj/item/grenade/chem_grenade/bioterrorfoam,
				/obj/item/grenade/chem_grenade/bioterrorfoam,
				/obj/item/grenade/chem_grenade/bioterrorfoam
			))
		if("BlastCo(tm) PYRO") // https://www.youtube.com/watch?v=WUhOnX8qt3I
			send_loadout(user, list(
				/obj/item/watertank/op,
				/obj/item/flamethrower/full/tank,
				/obj/item/grenade/syndieminibomb,
				/obj/item/grenade/syndieminibomb,
				/obj/item/grenade/syndieminibomb,
				/obj/item/gun/ballistic/automatic/pistol/APS,
				/obj/item/ammo_box/magazine/pistolm9mm,
				/obj/item/ammo_box/magazine/pistolm9mm,
				/obj/item/ammo_box/magazine/pistolm9mm
			))
		if("BlastCo(tm) EXPLOSIVE")
			send_loadout(user, list(
				/obj/item/implanter/explosive_macro,
				/obj/item/gun/ballistic/rocketlauncher,
				/obj/item/storage/belt/military,
				/obj/item/ammo_casing/caseless/rocket/hedp,
				/obj/item/ammo_casing/caseless/rocket/hedp,
				/obj/item/ammo_casing/caseless/rocket/hedp,
				/obj/item/ammo_casing/caseless/rocket/hedp,
				/obj/item/ammo_casing/caseless/rocket/hedp,
				/obj/item/ammo_casing/caseless/rocket/hedp,
				/obj/item/ammo_casing/caseless/rocket/hedp,
				/obj/item/ammo_casing/caseless/rocket/hedp,
				/obj/item/ammo_casing/caseless/rocket/hedp,
				/obj/item/ammo_casing/caseless/rocket/hedp,
				/obj/item/ammo_casing/caseless/rocket/hedp,
				/obj/item/ammo_casing/caseless/rocket/hedp,
				/obj/item/ammo_casing/caseless/rocket/hedp,
				/obj/item/ammo_casing/caseless/rocket/hedp,
				/obj/item/ammo_casing/caseless/rocket/hedp,
				/obj/item/ammo_casing/caseless/rocket/hedp,
				/obj/item/grenade/syndieminibomb,
				/obj/item/grenade/syndieminibomb,
				/obj/item/grenade/syndieminibomb,
				/obj/item/grenade/syndieminibomb,
				/obj/item/sbeacondrop/bomb,
				/obj/item/sbeacondrop/bomb,
				/obj/item/sbeacondrop/bomb,
				/obj/item/syndicatedetonator
			))

/obj/item/blastco_spawner/proc/send_loadout(mob/user, list/items)
	used = TRUE
	to_chat(user, "<span class='notice bold'>Supply pod inbound, please wait.</span>")
	var/obj/structure/closet/supplypod/amazonprime = new
	amazonprime.departureDelay = 10 SECONDS
	amazonprime.setStyle(STYLE_SYNDICATE)
	amazonprime.explosionSize = list(0,0,0,0)
	new /obj/item/clothing/suit/space/hardsuit/syndi/elite/blastco(amazonprime)
	new /obj/item/clothing/shoes/blastco(amazonprime)
	new /obj/item/clothing/mask/gas/syndicate(amazonprime)
	for(var/itemtype in items)
		new itemtype(amazonprime)
	new /obj/effect/DPtarget(get_turf(user), amazonprime)
	qdel(src)
