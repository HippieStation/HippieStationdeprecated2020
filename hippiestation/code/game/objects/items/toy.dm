/obj/item/toy/dummy
	desc = "It's a dummy, dummy. Altclick to change the dummy's name"

/obj/item/toy/dummy/AltClick(mob/user)
	var/new_name = stripped_input(usr,"What would you like to name the dummy?","Input a name",doll_name,MAX_NAME_LEN)
	if(!new_name) return
	doll_name = new_name
	to_chat(user, "You name the dummy as \"[doll_name]\"")
	name = "[initial(name)] - [doll_name]"

/obj/item/toy/dummy/attack_self(mob/user)
	var/msg = stripped_input("What is [doll_name] saying", "Doll ass play")
	if(user.is_holding_item_of_type(src)) talk_into(user, msg)
	else to_chat(user,"You lost your dummy dummy")

/obj/item/toy/cards
	var/card_sharpness
	var/card_embed_chance = 0

/obj/item/toy/cards/singlecard
	w_class = WEIGHT_CLASS_SMALL // Helps with embed chances.

/obj/item/toy/cards/singlecard/apply_card_vars(obj/item/toy/cards/singlecard/newobj,obj/item/toy/cards/sourceobj)
	..()
	newobj.card_embed_chance = sourceobj.card_embed_chance
	newobj.embedding = newobj.embedding.setRating(embed_chance = card_embed_chance)
	newobj.card_sharpness = sourceobj.card_sharpness
	newobj.sharpness = newobj.card_sharpness

/obj/item/toy/cards/deck/syndicate
	card_throwforce = 10
	card_embed_chance = 80
	card_sharpness = IS_SHARP //so you can embed it like the old way
	card_throw_speed = 6