//DEFINITIONS FOR ASSET DATUMS START HERE.

/datum/asset/simple/tgui
	assets = list(
		// tgui
		"tgui.css"	= 'tgui/assets/tgui.css',
		"tgui.js"	= 'tgui/assets/tgui.js',
		// tgui-next
		"tgui-main.html" = 'tgui-next/packages/tgui/public/tgui-main.html',
		"tgui-fallback.html" = 'tgui-next/packages/tgui/public/tgui-fallback.html',
		"tgui.bundle.js" = 'tgui-next/packages/tgui/public/tgui.bundle.js',
		"tgui.bundle.css" = 'tgui-next/packages/tgui/public/tgui.bundle.css',
		"shim-html5shiv.js" = 'tgui-next/packages/tgui/public/shim-html5shiv.js',
		"shim-ie8.js" = 'tgui-next/packages/tgui/public/shim-ie8.js',
		"shim-dom4.js" = 'tgui-next/packages/tgui/public/shim-dom4.js',
		"shim-css-om.js" = 'tgui-next/packages/tgui/public/shim-css-om.js',
	)

/datum/asset/simple/font
	assets = list(
		"runes.ttf"	= 'hippiestation/interface/runes.ttf'
	)

/datum/asset/group/tgui
	children = list(
		/datum/asset/simple/tgui,
		/datum/asset/simple/fontawesome
	)

/datum/asset/simple/headers
	assets = list(
		"alarm_green.gif" 			= 'icons/program_icons/alarm_green.gif',
		"alarm_red.gif" 			= 'icons/program_icons/alarm_red.gif',
		"batt_5.gif" 				= 'icons/program_icons/batt_5.gif',
		"batt_20.gif" 				= 'icons/program_icons/batt_20.gif',
		"batt_40.gif" 				= 'icons/program_icons/batt_40.gif',
		"batt_60.gif" 				= 'icons/program_icons/batt_60.gif',
		"batt_80.gif" 				= 'icons/program_icons/batt_80.gif',
		"batt_100.gif" 				= 'icons/program_icons/batt_100.gif',
		"charging.gif" 				= 'icons/program_icons/charging.gif',
		"downloader_finished.gif" 	= 'icons/program_icons/downloader_finished.gif',
		"downloader_running.gif" 	= 'icons/program_icons/downloader_running.gif',
		"ntnrc_idle.gif"			= 'icons/program_icons/ntnrc_idle.gif',
		"ntnrc_new.gif"				= 'icons/program_icons/ntnrc_new.gif',
		"power_norm.gif"			= 'icons/program_icons/power_norm.gif',
		"power_warn.gif"			= 'icons/program_icons/power_warn.gif',
		"sig_high.gif" 				= 'icons/program_icons/sig_high.gif',
		"sig_low.gif" 				= 'icons/program_icons/sig_low.gif',
		"sig_lan.gif" 				= 'icons/program_icons/sig_lan.gif',
		"sig_none.gif" 				= 'icons/program_icons/sig_none.gif',
		"smmon_0.gif" 				= 'icons/program_icons/smmon_0.gif',
		"smmon_1.gif" 				= 'icons/program_icons/smmon_1.gif',
		"smmon_2.gif" 				= 'icons/program_icons/smmon_2.gif',
		"smmon_3.gif" 				= 'icons/program_icons/smmon_3.gif',
		"smmon_4.gif" 				= 'icons/program_icons/smmon_4.gif',
		"smmon_5.gif" 				= 'icons/program_icons/smmon_5.gif',
		"smmon_6.gif" 				= 'icons/program_icons/smmon_6.gif'
	)

/datum/asset/spritesheet/simple/pda
	name = "pda"
	assets = list(
		"atmos"			= 'icons/pda_icons/pda_atmos.png',
		"back"			= 'icons/pda_icons/pda_back.png',
		"bell"			= 'icons/pda_icons/pda_bell.png',
		"blank"			= 'icons/pda_icons/pda_blank.png',
		"boom"			= 'icons/pda_icons/pda_boom.png',
		"bucket"		= 'icons/pda_icons/pda_bucket.png',
		"medbot"		= 'icons/pda_icons/pda_medbot.png',
		"floorbot"		= 'icons/pda_icons/pda_floorbot.png',
		"cleanbot"		= 'icons/pda_icons/pda_cleanbot.png',
		"crate"			= 'icons/pda_icons/pda_crate.png',
		"cuffs"			= 'icons/pda_icons/pda_cuffs.png',
		"eject"			= 'icons/pda_icons/pda_eject.png',
		"flashlight"	= 'icons/pda_icons/pda_flashlight.png',
		"honk"			= 'icons/pda_icons/pda_honk.png',
		"mail"			= 'icons/pda_icons/pda_mail.png',
		"medical"		= 'icons/pda_icons/pda_medical.png',
		"menu"			= 'icons/pda_icons/pda_menu.png',
		"mule"			= 'icons/pda_icons/pda_mule.png',
		"notes"			= 'icons/pda_icons/pda_notes.png',
		"power"			= 'icons/pda_icons/pda_power.png',
		"rdoor"			= 'icons/pda_icons/pda_rdoor.png',
		"reagent"		= 'icons/pda_icons/pda_reagent.png',
		"refresh"		= 'icons/pda_icons/pda_refresh.png',
		"scanner"		= 'icons/pda_icons/pda_scanner.png',
		"signaler"		= 'icons/pda_icons/pda_signaler.png',
		"status"		= 'icons/pda_icons/pda_status.png',
		"dronephone"	= 'icons/pda_icons/pda_dronephone.png'
	)

/datum/asset/spritesheet/simple/paper
	name = "paper"
	assets = list(
		"stamp-clown" = 'icons/stamp_icons/large_stamp-clown.png',
		"stamp-deny" = 'icons/stamp_icons/large_stamp-deny.png',
		"stamp-ok" = 'icons/stamp_icons/large_stamp-ok.png',
		"stamp-hop" = 'icons/stamp_icons/large_stamp-hop.png',
		"stamp-cmo" = 'icons/stamp_icons/large_stamp-cmo.png',
		"stamp-ce" = 'icons/stamp_icons/large_stamp-ce.png',
		"stamp-hos" = 'icons/stamp_icons/large_stamp-hos.png',
		"stamp-rd" = 'icons/stamp_icons/large_stamp-rd.png',
		"stamp-cap" = 'icons/stamp_icons/large_stamp-cap.png',
		"stamp-qm" = 'icons/stamp_icons/large_stamp-qm.png',
		"stamp-law" = 'icons/stamp_icons/large_stamp-law.png'
	)


/datum/asset/simple/IRV
	assets = list(
		"jquery-ui.custom-core-widgit-mouse-sortable-min.js" = 'html/IRV/jquery-ui.custom-core-widgit-mouse-sortable-min.js',
	)

/datum/asset/group/IRV
	children = list(
		/datum/asset/simple/jquery,
		/datum/asset/simple/IRV
	)

/datum/asset/simple/changelog
	assets = list(
		"88x31.png" = 'html/88x31.png',
		"bug-minus.png" = 'html/bug-minus.png',
		"cross-circle.png" = 'html/cross-circle.png',
		"hard-hat-exclamation.png" = 'html/hard-hat-exclamation.png',
		"image-minus.png" = 'html/image-minus.png',
		"image-plus.png" = 'html/image-plus.png',
		"music-minus.png" = 'html/music-minus.png',
		"music-plus.png" = 'html/music-plus.png',
		"tick-circle.png" = 'html/tick-circle.png',
		"wrench-screwdriver.png" = 'html/wrench-screwdriver.png',
		"spell-check.png" = 'html/spell-check.png',
		"burn-exclamation.png" = 'html/burn-exclamation.png',
		"chevron.png" = 'html/chevron.png',
		"chevron-expand.png" = 'html/chevron-expand.png',
		"scales.png" = 'html/scales.png',
		"coding.png" = 'html/coding.png',
		"ban.png" = 'html/ban.png',
		"chrome-wrench.png" = 'html/chrome-wrench.png',
		"changelog.css" = 'html/changelog.css'
	)

/datum/asset/group/goonchat
	children = list(
		/datum/asset/simple/jquery,
		/datum/asset/simple/goonchat,
		/datum/asset/spritesheet/goonchat,
		/datum/asset/simple/fontawesome
	)

/datum/asset/simple/jquery
	assets = list(
		"jquery.min.js"            = 'code/modules/goonchat/browserassets/js/jquery.min.js',
	)

/datum/asset/simple/goonchat
	assets = list(
		"json2.min.js"             = 'code/modules/goonchat/browserassets/js/json2.min.js',
		"browserOutput.js"         = 'code/modules/goonchat/browserassets/js/browserOutput.js',
		"browserOutput.css"	       = 'code/modules/goonchat/browserassets/css/browserOutput.css',
		"browserOutput_white.css"  = 'code/modules/goonchat/browserassets/css/browserOutput_white.css',
	)

/datum/asset/simple/fontawesome
	assets = list(
		"fa-regular-400.eot"  = 'html/font-awesome/webfonts/fa-regular-400.eot',
		"fa-regular-400.woff" = 'html/font-awesome/webfonts/fa-regular-400.woff',
		"fa-solid-900.eot"    = 'html/font-awesome/webfonts/fa-solid-900.eot',
		"fa-solid-900.woff"   = 'html/font-awesome/webfonts/fa-solid-900.woff',
		"font-awesome.css"    = 'html/font-awesome/css/all.min.css',
		"v4shim.css"          = 'html/font-awesome/css/v4-shims.min.css'
	)

/datum/asset/spritesheet/goonchat
	name = "chat"

/datum/asset/spritesheet/goonchat/register()
	InsertAll("emoji", 'icons/emoji.dmi')

	// pre-loading all lanugage icons also helps to avoid meta
	InsertAll("language", 'icons/misc/language.dmi')
	// catch languages which are pulling icons from another file
	for(var/path in typesof(/datum/language))
		var/datum/language/L = path
		var/icon = initial(L.icon)
		if (icon != 'icons/misc/language.dmi')
			var/icon_state = initial(L.icon_state)
			Insert("language-[icon_state]", icon, icon_state=icon_state)

	..()

/datum/asset/simple/permissions
	assets = list(
		"padlock.png"	= 'html/padlock.png'
	)

/datum/asset/simple/notes
	assets = list(
		"high_button.png" = 'html/high_button.png',
		"medium_button.png" = 'html/medium_button.png',
		"minor_button.png" = 'html/minor_button.png',
		"none_button.png" = 'html/none_button.png',
	)

/datum/asset/spritesheet/simple/pills
	name ="pills"
	assets = list(
		"pill1" = 'icons/UI_Icons/Pills/pill1.png',
		"pill2" = 'icons/UI_Icons/Pills/pill2.png',
		"pill3" = 'icons/UI_Icons/Pills/pill3.png',
		"pill4" = 'icons/UI_Icons/Pills/pill4.png',
		"pill5" = 'icons/UI_Icons/Pills/pill5.png',
		"pill6" = 'icons/UI_Icons/Pills/pill6.png',
		"pill7" = 'icons/UI_Icons/Pills/pill7.png',
		"pill8" = 'icons/UI_Icons/Pills/pill8.png',
		"pill9" = 'icons/UI_Icons/Pills/pill9.png',
		"pill10" = 'icons/UI_Icons/Pills/pill10.png',
		"pill11" = 'icons/UI_Icons/Pills/pill11.png',
		"pill12" = 'icons/UI_Icons/Pills/pill12.png',
		"pill13" = 'icons/UI_Icons/Pills/pill13.png',
		"pill14" = 'icons/UI_Icons/Pills/pill14.png',
		"pill15" = 'icons/UI_Icons/Pills/pill15.png',
		"pill16" = 'icons/UI_Icons/Pills/pill16.png',
		"pill17" = 'icons/UI_Icons/Pills/pill17.png',
		"pill18" = 'icons/UI_Icons/Pills/pill18.png',
		"pill19" = 'icons/UI_Icons/Pills/pill19.png',
		"pill20" = 'icons/UI_Icons/Pills/pill20.png',
		"pill21" = 'icons/UI_Icons/Pills/pill21.png',
		"pill22" = 'icons/UI_Icons/Pills/pill22.png',
	)

//this exists purely to avoid meta by pre-loading all language icons.
/datum/asset/language/register()
	for(var/path in typesof(/datum/language))
		set waitfor = FALSE
		var/datum/language/L = new path ()
		L.get_icon()

/datum/asset/spritesheet/pipes
	name = "pipes"

/datum/asset/spritesheet/pipes/register()
	for (var/each in list('icons/obj/atmospherics/pipes/pipe_item.dmi', 'icons/obj/atmospherics/pipes/disposal.dmi', 'icons/obj/atmospherics/pipes/transit_tube.dmi', 'icons/obj/plumbing/fluid_ducts.dmi'))
		InsertAll("", each, GLOB.alldirs)
	..()

// Representative icons for each research design
/datum/asset/spritesheet/research_designs
	name = "design"

/datum/asset/spritesheet/research_designs/register()
	for (var/path in subtypesof(/datum/design))
		var/datum/design/D = path

		var/icon_file
		var/icon_state
		var/icon/I

		if(initial(D.research_icon) && initial(D.research_icon_state)) //If the design has an icon replacement skip the rest
			icon_file = initial(D.research_icon)
			icon_state = initial(D.research_icon_state)
			if(!(icon_state in icon_states(icon_file)))
				warning("design [D] with icon '[icon_file]' missing state '[icon_state]'")
				continue
			I = icon(icon_file, icon_state, SOUTH)

		else
			// construct the icon and slap it into the resource cache
			var/atom/item = initial(D.build_path)
			if (!ispath(item, /atom))
				// biogenerator outputs to beakers by default
				if (initial(D.build_type) & BIOGENERATOR)
					item = /obj/item/reagent_containers/glass/beaker/large
				else
					continue  // shouldn't happen, but just in case

			// circuit boards become their resulting machines or computers
			if (ispath(item, /obj/item/circuitboard))
				var/obj/item/circuitboard/C = item
				var/machine = initial(C.build_path)
				if (machine)
					item = machine

			icon_file = initial(item.icon)
			icon_state = initial(item.icon_state)

			if(!(icon_state in icon_states(icon_file)))
				warning("design [D] with icon '[icon_file]' missing state '[icon_state]'")
				continue
			I = icon(icon_file, icon_state, SOUTH)

			// computers (and snowflakes) get their screen and keyboard sprites
			if (ispath(item, /obj/machinery/computer) || ispath(item, /obj/machinery/power/solar_control))
				var/obj/machinery/computer/C = item
				var/screen = initial(C.icon_screen)
				var/keyboard = initial(C.icon_keyboard)
				var/all_states = icon_states(icon_file)
				if (screen && (screen in all_states))
					I.Blend(icon(icon_file, screen, SOUTH), ICON_OVERLAY)
				if (keyboard && (keyboard in all_states))
					I.Blend(icon(icon_file, keyboard, SOUTH), ICON_OVERLAY)

		Insert(initial(D.id), I)
	return ..()

/datum/asset/spritesheet/vending
	name = "vending"

/datum/asset/spritesheet/vending/register()
	for (var/k in GLOB.vending_products)
		var/atom/item = k


		var/icon_file
		var/icon_state
		var/icon/I


		if (!ispath(item, /atom))
			continue

		icon_file = initial(item.icon)
		icon_state = initial(item.icon_state)

		if(icon_state in icon_states(icon_file))
			I = icon(icon_file, icon_state, SOUTH)
			var/c = initial(item.color)
			if (!isnull(c) && c != "#FFFFFF")
				I.Blend(initial(c), ICON_MULTIPLY)
		else
			item = new item()
			I = icon(item.icon, item.icon_state, SOUTH)
			qdel(item)

		var/imgid = replacetext(replacetext("[item]", "/obj/item/", ""), "/", "-")

		Insert(imgid, I)
	return ..()

/datum/asset/simple/genetics
	assets = list(
		"dna_discovered.png"	= 'html/dna_discovered.png',
		"dna_undiscovered.png"	= 'html/dna_undiscovered.png',
		"dna_extra.png" 		= 'html/dna_extra.png'
)


/datum/asset/simple/vv
	assets = list(
		"view_variables.css" = 'html/admin/view_variables.css'
	)
