/obj/item/paradoxical_vuvuzela
	name = "paradoxical vuvuzela"
	desc = "Only a clown of a mad scientist would think this is a good instrument!"
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	icon_state = "vuvuzaela"
	item_state = "vuvuzela"
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi'
	var/sound_to_play = 'hippiestation/sound/misc/paradox.ogg'
	var/cooldown = 15 SECONDS
	var/next_play = 0

/obj/item/paradoxical_vuvuzela/attack_self(mob/user)
	. = ..()
	if(next_play > world.time)
		to_chat(user, "<span class='notice'>You need to wait [DisplayTimeText(next_play - world.time)] before you can use \the [src] again.</span>")
		return
	user.visible_message("<span class='notice'>[user] blows into \the [src], releasing a horrible sound!</span>", \
		"<span class='notice'>You blow into \the [src], releasing a horrible sound!</span>", \
		"You hear a horrible sound")
	playsound(get_turf(src), sound_to_play, 100, FALSE)
	next_play = world.time + cooldown
