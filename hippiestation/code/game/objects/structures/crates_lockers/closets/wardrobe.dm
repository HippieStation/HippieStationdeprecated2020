/obj/structure/closet/wardrobe/black
	name = "black wardrobe"
	icon_door = "black"

/obj/structure/closet/wardrobe/black/PopulateContents()
	if(prob(40))
		new /obj/item/clothing/neck/cloak/black(src)


/obj/structure/closet/wardrobe/green
	name = "green wardrobe"
	icon_door = "green"

/obj/structure/closet/wardrobe/green/PopulateContents()
	if(prob(40))
		new /obj/item/clothing/neck/cloak/green(src)


/obj/structure/closet/wardrobe/mixed
	name = "mixed wardrobe"
	icon_door = "mixed"

/obj/structure/closet/wardrobe/mixed/PopulateContents()
	if(prob(40))
		new /obj/item/clothing/neck/cloak/black(src)
	if(prob(40))
		new /obj/item/clothing/neck/cloak/green(src)