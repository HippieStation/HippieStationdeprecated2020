/obj/item/implant/breaker
	name = "improvised implant breaker"
	desc = "When implanted, it will destroy all other implants."
	activated = 0

/obj/item/implant/breaker/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Implant breaker implant<BR>
				<b>Life:</b> A few seconds after injection.<BR>
				<b>Important Notes:</b> Illegal<BR>
				<HR>
				<b>Implant Details:</b><BR>
				<b>Function:</b> This device will emit a small EMP pulse, destroying any other implants within the host's brain.<BR>
				<b>Special Features:</b> None.<BR>
				<b>Integrity:</b> Implant's EMP function will destroy itself in the process."}
	return dat

/obj/item/implant/breaker/implant(mob/living/target, mob/user, silent = 0)
	if(!target || !target.mind || target.stat == DEAD)
		return 0
	if(..())
		for(var/obj/item/implant/I in target.implants)
			if(I != src)
				qdel(I)
		qdel(src) // put this if you want to del it after use
		return TRUE

/obj/item/implanter/breaker
	name = "implanter (improvised implant breaker)"
	desc = "When implanted, it will destroy all other implants."

/obj/item/implanter/breaker/Initialize(loc)
	imp = new /obj/item/implant/breaker(src)
	.=..()

/obj/item/implanter/breaker/attack(mob/living/M, mob/user)
	var/failchance = rand(1, 5)
	if(failchance != 5)
		if(!istype(M))
			return
		if(user && imp)
			if(M != user)
				M.visible_message("<span class='warning'>[user] is attempting to implant [M].</span>")

			var/turf/T = get_turf(M)
			if(T && (M == user || do_mob(user, M, 50)))
				if(src && imp)
					if(imp.implant(M, user))
						if (M == user)
							to_chat(user, "<span class='notice'>You implant yourself.</span>")
						else
							M.visible_message("[user] has implanted [M].", "<span class='notice'>[user] implants you.</span>")
						imp = null
						update_icon()
					else
						to_chat(user, "<span class='warning'>[src] fails to implant [M].</span>")
	else
		imp = null
		update_icon()
		visible_message(src, "<span class ='warning'>The poorly constructed [src] malfunctions and the implant breaks!")