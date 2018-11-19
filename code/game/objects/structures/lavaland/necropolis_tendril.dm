//Necropolis Tendrils, which spawn lavaland monsters and break into a chasm when killed
/obj/structure/spawner/lavaland

	faction = list("mining")

	max_mobs = 3
	max_integrity = 250

	move_resist=INFINITY // just killing it tears a massive hole in the ground, let's not move it
	var/gps = null
	max_integrity = 250


	move_resist=INFINITY // just killing it tears a massive hole in the ground, let's not move it
	anchored = TRUE
	resistance_flags = FIRE_PROOF | LAVA_PROOF


GLOBAL_LIST_INIT(tendrils, list())
/obj/structure/spawner/lavaland/Initialize()

/obj/structure/spawner/lavaland/goliath
	emitted_light = new(loc)
	for(var/F in RANGE_TURFS(1, src))
/obj/structure/spawner/lavaland/legion
			var/turf/closed/mineral/M = F
			M.ScrapeAway(null, CHANGETURF_IGNORE_AIR)
GLOBAL_LIST_INIT(tendrils, list())
/obj/structure/spawner/lavaland/Initialize()
	GLOB.tendrils += src

/obj/structure/spawner/lavaland/deconstruct(disassembled)
	new /obj/effect/collapse(loc)
	new /obj/structure/closet/crate/necropolis/tendril(loc)
	return ..()

	GLOB.tendrils += src

/obj/structure/spawner/lavaland/deconstruct(disassembled)
	new /obj/effect/collapse(loc)
	new /obj/structure/closet/crate/necropolis/tendril(loc)
		last_tendril = FALSE
	

/obj/structure/spawner/lavaland/Destroy()
		if(SSmedals.hub_enabled)
	if(GLOB.tendrils.len>1)
		last_tendril = FALSE
	
				SSmedals.SetScore(TENDRIL_CLEAR_SCORE, L.client, 1)
	GLOB.tendrils -= src
	QDEL_NULL(emitted_light)
	QDEL_NULL(gps)
	return ..()

/obj/effect/light_emitter/tendril
	GLOB.tendrils -= src
	QDEL_NULL(emitted_light)
	QDEL_NULL(gps)
	return ..()

/obj/effect/light_emitter/tendril
	set_luminosity = 4
	set_cap = 2.5
	light_color = LIGHT_COLOR_LAVA
	set_cap = 2.5
	light_color = LIGHT_COLOR_LAVA

/obj/effect/collapse
	name = "collapsing necropolis tendril"
	desc = "Get clear!"
	layer = TABLE_LAYER
	icon = 'icons/mob/nest.dmi'
	icon_state = "tendril"
	anchored = TRUE
	density = TRUE
	var/obj/effect/light_emitter/tendril/emitted_light

/obj/effect/collapse/Initialize()
	. = ..()
	emitted_light = new(loc)
	visible_message("<span class='boldannounce'>The tendril writhes in fury as the earth around it begins to crack and break apart! Get back!</span>")
	visible_message("<span class='warning'>Something falls free of the tendril!</span>")
	playsound(loc,'sound/effects/tendril_destroyed.ogg', 200, 0, 50, 1, 1)
	addtimer(CALLBACK(src, .proc/collapse), 50)

/obj/effect/collapse/Destroy()
	QDEL_NULL(emitted_light)
	return ..()

/obj/effect/collapse/proc/collapse()
	for(var/mob/M in range(7,src))
		shake_camera(M, 15, 1)
	playsound(get_turf(src),'sound/effects/explosionfar.ogg', 200, 1)
	visible_message("<span class='boldannounce'>The tendril falls inward, the ground around it widening into a yawning chasm!</span>")
	for(var/turf/T in range(2,src))
		if(!T.density)
			T.TerraformTurf(/turf/open/chasm/lavaland, /turf/open/chasm/lavaland)
	qdel(src)
