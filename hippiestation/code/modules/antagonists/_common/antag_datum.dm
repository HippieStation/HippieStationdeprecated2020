/datum/antagonist
	var/tips

/datum/antagonist/on_gain()
	. = ..()
	if(owner && owner.current)
		if(!silent && tips)
			show_tips(tips)

/datum/antagonist/proc/show_tips(file)
	if(!owner || !owner.current || !owner.current.client)
		return
	var/datum/asset/stuff = get_asset_datum(/datum/asset/simple/hippie_antags)
	stuff.send(owner.current.client)
	var/datum/browser/popup = new(owner.current, "antagTips", null, 600, 400)
	popup.set_window_options("titlebar=1;can_minimize=0;can_resize=0")
	popup.set_content(file2text(file))
	popup.open(FALSE)
