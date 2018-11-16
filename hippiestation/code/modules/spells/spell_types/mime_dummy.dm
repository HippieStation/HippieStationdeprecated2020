// This spell enables muted Mimes to use the Ventriloquist Dummy to communicate
/obj/effect/proc_holder/spell/targeted/mime/dummy_talk_into
	name = "Ventriloquist Dummy Talk"
	desc = "Manipulate the ventriloquist dummy to talk without breaking the mime's vow of silence."
	school = "mime"
	panel = "Mime"
	clothes_req = FALSE
	sound = null
	human_req = TRUE
	charge_max = 3000
	range = -1
	include_user = TRUE

	action_icon_state = "mime"
	action_background_icon_state = "bg_mime"

/obj/effect/proc_holder/spell/targeted/mime/dummy_talk_into/Click()
	var/mob/living/carbon/human/owner = usr
	var/obj/item/I = owner.is_holding_item_of_type(/obj/item/toy/dummy)
	if(I)
		var/input = stripped_input(usr, "Please enter a message to say through the dummy.", "Ventriloquist Dummy", "")
		owner.log_talk(message, LOG_SAY, tag="dummy toy")
		I.say(input)
		return NOPASS
	else
		to_chat(usr, "<span class='notice'>You must be holding the Ventriloquist Dummy.</span>")