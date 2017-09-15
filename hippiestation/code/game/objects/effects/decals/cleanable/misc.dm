/obj/effect/decal/cleanable/arc
	name = "charged goo"
	desc = "It's sparking and dangerous!"
	light_color = LIGHT_COLOR_YELLOW
	icon_state = "greenglow"

/obj/effect/decal/cleanable/arc/Crossed(atom/movable/O)
	if(ishuman(O))
		var/mob/living/carbon/human/H = O
		if(H.shoes)
			H.electrocute_act(5, 1, 1, stun = FALSE)
			playsound(H, "sparks", 50, 1)

		else
			H.electrocute_act(10, 1, 1) //extra nasty if you don't wear shoes
			playsound(H, "sparks", 50, 1)