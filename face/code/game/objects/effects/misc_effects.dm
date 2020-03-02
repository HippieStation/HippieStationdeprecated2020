//Special forcefield for CentCom that deletes itself at round end when escape shuttle docks. Original code in forcefields.dm

obj/effect/forcefield/centcom_dock
	name = "Bluespace Shield"
	desc = "Advanced forcefields employed by Central Command to stop trespassing when all other methods have failed."
	CanAtmosPass = ATMOS_PASS_NO
	timeleft = 0
	alpha = 100 //Less obnoxious

/obj/effect/forcefield/centcom_dock/Initialize()
    . = ..()
    GLOB.centcom_forcefields += src

/obj/effect/forcefield/centcom_dock/Destroy()
    GLOB.centcom_forcefields -= src
    return ..()
