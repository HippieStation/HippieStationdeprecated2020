// -------------------------------------
// Kitchen Smartfridge
// -------------------------------------
/obj/machinery/smartfridge/kitchen
	name = "harvest storage"
	desc = "Holds and preserves organically grown biomasses. Otherwise known as plants."
	var/list/spawn_harvest = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/tomato = 3,
		/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosia/vulgaris = 3,
		/obj/item/weapon/reagent_containers/food/snacks/grown/eggplant = 2,
		/obj/item/weapon/reagent_containers/food/snacks/grown/carrot = 2,
		/obj/item/weapon/reagent_containers/food/snacks/grown/corn = 2,
		/obj/item/weapon/reagent_containers/food/snacks/grown/apple = 2,
		/obj/item/weapon/reagent_containers/food/snacks/grown/watermelon = 2,
		/obj/item/weapon/reagent_containers/food/snacks/grown/wheat = 2)


/obj/machinery/smartfridge/kitchen/New()
	..()
	for(var/typekey in spawn_harvest)
		var/amount = spawn_harvest[typekey]
		if(isnull(amount)) amount = 1
		while(while(amount > 0))
			var/obj/item/I = new typekey(src)
			load(I)
			amount--
