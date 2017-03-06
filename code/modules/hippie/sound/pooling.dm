#define POOL_HIT_COUNT 1
#define POOL_MISS_COUNT 2
#define POOLINGS 3
#define UNPOOLINGS 4
#define EVICTIONS 5
#define DEFAULT_POOL_SIZE 50

#ifdef DETAILED_POOL_STATS
var/global/list/pool_stats = list()

proc/increment_pool_stats(var/type, var/index)
	if(!type || index < 1 || index > 5)
		return
	var/list/L = pool_stats[type]
	if(!L)
		L = list(0,0,0,0,0)

		pool_stats[type] = L

	L[index]++


#endif


/datum/var/tmp/disposed = 0
/datum/var/tmp/qdeled = 0

/datum/Del()
	if (!disposed)
		disposer()
	..()

// override this in children for your type specific disposing implementation, make sure to call ..() so the root disposing runs too
/datum/proc/disposing()

// don't override this one, just call it instead of delete to get rid of something cheaply
/datum/proc/disposer()
	if (!disposed)
		disposing()
		disposed = 1

// for caching/reusing
/datum/proc/pooled(var/pooltype)
	disposer()
	// If this thing went through the delete queue and was rescued by the pool mechanism, we should reset the qdeled flag.
	qdeled = 0

/datum/proc/unpooled(var/pooltype)
	disposed = 0

var/list/pool_limit_overrides = null

var/list/object_pools = list()


proc/get_pool_size_limit(var/type)
	if(!pool_limit_overrides)
		pool_limit_overrides = list(/sound = 300)
	. = pool_limit_overrides[type]
	if(!.) . = DEFAULT_POOL_SIZE

proc/unpool(var/type=null)
	if(!type)
		return null //Uh, here's your unpooled null. You weirdo.

	#ifdef DETAILED_POOL_STATS
	increment_pool_stats(type, UNPOOLINGS)
	#endif

	var/list/l = object_pools[type]
	if(!l) //Didn't have a pool
		l = createPool(type)

	if(!l.len) //Didn't have anything in the pool
		#ifdef DETAILED_POOL_STATS
		increment_pool_stats(type, POOL_MISS_COUNT)
		#endif
		return new type

	var/datum/thing = l[l.len]
	if (!thing) //This should not happen, but I guess it did.
		l.len-- // = 0
		#ifdef DETAILED_POOL_STATS
		increment_pool_stats(type, POOL_MISS_COUNT)
		#endif
		return new type

	else //Take the thing out of the pool and return it
		l.len-- //Remove(thing)
		#ifdef DETAILED_POOL_STATS
		increment_pool_stats(type, POOL_HIT_COUNT)
		#endif
		thing.unpooled(type)
	return thing

proc/createPool(var/type)
	if(!object_pools[type])
		object_pools[type] = list()
	return object_pools[type]

proc/pool(var/datum/to_pool)
	if (to_pool)

		var/list/type_pool = object_pools[to_pool.type]
		if(!type_pool)
			type_pool = createPool(to_pool.type)


		if(type_pool.len < get_pool_size_limit(to_pool.type))
			#ifdef DETAILED_POOL_STATS
			increment_pool_stats(to_pool.type, POOLINGS)
			#endif
			type_pool += to_pool
			to_pool.pooled(to_pool.type)
		else
			#ifdef DETAILED_POOL_STATS
			increment_pool_stats(to_pool.type, EVICTIONS)
			#endif
			qdel(to_pool)


#ifdef DETAILED_POOL_STATS

proc/getPoolingJson()
	var/json = "\[{path:null,count:0,hits:0,misses:0,poolings:0,unpoolings:0,evictions:0}"
	for(var/type in pool_stats)
		var/count = 0
		var/list/L = object_pools[type]
		if(L) count = L.len
		L = pool_stats[type]

		json += ",{path:'[type]',count:[count],hits:[L[POOL_HIT_COUNT]],misses:[L[POOL_MISS_COUNT]],poolings:[L[POOLINGS]],unpoolings:[L[UNPOOLINGS]],evictions:[L[EVICTIONS]]}"
	json += "]"

	//usr << browse(json, "window=teststuff")
	return json

#endif

#undef POOL_HIT_COUNT
#undef POOL_MISS_COUNT
#undef POOLINGS
#undef UNPOOLINGS
#undef EVICTIONS
