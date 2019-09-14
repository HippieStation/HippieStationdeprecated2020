/mob/dead/unauthed/Logout()
	..()
	qdel(provider)
	qdel(src)
