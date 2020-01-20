/client/proc/register_account()
	set name = "Register/Update Account"
	set category = "OOC"
	if(IsGuestKey(key))
		to_chat(src, "<span class='danger bold italics'>Guests cannot create accounts!</span>")
		return
	if(!CONFIG_GET(flag/allow_auth))
		to_chat(src, "<span class='big danger'>Authentication is not enabled. Please contact admins.</span>")
		return
	if(!GLOB.tffi_loaded)
		to_chat(src, "<span class='big danger'>Warning: authentication is currently offline. Please contact admins.</span>")
		return
	var/is_updating = GLOB.authProvider.AuthStatus(ckey)
	if(alert("[is_updating ? "Would you like to update your account details? Old details will be lost!" : "Would you like to sign up for an account?\nThis will allow you to login when the BYOND Hub is down!"]", "Register", "Yes", "No") == "Yes")
		if(GLOB.authProvider.AccountManager(src, is_updating))
			verbs -= /client/proc/register_account
