//Spawner grenades for the loot spawners specific to CentCom. Original code in spawnergrenade.dm

/obj/item/grenade/spawnergrenade/cluwne
	name = "Clownade"
	desc = "What has science done?"
	spawner_type = /mob/living/simple_animal/hostile/floor_cluwne
	deliveryamt = 5

/obj/item/grenade/spawnergrenade/gorilla
	name = "Gorillanade"
	spawner_type = /mob/living/simple_animal/hostile/gorilla
	deliveryamt = 5

/obj/item/grenade/spawnergrenade/colossus //This is ONLY intended for the weaponry lootdrops at CentCom. For obvious reasons, this should otherwise not show up anywhere.
	name = "Colossusnade"
	spawner_type = /mob/living/simple_animal/hostile/megafauna/colossus
	deliveryamt = 1