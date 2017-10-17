//see: https://github.com/HippieStation/HippieStation/blob/fix-lag/code/_globalvars/lists/typecache.dm
//please store common type caches here.
//type caches should only be stored here if used in mutiple places or likely to be used in mutiple places.

//Note: typecache can only replace istype if you know for sure the thing is at least a datum.

GLOBAL_LIST_INIT(holder_blacklist_typecache, typecacheof(list(
  /obj/effect/particle_effect,
  /obj/effect/decal/cleanable,
  /mob/living,
  /obj/item/reagent_containers/food)
))
