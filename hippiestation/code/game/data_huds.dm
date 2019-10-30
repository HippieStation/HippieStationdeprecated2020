/*~~~~~~~~~~~~
	Circutry!
~~~~~~~~~~~~~*/
/obj/item/electronic_assembly/proc/diag_hud_set_circuithealth(hide = FALSE)
	var/image/holder = hud_list[DIAG_CIRCUIT_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	if((!isturf(loc))||hide) //if not on the ground dont show overlay
		holder.icon_state = null
	else
		holder.icon_state = "huddiag[RoundDiagBar(obj_integrity/max_integrity)]"

/obj/item/electronic_assembly/proc/diag_hud_set_circuitcell(hide = FALSE)
	var/image/holder = hud_list[DIAG_BATT_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	if((!isturf(loc))||hide) //if not on the ground dont show overlay
		holder.icon_state = null
	else if(battery)
		var/chargelvl = battery.charge/battery.maxcharge
		holder.icon_state = "hudbatt[RoundDiagBar(chargelvl)]"
	else
		holder.icon_state = "hudnobatt"

/obj/item/electronic_assembly/proc/diag_hud_set_circuitstat(hide = FALSE) //On, On and dangerous, or Off
	var/image/holder = hud_list[DIAG_STAT_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	if((!isturf(loc))||hide) //if not on the ground don't show overlay
		holder.icon_state = null
	else if(!battery)
		holder.icon_state = "hudoffline"
	else if(battery.charge == 0)
		holder.icon_state = "hudoffline"
	else if(combat_circuits) //has a circuit that can harm people
		holder.icon_state = prefered_hud_icon + "-red"
	else //Bot is on and not dangerous
		holder.icon_state = prefered_hud_icon

/obj/item/electronic_assembly/proc/diag_hud_set_circuittracking(hide = FALSE)
	var/image/holder = hud_list[DIAG_TRACK_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	if((!isturf(loc))||hide) //if not on the ground dont show overlay
		holder.icon_state = null
	else if(long_range_circuits)
		holder.icon_state = "hudtracking"
	else
		holder.icon_state = null

/mob/living/carbon/human
	var/list/stored_hud_images = list()

/mob/living/carbon/human/Login()
	. = ..()
	for(var/mob/living/carbon/human/H in GLOB.carbon_list)
		H.sec_hud_set_threat_status(src)

/mob/living/carbon/human/proc/sec_hud_set_threat_status(mob/living/carbon/human/user, clear = FALSE)
	var/list/hud_images = list()
	var/image/holder_threat
	holder_threat = image('icons/mob/hud.dmi', src, "hudalert-red", HUD_LAYER)
	holder_threat.appearance_flags = RESET_COLOR|RESET_TRANSFORM
	var/icon/I = icon(icon, icon_state, dir)
	holder_threat.pixel_y = I.Height() - world.icon_size
	hud_images += holder_threat
	stored_hud_images += hud_images
	if(istype(user.glasses, /obj/item/clothing/glasses/hud/threat))
		var/obj/item/clothing/glasses/hud/threat/scanner = user.glasses
		if(clear)
			scanner.threat_list -= src
		if(src in scanner.threat_list)
			user.client.images += hud_images
		else
			user.client.images -= stored_hud_images