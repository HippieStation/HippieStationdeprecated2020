/* Stimpak */
/datum/uplink_item/stealthy_tools/stimpack
	name = "Syndicate Nano-Booster"
	desc = "Also known as the 'Call of Duty' this powerful cluster of medical nanites effectively heals all damage \
	over time. If you are injured simply get to cover and wait a while and your wounds will vanish before your eyes. \
	It's duration is roughly five minutes."
	item = /obj/item/reagent_containers/syringe/nanoboost
	cost = 5
	surplus = 90

/* Implants */
/datum/uplink_item/implants/adrenal
	name = "Combat Stimulant Implant"
	desc = "An implant injected into the body, and later activated at the user's will. It will inject a chemical \
			cocktail which has a very potent healing effect."
	item = /obj/item/storage/box/syndie_kit/imp_comstimms
	cost = 8
	player_minimum = 0 //Healing like this, while strong as heck, isn't going to help you murderbone like antistuns can.

/datum/uplink_item/implants/mindslave
	name = "Mindslave Implant"
	desc = "An implant injected into another body, forcing the victim to obey any command by the user for around 15 to 20 mintues."
	exclude_modes = list(/datum/game_mode/nuclear)
	item = /obj/item/storage/box/syndie_kit/imp_mindslave
	cost = 8
	surplus = 20

/datum/uplink_item/implants/greatermindslave
	name = "Greater Mindslave Implant"
	desc = "An implant injected into another body, forcing the victim to obey any command by the user, it does not expire like a regular mindslave implant."
	item = /obj/item/storage/box/syndie_kit/imp_gmindslave
	cost = 16

/* Botany */
/datum/uplink_item/role_restricted/lawnmower
	name = "Gas powered lawn mower"
	desc = "A lawn mower is a machine utilizing one or more revolving blades to cut a grass surface to an even height, or bodies if that's your thing"
	restricted_roles = list("Botanist")
	cost = 14
	item = /obj/vehicle/lawnmower/emagged

/datum/uplink_item/role_restricted/echainsaw
	name = "Energy Chainsaw"
	desc = "An incredibly deadly modified chainsaw with plasma-based energy blades instead of metal and a slick black-and-red finish. While it rips apart matter with extreme efficiency, it is heavy, large, and monstrously loud."
	restricted_roles = list("Botanist", "Chef", "Bartender")
	item = /obj/item/twohanded/required/chainsaw/energy
	cost = 16

/* Glock */
/datum/uplink_item/dangerous/g17
	name = "Glock 17 Handgun"
	desc = "A simple yet popular handgun chambered in 9mm. Made out of strong but lightweight polymer. The standard magazine can hold up to 14 9mm cartridges. Compatible with a universal suppressor."
	item = /obj/item/gun/ballistic/automatic/pistol/g17
	cost = 10
	surplus = 15

/datum/uplink_item/ammo/g17
	name = "9mm Handgun Magazine"
	desc = "An additional 14-round 9mm magazine; compatible with the Glock 17 pistol."
	item = /obj/item/ammo_box/magazine/g17
	cost = 1

/datum/uplink_item/dangerous/revolver
	cost = 10
	surplus = 45

/* Holo Parasites */
/datum/uplink_item/dangerous/guardian
	name = "Holoparasites"
	desc = "Though capable of near sorcerous feats via use of hardlight holograms and nanomachines, they require an organic host as a home base and source of fuel."
	item = /obj/item/storage/box/syndie_kit/guardian
	cost = 20
	exclude_modes = list(/datum/game_mode/nuclear)
	
/datum/uplink_item/nukeoffer/blastco
	name = "Unlock the BlastCo(tm) Armory"
	desc = "Enough gear to fully equip a team with explosive based weaponry."
	item = /obj/item/paper
	cost = 200

/datum/uplink_item/nukeoffer/blastco/spawn_item(turf/loc, obj/item/device/uplink/U)
	LAZYINITLIST(blastco_doors)
	if(LAZYLEN(blastco_doors))
		for(var/V in blastco_doors)
			var/obj/machinery/door/poddoor/shutters/blastco/X = V
			X.open()
		loc.visible_message("<span class='notice'>The Armory has been unlocked successfully!</span>")
	else
		loc.visible_message("<span class='warning'>The purchase was unsuccessful, and spent telecrystals have been refunded.</span>")
		U.telecrystals += cost //So the admins don't have to refund you
	return

/datum/uplink_item/role_restricted/firesuit_syndie
	name = "Syndicate Firesuit"
	desc = "A less heavy, armored version of the common firesuit developed by a now-defunct, \
	Syndicate-affiliated collective with a penchant for arson. It offers complete fireproofing, \
	spaceproofing, the added bonus of not slowing the wearer while equipped and it fits into any backpack. \
	Comes in conspicuous red/orange colors. Helmet included."
	cost = 4
	item = /obj/item/storage/box/syndie_kit/firesuit/
	restricted_roles = list("Atmospheric Technician")

/datum/uplink_item/role_restricted/fire_axe
	name = "Fire Axe"
	desc = "A rather blunt fire axe recovered from the burnt out wreck of an old space station. \
	Warm to the touch, this axe will set fire to anyone struck with it as long as you hold it with\
	two hands. The more you strike them, the hotter they burn, it will deal bonus fire damage to lit\
	targets and will enable you to shoot gouts of fire that will set them ablaze. It will also apply thermite to\
	standard walls and ignite them on a second hit."
	cost = 10
	item = /obj/item/twohanded/fireaxe/fireyaxe
	restricted_roles = list("Atmospheric Technician")

/datum/uplink_item/role_restricted/retardhorn
	name = "Extra Annoying Bike Horn."
	desc = "This bike horn has been carefully tuned by the clown federation to subtly affect the brains of those who\
	 hear it using advanced sonic techniques. To the untrained eye, a golden bike horn but each honk will cause small\
	  amounts of brain damage, most targets will be reduced to a gibbering wreck before they catch on."
	cost = 5
	item = /obj/item/bikehorn/golden/retardhorn
	restricted_roles = list("Clown")

/datum/uplink_item/ammo/pistol
	desc = "An additional 8-round 10mm magazine; compatible with the Stechkin Pistol. These \
			are dirt cheap but aren't as effective as .357 rounds."

/datum/uplink_item/ammo/revolver
	cost = 2

/datum/uplink_item/dangerous/butterfly
	name = "Energy Butterfly Knife"
	desc = "A highly lethal and concealable knife that causes critical backstab damage when used with harm intent."
	cost = 12//80 backstab damage and armour pierce isn't a fucking joke
	item = /obj/item/melee/transforming/butterfly/energy
	surplus = 15

/datum/uplink_item/dangerous/beenade
	name = "Bee delivery grenade"
	desc = "This grenade is filled with several random posionous bees. Fun for the whole family!"
	cost = 4
	item = /obj/item/grenade/spawnergrenade/beenade
	surplus = 30

/datum/uplink_item/dangerous/gremlin
	name = "Gremlin delivery grenade"
	desc = "This grenade is filled with several gremlins. Fun for RnD and engineering!"
	cost = 4
	item = /obj/item/grenade/spawnergrenade/gremlin
	surplus = 30

/datum/uplink_item/dangerous/cat
	name = "Feral cat grenade"
	desc = "This grenade is filled with 5 feral cats in stasis. Upon activation, the feral cats are awoken and unleashed unto unlucky bystanders."
	cost = 5
	item = /obj/item/grenade/spawnergrenade/cat
	surplus = 30

/datum/uplink_item/stealthy_tools/chameleon
	cost = 4
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/traitor)
	player_minimum = 0
	
/datum/uplink_item/stealthy_tools/syndigaloshes
	item = /obj/item/clothing/shoes/chameleon
	cost = 2
	player_minimum = 0
	
/datum/uplink_item/stealthy_tools/syndigaloshes/nuke
	cost = 2
	player_minimum = 0
	
/datum/uplink_item/stealthy_tools/mulligan
	cost = 2
	
/datum/uplink_item/device_tools/syndietome
	cost = 5
	
/datum/uplink_item/device_tools/binary
	cost = 2
	
/datum/uplink_item/device_tools/singularity_beacon
	cost = 8
	
/datum/uplink_item/device_tools/syndicate_bomb
	cost = 10
	
/datum/uplink_item/device_tools/syndicate_detonator
	cost = 1 //Nuke ops already spawn with one
	
/datum/uplink_item/device_tools/jammer
	cost = 3
	
/datum/uplink_item/device_tools/codespeak_manual_deluxe
	cost = 4
	
/datum/uplink_item/device_tools/autosurgeon
	name = "Autosurgeon"
	desc = "A surgery device that instantly implants you with whatever implant has been inserted in it. Infinite uses. Use a screwdriver to remove an implant from it."
	item = /obj/item/device/autosurgeon
	cost = 4
	surplus = 60
	
/datum/uplink_item/implants/microbomb
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/traitor)

/datum/uplink_item/implants/macrobomb
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/traitor)
	
/datum/uplink_item/dangerous/hockey
	name = "Ka-nada Hockey Set"
	desc = "Become one of the legends of the most brutal game in space. The items cannot be taken off once you wear them."
	item = /obj/item/storage/box/syndie_kit/hockey
	cost = 20
	exclude_modes = list(/datum/game_mode/nuclear)
	
/datum/uplink_item/dangerous/bowling
	name = "Bowling Set"
	desc = "Niko, it's me, your cousin! Let's go bowling."
	item = /obj/item/storage/box/syndie_kit/bowling
	cost = 12
	exclude_modes = list(/datum/game_mode/nuclear)
	
/datum/uplink_item/dangerous/wrestling
	name = "Wrestling Set"
	desc = "OH YEAH BROTHERRRR!"
	item = /obj/item/storage/box/syndie_kit/wrestling
	cost = 8 //The wrestling set is not as powerful as it once was
	exclude_modes = list(/datum/game_mode/nuclear)
	
/datum/uplink_item/dangerous/football
	name = "Football Set"
	desc = "Actually Rugby."
	item = /obj/item/storage/box/syndie_kit/football
	cost = 16
	exclude_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/role_restricted/meeseeks
	name = "Meeseeks Box"
	desc = "A mysterious box, able to conjure servants at will."
	cost = 18
	item = /obj/item/device/meeseeks_box
	restricted_roles = list("Scientist", "Research Director", "Geneticist")
