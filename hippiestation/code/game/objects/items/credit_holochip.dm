/obj/item/holochip
	name = "cash money"
	desc = "Space Dollar bills issued by the Nanotrasen Interstellar Bank."
	icon = 'hippiestation/icons/obj/economy.dmi'

/obj/item/holochip/update_icon()
	name = "\improper [credits] credit holochip"
	var/rounded_credits = credits
	switch(credits)
		if(1 to 999)
			icon_state = "holochip"
		if(1000 to 999999)
			icon_state = "holochip_kilo"
			rounded_credits = round(rounded_credits * 0.001)
		if(1000000 to 999999999)
			icon_state = "holochip_mega"
			rounded_credits = round(rounded_credits * 0.000001)
		if(1000000000 to INFINITY)
			icon_state = "holochip_giga"
			rounded_credits = round(rounded_credits * 0.000000001)
	var/overlay_color = "#914792"
	switch(rounded_credits)
		if(0 to 4)
			overlay_color = "#8E2E38"
		if(5 to 9)
			overlay_color = "#914792"
		if(10 to 19)
			overlay_color = "#BF5E0A"
		if(20 to 49)
			overlay_color = "#358F34"
		if(50 to 99)
			overlay_color = "#676767"
		if(100 to 199)
			overlay_color = "#009D9B"
		if(200 to 499)
			overlay_color = "#0153C1"
		if(500 to INFINITY)
			overlay_color = "#2C2C2C"
	cut_overlays()
	var/mutable_appearance/holochip_overlay = mutable_appearance('hippiestation/icons/obj/economy.dmi', "[icon_state]-color")
	holochip_overlay.color = overlay_color
	add_overlay(holochip_overlay)