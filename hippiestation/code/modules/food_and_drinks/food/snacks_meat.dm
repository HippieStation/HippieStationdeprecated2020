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
