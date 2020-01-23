/proc/get_area_by_type(N) // This is only here due to the shittiness of locate in world, and the fact that infiltrators seem to love throwing their objectives on the table.
	for(var/area/A in world)
		if(A.type == N)
			return A
	return FALSE

#define SIGNV(X) ((X<0)?-1:1)

// checks if there are any dense objects between two coordinates
/proc/inLineOfMovement(X1,Y1,X2,Y2,Z=1,PX1=16.5,PY1=16.5,PX2=16.5,PY2=16.5)
	var/turf/T
	if(X1==X2)
		if(Y1==Y2)
			return 1 //Cannot be blocked on same tile
		else
			var/s = SIGN(Y2-Y1)
			Y1+=s
			while(Y1!=Y2)
				T=locate(X1,Y1,Z)
				if(T.density)
					return 0
				for(var/obj/O in T)
					if(O.density)
						return 0
				Y1+=s
	else
		var/m=(32*(Y2-Y1)+(PY2-PY1))/(32*(X2-X1)+(PX2-PX1))
		var/b=(Y1+PY1/32-0.015625)-m*(X1+PX1/32-0.015625) //In tiles
		var/signX = SIGN(X2-X1)
		var/signY = SIGN(Y2-Y1)
		if(X1<X2)
			b+=m
		while(X1!=X2 || Y1!=Y2)
			if(round(m*X1+b-Y1))
				Y1+=signY //Line exits tile vertically
			else
				X1+=signX //Line exits tile horizontally
			T=locate(X1,Y1,Z)
			if(T.density)
				return 0
			for(var/obj/O in T)
				if(O.density)
					return 0
	return 1
#undef SIGNV

// checks if there are any dense objects between two atoms
/proc/isNotBlocked(atom/A, atom/B)
	var/turf/Aturf = get_turf(A)
	var/turf/Bturf = get_turf(B)

	if(!Aturf || !Bturf)
		return 0

	if(inLineOfMovement(Aturf.x,Aturf.y, Bturf.x,Bturf.y,Aturf.z))
		return 1

	else
		return 0
