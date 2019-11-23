/obj/item/melee/shank
	name = "shank"
	desc = "A nasty looking shard of glass. There's duct tape over one of the ends."
	icon = 'hippiestation/icons/obj/weapons.dmi'
	icon_state = "shank"
	force = 10 //Average force
	throwforce = 10
	throw_speed = 4
	w_class = WEIGHT_CLASS_TINY
	item_state = "shard-glass"
	attack_verb = list("stabbed", "shanked", "sliced", "cut")
	siemens_coefficient = 0 //Means it's insulated
	embedding = list("embed_chance" = 10)
	sharpness = IS_SHARP

/obj/item/shard/shank/attack_self(mob/user)
	playsound(user, 'hippiestation/sound/misc/ducttape2.ogg', 50, 1)
	var/obj/item/shard/new_item = new(user.loc)
	to_chat(user, "<span class='notice'>You take the duct tape off the [src].</span>")
	qdel(src)
	user.put_in_hands(new_item)

/datum/crafting_recipe/naturalpaper
	name = "Hand-Pressed Paper"
	tools = null //because it's weird that you need a hatchet to turn it into paper, not to mention there is no hatchet you can build with the resources on lavaland. For better minecrafting as hermit.