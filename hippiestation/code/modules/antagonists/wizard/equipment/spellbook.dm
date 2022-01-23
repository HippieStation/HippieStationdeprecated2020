/obj/item/spellbook
	var/list/bought_things = list()

/obj/item/spellbook/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/badmin_gauntlet))
		var/obj/item/badmin_gauntlet/IG = O
		if(IG.locked_on)
			to_chat(user, "<span class='notice'>You've put the gauntlet on already. No turning back now.</span>")
			return
		to_chat(user, "<span class='notice'>On second thought, wiping out half the universe is possibly a bad idea. You refund your points.</span>")
		uses += 10
		for(var/datum/spellbook_entry/item/badmin_gauntlet/I in entries)
			if(!isnull(I.limit))
				I.limit++
		bought_things[/datum/spellbook_entry/item/badmin_gauntlet] = 0
		qdel(O)
		return
	return ..()

/datum/spellbook_entry/lichdom/IsAvailible()
	return FALSE

/datum/spellbook_entry/teslablast
	cost = 1

/datum/spellbook_entry/lightningbolt
	cost = 2

/datum/spellbook_entry/infinite_guns
	cost = 2

/datum/spellbook_entry/arcane_barrage
	cost = 2

/datum/spellbook_entry/eruption
	cost = 1

/datum/spellbook_entry/item/plasma_fist
	cost = 3

/datum/spellbook_entry/item/mjolnir
	desc = "A mighty hammer on load from Thor, God of Thunder. It crackles with darely contained power. Counts as a staff."
	cost = 1

/datum/spellbook_entry/item/mjolnir/Buy(mob/living/carbon/human/user, obj/item/spellbook/book)
	. = ..()
	user.worthiness += 5

/datum/spellbook_entry/item/mjolnir/Refund(mob/living/carbon/human/user, obj/item/spellbook/book)
	. = ..()
	user.worthiness -= 5

/datum/spellbook_entry/item/singularity_hammer
	desc = "A hammer that creates an intensely powerful field of gravity where it strikes, pulling everything nearby to the point of impact. Counts as a staff."
	cost = 1

/datum/spellbook_entry/cluwnecurse
	name = "Cluwne Curse"
	spell_type = /obj/effect/proc_holder/spell/targeted/cluwnecurse

/datum/spellbook_entry/eruption
	name = "Eruption"
	spell_type = /obj/effect/proc_holder/spell/aoe_turf/conjure/eruption
	cost = 1

/datum/spellbook_entry/fist
	name = "Fist"
	spell_type = /obj/effect/proc_holder/spell/aimed/fist

/datum/spellbook_entry/soulflare
	name = "Soulflare"
	spell_type = /obj/effect/proc_holder/spell/targeted/trigger/soulflare

/datum/spellbook_entry/corpseexplosion
	name = "Corpse Explosion"
	spell_type = /obj/effect/proc_holder/spell/targeted/explodecorpse

/datum/spellbook_entry/soulsplit
	name = "Soulsplit"
	spell_type = /obj/effect/proc_holder/spell/self/soulsplit
	category = "Mobility"

/datum/spellbook_entry/summon_bees
	name = "Conjure Bees"
	spell_type = /obj/effect/proc_holder/spell/aoe_turf/conjure/bees
	category = "Assistance"

/datum/spellbook_entry/bfs
	name = "Interdimensional Sword"
	desc = "A massive flaming sword, capable of crushing walls, igniting enemies, and cutting rooms in half."
	spell_type = /obj/effect/proc_holder/spell/self/bfs
	cost = 3

/obj/item/book/granter/spell/smoke/lesser
	spell = /obj/effect/proc_holder/spell/targeted/smoke/lesser

/datum/spellbook_entry/item/voice
	name = "Voice Of God"
	desc = "Carefully harvested from Lavaland Colossi, these cords allow you to issue commands to those near you. Will not work on deaf people. Will drop upon resurrecting as a lich."
	item_path = /obj/item/autosurgeon/colossus
	category = "Assistance"
	cost = 1

/datum/spellbook_entry/item/bookofdarkness
	name = "Book of Darkness"
	desc = "A forbidden tome, previously outlawed from the Wizard Federation for containing necromancy that is now being redistributed. Contains a powerful artifact that gets stronger with every soul it claims, a stunning spell that deals heavy damage to a single target, an incorporeal move spell and a spell that lets you explode corpses. Comes with a cool set of powerful robes as well that can carry the Staff of Revenant."
	item_path = /obj/item/bookofdarkness
	category = "Assistance"
	cost = 6
	limit = 1

/datum/spellbook_entry/item/staffofrevenant
	name = "Staff of Revenant"
	desc = "A weak staff that can drain the souls of the dead to become far more powerful than anything you can lay your hands on. Activate in your hand to view your progress, stats and if possible, progress to the next stage."
	item_path = /obj/item/gun/magic/staff/staffofrevenant
	category = "Defensive"

/datum/spellbook_entry/item/scryingorb/Buy(mob/living/carbon/human/user,obj/item/spellbook/book)
	if(..())
		if (!(user.dna.check_mutation(XRAY)))
			user.dna.add_mutation(XRAY)
	return 1

/datum/spellbook_entry/item/plasma_fist
	name = "Plasma Fist Scroll"
	desc = "Consider this more of a \"spell bundle.\" This artifact is NOT reccomended for weaklings. An ancient scroll that will teach you the art of Plasma Fist. With it's various combos you can knock people down in the area around you, light them on fire and finally perform the PLASMA FIST that will gib your target."
	item_path = /obj/item/plasma_fist_scroll
	cost = 3

/datum/spellbook_entry/item/badmin_gauntlet
	name = "Badmin Gauntlet"
	desc = "A gauntlet capable of holding the Badmin Stones. <b>Wearing this will trigger a war declaration!</b>. Before you wear it, you can refund it by hitting it against the spellbook. \
		<b>You cannot buy this if you have bought anything else!</b> \
		Requires 18+ crew."
	item_path = /obj/item/badmin_gauntlet
	category = "Rituals"
	cost = 10

/datum/spellbook_entry/item/badmin_gauntlet/IsAvailible()
	return ..() && SSticker.mode.name != "ragin' mages" && SSticker.mode.name != "dynamic mode"

/datum/spellbook_entry/item/badmin_gauntlet/Buy(mob/living/carbon/human/user, obj/item/spellbook/book)
	. = ..()
	book.uses = cost

/datum/spellbook_entry/item/badmin_gauntlet/CanBuy(mob/living/carbon/human/user, obj/item/spellbook/book)
	for(var/SP in book.bought_things)
		if(book.bought_things[SP] > 0)
			return FALSE
	return ..() && (GLOB.Debug2 || GLOB.joined_player_list.len >= 18)

/datum/spellbook_entry/the_world
	name = "THE WORLD"
	desc = "Freeze time across the entire station. 1 second per spellpoint. Comes with the ability to throw a large amount of knives. <b><i>Cannot be refunded.</i></b>"
	category = "Offensive"
	cost = 1
	spell_type = /obj/effect/proc_holder/spell/self/the_world

/datum/spellbook_entry/the_world/Buy(mob/living/carbon/human/user, obj/item/spellbook/book)
	if(!S || QDELETED(S))
		S = new spell_type()
	for(var/obj/effect/proc_holder/spell/self/the_world/aspell in user.mind.spell_list)
		aspell.seconds += 10
		aspell.name = "THE WORLD ([aspell.seconds / 10] seconds)"
		SSblackbox.record_feedback("nested tally", "wizard_spell_improved", 1, list("THE WORLD", "[aspell.seconds]"))
		return TRUE
	SSblackbox.record_feedback("tally", "wizard_spell_learned", 1, "THE WORLD")
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/aimed/checkmate)
	S.name = "THE WORLD (1 second)"
	user.mind.AddSpell(S)
	to_chat(user, "<span class='notice'>You have learned [S.name].</span>")
	return TRUE

/datum/spellbook_entry/the_world/CanRefund(mob/living/carbon/human/user, obj/item/spellbook/book)
	return FALSE

/datum/spellbook_entry/summon/IsAvailible()
	return ..() && SSticker.mode.name != "ragin' mages" && SSticker.mode.name != "dynamic mode"

/datum/spellbook_entry/summon/guns/IsAvailible()
	return ..() && !CONFIG_GET(flag/no_summon_guns)

/datum/spellbook_entry/summon/magic/IsAvailible()
	return ..() && !CONFIG_GET(flag/no_summon_magic)

/datum/spellbook_entry/summon/events/IsAvailible()
	return ..() && !CONFIG_GET(flag/no_summon_events)

/obj/item/spellbook
	persistence_replacement = /obj/item/book/granter/spell/random

/datum/spellbook_entry/GetInfo() // hippiestation variant
	. = ..()
	. += "[S.staff_req?"Requires a staff to cast.":"Can be cast without a staff"]<br>"
