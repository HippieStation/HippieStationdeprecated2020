/obj/machinery/power/port_gen
	icon = 'hippiestation/icons/obj/power.dmi'
	icon_state = "portgen0"

/obj/machinery/power/port_gen/pacman/super
	icon_state = "portgen1"

/obj/machinery/power/port_gen/pacman/mrs
	icon_state = "portgen2"

/obj/machinery/power/port_gen/update_icon()
	icon_state = "[base_icon]"
/*
/obj/machinery/power/port_gen/process()
	..()
	if(active)
		updateUsrDialog()

/obj/machinery/power/port_gen/pacman/ui_interact(mob/user)
	. = ..()
	if(.)
		return
	if(!Adjacent(user)  || (stat & (NOPOWER|BROKEN)) && !issilicon(user))
		user.unset_machine(src)
		user << browse(null, "window=port_gen")
		return

	var/dat = text("<b>[name]</b><br>")
	dat += text("Generator: <A href='?src=[REF(src)];action=toggle'>[active?"On":"Off"]</A><br>")
	dat += text("[capitalize(sheet_name)]: [sheets] - <A href='?src=[REF(src)];action=eject'>Eject</A><br>")
	var/stack_percent = round(sheet_left * 100, 1)
	dat += text("Current stack: [stack_percent]% <br>")
	dat += text("Power output: <A href='?src=[REF(src)];action=lower_power'>-</A> [DisplayPower(power_gen * power_output)] <A href='?src=[REF(src)];action=higher_power'>+</A><br>")
	dat += text("Power current: [(powernet == null ? "Unconnected" : "[DisplayPower(avail())]")]<br>")
	dat += text("Heat: [current_heat]<br>")
	dat += "<br><A href='?src=[REF(src)];action=close'>Close</A>"
	user << browse(dat, "window=port_gen")
	onclose(user, "port_gen")

/obj/machinery/power/port_gen/pacman/Topic(href, href_list)
	if(..())
		return

	add_fingerprint(usr)
	if(href_list["action"])
		if(href_list["action"] == "toggle")
			TogglePower()
			. = TRUE
		if(href_list["action"] == "eject")
			if(!active)
				DropFuel()
				. = TRUE
		if(href_list["action"] == "lower_power")
			if (power_output > 1)
				power_output--
				. = TRUE
		if (href_list["action"] == "higher_power")
			if (power_output < 4 || (obj_flags & EMAGGED))
				power_output++
				. = TRUE
		if (href_list["action"] == "close")
			usr << browse(null, "window=port_gen")
			usr.unset_machine()

	updateDialog()
*/