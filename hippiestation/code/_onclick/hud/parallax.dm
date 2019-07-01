/obj/screen/parallax_layer/liquid
	icon = 'hippiestation/icons/effects/parallax.dmi'
	icon_state = "liquid"
	alpha = 100
	blend_mode = BLEND_OVERLAY
	absolute = TRUE //Status of seperation
	speed = 5
	layer = 35

/obj/screen/parallax_layer/liquid/update_status(mob/M)
	if(GLOB.space_reagent)
		invisibility = 0
		var/datum/reagent/R = GLOB.chemical_reagents_list[GLOB.space_reagent]
		if(R && R.color)
			color = R.color
	else
		invisibility = INVISIBILITY_ABSTRACT
