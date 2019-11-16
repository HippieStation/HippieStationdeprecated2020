/obj/item/gun/ballistic/a3
	internal_magazine = TRUE
	var/refilling = FALSE

/obj/item/gun/ballistic/a3/shoot_with_empty_chamber(mob/living/user as mob|obj)
	if(refilling)
		return
	INVOKE_ASYNC(src, .proc/refill, user)

/obj/item/gun/ballistic/a3/proc/refill(mob/living/user)
	refilling = TRUE
	to_chat(user, "<span class='notice'>\The [src] begins to refill!</span>")
	if(do_after_mob(user, src, 5 SECONDS, TRUE))
		for(var/i = 1 to magazine.max_ammo)
			magazine.stored_ammo += new magazine.ammo_type
		to_chat(user, "<span class='notice'>\The [src] refills.</span>")
		chamber_round()
	refilling = FALSE
