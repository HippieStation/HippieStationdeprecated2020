/obj/item/kitchen/knife/wizard
	name = "wizard's knife"
	desc = "Good for impaling the necks of enemies. Or just chucking 10 at a time... time."
	throwforce = 15
	throw_range = 7
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 90, "embedded_fall_chance" = 10, "embedded_ignore_throwspeed_threshold" = TRUE)

/obj/item/storage/backpack/duffelbag/syndie/knives
	name = "bag o' knives"

/obj/item/storage/backpack/duffelbag/syndie/knives/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/kitchen/knife/wizard(src)
