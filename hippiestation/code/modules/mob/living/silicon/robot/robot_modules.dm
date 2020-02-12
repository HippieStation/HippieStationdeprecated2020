/obj/item/robot_module
    var/hippie_cyborg_base_icon
// I know changing this might bite me in the ass, but nobody has touched it since I first coded this so I'M HOPING that future yske will have to deal with this rather then me. Fuck you, future yske. - past yske
/obj/item/robot_module/standard/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/R = loc
	alternate_screams = list('face/sound/screams/silicon/standard1.ogg','face/sound/screams/silicon//standard2.ogg','face/sound/screams/silicon/standard3.ogg','face/sound/screams/silicon/standard4.ogg','face/sound/screams/silicon/standard5.ogg')
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Standard", "Classic Style", "Hydro-bot", "Captain")
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Standard")
			hippie_cyborg_base_icon = "robot"
		if("Classic Style")
			hippie_cyborg_base_icon = "robot_old"
		if("Hydro-bot")
			hippie_cyborg_base_icon = "Hydrobot"
		if("Captain")
			hippie_cyborg_base_icon = "captainborg"
	return ..()

/obj/item/robot_module/medical/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/R = loc
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Standard", "Classic", "Humanoid")
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Standard")
			hippie_cyborg_base_icon = "medical"
		if("Classic")
			hippie_cyborg_base_icon = "Medbot"
		if("Humanoid")
			hippie_cyborg_base_icon = "cmoborg"
	return ..()

/obj/item/robot_module/security/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/R = loc
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Standard", "Classic", "Humanoid", "Black Scheme Humanoid", "PISSED OFF BEEPSKY")
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Standard")
			hippie_cyborg_base_icon = "sec"
		if("Classic")
			hippie_cyborg_base_icon = "secborg"
		if("Humanoid")
			hippie_cyborg_base_icon = "Security"
		if("Black Scheme Humanoid")
			hippie_cyborg_base_icon = "hosborg"
		if("PISSED OFF BEEPSKY")
			hippie_cyborg_base_icon = "secbot0"
	return ..()


/obj/item/robot_module/engineering/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/R = loc
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Standard", "Classic Style", "Tech-Priest", "Super Oldschool", "Thicc", "Humanoid")
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Standard")
			hippie_cyborg_base_icon = "engineer"
		if("Classic Style")
			hippie_cyborg_base_icon = "Engineering_old"
		if("Tech-Priest")
			hippie_cyborg_base_icon = "Engineering2"
		if("Super Oldschool")
			hippie_cyborg_base_icon = "engineering_drone"
			special_light_key = "medical"
			hat_offset = 3
		if("Thicc")
			hippie_cyborg_base_icon = "Engineering3"
			special_light_key = null
			hat_offset = INFINITY //He is already wearing a hat
		if("Humanoid")
			hippie_cyborg_base_icon = "ceborg"
	return ..()

/obj/item/robot_module/janitor/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/R = loc
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Standard", "Classic", "Botany Style")
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Standard")
			hippie_cyborg_base_icon = "janitor"
		if("Classic")
			hippie_cyborg_base_icon = "JanBot2"
		if("Botany Style")
			hippie_cyborg_base_icon = "botany"
	return ..()


/obj/item/robot_module/miner/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/R = loc
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Lavaland Colours", "Asteroid Colours", "Classic Skin", "Humanoid Borg")
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Asteroid Colours")
			hippie_cyborg_base_icon = "minerOLD"
		if("Classic Skin")
			hippie_cyborg_base_icon = "Miner_old"
		if("Lavaland Colours")
			hippie_cyborg_base_icon = "miner"
		if("Research Humanoid Borg")
			hippie_cyborg_base_icon = "rdborg"
			special_light_key = null
			hat_offset = INFINITY //I'm very lazy

	return ..()