/obj/item/gun/ballistic/a3_gatling
	name = "SG-7 Gatling Gun"
	icon = 'icons/obj/guns/minigun.dmi'
	icon_state = "minigun_spin"
	internal_magazine = TRUE
	automatic = TRUE
	mag_type = /obj/item/ammo_box/magazine/internal/a3_gatling
	var/refilling = FALSE

/obj/item/gun/ballistic/a3_gatling/shoot_with_empty_chamber(mob/living/user as mob|obj)
	if(refilling)
		return
	INVOKE_ASYNC(src, .proc/refill, user)

/obj/item/gun/ballistic/a3_gatling/proc/refill(mob/living/user)
	refilling = TRUE
	to_chat(user, "<span class='notice'>\The [src] begins to refill!</span>")
	if(do_after_mob(user, src, 5 SECONDS, TRUE))
		for(var/i = 1 to magazine.max_ammo)
			magazine.stored_ammo += new magazine.ammo_type
		to_chat(user, "<span class='notice'>\The [src] refills.</span>")
		chamber_round()
	refilling = FALSE

/obj/item/ammo_box/magazine/internal/a3_gatling
	ammo_type = /obj/item/ammo_casing/a3_gatling
	caliber = "gatling"
	max_ammo = 35

/obj/item/ammo_casing/a3_gatling
	projectile_type = /obj/item/projectile/bullet/a3

/obj/item/projectile/bullet/a3
	name = "gatling bullet"
	damage = 5
