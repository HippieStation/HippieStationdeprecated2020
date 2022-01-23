/obj/item/stack/rods
	tool_behaviour = TOOL_MINING
	toolspeed = 5

/obj/item/stack/broken_rods //Gauss rifle creates these
	name = "Broken rods"
	desc = "These rods look completely deformed."
	icon = 'hippiestation/icons/obj/ammo/ammo.dmi'
	icon_state = "broken_rod"
	item_state = "rods"
	max_amount = 5
	materials = list(MAT_METAL=500)

/obj/item/stack/broken_rods/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_WELDER)
		if(W.use_tool(src, user, 0, volume=40))
			var/obj/item/stack/rods/new_item = new(usr.loc)
			user.visible_message("[user.name] shaped [src] into a rod with [W].", \
						 "<span class='notice'>You shape [src] into a rod with [W].</span>", \
						 "<span class='italics'>You hear welding.</span>")
			var/obj/item/stack/rods/R = src
			src = null
			var/replace = (user.get_inactive_held_item()==R)
			R.use(1)
			if (!R && replace)
				user.put_in_hands(new_item)
	else
		return ..()