/obj/structure/closet/secure_closet/mime
	name = "Mime closet"
	desc = "Filled with mime stuff."
	icon = 'hippiestation/icons/obj/closet.dmi'
	req_access = list(ACCESS_THEATRE)
	icon_state = "mime"

/obj/structure/closet/secure_closet/mime/PopulateContents()
	new /obj/item/toy/crayon/mime(src)
	new /obj/item/clothing/head/beret(src)
	new /obj/item/clothing/mask/gas/mime(src)
	new /obj/item/clothing/shoes/sneakers/mime(src)
	new /obj/item/clothing/under/rank/mime(src)
	new /obj/item/storage/backpack/mime(src)
	new /obj/item/clothing/gloves/color/white(src)
	new /obj/item/clothing/suit/suspenders(src)

/obj/structure/closet/secure_closet/clown
	name = "Clown closet"
	icon = 'hippiestation/icons/obj/closet.dmi'
	desc = "Filled with clown stuff."
	req_access = list(ACCESS_THEATRE)
	icon_state = "clown"

/obj/structure/closet/secure_closet/clown/PopulateContents()
	new /obj/item/toy/crayon/rainbow(src)
	new /obj/item/stamp/clown(src)
	new /obj/item/clothing/under/rank/clown(src)
	new /obj/item/clothing/shoes/clown_shoes(src)
	new /obj/item/clothing/mask/gas/clown_hat(src)
	new /obj/item/storage/backpack/clown(src)
	new /obj/item/bikehorn(src)

/obj/structure/closet/secure_closet/discjockey
	name = "DJ closet"
	desc = "Filled with DJ stuff."
	icon = 'hippiestation/icons/obj/closet.dmi'
	icon_state = "DJ"
	req_access = list(ACCESS_DJ)

/obj/structure/closet/secure_closet/discjockey/PopulateContents()
	new /obj/item/cartridge/discjockey(src)
	new /obj/item/clothing/shoes/funk(src)
	new /obj/item/clothing/under/hippie/telvis(src)
	new /obj/item/clothing/head/helmet/daftpunk1(src)
	new /obj/item/clothing/head/helmet/daftpunk2(src)
