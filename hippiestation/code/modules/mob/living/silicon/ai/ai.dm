/mob/living/silicon/ai
	var/obj/item/ai_hijack_device/hijacking
	var/mutable_appearance/hijack_overlay
	var/hijack_start = 0
	deathsound = 'hippiestation/sound/voice/ai_death_hippie.ogg'

/mob/living/silicon/ai/attack_hand(mob/user)
	if(hijacking)
		user.visible_message("<span class='danger'>[user] attempts to disconnect the circuit board from [src].</span>", "<span class='notice'>There appears to be something connected to [src]'s ports! You attempt to disconnect it...</span>")
		if (do_after(user,100,target = src))
			hijacking.forceMove(loc)
			hijacking = null
			hijack_start = 0
		else
			to_chat(user, "<span class='notice'>You fail to remove the device.</span>")
		return
	return ..()

/mob/living/silicon/ai/update_icons()
	..()
	cut_overlays()
	if(hijacking)
		if(!hijack_overlay)
			hijack_overlay = mutable_appearance('hippiestation/icons/obj/module.dmi', "ai_hijack_overlay")
			hijack_overlay.layer = layer+0.1
			hijack_overlay.pixel_x = 8
		add_overlay(hijack_overlay)
		icon_state = "ai-static"
	else if(!hijacking && hijack_overlay)
		QDEL_NULL(hijack_overlay)

/mob/living/silicon/ai/proc/handle_remotedoor(href_list)
	var/obj/machinery/door/airlock/A = locate(href_list["remotedoor"]) in GLOB.machines
	if(stat == CONSCIOUS)
		if(A && near_camera(A))
			A.AIShiftClick(src)
			to_chat(src, "<span class='notice'>[A] opened.</span>")
		else
			to_chat(src, "<span class='notice'>Unable to locate airlock. It may be out of camera range.</span>")
