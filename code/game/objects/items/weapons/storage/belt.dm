<<<<<<< HEAD
/obj/item/storage/belt
=======
/obj/item/weapon/storage/belt
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "belt"
	desc = "Can hold various things."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "utilitybelt"
	item_state = "utility"
	slot_flags = SLOT_BELT
	attack_verb = list("whipped", "lashed", "disciplined")
	max_integrity = 300
	var/content_overlays = FALSE //If this is true, the belt will gain overlays based on what it's holding

<<<<<<< HEAD
/obj/item/storage/belt/update_icon()
=======
/obj/item/weapon/storage/belt/update_icon()
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	cut_overlays()
	if(content_overlays)
		for(var/obj/item/I in contents)
			var/mutable_appearance/M = I.get_belt_overlay()
			add_overlay(M)
	..()

<<<<<<< HEAD
/obj/item/storage/belt/Initialize()
	. = ..()
	update_icon()

/obj/item/storage/belt/utility
=======
/obj/item/weapon/storage/belt/Initialize()
	. = ..()
	update_icon()

/obj/item/weapon/storage/belt/utility
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "toolbelt" //Carn: utility belt is nicer, but it bamboozles the text parsing.
	desc = "Holds tools."
	icon_state = "utilitybelt"
	item_state = "utility"
	can_hold = list(
<<<<<<< HEAD
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
=======
		/obj/item/weapon/crowbar,
		/obj/item/weapon/screwdriver,
		/obj/item/weapon/weldingtool,
		/obj/item/weapon/wirecutters,
		/obj/item/weapon/wrench,
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
		/obj/item/device/multitool,
		/obj/item/device/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/device/t_scanner,
		/obj/item/device/analyzer,
<<<<<<< HEAD
		/obj/item/extinguisher/mini,
=======
		/obj/item/weapon/extinguisher/mini,
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
		/obj/item/device/radio,
		/obj/item/clothing/gloves
		)
	content_overlays = TRUE

<<<<<<< HEAD
/obj/item/storage/belt/utility/chief
=======
/obj/item/weapon/storage/belt/utility/chief
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "\improper Chief Engineer's toolbelt" //"the Chief Engineer's toolbelt", because "Chief Engineer's toolbelt" is not a proper noun
	desc = "Holds tools, looks snazzy."
	icon_state = "utilitybelt_ce"
	item_state = "utility_ce"

<<<<<<< HEAD
/obj/item/storage/belt/utility/chief/full/PopulateContents()
	new /obj/item/screwdriver/power(src)
	new /obj/item/crowbar/power(src)
	new /obj/item/weldingtool/experimental(src)//This can be changed if this is too much
	new /obj/item/device/multitool(src)
	new /obj/item/stack/cable_coil(src,30,pick("red","yellow","orange"))
	new /obj/item/extinguisher/mini(src)
=======
/obj/item/weapon/storage/belt/utility/chief/full/PopulateContents()
	new /obj/item/weapon/screwdriver/power(src)
	new /obj/item/weapon/crowbar/power(src)
	new /obj/item/weapon/weldingtool/experimental(src)//This can be changed if this is too much
	new /obj/item/device/multitool(src)
	new /obj/item/stack/cable_coil(src,30,pick("red","yellow","orange"))
	new /obj/item/weapon/extinguisher/mini(src)
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	new /obj/item/device/analyzer(src)
	//much roomier now that we've managed to remove two tools


<<<<<<< HEAD
/obj/item/storage/belt/utility/full/PopulateContents()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/wirecutters(src)
	new /obj/item/device/multitool(src)
	new /obj/item/stack/cable_coil(src,30,pick("red","yellow","orange"))

/obj/item/storage/belt/utility/full/engi/PopulateContents()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool/largetank(src)
	new /obj/item/crowbar(src)
	new /obj/item/wirecutters(src)
=======
/obj/item/weapon/storage/belt/utility/full/PopulateContents()
	new /obj/item/weapon/screwdriver(src)
	new /obj/item/weapon/wrench(src)
	new /obj/item/weapon/weldingtool(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/weapon/wirecutters(src)
	new /obj/item/device/multitool(src)
	new /obj/item/stack/cable_coil(src,30,pick("red","yellow","orange"))

/obj/item/weapon/storage/belt/utility/full/engi/PopulateContents()
	new /obj/item/weapon/screwdriver(src)
	new /obj/item/weapon/wrench(src)
	new /obj/item/weapon/weldingtool/largetank(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/weapon/wirecutters(src)
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	new /obj/item/device/multitool(src)
	new /obj/item/stack/cable_coil(src,30,pick("red","yellow","orange"))


<<<<<<< HEAD
/obj/item/storage/belt/utility/atmostech/PopulateContents()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/wirecutters(src)
	new /obj/item/device/t_scanner(src)
	new /obj/item/extinguisher/mini(src)



/obj/item/storage/belt/medical
=======
/obj/item/weapon/storage/belt/utility/atmostech/PopulateContents()
	new /obj/item/weapon/screwdriver(src)
	new /obj/item/weapon/wrench(src)
	new /obj/item/weapon/weldingtool(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/weapon/wirecutters(src)
	new /obj/item/device/t_scanner(src)
	new /obj/item/weapon/extinguisher/mini(src)


/obj/item/weapon/storage/belt/utility/servant/PopulateContents()
	new /obj/item/weapon/screwdriver/brass(src)
	new /obj/item/weapon/wirecutters/brass(src)
	new /obj/item/weapon/wrench/brass(src)
	new /obj/item/weapon/crowbar/brass(src)
	new /obj/item/weapon/weldingtool/experimental/brass(src)
	new /obj/item/device/multitool(src)
	new /obj/item/stack/cable_coil(src, 30, "yellow")


/obj/item/weapon/storage/belt/medical
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "medical belt"
	desc = "Can hold various medical equipment."
	icon_state = "medicalbelt"
	item_state = "medical"
	max_w_class = WEIGHT_CLASS_BULKY
	can_hold = list(
		/obj/item/device/healthanalyzer,
<<<<<<< HEAD
		/obj/item/dnainjector,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/lighter,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/device/flashlight/pen,
		/obj/item/extinguisher/mini,
		/obj/item/reagent_containers/hypospray,
		/obj/item/device/sensor_device,
		/obj/item/device/radio,
		/obj/item/clothing/gloves/,
		/obj/item/lazarus_injector,
		/obj/item/bikehorn/rubberducky,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/mask/breath,
		/obj/item/clothing/mask/breath/medical,
		/obj/item/surgical_drapes, //for true paramedics
		/obj/item/scalpel,
		/obj/item/circular_saw,
		/obj/item/surgicaldrill,
		/obj/item/retractor,
		/obj/item/cautery,
		/obj/item/hemostat,
		/obj/item/device/geiger_counter,
		/obj/item/clothing/neck/stethoscope,
		/obj/item/stamp,
		/obj/item/clothing/glasses,
		/obj/item/wrench/medical,
		/obj/item/clothing/mask/muzzle,
		/obj/item/storage/bag/chemistry,
		/obj/item/storage/bag/bio,
		/obj/item/reagent_containers/blood,
		/obj/item/tank/internals/emergency_oxygen
		)


/obj/item/storage/belt/security
=======
		/obj/item/weapon/dnainjector,
		/obj/item/weapon/reagent_containers/dropper,
		/obj/item/weapon/reagent_containers/glass/beaker,
		/obj/item/weapon/reagent_containers/glass/bottle,
		/obj/item/weapon/reagent_containers/pill,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/lighter,
		/obj/item/weapon/storage/fancy/cigarettes,
		/obj/item/weapon/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/device/flashlight/pen,
		/obj/item/weapon/extinguisher/mini,
		/obj/item/weapon/reagent_containers/hypospray,
		/obj/item/device/sensor_device,
		/obj/item/device/radio,
		/obj/item/clothing/gloves/,
		/obj/item/weapon/lazarus_injector,
		/obj/item/weapon/bikehorn/rubberducky,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/mask/breath,
		/obj/item/clothing/mask/breath/medical,
		/obj/item/weapon/surgical_drapes, //for true paramedics
		/obj/item/weapon/scalpel,
		/obj/item/weapon/circular_saw,
		/obj/item/weapon/surgicaldrill,
		/obj/item/weapon/retractor,
		/obj/item/weapon/cautery,
		/obj/item/weapon/hemostat,
		/obj/item/device/geiger_counter,
		/obj/item/clothing/neck/stethoscope,
		/obj/item/weapon/stamp,
		/obj/item/clothing/glasses,
		/obj/item/weapon/wrench/medical,
		/obj/item/clothing/mask/muzzle,
		/obj/item/weapon/storage/bag/chemistry,
		/obj/item/weapon/storage/bag/bio,
		/obj/item/weapon/reagent_containers/blood,
		/obj/item/weapon/tank/internals/emergency_oxygen
		)


/obj/item/weapon/storage/belt/security
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "security belt"
	desc = "Can hold security gear like handcuffs and flashes."
	icon_state = "securitybelt"
	item_state = "security"//Could likely use a better one.
	storage_slots = 5
	max_w_class = WEIGHT_CLASS_NORMAL //Because the baton wouldn't fit otherwise. - Neerti
	can_hold = list(
<<<<<<< HEAD
		/obj/item/melee/baton,
		/obj/item/melee/classic_baton,
		/obj/item/grenade,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/restraints/handcuffs,
=======
		/obj/item/weapon/melee/baton,
		/obj/item/weapon/melee/classic_baton,
		/obj/item/weapon/grenade,
		/obj/item/weapon/reagent_containers/spray/pepper,
		/obj/item/weapon/restraints/handcuffs,
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
		/obj/item/device/assembly/flash/handheld,
		/obj/item/clothing/glasses,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_box,
<<<<<<< HEAD
		/obj/item/reagent_containers/food/snacks/donut,
		/obj/item/reagent_containers/food/snacks/donut/jelly,
		/obj/item/kitchen/knife/combat,
		/obj/item/device/flashlight/seclite,
		/obj/item/melee/classic_baton/telescopic,
		/obj/item/device/radio,
		/obj/item/clothing/gloves/,
		/obj/item/restraints/legcuffs/bola
		)
	content_overlays = TRUE

/obj/item/storage/belt/security/full/PopulateContents()
	new /obj/item/reagent_containers/spray/pepper(src)
	new /obj/item/restraints/handcuffs(src)
	new /obj/item/grenade/flashbang(src)
	new /obj/item/device/assembly/flash/handheld(src)
	new /obj/item/melee/baton/loaded(src)
	update_icon()


/obj/item/storage/belt/mining
=======
		/obj/item/weapon/reagent_containers/food/snacks/donut,
		/obj/item/weapon/reagent_containers/food/snacks/donut/jelly,
		/obj/item/weapon/kitchen/knife/combat,
		/obj/item/device/flashlight/seclite,
		/obj/item/weapon/melee/classic_baton/telescopic,
		/obj/item/device/radio,
		/obj/item/clothing/gloves/,
		/obj/item/weapon/restraints/legcuffs/bola
		)
	content_overlays = TRUE

/obj/item/weapon/storage/belt/security/full/PopulateContents()
	new /obj/item/weapon/reagent_containers/spray/pepper(src)
	new /obj/item/weapon/restraints/handcuffs(src)
	new /obj/item/weapon/grenade/flashbang(src)
	new /obj/item/device/assembly/flash/handheld(src)
	new /obj/item/weapon/melee/baton/loaded(src)
	update_icon()


/obj/item/weapon/storage/belt/mining
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "explorer's webbing"
	desc = "A versatile chest rig, cherished by miners and hunters alike."
	icon_state = "explorer1"
	item_state = "explorer1"
	storage_slots = 6
	w_class = WEIGHT_CLASS_BULKY
	max_w_class = WEIGHT_CLASS_BULKY //Pickaxes are big.
	max_combined_w_class = 20 //Not an issue with this whitelist, probably.
	can_hold = list(
<<<<<<< HEAD
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/device/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/device/analyzer,
		/obj/item/extinguisher/mini,
		/obj/item/device/radio,
		/obj/item/clothing/gloves,
		/obj/item/resonator,
		/obj/item/device/mining_scanner,
		/obj/item/pickaxe,
		/obj/item/stack/sheet/animalhide,
		/obj/item/stack/sheet/sinew,
		/obj/item/stack/sheet/bone,
		/obj/item/lighter,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/reagent_containers/food/drinks/bottle,
		/obj/item/stack/medical,
		/obj/item/kitchen/knife,
		/obj/item/reagent_containers/hypospray,
		/obj/item/device/gps,
		/obj/item/storage/bag/ore,
		/obj/item/survivalcapsule,
		/obj/item/device/t_scanner/adv_mining_scanner,
		/obj/item/reagent_containers/pill,
		/obj/item/storage/pill_bottle,
		/obj/item/ore,
		/obj/item/reagent_containers/food/drinks,
		/obj/item/organ/regenerative_core,
		/obj/item/device/wormhole_jaunter,
		/obj/item/storage/bag/plants,
=======
		/obj/item/weapon/crowbar,
		/obj/item/weapon/screwdriver,
		/obj/item/weapon/weldingtool,
		/obj/item/weapon/wirecutters,
		/obj/item/weapon/wrench,
		/obj/item/device/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/device/analyzer,
		/obj/item/weapon/extinguisher/mini,
		/obj/item/device/radio,
		/obj/item/clothing/gloves,
		/obj/item/weapon/resonator,
		/obj/item/device/mining_scanner,
		/obj/item/weapon/pickaxe,
		/obj/item/stack/sheet/animalhide,
		/obj/item/stack/sheet/sinew,
		/obj/item/stack/sheet/bone,
		/obj/item/weapon/lighter,
		/obj/item/weapon/storage/fancy/cigarettes,
		/obj/item/weapon/reagent_containers/food/drinks/bottle,
		/obj/item/stack/medical,
		/obj/item/weapon/kitchen/knife,
		/obj/item/weapon/reagent_containers/hypospray,
		/obj/item/device/gps,
		/obj/item/weapon/storage/bag/ore,
		/obj/item/weapon/survivalcapsule,
		/obj/item/device/t_scanner/adv_mining_scanner,
		/obj/item/weapon/reagent_containers/pill,
		/obj/item/weapon/storage/pill_bottle,
		/obj/item/weapon/ore,
		/obj/item/weapon/reagent_containers/food/drinks,
		/obj/item/organ/regenerative_core,
		/obj/item/device/wormhole_jaunter,
		/obj/item/weapon/storage/bag/plants,
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
		/obj/item/stack/marker_beacon
		)


<<<<<<< HEAD
/obj/item/storage/belt/mining/vendor
	contents = newlist(/obj/item/survivalcapsule)

/obj/item/storage/belt/mining/alt
	icon_state = "explorer2"
	item_state = "explorer2"

/obj/item/storage/belt/mining/primitive
=======
/obj/item/weapon/storage/belt/mining/vendor
	contents = newlist(/obj/item/weapon/survivalcapsule)

/obj/item/weapon/storage/belt/mining/alt
	icon_state = "explorer2"
	item_state = "explorer2"

/obj/item/weapon/storage/belt/mining/primitive
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "hunter's belt"
	desc = "A versatile belt, woven from sinew."
	storage_slots = 5
	icon_state = "ebelt"
	item_state = "ebelt"

<<<<<<< HEAD
/obj/item/storage/belt/soulstone
=======
/obj/item/weapon/storage/belt/soulstone
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "soul stone belt"
	desc = "Designed for ease of access to the shards during a fight, as to not let a single enemy spirit slip away"
	icon_state = "soulstonebelt"
	item_state = "soulstonebelt"
	storage_slots = 6
	can_hold = list(
		/obj/item/device/soulstone
		)

<<<<<<< HEAD
/obj/item/storage/belt/soulstone/full/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/device/soulstone(src)

/obj/item/storage/belt/champion
=======
/obj/item/weapon/storage/belt/soulstone/full/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/device/soulstone(src)

/obj/item/weapon/storage/belt/champion
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "championship belt"
	desc = "Proves to the world that you are the strongest!"
	icon_state = "championbelt"
	item_state = "champion"
	materials = list(MAT_GOLD=400)
	storage_slots = 1
	can_hold = list(
		/obj/item/clothing/mask/luchador
		)

<<<<<<< HEAD
/obj/item/storage/belt/military
=======
/obj/item/weapon/storage/belt/military
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "chest rig"
	desc = "A set of tactical webbing worn by Syndicate boarding parties."
	icon_state = "militarywebbing"
	item_state = "militarywebbing"
	max_w_class = WEIGHT_CLASS_SMALL

<<<<<<< HEAD
/obj/item/storage/belt/military/abductor
=======
/obj/item/weapon/storage/belt/military/abductor
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "agent belt"
	desc = "A belt used by abductor agents."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "belt"
	item_state = "security"

<<<<<<< HEAD
/obj/item/storage/belt/military/abductor/full/PopulateContents()
	new /obj/item/screwdriver/abductor(src)
	new /obj/item/wrench/abductor(src)
	new /obj/item/weldingtool/abductor(src)
	new /obj/item/crowbar/abductor(src)
	new /obj/item/wirecutters/abductor(src)
=======
/obj/item/weapon/storage/belt/military/abductor/full/PopulateContents()
	new /obj/item/weapon/screwdriver/abductor(src)
	new /obj/item/weapon/wrench/abductor(src)
	new /obj/item/weapon/weldingtool/abductor(src)
	new /obj/item/weapon/crowbar/abductor(src)
	new /obj/item/weapon/wirecutters/abductor(src)
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	new /obj/item/device/multitool/abductor(src)
	new /obj/item/stack/cable_coil(src,30,"white")


<<<<<<< HEAD
/obj/item/storage/belt/military/army
=======
/obj/item/weapon/storage/belt/military/army
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "army belt"
	desc = "A belt used by military forces."
	icon_state = "grenadebeltold"
	item_state = "security"

<<<<<<< HEAD
/obj/item/storage/belt/military/assault
=======
/obj/item/weapon/storage/belt/military/assault
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "assault belt"
	desc = "A tactical assault belt."
	icon_state = "assaultbelt"
	item_state = "security"
	storage_slots = 6

<<<<<<< HEAD
/obj/item/storage/belt/grenade
=======
/obj/item/weapon/storage/belt/grenade
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "grenadier belt"
	desc = "A belt for holding grenades."
	icon_state = "grenadebeltnew"
	item_state = "security"
	max_w_class = WEIGHT_CLASS_BULKY
	display_contents_with_number = TRUE
	storage_slots = 30
	max_combined_w_class = 60 //needs to be this high
	can_hold = list(
<<<<<<< HEAD
		/obj/item/grenade,
		/obj/item/screwdriver,
		/obj/item/lighter,
		/obj/item/device/multitool,
		/obj/item/reagent_containers/food/drinks/bottle/molotov,
		/obj/item/grenade/plastic/c4,
		)
/obj/item/storage/belt/grenade/full/PopulateContents()
	new /obj/item/grenade/flashbang(src)
	new /obj/item/grenade/smokebomb(src)
	new /obj/item/grenade/smokebomb(src)
	new /obj/item/grenade/smokebomb(src)
	new /obj/item/grenade/smokebomb(src)
	new /obj/item/grenade/empgrenade(src)
	new /obj/item/grenade/empgrenade(src)
	new /obj/item/grenade/syndieminibomb/concussion/frag(src)
	new /obj/item/grenade/syndieminibomb/concussion/frag(src)
	new /obj/item/grenade/syndieminibomb/concussion/frag(src)
	new /obj/item/grenade/syndieminibomb/concussion/frag(src)
	new /obj/item/grenade/syndieminibomb/concussion/frag(src)
	new /obj/item/grenade/syndieminibomb/concussion/frag(src)
	new /obj/item/grenade/syndieminibomb/concussion/frag(src)
	new /obj/item/grenade/syndieminibomb/concussion/frag(src)
	new /obj/item/grenade/syndieminibomb/concussion/frag(src)
	new /obj/item/grenade/syndieminibomb/concussion/frag(src)
	new /obj/item/grenade/gluon(src)
	new /obj/item/grenade/gluon(src)
	new /obj/item/grenade/gluon(src)
	new /obj/item/grenade/gluon(src)
	new /obj/item/grenade/chem_grenade/incendiary(src)
	new /obj/item/grenade/chem_grenade/incendiary(src)
	new /obj/item/grenade/chem_grenade/facid(src)
	new /obj/item/grenade/syndieminibomb(src)
	new /obj/item/grenade/syndieminibomb(src)
	new /obj/item/screwdriver(src)
	new /obj/item/device/multitool(src)

/obj/item/storage/belt/wands
=======
		/obj/item/weapon/grenade,
		/obj/item/weapon/screwdriver,
		/obj/item/weapon/lighter,
		/obj/item/device/multitool,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/molotov,
		/obj/item/weapon/grenade/plastic/c4,
		)
/obj/item/weapon/storage/belt/grenade/full/PopulateContents()
	new /obj/item/weapon/grenade/flashbang(src)
	new /obj/item/weapon/grenade/smokebomb(src)
	new /obj/item/weapon/grenade/smokebomb(src)
	new /obj/item/weapon/grenade/smokebomb(src)
	new /obj/item/weapon/grenade/smokebomb(src)
	new /obj/item/weapon/grenade/empgrenade(src)
	new /obj/item/weapon/grenade/empgrenade(src)
	new /obj/item/weapon/grenade/syndieminibomb/concussion/frag(src)
	new /obj/item/weapon/grenade/syndieminibomb/concussion/frag(src)
	new /obj/item/weapon/grenade/syndieminibomb/concussion/frag(src)
	new /obj/item/weapon/grenade/syndieminibomb/concussion/frag(src)
	new /obj/item/weapon/grenade/syndieminibomb/concussion/frag(src)
	new /obj/item/weapon/grenade/syndieminibomb/concussion/frag(src)
	new /obj/item/weapon/grenade/syndieminibomb/concussion/frag(src)
	new /obj/item/weapon/grenade/syndieminibomb/concussion/frag(src)
	new /obj/item/weapon/grenade/syndieminibomb/concussion/frag(src)
	new /obj/item/weapon/grenade/syndieminibomb/concussion/frag(src)
	new /obj/item/weapon/grenade/gluon(src)
	new /obj/item/weapon/grenade/gluon(src)
	new /obj/item/weapon/grenade/gluon(src)
	new /obj/item/weapon/grenade/gluon(src)
	new /obj/item/weapon/grenade/chem_grenade/incendiary(src)
	new /obj/item/weapon/grenade/chem_grenade/incendiary(src)
	new /obj/item/weapon/grenade/chem_grenade/facid(src)
	new /obj/item/weapon/grenade/syndieminibomb(src)
	new /obj/item/weapon/grenade/syndieminibomb(src)
	new /obj/item/weapon/screwdriver(src)
	new /obj/item/device/multitool(src)

/obj/item/weapon/storage/belt/wands
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "wand belt"
	desc = "A belt designed to hold various rods of power. A veritable fanny pack of exotic magic."
	icon_state = "soulstonebelt"
	item_state = "soulstonebelt"
	storage_slots = 6
	can_hold = list(
<<<<<<< HEAD
		/obj/item/gun/magic/wand
		)

/obj/item/storage/belt/wands/full/PopulateContents()
	new /obj/item/gun/magic/wand/death(src)
	new /obj/item/gun/magic/wand/resurrection(src)
	new /obj/item/gun/magic/wand/polymorph(src)
	new /obj/item/gun/magic/wand/teleport(src)
	new /obj/item/gun/magic/wand/door(src)
	new /obj/item/gun/magic/wand/fireball(src)

	for(var/obj/item/gun/magic/wand/W in contents) //All wands in this pack come in the best possible condition
		W.max_charges = initial(W.max_charges)
		W.charges = W.max_charges

/obj/item/storage/belt/janitor
=======
		/obj/item/weapon/gun/magic/wand
		)

/obj/item/weapon/storage/belt/wands/full/PopulateContents()
	new /obj/item/weapon/gun/magic/wand/death(src)
	new /obj/item/weapon/gun/magic/wand/resurrection(src)
	new /obj/item/weapon/gun/magic/wand/polymorph(src)
	new /obj/item/weapon/gun/magic/wand/teleport(src)
	new /obj/item/weapon/gun/magic/wand/door(src)
	new /obj/item/weapon/gun/magic/wand/fireball(src)

	for(var/obj/item/weapon/gun/magic/wand/W in contents) //All wands in this pack come in the best possible condition
		W.max_charges = initial(W.max_charges)
		W.charges = W.max_charges

/obj/item/weapon/storage/belt/janitor
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "janibelt"
	desc = "A belt used to hold most janitorial supplies."
	icon_state = "janibelt"
	item_state = "janibelt"
	storage_slots = 6
	max_w_class = WEIGHT_CLASS_BULKY // Set to this so the  light replacer can fit.
	can_hold = list(
<<<<<<< HEAD
		/obj/item/grenade/chem_grenade,
		/obj/item/device/lightreplacer,
		/obj/item/device/flashlight,
		/obj/item/reagent_containers/spray,
		/obj/item/soap,
		/obj/item/holosign_creator,
=======
		/obj/item/weapon/grenade/chem_grenade,
		/obj/item/device/lightreplacer,
		/obj/item/device/flashlight,
		/obj/item/weapon/reagent_containers/spray,
		/obj/item/weapon/soap,
		/obj/item/weapon/holosign_creator,
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
		/obj/item/key/janitor,
		/obj/item/clothing/gloves
		)

<<<<<<< HEAD
/obj/item/storage/belt/bandolier
=======
/obj/item/weapon/storage/belt/bandolier
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "bandolier"
	desc = "A bandolier for holding shotgun ammunition."
	icon_state = "bandolier"
	item_state = "bandolier"
	storage_slots = 18
	display_contents_with_number = TRUE
	can_hold = list(
		/obj/item/ammo_casing/shotgun
		)

<<<<<<< HEAD
/obj/item/storage/belt/holster
=======
/obj/item/weapon/storage/belt/holster
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "shoulder holster"
	desc = "A holster to carry a handgun and ammo. WARNING: Badasses only."
	icon_state = "holster"
	item_state = "holster"
	storage_slots = 3
	max_w_class = WEIGHT_CLASS_NORMAL
	can_hold = list(
<<<<<<< HEAD
		/obj/item/gun/ballistic/automatic/pistol,
		/obj/item/gun/ballistic/revolver,
=======
		/obj/item/weapon/gun/ballistic/automatic/pistol,
		/obj/item/weapon/gun/ballistic/revolver,
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
		/obj/item/ammo_box,
		)
	alternate_worn_layer = UNDER_SUIT_LAYER

<<<<<<< HEAD
/obj/item/storage/belt/holster/full/PopulateContents()
	new /obj/item/gun/ballistic/revolver/detective(src)
	new /obj/item/ammo_box/c38(src)
	new /obj/item/ammo_box/c38(src)

/obj/item/storage/belt/fannypack
=======
/obj/item/weapon/storage/belt/holster/full/PopulateContents()
	new /obj/item/weapon/gun/ballistic/revolver/detective(src)
	new /obj/item/ammo_box/c38(src)
	new /obj/item/ammo_box/c38(src)

/obj/item/weapon/storage/belt/fannypack
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "fannypack"
	desc = "A dorky fannypack for keeping small items in."
	icon_state = "fannypack_leather"
	item_state = "fannypack_leather"
	storage_slots = 3
	max_w_class = WEIGHT_CLASS_SMALL

<<<<<<< HEAD
/obj/item/storage/belt/fannypack/black
=======
/obj/item/weapon/storage/belt/fannypack/black
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "black fannypack"
	icon_state = "fannypack_black"
	item_state = "fannypack_black"

<<<<<<< HEAD
/obj/item/storage/belt/fannypack/red
=======
/obj/item/weapon/storage/belt/fannypack/red
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "red fannypack"
	icon_state = "fannypack_red"
	item_state = "fannypack_red"

<<<<<<< HEAD
/obj/item/storage/belt/fannypack/purple
=======
/obj/item/weapon/storage/belt/fannypack/purple
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "purple fannypack"
	icon_state = "fannypack_purple"
	item_state = "fannypack_purple"

<<<<<<< HEAD
/obj/item/storage/belt/fannypack/blue
=======
/obj/item/weapon/storage/belt/fannypack/blue
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "blue fannypack"
	icon_state = "fannypack_blue"
	item_state = "fannypack_blue"

<<<<<<< HEAD
/obj/item/storage/belt/fannypack/orange
=======
/obj/item/weapon/storage/belt/fannypack/orange
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "orange fannypack"
	icon_state = "fannypack_orange"
	item_state = "fannypack_orange"

<<<<<<< HEAD
/obj/item/storage/belt/fannypack/white
=======
/obj/item/weapon/storage/belt/fannypack/white
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "white fannypack"
	icon_state = "fannypack_white"
	item_state = "fannypack_white"

<<<<<<< HEAD
/obj/item/storage/belt/fannypack/green
=======
/obj/item/weapon/storage/belt/fannypack/green
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "green fannypack"
	icon_state = "fannypack_green"
	item_state = "fannypack_green"

<<<<<<< HEAD
/obj/item/storage/belt/fannypack/pink
=======
/obj/item/weapon/storage/belt/fannypack/pink
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "pink fannypack"
	icon_state = "fannypack_pink"
	item_state = "fannypack_pink"

<<<<<<< HEAD
/obj/item/storage/belt/fannypack/cyan
=======
/obj/item/weapon/storage/belt/fannypack/cyan
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "cyan fannypack"
	icon_state = "fannypack_cyan"
	item_state = "fannypack_cyan"

<<<<<<< HEAD
/obj/item/storage/belt/fannypack/yellow
=======
/obj/item/weapon/storage/belt/fannypack/yellow
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "yellow fannypack"
	icon_state = "fannypack_yellow"
	item_state = "fannypack_yellow"

<<<<<<< HEAD
/obj/item/storage/belt/sabre
=======
/obj/item/weapon/storage/belt/sabre
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	name = "sabre sheath"
	desc = "An ornate sheath designed to hold an officer's blade."
	icon_state = "sheath"
	item_state = "sheath"
	storage_slots = 1
	rustle_jimmies = FALSE
	w_class = WEIGHT_CLASS_BULKY
	max_w_class = WEIGHT_CLASS_BULKY
	can_hold = list(
<<<<<<< HEAD
		/obj/item/melee/sabre
		)

/obj/item/storage/belt/sabre/examine(mob/user)
=======
		/obj/item/weapon/melee/sabre
		)

/obj/item/weapon/storage/belt/sabre/examine(mob/user)
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	..()
	if(contents.len)
		to_chat(user, "<span class='notice'>Alt-click it to quickly draw the blade.</span>")

<<<<<<< HEAD
/obj/item/storage/belt/sabre/AltClick(mob/user)
=======
/obj/item/weapon/storage/belt/sabre/AltClick(mob/user)
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	if(!ishuman(user) || !user.canUseTopic(src, be_close=TRUE))
		return
	if(contents.len)
		var/obj/item/I = contents[1]
		user.visible_message("[user] takes [I] out of [src].", "<span class='notice'>You take [I] out of [src].</span>",\
		)
		user.put_in_hands(I)
		update_icon()
	else
		to_chat(user, "[src] is empty.")

<<<<<<< HEAD
/obj/item/storage/belt/sabre/update_icon()
=======
/obj/item/weapon/storage/belt/sabre/update_icon()
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	icon_state = "sheath"
	item_state = "sheath"
	if(contents.len)
		icon_state += "-sabre"
		item_state += "-sabre"
	if(loc && isliving(loc))
		var/mob/living/L = loc
		L.regenerate_icons()
	..()


<<<<<<< HEAD
/obj/item/storage/belt/sabre/PopulateContents()
	new /obj/item/melee/sabre(src)
=======
/obj/item/weapon/storage/belt/sabre/PopulateContents()
	new /obj/item/weapon/melee/sabre(src)
>>>>>>> b7e7779c19... (Ready) Clockwork Cult Rework: Proof-of-concept (#29741)
	update_icon()
