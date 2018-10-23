// Process data before sending it
/datum/netdata/proc/pre_send(datum/component/ntnet_interface/interface)
	// Decrypt the passkey.
	if(autopasskey)
		if(data["encrypted_passkey"] && !passkey)
			var/result = XorEncrypt(hextostr(data["encrypted_passkey"], TRUE), SScircuit.cipherkey)
			if(length(result) > 1)
				passkey = json_decode(XorEncrypt(hextostr(data["encrypted_passkey"], TRUE), SScircuit.cipherkey))

			// Encrypt the passkey.
			if(!data["encrypted_passkey"] && passkey)
				data["encrypted_passkey"] = strtohex(XorEncrypt(json_encode(passkey), SScircuit.cipherkey))

	// If there is no sender ID, set the default one.
	if(!sender_id && interface)
		sender_id = interface.hardware_id
