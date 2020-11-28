/obj/item/storage/box
	icon_hippie = 'hippiestation/icons/obj/storage.dmi'

/obj/item/storage/box/update_icon()
	. = ..()
	if(illustration)
		cut_overlays()
		var/image/I = image(icon = 'icons/obj/storage.dmi', icon_state = illustration) // use the /tg/ icons
		I.pixel_y = 5
		add_overlay(I)

/obj/item/storage/box/monkeycubes
	icon = 'icons/obj/storage.dmi'

/obj/item/storage/box/papersack
	icon = 'icons/obj/storage.dmi'

/obj/item/storage/box/cyber_implants
	icon = 'icons/obj/storage.dmi'

/obj/item/storage/box/mousetraps
	illustration = "mousetrap" // fucking tg typoed it

/obj/item/storage/box/emergency/old
	icon = 'icons/obj/storage.dmi'

/obj/item/storage/box/mechanical/old
	icon = 'icons/obj/storage.dmi'

/obj/item/storage/toolbox/brass
	icon = 'icons/obj/storage.dmi'

/obj/item/storage/box/lights
	icon_hippie = 'hippiestation/icons/obj/storage.dmi'

/obj/item/storage/box/seclarp
	name = "\improper Medieval Officer Kit"
	desc = "You've commited crimes against Nanotrasen and her people. What say you in your defense?"

/obj/item/storage/box/seclarp/PopulateContents()
	new /obj/item/clothing/head/helmet/larp(src)
	new /obj/item/clothing/suit/armor/larp(src)
	new /obj/item/clothing/shoes/jackboots/larp(src)

/obj/item/storage/box/cowcubes
	name = "cow cube box"
	desc = "Drymate brand cow cubes. Just add water!"
	icon = 'hippiestation/icons/obj/storage.dmi'
	icon_state = "cowcubebox"
	illustration = null
	var/cube_type = /obj/item/reagent_containers/food/snacks/monkeycube/cowcube

/obj/item/storage/box/cowcubes/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 3
	STR.set_holdable(list(/obj/item/reagent_containers/food/snacks/monkeycube/cowcube))

/obj/item/storage/box/cowcubes/PopulateContents()
	for(var/i in 1 to 3)
		new cube_type(src)

/obj/item/storage/box/chickencubes
	name = "chicken cube box"
	desc = "United Chicken Federation brand chicken cubes. Just add water!"
	icon = 'hippiestation/icons/obj/storage.dmi'
	icon_state = "chickencubebox"
	illustration = null
	var/cube_type = /obj/item/reagent_containers/food/snacks/monkeycube/chickencube

/obj/item/storage/box/chickencubes/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 5
	STR.set_holdable(list(/obj/item/reagent_containers/food/snacks/monkeycube/chickencube))

/obj/item/storage/box/chickencubes/PopulateContents()
	for(var/i in 1 to 4)
		new cube_type(src)

/obj/item/storage/box/ink
	name = "Spacestar-brand ink box"
	desc = "A patented storage for Spacestar-brand ink."
	icon = 'hippiestation/icons/obj/storage.dmi'
	icon_state = "inkbox"
	illustration = null

/obj/item/storage/box/ink/PopulateContents()
	new /obj/item/inkcartridge(src)
	new /obj/item/inkcartridge(src)
	new /obj/item/inkcartridge(src)

/obj/item/storage/box/glowsticks
	name = "glowstick box"
	desc = "A box with glowsticks in it."
	icon = 'hippiestation/icons/obj/storage.dmi'
	icon_state = "glowstick_box"
	illustration = null

/obj/item/storage/box/glowsticks/PopulateContents()
	var/type = pick(
			/obj/item/flashlight/glowstick,
			/obj/item/flashlight/glowstick/blue,
			/obj/item/flashlight/glowstick/cyan,
			/obj/item/flashlight/glowstick/orange,
			/obj/item/flashlight/glowstick/pink,
			/obj/item/flashlight/glowstick/red,
			/obj/item/flashlight/glowstick/yellow )
	new type(src)
	type = pick(
			/obj/item/flashlight/glowstick,
			/obj/item/flashlight/glowstick/blue,
			/obj/item/flashlight/glowstick/cyan,
			/obj/item/flashlight/glowstick/orange,
			/obj/item/flashlight/glowstick/pink,
			/obj/item/flashlight/glowstick/red,
			/obj/item/flashlight/glowstick/yellow )
	new type(src)
	type = pick(
			/obj/item/flashlight/glowstick,
			/obj/item/flashlight/glowstick/blue,
			/obj/item/flashlight/glowstick/cyan,
			/obj/item/flashlight/glowstick/orange,
			/obj/item/flashlight/glowstick/pink,
			/obj/item/flashlight/glowstick/red,
			/obj/item/flashlight/glowstick/yellow )
	new type(src)
	type = pick(
			/obj/item/flashlight/glowstick,
			/obj/item/flashlight/glowstick/blue,
			/obj/item/flashlight/glowstick/cyan,
			/obj/item/flashlight/glowstick/orange,
			/obj/item/flashlight/glowstick/pink,
			/obj/item/flashlight/glowstick/red,
			/obj/item/flashlight/glowstick/yellow )
	new type(src)
	type = pick(
			/obj/item/flashlight/glowstick,
			/obj/item/flashlight/glowstick/blue,
			/obj/item/flashlight/glowstick/cyan,
			/obj/item/flashlight/glowstick/orange,
			/obj/item/flashlight/glowstick/pink,
			/obj/item/flashlight/glowstick/red,
			/obj/item/flashlight/glowstick/yellow )
	new type(src)

/obj/item/storage/box/laserpointers
	name = "laser pointer box"
	desc = "A box full of laser pointers. Every color!"
	icon = 'hippiestation/icons/obj/storage.dmi'
	icon_state = "laserpointer_box"
	illustration = null

/obj/item/storage/box/laserpointers/PopulateContents()
	new /obj/item/laser_pointer/red(src)
	new /obj/item/laser_pointer/green(src)
	new /obj/item/laser_pointer/blue(src)
	new /obj/item/laser_pointer/purple(src)