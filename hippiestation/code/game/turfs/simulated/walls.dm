/turf/closed/wall
	icon_hippie = 'hippiestation/icons/turf/walls/wall.dmi'

//Circuitry proc overwrite for wall assemblies
/turf/closed/wall/try_wallmount(obj/item/W, mob/user, turf/T)
	if(istype(W, /obj/item/electronic_assembly/wallmount))
		var/obj/item/electronic_assembly/wallmount/A = W
		A.mount_assembly(src, user)
		return TRUE
	else
		return(..())
