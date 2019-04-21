/obj/effect/forcefield
	desc = "A space wizard's magic wall."
	name = "FORCEWALL"
	icon_state = "m_shield"
	anchored = TRUE
	opacity = 0
	density = TRUE
	CanAtmosPass = ATMOS_PASS_DENSITY
	var/timeleft = 300 //Set to 0 for permanent forcefields (ugh)

/obj/effect/forcefield/Initialize()
	. = ..()
	if(timeleft)
		QDEL_IN(src, timeleft)

/obj/effect/forcefield/singularity_pull()
	return

/obj/effect/forcefield/cult
	desc = "An unholy shield that blocks all attacks."
	name = "glowing wall"
	icon = 'icons/effects/cult_effects.dmi'
	icon_state = "cultshield"
	CanAtmosPass = ATMOS_PASS_NO
	timeleft = 200

obj/effect/forcefield/centcom_dock
	name = "Bluespace Shield"
	desc = "Advanced forcefields employed by Central Command to stop trespassing when all other methods have failed."
	CanAtmosPass = ATMOS_PASS_NO
	timeleft = 0

/obj/effect/forcefield/centcom_dock/Initialize()
    . = ..()
    GLOB.centcom_forcefields += src

/obj/effect/forcefield/centcom_dock/Destroy()
    GLOB.centcom_forcefields -= src
    return ..()

///////////Mimewalls///////////

/obj/effect/forcefield/mime
	icon_state = "nothing"
	name = "invisible wall"
	desc = "You have a bad feeling about this."

/obj/effect/forcefield/mime/advanced
	name = "invisible blockade"
	desc = "You're gonna be here awhile."
	timeleft = 600
