//Effects used for anything holy and divine currently used for smite and spawming a admin dummy... maybe for holy explosion one day
/obj/effect/holy
	name = "holy"
	icon = 'icons/hippie/effects/holy.dmi'
	layer = MOB_LAYER+1
	use_fade = FALSE
	mouse_opacity = 0
	pixel_x = -32
	pixel_y = 0
	var/holystate = "beamin"
	var/holysound = 'sound/effects/pray.ogg'

	proc/start(atom/location)
		loc = get_turf(location)
		flick(holystate,src)
		playsound(src,holysound,50,1)
		addtimer(CALLBACK(src, .proc/destroy_effect), 20)

/obj/effect/holy/lightning
	name = "divine retribution"
	pixel_x = -96
	pixel_y = -32
	holystate = "lightning"
	holysound = 'sound/effects/thunder.ogg'
