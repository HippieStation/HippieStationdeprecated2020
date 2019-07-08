/obj/item/stack/redshard
	name = "Aja Shard"
	desc = "An imperfect piece of a perfect stone."
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	icon_state = "aja1"
	max_amount = 4

/obj/item/stack/redshard/update_icon()
	icon_state = "aja[amount]"

/obj/item/stack/redshard/add(amount)
	. = ..()
	if(amount >= 4)
		visible_message("<span class='hypnophrase big'>[src] begins to glow brilliantly as the final piece is united!</span>")
		new /obj/item/redstone(loc)
		qdel(src)

/obj/item/redstone
	name = "Red Stone of Aja"
	desc = "A perfect gemstone, filled with immense power."
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	icon_state = "aja"
