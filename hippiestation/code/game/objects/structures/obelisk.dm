/obj/structure/destructible/obelisk
    name = "mysterious obelisk"
    desc = "Feel it.... feel the magic..."
    density = TRUE
    max_integrity = 400
    anchored = 1
    icon = 'hippiestation/icons/obj/structures/obelisk.dmi'
    icon_state = "tier1"
    layer = BELOW_OBJ_LAYER + 0.1
    var/obj/item/screwdriver/obelisk/tool
    var/cooldowntime = 0

/obj/structure/destructible/obelisk/Initialize()
    . = ..()
    tool = new(get_turf(src))

/obj/structure/destructible/obelisk/Destroy()
    . = ..()
    qdel(tool)

/obj/structure/destructible/obelisk/attack_hand(mob/living/user)
	. = ..()
	if(cooldowntime > world.time)
		to_chat(user, "<span class='cult italic'>The magic in [src] is weak, it will be ready to use again in [DisplayTimeText(cooldowntime - world.time)].</span>")
		return
	var/choice = alert(user,"You stare deep into the obelisk and see a glimpse of the true power...",,"Magical inscripture",,"Nevermind")
	var/list/pickedtype = list()
	switch(choice)
		if("Magical inscripture")
			pickedtype += /obj/item/inscripture
	if(src && !QDELETED(src) && anchored && pickedtype.len && Adjacent(user) && !user.incapacitated() && cooldowntime <= world.time)
		cooldowntime = world.time + 1200
		for(var/N in pickedtype)
			new N(get_turf(src))
			to_chat(user, "<span class='cultitalic'>You create the [choice] from the obelisk!</span>")
		if("Nevermind")
			return


/obj/item/screwdriver/obelisk //This is what is actually used to craft obelisk magic items for the curator.
    name = "mysterious obelisk"
    desc = "A broken part of the obelisk"
    icon = null
    icon_state = null
    item_state = null
    mouse_opacity = 0
    anchored = TRUE


//***Tier 2***


/obj/structure/destructible/obelisktier2
	name = "greater obelisk"
	desc = "Feel it.... feel the magic..."
	density = TRUE
	max_integrity = 700
	anchored = 1
	icon = 'hippiestation/icons/obj/structures/obelisk.dmi'
	icon_state = "tier2"
	layer = BELOW_OBJ_LAYER + 0.1
	var/obj/item/screwdriver/obelisk/tier2/tool1

/obj/structure/destructible/obelisktier2/Initialize()
    . = ..()
    tool1 = new(get_turf(src))

/obj/structure/destructible/obelisktier2/Destroy()
    . = ..()
    qdel(tool1)

/obj/item/screwdriver/obelisk/tier2
	name = "greater obelisk"

/obj/item/inscripture
	name = "magical inscripture"
	desc = "Magic on a piece of paper."
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	icon_state = "inscripture"
	throw_range = 1

/obj/item/inscripture/attack_self(mob/user)
	var/choice = alert(user,"You begin to fold the magical inscripture... (WARNING: Clicking 'Yes' is very dangerous)",,"Yes, finish folding it.",,"On second thought...")
	switch(choice)
		if("Yes, finish folding it.")
			user.visible_message("<span class='warning'>[user] folds the [src] and is sucked into nothingness!")
			var/turf/T = get_turf(user)
			new /obj/effect/decal/cleanable/molten_object(T)
			var/turf/dest = locate(rand(30, 160), rand(40, 160), rand(2, 9))
			do_teleport(user, dest, 8, asoundin = 'sound/effects/phasein.ogg', channel = TELEPORT_CHANNEL_MAGIC)
			new /obj/effect/particle_effect/sparks(loc)
			playsound(loc, "sparks", 50, 1)
			qdel(src)
		if("On second thought...")
			return


//***Tier 3***