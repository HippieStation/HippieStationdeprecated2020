/obj/item/reagent_containers/glass/beaker/bluespace
	materials = list(MAT_GLASS = 5000, MAT_PLASMA = 3000, MAT_DIAMOND = 1000, MAT_BLUESPACE = 1000) // matches the materials it's made of with the recipe in medical_designs.dm

/obj/item/reagent_containers/glass/beaker/huge
	name = "huge beaker"
	desc = "A very large beaker. Can hold up to 500 units."
	icon_state = "beakerlarge1"
	materials = list(MAT_GLASS=12500)
	volume = 500
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(1,5,10,15,20,25,30,50,100,250,500) //very precise measurements
	w_class = WEIGHT_CLASS_SMALL //it's quite a bit bigger than most beakers

/obj/item/reagent_containers/glass/beaker/huge/Initialize()
	. = ..()
	var/matrix/M = matrix()
	M.Scale(1.1, 1.1)

/obj/item/reagent_containers/glass/beaker/huge/update_icon()
	icon_state = "beakerlarge" // hack to lets us reuse the large beaker reagent fill states
	..()
	icon_state = "beakerlarge1"
