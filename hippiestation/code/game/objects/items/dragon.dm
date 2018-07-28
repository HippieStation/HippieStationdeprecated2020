/obj/item/dragon
	name = "Bad Dragon"
	desc = "You really shouldn't see this.. but if you do... Huzzah.. you found a bug..."
	icon = 'hippiestation/icons/obj/dicks.dmi'
	icon_state = null
	force = 1
	w_class = 1
	throwforce = 2
	throw_speed = 4
	hitsound = 'hippiestation/sound/misc/squishy.ogg'
	attack_verb = list("slapped")

/obj/item/dragon/suicide_act(mob/user)
	user.visible_message(pick("<span class='suicide'>[user] is shoving [src.name] down \his throat! It looks like they're trying to commit suicide.</span>"))
	return(BRUTELOSS)

/obj/item/dragon/sea
	name = "Sea Dragon Dildo"
	desc = "It's damp."
	icon_state = "seadragon"
	force = 1
	throwforce = 2
	throw_speed = 4
	embedding = list("embed_chance" = 30)

/obj/item/dragon/canine
	name = "Canine Dildo"
	desc = "Taking the phrase \"dogging your mates\" to a whole new level."
	icon_state = "canine"
	force = 1
	throwforce = 2
	throw_speed = 4
	embedding = list("embed_chance" = 30)

/obj/item/dragon/equine
	name = "Equine Dildo"
	desc = "Yes, it's the whole horse."
	icon_state = "equine"
	force = 1
	throwforce = 3
	throw_speed = 5
	embedding = list("embed_chance" = 40)

/obj/structure/statue/dragon/shelf
	name = "Dragon Dildo Shelf"
	desc =  "Built to withstand your collection and your sins."
	icon = 'hippiestation/icons/obj/dicks.dmi'
	icon_state = "shelf1"

/obj/structure/statue/dragon/shelf/alt
	name = "Dragon Dildo Shelf"
	desc =  "Built to withstand your collection and your sins."
	icon_state = "shelf2"