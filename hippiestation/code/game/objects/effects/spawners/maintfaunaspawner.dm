/obj/effect/spawner/maintfauna
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x2"
	layer = OBJ_LAYER
	var/faunacount = 1		//how many items will be spawned
	var/faunadoubles = TRUE	//if the same item can be spawned twice
	var/list/fauna			//a list of possible items to spawn e.g. list(/obj/item, /obj/structure, /obj/effect)
	var/fan_out_fauna = FALSE //Whether the items should be distributed to offsets 0,1,-1,2,-2,3,-3.. This overrides pixel_x/y on the spawner itself

/obj/effect/spawner/maintfauna/Initialize(mapload)
	..()
	if(fauna && fauna.len)
		var/turf/T = get_turf(src)
		var/fauna_spawned = 0
		while((faunacount-fauna_spawned) && fauna.len)
			var/faunaspawn = pickweight(fauna)
			if(!faunadoubles)
				fauna.Remove(faunaspawn)

			if(faunaspawn)
				var/atom/movable/spawned_fauna = new faunaspawn(T)
				if (!fan_out_fauna)
					if (pixel_x != 0)
						spawned_fauna.pixel_x = pixel_x
					if (pixel_y != 0)
						spawned_fauna.pixel_y = pixel_y
				else
					if (fauna_spawned)
						spawned_fauna.pixel_x = spawned_fauna.pixel_y = ((!(fauna_spawned%2)*fauna_spawned/2)*-1)+((fauna_spawned%2)*(fauna_spawned+1)/2*1)
			fauna_spawned++
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/maintfauna/massmaintenanceshroom
	name = "mass maintenance mushroom spawner"
	faunadoubles = TRUE
	fan_out_fauna = TRUE
	fauna = list(
				/obj/structure/flora/maintenanceshroom/redmushroom = 1,
				/obj/structure/flora/maintenanceshroom/greenmushroom = 2,
				/obj/structure/flora/maintenanceshroom/purplemushroom = 2)

/obj/effect/spawner/maintfauna/massmaintenanceshroom/Initialize(mapload)
	faunacount = rand(1,5)	//Calling functions in a definition doesn't even work wtf DM shitcode
	. = ..()	//Otherwise we won't call how initialize works, nor will we call the initialize that's supposed to work for all of these spawners


/obj/effect/spawner/maintfauna/singlemaintenanceshroom
	name = "single maintenance mushroom spawner"
	fauna = list(
				/obj/structure/flora/maintenanceshroom/redmushroom = 1,
				/obj/structure/flora/maintenanceshroom/greenmushroom = 2,
				/obj/structure/flora/maintenanceshroom/purplemushroom = 2)