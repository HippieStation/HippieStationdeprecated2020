// - hsv to rgb - //
/obj/item/integrated_circuit/converter/hsv2rgb
	name = "hsv to rgb"
	desc = "This circuit can convert a HSV (Hue, Saturation, and Value) color to a RGB (red, blue and green) color."
	extended_desc = "The first pin controls tint (0-359), the second pin controls how intense the tint is (0-255), and the third controls how bright the tint is (0 for black, 127 for normal, 255 for white)."
	icon_state = "hsv-hex"
	inputs = list(
		"hue" = IC_PINTYPE_NUMBER,
		"saturation" = IC_PINTYPE_NUMBER,
		"value" = IC_PINTYPE_NUMBER
	)
	outputs = list(
		"red" = IC_PINTYPE_NUMBER,
		"green" = IC_PINTYPE_NUMBER,
		"blue" = IC_PINTYPE_NUMBER
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/hsv2rgb/do_work()
	var/hue = get_pin_data(IC_INPUT, 1)
	var/sat = get_pin_data(IC_INPUT, 2)
	var/val = get_pin_data(IC_INPUT, 3)
	if(!hue || !sat || !val)
		set_pin_data(IC_OUTPUT, 1, 0)
		set_pin_data(IC_OUTPUT, 2, 0)
		set_pin_data(IC_OUTPUT, 3, 0)
	else
		var/list/RGB = ReadRGB(HSVtoRGB(hsv(hue,sat,val)))
	
		set_pin_data(IC_OUTPUT, 1, RGB[1])
		set_pin_data(IC_OUTPUT, 2, RGB[2])
		set_pin_data(IC_OUTPUT, 3, RGB[3])
	push_data()
	activate_pin(2)


// - rgb to hsv - //
/obj/item/integrated_circuit/converter/rgb2hsv
	name = "rgb to hsv"
	desc = "This circuit can convert a RGB (Red, Blue, and Green) color to a HSV (Hue, Saturation and Value) color."
	extended_desc = "All values for the RGB colors are situated between 0 and 255."
	icon_state = "hsv-hex"
	inputs = list(
		"red" = IC_PINTYPE_NUMBER,
		"green" = IC_PINTYPE_NUMBER,
		"blue" = IC_PINTYPE_NUMBER
	)
	outputs = list(
		"hue" = IC_PINTYPE_NUMBER,
		"saturation" = IC_PINTYPE_NUMBER,
		"value" = IC_PINTYPE_NUMBER
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/rgb2hsv/do_work()
	var/red = get_pin_data(IC_INPUT, 1)
	var/blue = get_pin_data(IC_INPUT, 2)
	var/green = get_pin_data(IC_INPUT, 3)
	if(!red || !blue || !green)
		set_pin_data(IC_OUTPUT, 1, 0)
		set_pin_data(IC_OUTPUT, 2, 0)
		set_pin_data(IC_OUTPUT, 3, 0)
	else
		var/list/HSV = ReadHSV(RGBtoHSV(rgb(red,blue,green)))
	
		set_pin_data(IC_OUTPUT, 1, HSV[1])
		set_pin_data(IC_OUTPUT, 2, HSV[2])
		set_pin_data(IC_OUTPUT, 3, HSV[3])
	push_data()
	activate_pin(2)


// - hexadecimal to hsv - //
/obj/item/integrated_circuit/converter/hex2hsv
	name = "hexadecimal to hsv"
	desc = "This circuit can convert a Hexadecimal RGB color into a HSV (Hue, Saturation and Value) color."
	extended_desc = "Hexadecimal colors follow the format #RRBBGG, RR being the red value, BB the blue value and GG the green value. They are written in hexadecimal, giving each color a value from 0 (00) to 255 (FF)."
	icon_state = "hsv-hex"
	inputs = list("hexadecimal rgb" = IC_PINTYPE_COLOR)
	outputs = list(
		"hue" = IC_PINTYPE_NUMBER,
		"saturation" = IC_PINTYPE_NUMBER,
		"value" = IC_PINTYPE_NUMBER
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/hex2hsv/do_work()
	pull_data()
	var/rgb = get_pin_data(IC_INPUT, 1)
	if(!rgb)
		set_pin_data(IC_OUTPUT, 1, 0)
		set_pin_data(IC_OUTPUT, 2, 0)
		set_pin_data(IC_OUTPUT, 3, 0)
		return
	else
		var/list/hsv = ReadHSV(RGBtoHSV(rgb))
		set_pin_data(IC_OUTPUT, 1, hsv[1])
		set_pin_data(IC_OUTPUT, 2, hsv[2])
		set_pin_data(IC_OUTPUT, 3, hsv[3])
	push_data()
	activate_pin(2)


// - hex 2 rgb - //
/obj/item/integrated_circuit/converter/hex2rgb
	name = "hexadecimal to rgb"
	desc = "This circuit can convert a Hexadecimal RGB color into a RGB (Red, Blue and Green color."
	extended_desc = "Hexadecimal colors follow the format #RRBBGG, RR being the red value, BB the blue value and GG the green value. They are written in hexadecimal, giving each color a value from 0 (00) to 255 (FF)."
	icon_state = "hsv-hex"
	inputs = list("hexadecimal rgb" = IC_PINTYPE_COLOR)
	outputs = list(
		"red" = IC_PINTYPE_NUMBER,
		"green" = IC_PINTYPE_NUMBER,
		"blue" = IC_PINTYPE_NUMBER
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/hex2rgb/do_work()
	var/rgb = get_pin_data(IC_INPUT, 1)
	if(!rgb)
		set_pin_data(IC_OUTPUT, 1, 0)
		set_pin_data(IC_OUTPUT, 2, 0)
		set_pin_data(IC_OUTPUT, 3, 0)
	else
		var/list/RGB = ReadRGB(rgb)
	
		set_pin_data(IC_OUTPUT, 1, RGB[1])
		set_pin_data(IC_OUTPUT, 2, RGB[2])
		set_pin_data(IC_OUTPUT, 3, RGB[3])
	push_data()
	activate_pin(2)
