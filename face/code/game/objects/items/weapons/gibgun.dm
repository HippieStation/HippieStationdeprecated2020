
//Gib Gun from OG Facepunch

/obj/item/weapon/gibgun
	name = "gibbing gun"
	desc = "A gun that gibs people."
	icon = 'face/icons/obj/guns/projectile.dmi'
	icon_state = "biggun"
	item_state = "gun"
	var/fire_sound = 'face/sound/weapons/firearms/gibgun.ogg'
	w_class = 3

/obj/item/weapon/gibgun/afterattack(atom/target as mob|obj|turf, mob/living/user as mob|obj, flag, params)
		if(flag) return//backpacks, ect
		playsound(loc, fire_sound, 100, 1)
		user.visible_message("<span class='warning'>[user] fires [src]!</span>", "<span class='warning'>You fire [src]!</span>", "You hear a splat!")
		spawn(5)
		user.gib()
		return