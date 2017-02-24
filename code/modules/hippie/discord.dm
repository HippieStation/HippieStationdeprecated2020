/proc/send2admindiscord_adminless_only(source, msg, requiredflags = R_BAN)
	var/list/adm = get_admin_counts(requiredflags)
	. = adm["present"]
	if(. <= 0)
		var/final = ""
		if(!adm["afk"] && !adm["stealth"] && !adm["noflags"])
			final = "[source] - [msg] - No admins online"
		else
			final = "[source] - [msg] - All admins AFK ([adm["afk"]]/[adm["total"]]), stealthminned ([adm["stealth"]]/[adm["total"]]), or lack[rights2text(requiredflags, " ")] ([adm["noflags"]]/[adm["total"]])"
		send2admindiscord(final, TRUE)

/proc/send2maindiscord(var/msg)
	send2discord(msg, FALSE)

/proc/send2admindiscord(var/msg, var/ping = FALSE)
	send2discord(msg, TRUE, ping)

/proc/send2discord(var/msg, var/admin = FALSE, var/ping = FALSE)
	if (!global.config.discord_url || !global.config.discord_password)
		return

	var/url = "[global.config.discord_url]?pass=[url_encode(global.config.discord_password)]&admin=[admin ? "true" : "false"]&content=[url_encode(msg)]&ping=[ping ? "true" : "false"]"
	world.Export(url)