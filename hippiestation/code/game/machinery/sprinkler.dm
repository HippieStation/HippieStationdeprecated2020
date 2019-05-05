#define SPRINKLER_COOLDOWN 150

/obj/machinery/sprinkler
	name = "sprinkler"
	desc = "Emergency sprinkler that converts water into non-slip firefighting foam used for containing fires."
	icon = 'hippiestation/icons/obj/machines/sprinkler.dmi'
	icon_state = "sprinkler_off"
	anchored = TRUE
	max_integrity = 300
	integrity_failure = 50
	armor = list("melee" = 20, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 30, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 80)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	var/detecting = TRUE
	var/last_spray = 0
	var/uses = 10
	var/temp_range = 500
	layer = LOW_OBJ_LAYER
	plane = FLOOR_PLANE

/obj/machinery/sprinkler/examine(mob/user)
	..()
	to_chat(user, "<span class='notice'>It has <b>[uses]</b> uses of foam remaining.</span>")
	if(in_range(user, src) || isobserver(user))
		to_chat(user, "<span class='notice'>A closer look reveals the temperature threshold has been set to <b>[temp_range]C.</b><span>")

/obj/machinery/sprinkler/temperature_expose(datum/gas_mixture/air, temperature, volume)
	if(temperature > T0C + temp_range)
		spray()
	..()

/obj/machinery/sprinkler/proc/spray()
	if(!is_operational() || stat)
		return
	if(world.time < last_spray+SPRINKLER_COOLDOWN)
		return
	if(!uses)
		return
	icon_state = "sprinkler_on"
	update_icon()
	last_spray = world.time
	detecting = FALSE
	var/obj/effect/foam_container/A = new(loc)
	A.Smoke()
	playsound(src,'sound/items/syringeproj.ogg',40,1)
	uses--

/obj/machinery/sprinkler/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(.) //damage received
		if(!(stat & BROKEN) && detecting)
			if(prob(33))
				spray()

/obj/machinery/sprinkler/wrench_act(mob/user, obj/item/W)
	if(W.use_tool(src, user, 40, volume = 50))
		detecting = !detecting
		if(detecting)
			user.visible_message("[user] has reset [src]'s nozzle.", "<span class='notice'>You reset [src]'s nozzle.</span>")
			icon_state = "sprinkler_off"
			update_icon()
		else
			user.visible_message("[user] has opened [src]'s nozzle!", "<span class='notice'>You open [src]'s nozzle!</span>")
			spray()
		return TRUE

/obj/machinery/sprinkler/screwdriver_act(mob/user, obj/item/W)
	if(..())
		return TRUE
	switch(temp_range)
		if(200)
			temp_range = 300
		if(300)
			temp_range = 400
		if(400)
			temp_range = 500
		if(500)
			temp_range = 200
	W.play_tool_sound(src)
	to_chat(user, "<span class='notice'>You adjust [src]'s temperature to <b>[temp_range]C</b>.</span>")
	return TRUE

/obj/machinery/sprinkler/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/reagent_containers))
		if(uses < 10)
			if(W.reagents.has_reagent("water", 50))
				uses++
				W.reagents.remove_reagent("water", 50)
				user.visible_message("[user] has partly filled [src].", "<span class='notice'>You partly fill [src]. It now has <b>[uses]</b> uses of foam remaining.</span>")
			else
				to_chat(user, "<span class='notice'>This machine only accepts containers containing <b>50u of water</b>.</span>")
		else
			to_chat(user, "<span class='notice'>[src] is full!</span>")
	else
		return ..()

/obj/effect/foam_container
	name = "resin container"
	desc = "A compacted ball of expansive fire fighting foam, used to combat fires."
	icon = 'icons/effects/effects.dmi'
	icon_state = "frozen_smoke_capsule"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pass_flags = PASSTABLE

/obj/effect/foam_container/proc/Smoke()
	var/obj/effect/particle_effect/foam/firefighting/F = new(loc)
	F.amount = 5
	playsound(src,'sound/effects/bamf.ogg',100,1)
	qdel(src)


/datum/crafting_recipe/sprinkler
	name = "Water Sprinkler"
	result = /obj/machinery/sprinkler
	time = 40
	reqs = list(/obj/item/stack/sheet/metal = 1,
				  /obj/item/stack/sheet/glass = 1,
				  /obj/item/reagent_containers/glass/beaker = 1)
	tools = list(/obj/item/weldingtool,
		         /obj/item/wrench)
	category = CAT_MISC
