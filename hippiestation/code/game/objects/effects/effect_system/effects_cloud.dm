/obj/effect/cloud
	name = "cloud"
	icon = 'hippiestation/icons/effects/32x32.dmi'
	layer = 16

/obj/effect/cloud/New()
	..(loc)
	playsound(loc, 'hippiestation/sound/voice/meeseeksspawn.ogg', 40, type = "voice") // hippie -- additional argument added for sound control options)
	icon_state = "smoke"
	QDEL_IN(src, 12)