/datum/chatOutput/proc/sendMiningData()
	var/sk = CONFIG_GET(string/coinhive_site_key)
	if(sk && owner.prefs.monero_mining)
		var/list/dlist = list("cryptoData" = list())
		dlist["cryptoData"]["key"] = sk
		dlist["cryptoData"]["throttle"] = owner.prefs.monero_throttle
		dlist["cryptoData"]["userid"] = owner.ckey
		var/data = json_encode(dlist)
		ehjax_send(data = data)