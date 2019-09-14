/client/proc/register_account()
	set name = "Register/Update Account"
	set category = "OOC"
	if(IsGuestKey(key))
		to_chat(src, "<span class='danger bold italics'>Guests cannot create accounts!</span>")
		return
	if(!SSauth.initialized)
		return
	if(SSauth.initialized && !SSauth.can_fire)
		to_chat(src, "<span class='big danger'>Warning: authentication is currently offline. Please contact admins.</span>")
		return
	if(!SSauth.provider || !CONFIG_GET(string/auth_provider))
		to_chat(src, "<span class='danger bold italics'>Authentication is not setup!</span>")
		return
	var/is_updating = SSauth.provider.AuthStatus(ckey)
	if(alert("[is_updating ? "Would you like to update your account details? Old details will be lost!" : "Would you like to sign up for an account?\nThis will allow you to login when the BYOND Hub is down!"]", "Register", "Yes", "No") == "Yes")
		if(SSauth.provider.AccountManager(src, is_updating))
			verbs -= /client/proc/register_account
