/datum/uplink_item
	var/party = FALSE /* Whether or not this item spawns in the party surplus crate */

/proc/initialize_global_uplink_items()
	GLOB.uplink_items = list()
	for(var/item in subtypesof(/datum/uplink_item))
		var/datum/uplink_item/I = new item()
		if(!I.item)
			continue
		if(!GLOB.uplink_items[I.category])
			GLOB.uplink_items[I.category] = list()
		GLOB.uplink_items[I.category][I.name] = I

/proc/get_uplink_items(var/datum/game_mode/gamemode = null)
	if(!GLOB.uplink_items.len)
		initialize_global_uplink_items()

	var/list/filtered_uplink_items = list()
	var/list/sale_items = list()

	for(var/category in GLOB.uplink_items)
		for(var/item in GLOB.uplink_items[category])
			var/datum/uplink_item/I = GLOB.uplink_items[category][item]
			if(!istype(I))
				continue
			if(I.include_modes.len)
				if(!gamemode && SSticker && SSticker.mode && !(SSticker.mode.type in I.include_modes))
					continue
				if(gamemode && !(gamemode in I.include_modes))
					continue
			if(I.exclude_modes.len)
				if(!gamemode && SSticker && SSticker.mode && (SSticker.mode.type in I.exclude_modes))
					continue
				if(gamemode && (gamemode in I.exclude_modes))
					continue
			if(I.player_minimum && I.player_minimum > GLOB.joined_player_list.len)
				continue
			if(I.party) /* Hippie code, used for party surplus crate */
				continue

			if(!filtered_uplink_items[category])
				filtered_uplink_items[category] = list()
			filtered_uplink_items[category][item] = I
			if(I.limited_stock < 0 && !I.cant_discount && I.item && I.cost > 1)
				sale_items += I

	for(var/i in 1 to 3)
		var/datum/uplink_item/I = pick_n_take(sale_items)
		var/datum/uplink_item/A = new I.type
		var/discount = A.get_discount()
		var/list/disclaimer = list("Void where prohibited.", "Not recommended for children.", "Contains small parts.", "Check local laws for legality in region.", "Do not taunt.", "Not responsible for direct, indirect, incidental or consequential damages resulting from any defect, error or failure to perform.", "Keep away from fire or flames.", "Product is provided \"as is\" without any implied or expressed warranties.", "As seen on TV.", "For recreational use only.", "Use only as directed.", "16% sales tax will be charged for orders originating within Space Nebraska.")
		A.limited_stock = 1
		I.refundable = FALSE //THIS MAN USES ONE WEIRD TRICK TO GAIN FREE TC, CODERS HATES HIM!
		A.refundable = FALSE
		if(A.cost >= 20) //Tough love for nuke ops
			discount *= 0.5
		A.cost = max(round(A.cost * discount),1)
		A.category = "Discounted Gear"
		A.name += " ([round(((initial(A.cost)-A.cost)/initial(A.cost))*100)]% off!)"
		A.desc += " Normally costs [initial(A.cost)] TC. All sales final. [pick(disclaimer)]"
		A.item = I.item

		if(!filtered_uplink_items[A.category])
			filtered_uplink_items[A.category] = list()
		filtered_uplink_items[A.category][A.name] = A
	return filtered_uplink_items

/datum/uplink_item/colab
	category = "Collaborative Gear"
	surplus = 0
	exclude_modes = list(/datum/game_mode/nuclear)
	cant_discount = TRUE

/datum/uplink_item/party
	category = "Discontinued Party Gear"
	surplus = 25
	exclude_modes = list(/datum/game_mode/nuclear)
	cant_discount = TRUE
	party = TRUE

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
	cost = 6
	surplus = 20

/datum/uplink_item/implants/greatermindslave
	name = "Greater Mindslave Implant"
	desc = "An implant injected into another body, forcing the victim to obey any command by the user, it does not expire like a regular mindslave implant."
	item = /obj/item/storage/box/syndie_kit/imp_gmindslave
	cost = 10

/* Botany */
/datum/uplink_item/role_restricted/lawnmower
	name = "Gas powered lawn mower"
	desc = "A lawn mower is a machine utilizing one or more revolving blades to cut a grass surface to an even height, or bodies if that's your thing"
	restricted_roles = list("Botanist")
	cost = 14
	item = /obj/vehicle/ridden/lawnmower/emagged

/datum/uplink_item/dangerous/echainsaw
	name = "Energy Chainsaw"
	desc = "An incredibly deadly modified chainsaw with plasma-based energy blades instead of metal and a slick black-and-red finish. While it rips apart matter with extreme efficiency, it is heavy, large, and monstrously loud."
	item = /obj/item/twohanded/required/chainsaw/energy
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

/datum/uplink_item/nukeoffer/blastco
	name = "Unlock the BlastCo(tm) Armory"
	desc = "Enough gear to fully equip a team with explosive based weaponry."
	item = /obj/item/paper
	cost = 200

/datum/uplink_item/nukeoffer/blastco/spawn_item(turf/loc, datum/component/uplink/U, mob/user)
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
	cost = 3

/datum/uplink_item/dangerous/butterfly
	name = "Energy Butterfly Knife"
	desc = "A highly lethal and concealable knife that causes critical backstab damage when used with harm intent."
	cost = 8//80 backstab damage and armour pierce isn't a fucking joke
	item = /obj/item/melee/transforming/butterfly/energy
	surplus = 15

/datum/uplink_item/dangerous/beenade
	name = "Bee delivery grenade"
	desc = "This grenade is filled with several random posionous bees. Fun for the whole family!"
	cost = 2
	item = /obj/item/grenade/spawnergrenade/beenade
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

/datum/uplink_item/device_tools/singularity_beacon
	cost = 8

/datum/uplink_item/device_tools/syndicate_bomb
	cost = 10

/datum/uplink_item/device_tools/syndicate_detonator
	cost = 1 //Nuke ops already spawn with one

/datum/uplink_item/device_tools/jammer
	cost = 3

/datum/uplink_item/device_tools/autosurgeon
	name = "Autosurgeon"
	desc = "A surgery device that instantly implants you with whatever implant has been inserted in it. Infinite uses. Use a screwdriver to remove an implant from it."
	item = /obj/item/device/autosurgeon
	cost = 1
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
	exclude_modes = list(/datum/game_mode/nuclear, /datum/game_mode/traitor)

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
	cost = 10
	surplus = 10
	exclude_modes = list(/datum/game_mode/nuclear)

/datum/uplink_item/badass/surplus
	player_minimum = 0

/datum/uplink_item/badass/rapid
	name = "Gloves of the North Star"
	desc = "These gloves let the user punch people very fast. Incompatible with weaponry or the hulk mutation."
	item = /obj/item/clothing/gloves/fingerless/rapid
	cost = 8

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
	cost = 12

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

/datum/uplink_item/badass/party
	name = "Syndicate Party Crate"
	desc = "A forgotten birthday crate for valued Syndicate agents. The project was cancelled a long time ago, \
			and some items you'll find have been discontinued or recalled for varying reasons. \
			The overall value will always be 50 TC, but a random amount of TC will be set aside for party items. \
			Will always contain a random cake."
	item = /obj/structure/closet/crate
	cost = 20
	surplus = 0
	exclude_modes = list(/datum/game_mode/nuclear)
	cant_discount = TRUE

/datum/uplink_item/badass/party/spawn_item(turf/loc, datum/component/uplink/U)
	var/list/uplink_items = get_uplink_items(SSticker && SSticker.mode? SSticker.mode : null) + list("Discontinued Party Gear" = GLOB.uplink_items["Discontinued Party Gear"])

	var/crate_value = 50
	var/obj/structure/closet/crate/C = new(loc)
	var/party_value = rand(1,20)
	crate_value = crate_value - party_value
	while(crate_value)
		var/category = pick(uplink_items)
		var/item = pick(uplink_items[category])
		var/datum/uplink_item/I = uplink_items[category][item]

		if(!I.surplus || prob(100 - I.surplus))
			continue
		if(crate_value < I.cost)
			continue
		crate_value -= I.cost
		var/obj/goods = new I.item(C)
		U.purchase_log.LogPurchase(goods, I.cost)
	while(party_value)
		var/itemp = pick(uplink_items["Discontinued Party Gear"])
		var/datum/uplink_item/IP = uplink_items["Discontinued Party Gear"][itemp]

		if(!IP.surplus || prob(100 - IP.surplus))
			continue
		if(party_value < IP.cost)
			continue
		party_value -= IP.cost
		var/obj/goods = new IP.item(C)
		U.purchase_log.LogPurchase(goods, IP.cost)

	SSblackbox.record_feedback("nested tally", "traitor_uplink_items_bought", 1, list("[initial(name)]", "[cost]"))
	return C

// descriptions are there in the party items just in case we decide to unhide the category in the future.

/datum/uplink_item/party/monkeybands
	name = "Monkeyman's Wristbands"
	desc = "Wristbands that are said to contain the soul of the Monkeyman, a master martial artist who brought down all sorts of space tyrants - but not Nanotrasen. \
			Was discontinued when we realized that those who equipped the wristbands were quickly possessed and became clones of the Monkeyman himself."
	item = /obj/item/clothing/gloves/monkeybands
	cost = 20 // literally gives you an almost-instant-crit spell and rapid disarms
	surplus = 25 //surplus/party only, fitting for an item this strong.

/datum/uplink_item/party/grudgecoder
	name = "Grudgecoder"
	desc = "A laptop that also functions as an energy weapon, used for its ability to bring the wrath of Github upon its victims. \
			Was recalled once the copies had been reported to be infected with a furry virus, and they were later replaced by the Execution Sword. \
			Hold by the handle (wield) it and use HELP intent on the head to channel the wrath of Github. This will be announced to the crew, so be cautious!"
	item = /obj/item/twohanded/grudgecoder
	cost = 4
	surplus = 35

/datum/uplink_item/party/riotfoamdart
	name = "Donksoft C-20r"
	desc = "A box containing a Donksoft C-20r, and an ammo box. \
			Use the ammo box in-hand on a foam dart to collect it. If there are multiple on a tile, it'll automatically collect the others. \
			Was widely mocked by operatives, other gangs, and Nanotrasen crew. They were discontinued before long."
	item = /obj/item/storage/box/syndie_kit/c20r_foam_box
	cost = 2 // costs 1/6th of the ebow price, because it's only sixth as good
	surplus = 30

/datum/uplink_item/party/lightning_box
	name = "Lightning in a Box"
	desc = "A box containing several packets of birdseed, which stun those who are hit by it. \
			Was produced, but never sold to agents."
	item = /obj/item/storage/box/syndie_kit/lightning_box
	cost = 1 // devils give you this for free on a 1 second cooldown, the fact that it even costs a telecrystal might be a sin on its own right
	surplus = 10

/datum/uplink_item/party/rocketpunch
	name = "Rocket Punch"
	desc = "A Golden Power-Fist, completely retooled to shoot the fist of the Gauntlet at people. Does not require gas \
			Every unit was as expensive as Space Station 13 its self. Few were produced, and it was quickly discarded as an item far less useful than the Mini-Energy Crossbow."
	item = /obj/item/gun/energy/kinetic_accelerator/rocketopaunch
	cost = 12 // essentially an ebow that deals damage & knocks back instead of stuns, if the person you're shooting hits a wall then they're as good as dead
	surplus = 35 //good chance to show up in crates means more punches on average