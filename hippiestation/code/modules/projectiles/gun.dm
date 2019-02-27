/obj/item/gun/proc/replace_pin(var/gun, var/firing_pin = /obj/item/firing_pin)	//Change any ballistic gun's firing clip to a clip of your choosing! Default is normal clip
	if(gun && firing_pin)	//If actually a gun, and a firing clip path has been set
		pin = firing_pin
	else if(!gun)
		EXCEPTION("A firing pin change was attempted without a firing clip being selected")
	else
		EXCEPTION("A firing pin change was attempted on an item that is not a gun")