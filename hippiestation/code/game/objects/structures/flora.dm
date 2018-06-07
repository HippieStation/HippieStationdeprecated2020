#define SHARP_DESC_ADD "This one appears to have a bunch of sharp edges peeking out from under its leaves."
#define EMAG_DESC_ADD "This plant appears to have been illegally modified."

/obj/item/twohanded/required/kirbyplants
	var/disable = 0 //for screwdriver
	var/is_sharpened = 0 //to prevent multiple sharpenings
	var/sharp_prefix = "thorny"

/obj/item/twohanded/required/kirbyplants/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/screwdriver)) //If you screwdrive it, it is attachable
		add_fingerprint(user)
		disable = !disable
		if(disable)
			user.visible_message("[user] prepares the foliage for connection.", "<span class='notice'>The screwdriver reveals a panel labelled 'INSERT SHARP ITEM HERE'...</span>")
		if(!disable)
			user.visible_message("[user] impedes the foliage from connection.", "<span class='notice'>You close the panel back up.</span>")
	if(W.is_sharp() && disable)  //If screwdriven and the item is sharp, it creates sharp plant
		if(is_sharpened)
			var/mob/living/carbon/C = user
			var/hit_hand = ((user.active_hand_index % 2 == 0) ? "r_" : "l_") + "arm"
			user.visible_message("Tries to place an object among the plant's branches, but there's already something sharp inside. Be careful!", "<span class='notice'>You cut yourself on the plant! It's already full...</span>")
			C.apply_damage(5, BRUTE, hit_hand)
		else
			var/item_name=W.name
			user.visible_message("[user] places something sharp inside the plant's branches..", "<span class='notice'>You insert the [item_name] into the panel and close it. The plant suddenly seems more dangerous.</span>")
			name = "[sharp_prefix] [name]"
			desc = "[desc] " + SHARP_DESC_ADD
			is_sharpened = 1
			force = W.force
			sharpness = W.sharpness
			hitsound='hippiestation/sound/weapons/sharpBushHit.ogg' //cool sound
			qdel(W)
			disable = !disable
	if(istype(W, /obj/item/reagent_containers) && (obj_flags & EMAGGED))
		if(W.reagents.has_reagent("lean"))
			W.reagents.clear_reagents()
			playsound(src.loc, 'hippiestation/sound/effects/pottedLeanSpawnSound.ogg', 25)
			new /mob/living/simple_animal/hostile/retaliate/pottedlean(get_turf(src))
			qdel(src)
	else
		return ..()

/obj/item/twohanded/required/kirbyplants/emag_act(mob/user)
	do_sparks(8, FALSE, get_turf(src))
	user.visible_message("<span class='warning'>Sparks burst from the plant as a jolt of electricity courses through your arm.</span>")
	var/obj/item/new_plant = new /obj/item/kirbyplants_onehanded(get_turf(src))
	new_plant.icon_state = src.icon_state
	qdel(src)


/obj/item/twohanded/required/kirbyplants/photosynthetic/emag_act(mob/user) //do not emag this one!
	explosion(get_turf(src), 0, 1, 5, flame_range = 5)
	qdel(src)

/obj/item/twohanded/required/kirbyplants/equipped(mob/user, slot)
	if((obj_flags & EMAGGED) && wielded)
		unwield(user) //This is a ghetto way to make it one-handed and it works
	var/image/I = image(icon = 'icons/obj/flora/plants.dmi' , icon_state = src.icon_state, loc = user)
	I.copy_overlays(src)
	I.override = 1
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/everyone, "sneaking_mission", I)
	I.layer = ABOVE_MOB_LAYER


/obj/item/kirbyplants_onehanded
	name = "potted plant"
	icon = 'icons/obj/flora/_flora.dmi'
	icon_state = "random_plant"
	var/list/static/states
	desc = "An extra little bit of nature contained in a pot."
	layer = ABOVE_MOB_LAYER
	w_class = WEIGHT_CLASS_HUGE
	force = 10
	throwforce = 13
	throw_speed = 2
	throw_range = 4
	var/disable = 0 //for screwdriver
	var/is_sharpened = 0 //to prevent multiple sharpenings
	var/sharp_prefix = "thorny"

obj/item/kirbyplants_onehanded/equipped(mob/living/user)
	var/image/I = image(icon = 'icons/obj/flora/plants.dmi' , icon_state = src.icon_state, loc = user)
	I.copy_overlays(src)
	I.override = 1
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/everyone, "sneaking_mission", I)
	I.layer = ABOVE_MOB_LAYER
	..()

/obj/item/kirbyplants_onehanded/dropped(mob/living/user)
	..()
	user.remove_alt_appearance("sneaking_mission")

/obj/item/kirbyplants_onehanded/Initialize()
	. = ..()
	icon = 'icons/obj/flora/plants.dmi'
	if(!states)
		generate_states()
	icon_state = pick(states)

/obj/item/kirbyplants_onehanded/proc/generate_states()
	states = list()
	for(var/i in 1 to 25)
		var/number
		if(i < 10)
			number = "0[i]"
		else
			number = "[i]"
		states += "plant-[number]"
	states += "applebush"

/obj/item/kirbyplants_onehanded/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/screwdriver)) //If you screwdrive it, it is attachable
		add_fingerprint(user)
		disable = !disable
		if(disable)
			user.visible_message("[user] prepares the foliage for connection.", "<span class='notice'>The screwdriver reveals a panel labelled 'INSERT SHARP ITEM HERE'...</span>")
		if(!disable)
			user.visible_message("[user] impedes the foliage from connection.", "<span class='notice'>You close the panel back up.</span>")
	if(W.is_sharp() && disable)  //If screwdriven and the item is sharp, it creates sharp plant
		if(is_sharpened)
			var/mob/living/carbon/C = user
			var/hit_hand = ((user.active_hand_index % 2 == 0) ? "r_" : "l_") + "arm"
			user.visible_message("Tries to place an object among the plant's branches, but there's already something sharp inside. Be careful!", "<span class='notice'>You cut yourself on the plant! It's already full...</span>")
			C.apply_damage(5, BRUTE, hit_hand)
		else
			var/item_name=W.name
			user.visible_message("[user] places something sharp inside the plant's branches..", "<span class='notice'>You insert the [item_name] into the panel and close it. The plant suddenly seems more dangerous.</span>")
			name = "[sharp_prefix] [name]"
			desc = "[desc] " + SHARP_DESC_ADD
			is_sharpened = 1
			force = W.force
			sharpness = W.sharpness
			hitsound='hippiestation/sound/weapons/sharpBushHit.ogg' //cool sound
			qdel(W)
			disable = !disable
	if(istype(W, /obj/item/reagent_containers)) //You have to emag a plant to get this item, so it shouldn't need a check for emagging again
		if(W.reagents.has_reagent("lean"))
			W.reagents.clear_reagents()
			playsound(src.loc, 'hippiestation/sound/effects/pottedLeanSpawnSound.ogg', 25)
			new /mob/living/simple_animal/hostile/retaliate/pottedlean(get_turf(src))
			qdel(src)
	else
		return ..()


/////////////////////////////////////////////
//   HIPPIESTATION MAINTENANCE MUSHROOMS   //
/////////////////////////////////////////////

/obj/structure/flora/maintenanceshroom
	gender = PLURAL
	layer = PROJECTILE_HIT_THRESHHOLD_LAYER
	icon = 'hippiestation/icons/obj/maint_flora.dmi'
	icon_state = "mushroom"
	name = "mushrooms"
	desc = "A bundle of small mushrooms."
	var/harvested_name = "harvested mushrooms"
	var/harvested_desc = "Some harvested mushrooms, they will grow back soon"
	var/needs_sharp_harvest = TRUE
	var/harvest = /obj/item/reagent_containers/food/snacks/grown/maintenanceshroom/redmushroom
	var/harvest_amount_low = 1
	var/harvest_amount_high = 3
	var/harvest_time = 60
	var/harvest_message_low = ""
	var/harvest_message_med = ""
	var/harvest_message_high = ""
	var/harvested = FALSE
	var/base_icon
	var/regrowth_time_low = 8 MINUTES
	var/regrowth_time_high = 16 MINUTES

/obj/structure/flora/maintenanceshroom/Initialize()
	. = ..()
	base_icon = "[icon_state][rand(1, 4)]"
	icon_state = base_icon

/obj/structure/flora/maintenanceshroom/proc/harvest(user)
	if(harvested)
		return 0

	var/rand_harvested = rand(harvest_amount_low, harvest_amount_high)
	if(rand_harvested)
		if(user)
			var/msg = harvest_message_med
			if(rand_harvested == harvest_amount_low)
				msg = harvest_message_low
			else if(rand_harvested == harvest_amount_high)
				msg = harvest_message_high
			to_chat(user, "<span class='notice'>[msg]</span>")
		for(var/i in 1 to rand_harvested)
			new harvest(get_turf(src))

	icon_state = "[base_icon]p"
	name = harvested_name
	desc = harvested_desc
	harvested = TRUE
	addtimer(CALLBACK(src, .proc/regrow), rand(regrowth_time_low, regrowth_time_high))
	return 1

/obj/structure/flora/maintenanceshroom/proc/regrow()
	icon_state = base_icon
	name = initial(name)
	desc = initial(desc)
	harvested = FALSE

/obj/structure/flora/maintenanceshroom/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!harvested && !needs_sharp_harvest)
		user.visible_message("<span class='notice'>[user] starts to harvest from [src].</span>","<span class='notice'>You begin to harvest from [src].</span>")
		if(do_after(user, harvest_time, target = src))
			harvest(user)

/obj/structure/flora/maintenanceshroom/redmushroom
	icon = 'hippiestation/icons/obj/maint_flora.dmi'
	icon_state = "redmushroom"
	name = "small red mushrooms"
	desc = "A number of small vibrant red mushrooms, growing in the station's maintenance tunnels."
	harvested_name = "harvested red mushrooms"
	harvested_desc = "Some recently harvested red mushrooms. They'll probably grow back soon."
	harvest = /obj/item/reagent_containers/food/snacks/grown/maintenanceshroom/redmushroom
	harvest_amount_low = 1
	harvest_amount_high = 3
	harvest_time = 60
	harvest_message_low = "You violently rip out the mushrooms and destroy most of the caps and stems!"
	harvest_message_med = "You pick out some of the mushrooms intact."
	harvest_message_high = "You carefully grab the mushrooms and successfully pull them all out, completely intact."
	regrowth_time_low = 3000
	regrowth_time_high = 6000

/obj/structure/flora/maintenanceshroom/greenmushroom
	icon = 'hippiestation/icons/obj/maint_flora.dmi'
	icon_state = "greenmushroom"
	name = "small green mushrooms"
	desc = "A number of small green mushrooms, growing in the station's maintenance tunnels. They appear to be glowing slightly..."
	harvested_name = "harvested green mushrooms"
	harvested_desc = "Some recently harvested green mushrooms. They'll probably grow back soon."
	harvest = /obj/item/reagent_containers/food/snacks/grown/maintenanceshroom/greenmushroom
	harvest_amount_low = 1
	harvest_amount_high = 4
	harvest_time = 60
	harvest_message_low = "Your hand slips while pulling out the mushrooms and you damage them!"
	harvest_message_med = "You pull out some of the mushrooms."
	harvest_message_high = "You manage to pull out the mushrooms without damaging them at all."
	regrowth_time_low = 3000
	regrowth_time_high = 6000

/obj/structure/flora/maintenanceshroom/greenmushroom/Initialize(mapload)
	AddComponent(/datum/component/slippery, 50)	//Le slip man ecks dee

/obj/structure/flora/maintenanceshroom/purplemushroom
	icon = 'hippiestation/icons/obj/maint_flora.dmi'
	icon_state = "purplemushroom"
	name = "small purple mushrooms"
	desc = "A number of small purple mushrooms, growing in the station's maintenance tunnels. They seem to give off a nasty smell."
	harvested_name = "harvested purple mushrooms"
	harvested_desc = "Some recently harvested purple mushrooms. They'll probably grow back soon."
	harvest = /obj/item/reagent_containers/food/snacks/grown/maintenanceshroom/purplemushroom
	harvest_amount_low = 1
	harvest_amount_high = 3
	harvest_time = 60
	harvest_message_low = "You collect some of the mushrooms but end up damaging most of the caps and stems."
	harvest_message_med = "You successfully pull out some of the mushrooms"
	harvest_message_high = "You pull out the mushrooms completely intact."
	regrowth_time_low = 3000
	regrowth_time_high = 6000

/obj/item/reagent_containers/food/snacks/grown/maintenanceshroom/redmushroom
	name = "red mushrooms"
	desc = "Some bright red mushrooms. Maybe you shouldn't eat these..."
	icon = 'hippiestation/icons/obj/maint_flora.dmi'
	icon_state = "redmushroom_hand"
	list_reagents = list("toxin" = 3, "carpotoxin" = 2)
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	max_integrity = 100

/obj/item/reagent_containers/food/snacks/grown/maintenanceshroom/greenmushroom
	name = "green mushrooms"
	desc = "Some green mushrooms. They're glowing slightly."
	icon = 'hippiestation/icons/obj/maint_flora.dmi'
	icon_state = "greenmushroom_hand"
	list_reagents = list("nutriment" = 2, "radium" = 4)
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	max_integrity = 100

/obj/item/reagent_containers/food/snacks/grown/maintenanceshroom/purplemushroom
	name = "purple mushrooms"
	desc = "Some purple mushrooms. They smell pretty bad."
	icon = 'hippiestation/icons/obj/maint_flora.dmi'
	icon_state = "purplemushroom_hand"
	list_reagents = list("mindbreaker" = 2, "mushroomhallucinogen" = 3)
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	max_integrity = 100