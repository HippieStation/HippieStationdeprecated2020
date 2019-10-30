/obj/structure/statue/sandstone/asstue
	name = "giant stone ass"
	desc = "On Saturday, August 4th, 2018 the toolbox was thrown down by the people of tgstation,\
	 three randomly selected hippies took up the challenge and stood poised to fight the tg menace. \
	 They failed miserably and bought shame upon our once proud station. We have made this giant ass \
	 statue to commemorate their failure and the giant ass they made of us. \
	 Pyko, Frozenguy5, EagleEyes: their names etched upon this stone butt for all eternity."
	icon = 'hippiestation/icons/obj/statue.dmi'
	icon_state = "asstue"

/obj/structure/statue/sandstone/asstue/proc/toot()
	playsound(src, 'hippiestation/sound/effects/fart.ogg', 100, 1)

/obj/structure/statue/sandstone/asstue/Bumped(atom/movable/AM)
	toot()
	..()

/obj/structure/statue/sandstone/asstue/attackby(obj/item/W, mob/user, params)
	toot()
	return ..()

/obj/structure/statue/sandstone/asstue/attack_hand(mob/user)
	toot()
	. = ..()

/obj/structure/statue/sandstone/asstue/attack_paw(mob/user)
	toot()
	..()

/obj/structure/statue/sandstone/asstue/deconstruct(disassembled = TRUE)
	playsound(src, 'hippiestation/sound/effects/superfart.ogg', 200, 1)
	..()
