/datum/magic_trait/light
	name = "Light"
	typecache = list(
		/obj/item/flashlight,
		/obj/item/organ/eyes/robotic/glow
	)

/datum/magic_trait/light/has_trait(atom/thing)
	if(istype(thing, /obj/item/light))
		var/obj/item/light/L = thing
		return L.status == LIGHT_OK
	return ..()
