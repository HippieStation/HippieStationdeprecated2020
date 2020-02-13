/datum/techweb_node/adv_mining
	id = "bluespace_mining"
	display_name = "Bluespace Mining Technology"
	description = "Harness the power of bluespace to make materials out of nothing. Slowly."
	prereq_ids = list("practical_bluespace", "adv_mining")
	design_ids = list("bluespace_miner")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	export_price = 5000

/datum/design/board/bluespace_miner
	name = "Machine Design (Bluespace Miner)"
	desc = "The circuit board for a Bluespace Miner."
	id = "bluespace_miner"
	build_path = /obj/item/circuitboard/machine/bluespace_miner
	category = list ("Misc. Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_ENGINEERING

/obj/item/circuitboard/machine/bluespace_miner
	name = "Bluespace Miner (Machine Board)"
	build_path = /obj/machinery/mineral/bluespace_miner
	req_components = list(
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/manipulator = 3,
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stack/ore/bluespace_crystal = 3,
		/obj/item/stack/sheet/mineral/gold = 1,
		/obj/item/stack/sheet/mineral/uranium = 1)
	needs_anchored = FALSE


//big thanks to ninja and ma44 on coderbus for solving my autism
/obj/machinery/mineral/bluespace_miner
	name = "bluespace mining machine"
	desc = "A machine that uses the magic of Bluespace to slowly generate materials and add them to a linked ore silo."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "stacker"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/bluespace_miner
	layer = BELOW_OBJ_LAYER
	var/datum/component/remote_materials/materials
	var/debugging = 0

/obj/machinery/mineral/bluespace_miner/Initialize(mapload)
	. = ..()
	materials = AddComponent(/datum/component/remote_materials, "bsm", mapload)

/obj/machinery/mineral/bluespace_miner/Destroy()
	materials = null
	return ..()

/obj/machinery/mineral/bluespace_miner/multitool_act(mob/living/user, obj/item/multitool/I)
	. = ..()
	if (istype(I))
		to_chat(user, "<span class='notice'>You update [src] with the multitool's buffer.</span>")
		materials?.silo = I.buffer
		return TRUE
	else
		to_chat(user, "<span class='notice'>The buffer is empty.</span>")
		return FALSE

/obj/machinery/mineral/bluespace_miner/examine(mob/user)
	. = ..()
	if(!materials?.silo)
		. += "<span class='notice'>No ore silo connected. Use a multi-tool to link an ore silo to this machine.</span>"
	else if(materials?.on_hold())
		. += "<span class='warning'>Ore silo access is on hold, please contact the quartermaster.</span>"

/obj/machinery/mineral/bluespace_miner/process()
	if(!materials?.silo || materials?.on_hold())
		return
	var/datum/component/material_container/mat_container = materials.mat_container
	if(!mat_container || panel_open || !powered())
		return
	if(debugging == 1)
		materials.mat_container.insert_amount(10000,MAT_METAL)
	if(prob(10))
		materials.mat_container.insert_amount(90,MAT_BLUESPACE)
		materials.mat_container.insert_amount(90,MAT_DIAMOND)
		materials.silo_log(src, "Generated two very rare resources.")
	if(prob(30))
		materials.mat_container.insert_amount(250,MAT_URANIUM)
		materials.mat_container.insert_amount(250,MAT_TITANIUM)
		materials.mat_container.insert_amount(250,MAT_GOLD)
		materials.silo_log(src, "Generated three rare resources.")
	if(prob(60))
		materials.mat_container.insert_amount(400,MAT_PLASMA)
		materials.mat_container.insert_amount(400,MAT_SILVER)
		materials.silo_log(src, "Generated two semi-rare resources.")
	if(prob(80))
		materials.mat_container.insert_amount(600,MAT_GLASS)
		materials.mat_container.insert_amount(600,MAT_METAL)
		materials.silo_log(src, "Generated two common materials.")
	
	
