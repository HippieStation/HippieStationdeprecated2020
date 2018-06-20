/obj/mecha/makeshift
	desc = "A locker with stolen wires, struts, electronics and airlock servos crudley assemebled into something that resembles the fuctions of a mech."
	name = "Locker Mech"
	icon = 'hippiestation/icons/mecha/lockermech.dmi'
	icon_state = "lockermech"
	max_integrity = 100 //its made of scraps
	lights_power = 5
	step_in = 4 //Same speed as a ripley, for now.
	armor = list(melee = 20, bullet = 10, laser = 10, energy = 0, bomb = 10, bio = 0, rad = 0, fire = 70, acid = 60) //Same armour as a locker
	internal_damage_threshold = 30 //Its got shitty durability
	max_equip = 2 //You only have two arms and the control system is shitty
	var/list/cargo = new
	var/cargo_capacity = 5 // you can fit a few things in this locker but not much.

/obj/mecha/makeshift/Destroy()
	for(var/atom/movable/A in cargo)
		A.forceMove(loc)
		step_rand(A)
	cargo.Cut()
	return ..()

/obj/mecha/makeshift/Topic(href, href_list)
	..()
	if(href_list["drop_from_cargo"])
		var/obj/O = locate(href_list["drop_from_cargo"])
		if(O && O in src.cargo)
			src.occupant_message("<span class='notice'>You unload [O].</span>")
			O.forceMove(loc)
			src.cargo -= O
			src.log_message("Unloaded [O]. Cargo compartment capacity: [cargo_capacity - src.cargo.len]")
	return

/obj/mecha/makeshift/go_out()
	..()
	update_icon()

/obj/mecha/makeshift/moved_inside(mob/living/carbon/human/H)
	..()
	update_icon()


/obj/mecha/makeshift/Exit(atom/movable/O)
	if(O in cargo)
		return 0
	return ..()

/obj/mecha/makeshift/contents_explosion(severity, target)
	for(var/X in cargo)
		var/obj/O = X
		if(prob(30/severity))
			cargo -= O
			O.forceMove(loc)
	. = ..()

/obj/mecha/makeshift/get_stats_part()
	var/output = ..()
	output += "<b>Cargo Compartment Contents:</b><div style=\"margin-left: 15px;\">"
	if(cargo.len)
		for(var/obj/O in cargo)
			output += "<a href='?src=\ref[src];drop_from_cargo=\ref[O]'>Unload</a> : [O]<br>"
	else
		output += "Nothing"
	output += "</div>"
	return output

/obj/mecha/makeshift/relay_container_resist(mob/living/user, obj/O)
	to_chat(user, "<span class='notice'>You lean on the back of [O] and start pushing so it falls out of [src].</span>")
	if(do_after(user, 10, target = O))//Its a fukken locker
		if(!user || user.stat != CONSCIOUS || user.loc != src || O.loc != src )
			return
		to_chat(user, "<span class='notice'>You successfully pushed [O] out of [src]!</span>")
		O.loc = loc
		cargo -= O
	else
		if(user.loc == src) //so we don't get the message if we resisted multiple times and succeeded.
			to_chat(user, "<span class='warning'>You fail to push [O] out of [src]!</span>")

/obj/mecha/makeshift/Destroy()
	go_out()
	var/mob/living/silicon/ai/AI
	for(var/mob/M in src) //Let's just be ultra sure
		if(isAI(M))
			occupant = null
			AI = M //AIs are loaded into the mech computer itself. When the mech dies, so does the AI. They can be recovered with an AI card from the wreck.
		else
			M.forceMove(loc)
	for(var/obj/item/mecha_parts/mecha_equipment/E in equipment)
		E.detach(loc)
		qdel(E)
	if(cell)
		qdel(cell)
	if(internal_tank)
		qdel(internal_tank)
	if(AI)
		AI.gib() //No wreck, no AI to recover
	STOP_PROCESSING(SSobj, src)
	GLOB.poi_list.Remove(src)
	equipment.Cut()
	cell = null
	internal_tank = null
	if(loc)
		loc.assume_air(cabin_air)
		air_update_turf()
	else
		qdel(cabin_air)
	cabin_air = null
	qdel(spark_system)
	spark_system = null
	qdel(smoke_system)
	smoke_system = null
	new /obj/structure/closet(loc)
	GLOB.mechas_list -= src //global mech list
	return ..()
