/datum/magic_trait/fire
	name = "Fire"
	typecache = list(
		/obj/effect/hotspot, // wow! you can ignite a real plasmafire to get this trait!
		/obj/item/flashlight/flare,
		/obj/structure/bonfire,
		/obj/item/lava_staff
	)

/datum/magic_trait/fire/has_trait(atom/thing)
	if(isliving(thing))
		var/mob/living/L = thing
		return L.on_fire && (L.fire_stacks > 1)
	return ..()
