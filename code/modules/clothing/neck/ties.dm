/obj/item/clothing/neck/tie
	name = "tie"
	desc = "A neosilk clip-on tie."
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "bluetie"
	item_state = ""	//no inhands
	item_color = "bluetie"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/neck/tie/blue
	name = "blue tie"
	icon_state = "bluetie"
	item_color = "bluetie"

/obj/item/clothing/neck/tie/red
	name = "red tie"
	icon_state = "redtie"
	item_color = "redtie"

/obj/item/clothing/neck/tie/cable
	name = "cable-coil bowtie"
	desc = "When you're too lazy to tie a noose to the ceiling."
	icon_state = "coiltie"
	item_color = "coiltie"

/obj/item/clothing/neck/tie/black
	name = "black tie"
	icon_state = "blacktie"
	item_color = "blacktie"

/obj/item/clothing/neck/tie/horrible
	name = "horrible tie"
	desc = "A neosilk clip-on tie. This one is disgusting."
	icon_state = "horribletie"
	item_color = "horribletie"

/obj/item/clothing/neck/stethoscope
	name = "stethoscope"
	desc = "An outdated medical apparatus for listening to the sounds of the human body. It also makes you look like you know what you're doing."
	icon_state = "stethoscope"
	item_color = "stethoscope"

/obj/item/clothing/neck/stethoscope/attack(mob/living/carbon/human/M, mob/living/user)
	if(ishuman(M) && isliving(user))
		if(user.a_intent == INTENT_HELP)
			var/body_part = parse_zone(user.zone_selected)
			if(body_part)
				var/their = "their"
				switch(M.gender)
					if(MALE)
						their = "his"
					if(FEMALE)
						their = "her"

				var/sound = "pulse"
				var/sound_strength

				if(M.stat == DEAD || (M.status_flags&FAKEDEATH))
					sound_strength = "cannot hear"
					sound = "anything"
				else
					sound_strength = "hear a weak"
					switch(body_part)
						if("chest")
							if(M.oxyloss < 50)
								sound_strength = "hear a healthy"
							sound = "pulse and respiration"
						if("eyes","mouth")
							sound_strength = "cannot hear"
							sound = "anything"
						else
							sound_strength = "hear a weak"

				user.visible_message("[user] places [src] against [M]'s [body_part] and listens attentively.", "You place [src] against [their] [body_part]. You [sound_strength] [sound].")
				return
	return ..(M,user)

///////////
//SCARVES//
///////////

/obj/item/clothing/neck/scarf //Default white color, same functionality as beanies.
	name = "white scarf"
	icon_state = "scarf"
	desc = "A stylish scarf. The perfect winter accessory for those with a keen fashion sense, and those who just can't handle a cold breeze on their necks."
	item_color = "scarf"
	dog_fashion = /datum/dog_fashion/head

/obj/item/clothing/neck/scarf/black
	name = "black scarf"
	icon_state = "scarf"
	color = "#4A4A4B" //Grey but it looks black

/obj/item/clothing/neck/scarf/red
	name = "red scarf"
	icon_state = "scarf"
	color = "#D91414" //Red

/obj/item/clothing/neck/scarf/green
	name = "green scarf"
	icon_state = "scarf"
	color = "#5C9E54" //Green

/obj/item/clothing/neck/scarf/darkblue
	name = "dark blue scarf"
	icon_state = "scarf"
	color = "#1E85BC" //Blue

/obj/item/clothing/neck/scarf/purple
	name = "purple scarf"
	icon_state = "scarf"
	color = "#9557C5" //purple

/obj/item/clothing/neck/scarf/yellow
	name = "yellow scarf"
	icon_state = "scarf"
	color = "#E0C14F" //Yellow

/obj/item/clothing/neck/scarf/orange
	name = "orange scarf"
	icon_state = "scarf"
	color = "#C67A4B" //orange

/obj/item/clothing/neck/scarf/cyan
	name = "cyan scarf"
	icon_state = "scarf"
	color = "#54A3CE" //Cyan


//Striped scarves get their own icons

/obj/item/clothing/neck/scarf/zebra
	name = "zebra scarf"
	icon_state = "zebrascarf"
	item_color = "zebrascarf"

/obj/item/clothing/neck/scarf/christmas
	name = "christmas scarf"
	icon_state = "christmasscarf"
	item_color = "christmasscarf"

//The three following scarves don't have the scarf subtype
//This is because Ian can equip anything from that subtype
//However, these 3 don't have corgi versions of their sprites
/obj/item/clothing/neck/stripedredscarf
	name = "striped red scarf"
	icon_state = "stripedredscarf"
	item_color = "stripedredscarf"

/obj/item/clothing/neck/stripedgreenscarf
	name = "striped green scarf"
	icon_state = "stripedgreenscarf"
	item_color = "stripedgreenscarf"

/obj/item/clothing/neck/stripedbluescarf
	name = "striped blue scarf"
	icon_state = "stripedbluescarf"
	item_color = "stripedbluescarf"

/obj/item/clothing/neck/petcollar //don't really wear this though please c'mon seriously guys
	name = "pet collar"
	desc = "It's for pets. Though you probably could wear it yourself, you'd doubtless be the subject of ridicule."
	icon_state = "petcollar"
	item_color = "petcollar"
	var/tagname = null

/obj/item/clothing/neck/petcollar/attack_self(mob/user)
	tagname = copytext(sanitize(input(user, "Would you like to change the name on the tag?", "Name your new pet", "Spot") as null|text),1,MAX_NAME_LEN)
	name = "[initial(name)] - [tagname]"

//////////////
//DOPE BLING//
//////////////

/obj/item/clothing/neck/necklace/dope
	name = "gold necklace"
	desc = "Damn, it feels good to be a gangster."
	icon = 'icons/obj/clothing/ties.dmi'
	icon_state = "bling"
	item_color = "bling"

//Here comes the tooth necklace, wanted to keep it in the same area as most under attachments. This seems to be the best place
/obj/item/clothing/tie/necklace
	name = "necklace"
	w_class = 2
	desc = "Can attach teeth to it."
	icon = 'icons/obj/clothing/ties.dmi'
	icon_state = "necklace_red"
	var/list/ornaments = list() //Teeth attached to this.
	var/max_ornaments = 16
	var/updatecolor = "red"
	item_color = "necklace" //Workaround, necklace color won't show up on person but whether or not teeth are on it will

/obj/item/clothing/tie/necklace/New()
	..()
	update_icon()

/obj/item/clothing/tie/necklace/update_icon()
	icon_state = "necklace_[updatecolor]"
	item_color = "necklace"
	overlays.Cut()
	if(ornaments && ornaments.len)
		item_color = "necklace_teeth"
		var/i = 0
		for(var/obj/item/I in ornaments)
			if(i >= 10) break //Too many teeth already, no room to display anymore
			var/image/img = image(icon,src,"o_[I.icon_state]")
			if(img)
				i++
				//X for tooth number N = necklace center X - tooth spacing * tooth count / 2 + tooth spacing * N
				var/necklace_center_x = 14
				var/tooth_spacing = 2
				img.pixel_x = necklace_center_x - tooth_spacing * min(ornaments.len, 10) / 2 + tooth_spacing * i
				//TODO: Make below if checks a single calculation like pixel_x
				if(img.pixel_x < 11 || img.pixel_x > 19)
					img.pixel_y += 1
				if(img.pixel_x < 9 || img.pixel_x > 21)
					img.pixel_y += 1
				if(img.pixel_x < 8 || img.pixel_x > 22)
					img.pixel_y += 1

				overlays += img

/obj/item/clothing/tie/necklace/examine(mob/user)
	..()
	user << "It contains:"
	for(var/obj/item/I in ornaments)
		var/getname = I.name
		if(istype(I, /obj/item/stack))
			var/obj/item/stack/S = I
			getname = S.singular_name
		user << "\icon[I] \a [getname]"

/obj/item/clothing/tie/necklace/attack_self(mob/user)
	if(ornaments.len)
		user << "You shuffle the ornaments on the necklace."
		ornaments = shuffle(ornaments)
		update_icon()

/obj/item/clothing/tie/necklace/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/wirecutters))
		new /obj/item/stack/cable_coil(user.loc, 4, updatecolor)
		for(var/obj/item/I in ornaments)
			I.loc = user.loc
		user << "You cut the necklace."
		qdel(src)
		return
	if(istype(W, /obj/item/stack/teeth))
		if(ornaments.len >= max_ornaments)
			user << "There's no room for \the [src]!"
			return
		var/obj/item/stack/teeth/O = W
		var/obj/item/stack/teeth/T = new O.type(user, 1)
		T.copy_evidences(src)
		T.add_fingerprint(user)
		ornaments += T
		T.loc = src
		O.use(1) //Take some teeth from the teeth stack
		update_icon()
		user << "You add one [T] to \the [src]."

/obj/item/stack/teeth/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/cable_coil))
		src.add_fingerprint(user)
		var/obj/item/stack/cable_coil/C = W
		if(C.amount < 4)
			usr << "<span class='danger'>You need at least 4 lengths to make a necklace!</span>"
			return
		var/obj/item/clothing/tie/necklace/N = new (usr.loc)
		N.updatecolor = C.item_color
		var/obj/item/stack/teeth/T = new src.type(user, 1)
		T.copy_evidences(src)
		T.add_fingerprint(user)
		src.use(1) //Take some teeth from the teeth stack
		N.ornaments += T
		T.loc = N
		N.update_icon()
		C.use(4) //Take some cables
	else
		..()

////////////////
//OONGA BOONGA//
////////////////

/obj/item/clothing/neck/talisman
	name = "bone talisman"
	desc = "A hunter's talisman, some say the old gods smile on those who wear it."
	icon_state = "talisman"
	item_color = "talisman"
	armor = list(melee = 5, bullet = 5, laser = 5, energy = 5, bomb = 20, bio = 20, rad = 5, fire = 0, acid = 25)