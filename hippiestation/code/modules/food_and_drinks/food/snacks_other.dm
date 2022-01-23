/obj/item/reagent_containers/food/snacks/neep_tatty_haggis
	name = "neep tatty haggis"
	desc = "Oi mate! No neeps, but double beets! SCAM!!!"
	icon_state = "neep_tatty_haggis"
	icon = 'hippiestation/icons/obj/food/food.dmi'
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/nutriment/vitamin = 10, /datum/reagent/iron = 10)
	trash = /obj/item/trash/plate
	foodtype = GRAIN | VEGETABLES | MEAT | GROSS

/obj/item/reagent_containers/food/snacks/taco/leg
	desc = "An untraditional taco with leg, cheese, and lettuce."
	icon = 'hippiestation/icons/obj/food/food.dmi'
	icon_state = "legtaco"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 2)
	filling_color = "F0D830"
	tastes = list("taco" = 2, "leg" = 4, "cheese" = 2, "lettuce" = 1)
	foodtype = MEAT | DAIRY | GRAIN | VEGETABLES | GROSS

/obj/item/reagent_containers/food/snacks/beans/old
	name = "rusted tin of beans"
	desc = "You get the feeling this has been around longer than most things in the history books."
	icon = 'hippiestation/icons/obj/food/food.dmi'
	icon_state = "oldbeans"
	tastes = list("beans" = 3, "dust" = 1)
