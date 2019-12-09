/datum/uplink_item/colab
	category = "Collaborative Gear"
	surplus = 0
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/infiltration)
	cant_discount = TRUE

/* Stimpak */
/datum/uplink_item/stealthy_tools/stimpack
	name = "Syndicate Nano-Booster"
	desc = "Also known as the 'Call of Duty' this powerful cluster of medical nanites effectively heals all damage \
	over time. If you are injured simply get to cover and wait a while and your wounds will vanish before your eyes. \
	It's duration is roughly five minutes."
	item = /obj/item/reagent_containers/syringe/nanoboost
	cost = 5
	surplus = 90


/datum/uplink_item/stealthy_tools/thermal
	name = "Thermal Imaging Goggles"
	desc = "These goggles allow you to see organisms through walls by capturing the upper portion of the infrared light spectrum, \
			emitted as heat and light by objects. Hotter objects, such as warm bodies, cybernetic organisms \
			and artificial intelligence cores emit more of this light than cooler objects like walls and airlocks."
	item = /obj/item/clothing/glasses/thermal/meson
	cost = 4

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
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/infiltration)
	item = /obj/item/storage/box/syndie_kit/imp_mindslave
	cost = 6
	surplus = 20

/datum/uplink_item/implants/greatermindslave
	name = "Greater Mindslave Implant"
	desc = "An implant injected into another body, forcing the victim to obey any command by the user, it does not expire like a regular mindslave implant."
	item = /obj/item/storage/box/syndie_kit/imp_gmindslave
	exclude_modes = list(/datum/game_mode/infiltration)
	cost = 10


/* Botany */
/datum/uplink_item/role_restricted/lawnmower
	name = "Gas powered lawn mower"
	desc = "A lawn mower is a machine utilizing one or more revolving blades to cut a grass surface to an even height, or bodies if that's your thing"
	restricted_roles = list("Botanist")
	cost = 14
	item = /obj/vehicle/ridden/lawnmower/emagged

/datum/uplink_item/role_restricted/gatfruit
	name = "Syndi Gatfruit"
	desc = "An extrememly rare plant seed which grows .357 revolvers. Has been modified to mature twice as fast as normal Gatfruit"
	restricted_roles = list("Botanist")
	cost = 18
	item = /obj/item/seeds/gatfruit/syndi

/datum/uplink_item/dangerous/echainsaw
	name = "Energy Chainsaw"
	desc = "An incredibly deadly modified chainsaw with plasma-based energy blades instead of metal and a slick black-and-red finish. While it rips apart matter with extreme efficiency, it is heavy, large, and monstrously loud."
	item = /obj/item/twohanded/required/chainsaw/energy
	exclude_modes = list(/datum/game_mode/infiltration)
	cost = 14

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
	cost = 13
	surplus = 45

/datum/uplink_item/bundles_TC/blastco
	name = "BlastCo(tm) Armory"
	desc = "Enough gear to fully equip a team!"
	item = /obj/effect/gibspawner/generic // non-tangible item because techwebs use this path to determine illegal tech
	cost = 200

/datum/uplink_item/bundles_TC/blastco/spawn_item(spawn_path, mob/user, datum/component/uplink/U)
	var/datum/antagonist/nukeop/N = user?.mind?.has_antag_datum(/datum/antagonist/nukeop)
	if(!N || !istype(N))
		to_chat(user, "<span class='warning'>The purchase was unsuccessful, and spent telecrystals have been refunded.</span>")
		U.telecrystals += cost
		return
	if(N.nuke_team)
		if(N.nuke_team.bought_blastco)
			to_chat(user, "<span class='warning'>You have already recieved a BlastCo(tm) supply!</span>")
			U.telecrystals += cost
			return
		N.nuke_team.bought_blastco = TRUE
		for(var/datum/mind/M in N.nuke_team.members)
			if(iscarbon(M.current))
				var/mob/living/carbon/C = M.current
				var/obj/item/blastco_spawner/BCS = new(get_turf(C))
				to_chat(C, "<span class='notice'>\The [BCS] appears [C.put_in_hands(BCS) ? "in your hands" : "on the floor"]!</span>")
	else
		var/obj/item/blastco_spawner/BCS = new(get_turf(user))
		to_chat(user, "<span class='notice'>\The [BCS] appears [user.put_in_hands(BCS) ? "in your hands" : "on the floor"]!</span>")

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
	cost = 3

/datum/uplink_item/role_restricted/canegun
	name = "Concealed cane shotgun"
	desc = "A shotgun cleverly disgusied as a pimp stick. Pull on it to rack it and fold it to fire. Holds 8 shells at once. Keep away from assistants."
	restricted_roles = list("Clown","Mime")
	cost = 8
	item = /obj/item/gun/ballistic/shotgun/canegun

/datum/uplink_item/dangerous/butterfly
	name = "Energy Butterfly Knife"
	desc = "A highly lethal and concealable knife that causes critical backstab damage when used with harm intent."
	cost = 8
	item = /obj/item/melee/transforming/butterfly/energy
	surplus = 15

/datum/uplink_item/dangerous/beenade
	name = "Bee delivery grenade"
	desc = "This grenade is filled with several random posionous bees. Fun for the whole family!"
	cost = 2
	item = /obj/item/grenade/spawnergrenade/beenade
	exclude_modes = list(/datum/game_mode/infiltration)
	surplus = 30

/datum/uplink_item/dangerous/gremlin
	name = "Gremlin delivery grenade"
	desc = "This grenade is filled with several gremlins. Fun for RnD and engineering!"
	cost = 2
	item = /obj/item/grenade/spawnergrenade/gremlin
	surplus = 30

/datum/uplink_item/dangerous/cat
	name = "Feral cat grenade"
	desc = "This grenade is filled with 5 feral cats in stasis. Upon activation, the feral cats are awoken and unleashed unto unlucky bystanders."
	cost = 3
	item = /obj/item/grenade/spawnergrenade/cat
	exclude_modes = list(/datum/game_mode/infiltration)
	surplus = 30

/datum/uplink_item/stealthy_weapons/crossbow
	name = "Miniature Energy Crossbow"
	desc = "A short bow mounted across a tiller in miniature. Small enough to \
	fit into a pocket or slip into a bag unnoticed. It will synthesize \
	and fire bolts tipped with lethal toxins that will disorient and \
	irradiate targets. It can produce an infinite number of bolts \
	but takes time to automatically recharge after each shot."
	item = /obj/item/gun/energy/kinetic_accelerator/hippie_ebow
	cost = 8
	exclude_modes = list() // Has no reason to be excluded any more.

/datum/uplink_item/stealthy_tools/syndigaloshes
	name = "No-Slip Brown Shoes"
	item = /obj/item/clothing/shoes/sneakers/brown/noslip
	cost = 3
	player_minimum = 0

/datum/uplink_item/stealthy_tools/syndigaloshes/nuke
	cost = 3
	player_minimum = 0

/datum/uplink_item/stealthy_tools/mulligan
	cost = 2

/datum/uplink_item/device_tools/singularity_beacon
	cost = 8

/datum/uplink_item/device_tools/syndicate_bomb
	cost = 10
	exclude_modes = list(/datum/game_mode/infiltration) //no blowing shit up

/datum/uplink_item/device_tools/syndicate_detonator
	cost = 1 //Nuke ops already spawn with one

/datum/uplink_item/device_tools/jammer
	cost = 3

/datum/uplink_item/device_tools/autosurgeon
	name = "Autosurgeon"
	desc = "A surgery device that instantly implants you with whatever implant has been inserted in it. Infinite uses. Use a screwdriver to remove an implant from it."
	item = /obj/item/autosurgeon
	cost = 1
	surplus = 60

/datum/uplink_item/implants/macrobomb
	restricted = FALSE

/datum/uplink_item/dangerous/hockey
	name = "Ka-nada Hockey Set"
	desc = "Become one of the legends of the most brutal game in space. The items cannot be taken off once you wear them."
	item = /obj/item/storage/box/syndie_kit/hockey
	cost = 20
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/infiltration)

/datum/uplink_item/dangerous/bowling
	name = "Bowling Set"
	desc = "Niko, it's me, your cousin! Let's go bowling."
	item = /obj/item/storage/box/syndie_kit/bowling
	cost = 12
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/infiltration)

/datum/uplink_item/dangerous/wrestling
	name = "Wrestling Set"
	desc = "OH YEAH BROTHERRRR!"
	item = /obj/item/storage/box/syndie_kit/wrestling
	cost = 8 //The wrestling set is not as powerful as it once was
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/infiltration)

/datum/uplink_item/badass/execution_sword
	name = "Executioners Sword"
	desc = "This modified energy sword has been specially designed to cleanly remove the head of a human\
			 being in one well aimed swipe. It contains a little hacked transmitter that will broadcast the\
			 details of your gruesome execution on the Centcom announcement channel so everyone will know the\
			 name of the filthy pig you are about to slaughter. You may dedicate your executions to whomever you\
			 please by using the device in hand but you may only do so once. Be warned that you must remain still\
			 for a long time to execute a target so be sure to have them restrained and if you should be interrupted\
			 then news of your failure will be broadcast to the station."
	item = /obj/item/melee/execution_sword
	cost = 1 //Its weaker than an energy dagger and cannot be concealed.
	surplus = 30 //Theres a good chance this will end up in surplus crates, so its a great way to add a little spice to any meme round.
	exclude_modes = list(/datum/game_mode/infiltration)
	restricted = TRUE

/datum/uplink_item/dangerous/guardian
	surplus = 5 //Up yours TGbalanceing
	player_minimum = 0

/datum/uplink_item/colab/romerol_kit
	name = "Romerol"
	desc = "A highly experimental bioterror agent which creates dormant nodules to be etched into the grey matter of the brain. On death, these nodules take control of the dead body, causing limited revivification, along with slurred speech, aggression, and the ability to infect others with this agent."
	item = /obj/item/storage/box/syndie_kit/romerol
	cost = 25
	surplus = 5

/datum/uplink_item/stealthy_weapons/romerol_kit
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/traitor, /datum/game_mode/infiltration)

/datum/uplink_item/badass/banhammer
	name = "Banhammer"
	desc = "Mimick an imperfect version of god's wrath with this unholy weapon. Found in an abandoned bus."
	item = /obj/item/banhammer
	cost = 1
	surplus = 40

/datum/uplink_item/dangerous/syndiebanhammer
	name = "Syndicate Banhammer"
	desc = "By inserting small kinetic pounders into a banhammer, the banhammer becomes a dangerous object that is able to kill people before they even realize what happened. Completely stealthy unless someone examines it. Don't try this at home."
	item = /obj/item/banhammer/syndicate
	cost = 6
	surplus = 10

/datum/uplink_item/support/reinforcement
	desc = "Call in an additional team member. They'll start with a kit of their choice, but that's it."
	cost = 30

/datum/uplink_item/badass/surplus
	player_minimum = 0

/datum/uplink_item/device_tools/syndietome
	cost = 2

/datum/uplink_item/device_tools/binary
	cost = 2

/datum/uplink_item/device_tools/codespeak_manual
	desc = "Syndicate agents can be trained to use a series of codewords to convey complex information, which makes you look like an obvious traitor to anyone listening. This manual teaches you this Codespeak. You can also hit someone else with the manual in order to teach them. One use."
	cost = 0
	limited_stock = 4

/datum/uplink_item/device_tools/codespeak_manual_deluxe
	desc = "Syndicate agents can be trained to use a series of codewords to convey complex information, which makes you look like an obvious traitor to anyone listening. This manual teaches you this Codespeak. You can also hit someone else with the manual in order to teach them. This is the deluxe edition, which has unlimited uses. Now you and your club can get lynched together!"
	cost = 3

/datum/uplink_item/stealthy_weapons/martialarts
	name = "Sleeping Carp Mask"
	item = /obj/item/clothing/mask/gas/carp/sleeping
	desc = "This mask contains the secrets of an ancient martial arts technique. You will master unarmed combat, but you also refuse to use dishonorable ranged weaponry. \
	Put two together to create the carp suit, which allows you to deflect ranged attacks."
	cost = 5
	limited_stock = 2
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops, /datum/game_mode/infiltration)

/datum/uplink_item/stealthy_weapons/cqc
	item = /obj/item/cqc_manual // lmao @ granter code

/datum/uplink_item/stealthy_weapons/throwingweapons
	cost = 2

/datum/uplink_item/stealthy_weapons/dart_pistol
	cost = 3

/datum/uplink_item/suits/hardsuit
	cost = 7

/datum/uplink_item/device_tools/surgerybag
	cost = 1

/datum/uplink_item/role_restricted/ancient_jumpsuit
	cost = 0
	limited_stock = 4

/datum/uplink_item/role_restricted/reverse_revolver
	cost = 13

/datum/uplink_item/dangerous/powerfist
	cost = 6

/datum/uplink_item/role_restricted/reverse_bear_trap
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/traitor)


/datum/uplink_item/badass/contender
	name = "Contender G13"
	desc = "A poacher's favorite, ArcWorks' Contender G13 can hold any ammo you put into it. Each shot must be loaded individually. Ammo sold seperately!"
	item = /obj/item/gun/ballistic/shotgun/doublebarrel/contender
	cost = 7 // You have to buy ammo for it, and there's only two shots. If you really want to get any use out of it, it'll be more around 10 TC.
	surplus = 45 // Why not? You get a boatload of ammo in Surplus Crates anyhow.

/datum/uplink_item/ammo/buckshotbox
	name = "Box of Buckshot"
	desc = "Contains 60 rounds of Buckshot. A popular purchase, whether it be the gondola poachers or the militia."
	item = /obj/item/ammo_box/buckshotbox
	cost = 10 // the math has been done, I assure you. // the math has been broken
	surplus = 25 // let's maybe not have players waste 13 TC on ammo every time they get a crate

/datum/uplink_item/dangerous/armstrong
	name = "Armstrong Style Kit"
	desc = "A kit with the necessary equipment to become an excellent martial artist, and terrible parent!"
	item = /obj/item/storage/box/syndie_kit/armstrong
	cost = 14
	surplus = 20 // someone who respects the eldritch god Nar-Sie a little (((too much))) complained
	exclude_modes = list(/datum/game_mode/infiltration)

/datum/uplink_item/device_tools/brainwash_disk
	restricted_roles = list("Medical Doctor", "Chief Medical Officer")

//Nanosuit uplink item, available in all traitor rounds and nuke.
/datum/uplink_item/dangerous/nanosuit
	name = "CryNet Nanosuit"
	desc = "Become a posthuman warrior. The items cannot be taken off once you wear them and alerts the crew of your position if equipped on station."
	item = /obj/item/storage/box/syndie_kit/nanosuit
	cost = 20
	surplus = 10
	cant_discount = TRUE	
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/infiltration)

/datum/uplink_item/dangerous/synth
	name = "Cybersun Sponsorship Kit"
	desc = "Containing an arm mounted laser implant and a device bestowing the mysteries of the synth augmentation upon you, this kit also comes with a free autosurgeon."
	item = /obj/item/storage/box/syndie_kit/synth
	cost = 8
	surplus = 40
	exclude_modes = list(/datum/game_mode/infiltration)

/datum/uplink_item/badass/brick
	name = "A brick"
	desc = "A literal brick, able to break a common windows like nothing. Serves well as a melee and thrown weapon aswell. Keep an eye out for the fabled brown brick."
	item = /obj/item/brick
	cost = 1
	surplus = 30

/datum/uplink_item/device_tools/arm
	name = "Additional Arm"
	desc = "An additional arm harvested from slaves captured by the Syndicate. Comes with an implanter."
	item = /obj/item/extra_arm
	cost = 4
	limited_stock = 2
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/infiltration)

/datum/uplink_item/role_restricted/clowncar
	cost = 15

/datum/uplink_item/dangerous/sword
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops, /datum/game_mode/infiltration)

/datum/uplink_item/dangerous/doublesword
	exclude_modes = list(/datum/game_mode/traitor, /datum/game_mode/nuclear, /datum/game_mode/infiltration) //excluded from every mode. you make it by putting two swords together again.

/datum/uplink_item/dangerous/syndicate_minibomb
	exclude_modes = list(/datum/game_mode/nuclear/clown_ops, /datum/game_mode/infiltration)

/datum/uplink_item/dangerous/guardian
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops, /datum/game_mode/infiltration)

/datum/uplink_item/stealthy_weapons/romerol_kit
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/infiltration)

/datum/uplink_item/stealthy_weapons/detomatix
	exclude_modes = list(/datum/game_mode/infiltration) //stealthhhh!

/datum/uplink_item/device_tools/c4bag
	exclude_modes = list(/datum/game_mode/infiltration) //you don't need to be blowing that much shit up!

/datum/uplink_item/device_tools/x4bag
	exclude_modes = list(/datum/game_mode/infiltration) //you don't need to be blowing that much shit up!

/datum/uplink_item/device_tools/powersink
	exclude_modes = list(/datum/game_mode/infiltration) //if they have this objective, they get a special one

/datum/uplink_item/device_tools/singularity_beacon
	exclude_modes = list(/datum/game_mode/infiltration) //no.

/datum/uplink_item/cyber_implants/thermals
	include_modes = list(/datum/game_mode/nuclear, /datum/game_mode/infiltration)

/datum/uplink_item/badass/balloon
	exclude_modes = list(/datum/game_mode/infiltration) //no.

/datum/uplink_item/bundles_TC/bundle_A
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/infiltration)

/datum/uplink_item/bundles_TC/bundle_B
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/infiltration)

/datum/uplink_item/bundles_TC/surplus
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/nuclear/clown_ops, /datum/game_mode/infiltration)
	player_minimum = 0

//Infiltrator shit
/datum/uplink_item/infiltration
	category = "Infiltration Gear"
	include_modes = list(/datum/game_mode/infiltration)
	surplus = 0

/datum/uplink_item/infiltration/pinpointer_upgrade
	name = "Pinpointer Upgrade"
	desc = "An infiltration pinpointer upgrade that allows pinpointers to track objective targets."
	item = /obj/item/infiltrator_pinpointer_upgrade
	cost = 8

/datum/uplink_item/infiltration/extra_stealthsuit
	name = "Extra Chameleon Hardsuit"
	desc = "An infiltration hardsuit, capable of changing it's appearance instantly."
	item = /obj/item/clothing/suit/space/hardsuit/infiltration
	cost = 10

// Events
/datum/uplink_item/services
	category = "Services"
	include_modes = list(/datum/game_mode/infiltration, /datum/game_mode/nuclear)
	surplus = 0
	restricted = TRUE

/datum/uplink_item/services/manifest_spoof
	name = "Crew Manifest Spoof"
	desc = "A button capable of adding a single person to the crew manifest."
	item = /obj/item/service/manifest
	cost = 15 //Maybe this is too cheap??

/datum/uplink_item/services/fake_ion
	name = "Fake Ion Storm"
	desc = "Fakes an ion storm announcment. A good distraction, especially if the AI is weird anyway."
	item = /obj/item/service/ion
	cost = 7

/datum/uplink_item/services/fake_meteor
	name = "Fake Meteor Announcement"
	desc = "Fakes an meteor announcment. A good way to get any C4 on the station exterior, or really any small explosion, brushed off as a meteor hit."
	item = /obj/item/service/meteor
	cost = 7

/datum/uplink_item/services/fake_rod
	name = "Fake Immovable Rod"
	desc = "Fakes an immovable rod announcement. Good for a short-lasting distraction."
	item = /obj/item/service/rodgod
	cost = 6 //less likely to be believed

/datum/uplink_item/role_restricted/monk_manual
	name = "Monk Manual"
	desc = "Study the ways of asceticism and pacifism by beating the living shit out of people."
	item = /obj/item/nullrod/monk_manual
	cost = 6
	restricted_roles = list("Chaplain")

/datum/uplink_item/role_restricted/antigrav_boots
	name = "Anti Gravity Boots"
	desc = "Modified mag boots that let you float over floors and gaps."
	item = /obj/item/clothing/shoes/magboots/antigrav
	cost = 8
	surplus = 30
	restricted_roles = list("Shaft Miner")

// stop VR CRABBING
/datum/uplink_item/device_tools/suspiciousphone
	restricted = TRUE

/datum/uplink_item/dangerous/vibroblade
	name = "High Frequency Blade"
	desc = "An electric katana that weakens the molecular bonds of whatever it touches. Perfect for slicing off the limbs of your coworkers. \
	Avoid using a multitool on it."
	item = /obj/item/storage/belt/hfblade
	cost = 9
	surplus = 15
	exclude_modes = list(/datum/game_mode/infiltration)

/datum/uplink_item/device_tools/threat
	name = "Threat scanning glasses"
	desc = "Mark threats and check enemies for objective items, weapons and high level access. Guaranteed to greentext or your telecrystals back."
	item = /obj/item/clothing/glasses/hud/threat
	cost = 6
