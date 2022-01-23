/obj/item/nullrod/Initialize()
	. = ..()
	var/datum/component/AM = GetComponent(/datum/component/anti_magic)
	AM.RemoveComponent()

/obj/item/nullrod/fedora/attack_self(mob/user)
	user.visible_message("<span class='danger'>[user] tips [user.p_their()] [name]!</span>")
	..() //incase an admin allows you to reset the rod

/obj/item/nullrod/scythe/talking/chainsword
	icon_state = "chainswordon"
	item_state = "chainswordon"
	name = "possessed chainsaw sword"
	desc = "Suffer not a heretic to live."
	chaplain_spawnable = TRUE
	force = 18
	slot_flags = ITEM_SLOT_BELT
	attack_verb = list("sawed", "torn", "cut", "chopped", "diced")
	hitsound = 'sound/weapons/chainsawhit.ogg'
	
/obj/item/nullrod/monk_manual
	chaplain_spawnable = FALSE
