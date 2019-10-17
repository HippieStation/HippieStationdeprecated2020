/datum/magic_trait
	var/name
	var/list/typecache

/datum/magic_trait/New()
	..()
	if(LAZYLEN(typecache))
		typecache = typecacheof(typecache)

/datum/magic_trait/proc/has_trait(atom/thing)
	return is_type_in_typecache(thing, typecache)
