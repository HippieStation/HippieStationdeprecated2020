/obj/item/dildo
	name = "Bad Dragon"
	desc = "You really shouldn't see this.. but if you do... Huzzah.. you found a bug..."
	icon = 'hippiestation/icons/obj/dicks.dmi'
	icon_state = null
	force = 1
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 2
	throw_speed = 4
	embedding = list("embed_chance" = 25, "embedded_pain_multiplier" = 1, "embedded_fall_pain_multiplier" = 1, "embedded_impact_pain_multiplier" = 1, "embedded_unsafe_removal_pain_multiplier" = 1)
	hitsound = 'hippiestation/sound/misc/squishy.ogg'
	attack_verb = list("slapped")

/obj/item/dragon/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is shoving [src] down [user.p_their()] throat! It looks like they're trying to commit suicide.</span>")
	return(OXYLOSS)

/obj/item/dildo/sea
	name = "Sea Dragon Dildo"
	desc = "It's damp."
	icon_state = "seadragon"

/obj/item/dildo/canine
	name = "Canine Dildo"
	desc = "Taking the phrase \"dogging your mates\" to a whole new level."
	icon_state = "canine"

/obj/item/dildo/equine
	name = "Equine Dildo"
	desc = "Yes, it's the whole horse."
	icon_state = "equine"
	throw_speed = 5
	embedding = list("embed_chance" = 30)

/obj/structure/statue/dildo/shelf
	name = "Dragon Dildo Shelf"
	desc =  "Built to withstand your collection and your sins."
	icon = 'hippiestation/icons/obj/dicks.dmi'
	icon_state = "shelf1"

/obj/structure/statue/dildo/shelf/alt
	icon_state = "shelf2"