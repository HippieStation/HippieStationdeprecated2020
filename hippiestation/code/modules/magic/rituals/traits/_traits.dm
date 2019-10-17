/datum/magic_trait
	var/name
	var/typecache

/datum/magic_trait/proc/has_trait(atom/thing)
	return is_type_in_typecache(thing, typecache)
