/client/proc/HippiePPoptions(mob/M) // why is this client and not /datum/admins? noone knows, in PP src == client, instead of holder. wtf.
	var/body = "<br>"
	if(M.client)
		body += "<A href='?_src_=holder;[HrefToken()];makementor=[M.ckey]'>Make mentor</A> | "
		body += "<A href='?_src_=holder;[HrefToken()];removementor=[M.ckey]'>Remove mentor</A> | "
		body += "<A href='?_src_=holder;[HrefToken()];makedonator=[M.ckey]'>Make donator</A> | "
		body += "<A href='?_src_=holder;[HrefToken()];removedonator=[M.ckey]'>Remove donator</A>"
	return body