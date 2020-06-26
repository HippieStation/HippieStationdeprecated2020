/obj/structure/destructible/obelisk
    name = "mysterious obelisk"
    desc = "Feel it.... feel the magic..."
    density = TRUE
    max_integrity = 400
    anchored = 1
    icon = 'hippiestation/icons/obj/structures/obelisk.dmi'
    icon_state = "tier1"
    layer = BELOW_OBJ_LAYER + 0.1
    var/obj/item/tier1/tool
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
		if("Nevermind")
			return

	if(src && !QDELETED(src) && anchored && pickedtype.len && Adjacent(user) && !user.incapacitated() && cooldowntime <= world.time)
		cooldowntime = world.time + 1200
		for(var/N in pickedtype)
			new N(get_turf(src))
			to_chat(user, "<span class='cultitalic'>You create the [choice] from the [src]!</span>")

/obj/item/tier1 //This is what is actually used to craft obelisk magic items for the curator.
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
	var/obj/item/tier2/tool1
	var/cooldowntime = 0

/obj/structure/destructible/obelisktier2/Initialize()
    . = ..()
    tool1 = new(get_turf(src))

/obj/structure/destructible/obelisktier2/Destroy()
    . = ..()
    qdel(tool1)

/obj/structure/destructible/obelisktier2/attack_hand(mob/living/user)
	. = ..()
	if(cooldowntime > world.time)
		to_chat(user, "<span class='cult italic'>The magic in [src] is weak, it will be ready to use again in [DisplayTimeText(cooldowntime - world.time)].</span>")
		return
	var/choice = alert(user,"You stare deep into the [src] and see a glimpse of the true power...",,"Magical inscripture",,"Nevermind")
	var/list/pickedtype = list()
	switch(choice)
		if("Magical inscripture")
			pickedtype += /obj/item/inscripture
		if("Nevermind")
			return

	if(src && !QDELETED(src) && anchored && pickedtype.len && Adjacent(user) && !user.incapacitated() && cooldowntime <= world.time)
		cooldowntime = world.time + 1000
		for(var/N in pickedtype)
			new N(get_turf(src))
			to_chat(user, "<span class='cultitalic'>You create the [choice] from the [src]!</span>")

/obj/item/tier2
    name = "greater obelisk"
    desc = "A broken part of the obelisk"
    icon = null
    icon_state = null
    item_state = null
    mouse_opacity = 0
    anchored = TRUE


//***Tier 3***

/obj/structure/destructible/obelisktier3
	name = "Obelisk of Limitless Wisdom"
	desc = "Feel it.... feel the magic..."
	density = TRUE
	max_integrity = 900
	anchored = 1
	icon = 'hippiestation/icons/obj/structures/obelisk.dmi'
	icon_state = "tier4"
	layer = BELOW_OBJ_LAYER + 0.1
	var/obj/item/tier3/tool2
	var/cooldowntime = 0

/obj/structure/destructible/obelisktier3/Initialize()
    . = ..()
    tool2 = new(get_turf(src))

/obj/structure/destructible/obelisktier3/Destroy()
    . = ..()
    qdel(tool2)

/obj/structure/destructible/obelisktier3/attack_hand(mob/living/user)
	. = ..()
	if(cooldowntime > world.time)
		to_chat(user, "<span class='cult italic'>The magic in [src] is weak, it will be ready to use again in [DisplayTimeText(cooldowntime - world.time)].</span>")
		return
	var/choice = alert(user,"You stare deep into the [src] and see a glimpse of the true power...",,"Magical inscripture",,"Nevermind")
	var/list/pickedtype = list()
	switch(choice)
		if("Magical inscripture")
			pickedtype += /obj/item/inscripture
		if("Nevermind")
			return

	if(src && !QDELETED(src) && anchored && pickedtype.len && Adjacent(user) && !user.incapacitated() && cooldowntime <= world.time)
		cooldowntime = world.time + 800
		for(var/N in pickedtype)
			new N(get_turf(src))
			to_chat(user, "<span class='cultitalic'>You create the [choice] from the [src]!</span>")

/obj/item/tier3
    name = "Obelisk of Limitless Wisdom"
    desc = "A broken part of the obelisk"
    icon = null
    icon_state = null
    item_state = null
    mouse_opacity = 0
    anchored = TRUE

/obj/item/inscripture
	name = "magical inscripture"
	desc = "Magic on a piece of paper."
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	icon_state = "inscripture"
	w_class = WEIGHT_CLASS_TINY
	throw_range = 1
	layer = ABOVE_OBJ_LAYER + 0.1
	var/used = 0
	var/i

/obj/item/inscripture/examine(mob/user)
	. = ..()
	if(used)
		. += "<span class='notice'>This one seems to be used and drained of its magical power. It will likely dissipate soon.</span>"

/obj/item/inscripture/attack_self(mob/living/user)
	if(!used)
		var/choice = alert(user,"You begin to fold the magical inscripture... (WARNING: This is a bad idea)",,"Yes, finish folding it.",,"On second thought...")
		switch(choice)
			if("Yes, finish folding it.")
				used = 1
				icon_state = "usedinscripture"
				update_icon()
				user.visible_message("<span class='warning'>[user] folds the [src] and is sucked into nothingness!")
				new /obj/effect/decal/cleanable/molten_object(get_turf(user))
				var R = rand(15, 250)
				teleportation(user, R)
			if("On second thought...")
				return

/obj/item/inscripture/proc/teleportation(mob/living/user, teleports)
	for(i = 1, i <= teleports, i++)
		addtimer(CALLBACK(src, .proc/teleportation2, user, teleports), 3 - (i/40))
		switch(i)
			if(0)
				sleep(13)
			if(1) //These sleeps make it so that it slowly teleports at first and then speeds up. Timers couldnt help me here.
				sleep(10)
			if(2)
				sleep(8)
			if(3)
				sleep(6)
			if(4)
				sleep(5)
			if(5)
				sleep(3)
			if(6)
				sleep(1.5)
			if(7)
				sleep(0.7)
			if(8)
				sleep(0.35)
			if(9)
				sleep(0.17)
			if(10)
				sleep(0.08)
		//addtimer(CALLBACK(src, .proc/teleportation2, user, teleports), 10 - (i/4))

	addtimer(CALLBACK(src, .proc/delete), 2*teleports)

/obj/item/inscripture/proc/teleportation2(mob/living/user, teleports)
	var/turf/dest = locate(rand(1, 300), rand(1, 300), rand(2, 9))

//	if(istype(get_turf(dest), /turf/open/lava/)) These commented out parts were used for debugging.
//		to_chat(world, "RETURNED: [get_turf(dest)]")
//		return .(user, teleports)
	if(istype(get_turf(dest), /turf/open/lava/smooth/lava_land_surface) || istype(get_turf(dest), /turf/open/floor/plating/asteroid/basalt/lava_land_surface) || istype(get_turf(dest), /turf/closed/mineral/random))
//		to_chat(world, "RETURNED: [get_turf(dest)]")
		return .(user, teleports)

//	var/turf/thing = get_turf(dest)
//	to_chat(world, "WE'RE IN: [thing] [thing.type]")
	do_teleport(user, dest, 8, asoundin = 'sound/effects/podwoosh.ogg', channel = TELEPORT_CHANNEL_MAGIC)
	new /obj/effect/particle_effect/sparks(loc)
	playsound(loc, "sparks", 50, 1)

/obj/item/inscripture/proc/delete()
	visible_message("<span class ='warning'>The [src] dissipates!")
	qdel(src)