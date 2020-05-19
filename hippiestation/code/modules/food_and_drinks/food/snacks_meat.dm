/obj/item/reagent_containers/food/snacks/kebab/butt
	name = "butt-kebab"
	desc = "Butt on a stick."
	icon_state = "buttkebab"
	icon = 'hippiestation/icons/obj/food/food.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("butt" = 2, "metal" = 1)
	foodtype = MEAT | GROSS

/obj/item/reagent_containers/food/snacks/gondoleg
	name = "gondola leg"
	desc = "A leg of a gondola. Who would just resort to such cruelty?!"
	icon_state = "gondoleg"
	icon = 'hippiestation/icons/obj/food/food.dmi'
	list_reagents = list(/datum/reagent/consumable/nutriment = 4)
	filling_color = "#000000"
	tastes = list("meat" = 1)
	foodtype = MEAT

/obj/item/reagent_containers/food/snacks/gondoface
	name = "gondola face"
	desc = "The face of a dead gondola with an expression as calm and composed as it was during its lifetime. Good night, sweet prince."
	icon_state = "gondoface"
	icon = 'hippiestation/icons/obj/food/food.dmi'
	list_reagents = list(/datum/reagent/consumable/nutriment = 4)
	filling_color = "#000000"
	tastes = list("meat" = 1)
	foodtype = MEAT

/obj/item/reagent_containers/food/snacks/monkeycube/cowcube
	name = "cow cube"
	desc = "Just add water!"
	icon_state = "cowcube"
	icon = 'hippiestation/icons/obj/food/food.dmi'
	list_reagents = list(/datum/reagent/consumable/milk = 4, /datum/reagent/consumable/nutriment = 4)
	filling_color = "#000000"
	tastes = list("milk" = 1)
	foodtype = MEAT
	spawned_mob = /mob/living/simple_animal/cow

/obj/item/reagent_containers/food/snacks/monkeycube/chickencube
	name = "chicken cube"
	desc = "UCF approved! Just add water!"
	icon_state = "chickencube"
	icon = 'hippiestation/icons/obj/food/food.dmi'
	list_reagents = list(/datum/reagent/consumable/nutriment = 4)
	filling_color = "#000000"
	tastes = list("feathers" = 1, "United Chicken Federation propaganda" = 1)
	foodtype = MEAT
	spawned_mob = /mob/living/simple_animal/chicken

/obj/item/reagent_containers/food/snacks/monkeycube/monstercube
	name = "monster cube"
	desc = "Just add water!"
	icon_state = "monkeycube"
	bitesize = 12
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	filling_color = "#CD853F"
	tastes = list("Hell" = 1, "diarrhea" = 1)
	foodtype = MEAT
	spawned_mob = /mob/living/simple_animal/hostile/netherworld
