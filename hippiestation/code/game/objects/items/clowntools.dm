/obj/item/storage/belt/fannypack/clown
	name = "fannypack"
	desc = "A dorky fannypack for keeping small items in."
	icon_state = "fannypack_leather"
	item_state = "fannypack_leather"
	storage_slots = 4
	max_w_class = WEIGHT_CLASS_SMALL

/obj/item/storage/belt/fannypack/clown/full/PopulateContents()
	new /obj/item/screwdriver/power/clown(src)
	new /obj/item/crowbar/power(src)
	new /obj/item/weldingtool/clown(src)
	new /obj/item/device/multitool/clown(src)

/obj/item/screwdriver/power/clown
	name = "chompie the honk"
	desc = "A multi-purpose pranking tool. It has teeth capable of unscrewing things at a slow rate."
	icon = 'hippiestation/icons/obj/clowntools.dmi'
	icon_state = "chompie_screw"
	item_state = "clown_screw"
	lefthand_file = 'hippiestation/icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/equipment/tools_righthand.dmi'
	materials = list(MAT_BANANIUM=1000) // HONK!
	force = 5
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 2
	throw_speed = 10 // you will not escape chompie
	throw_range = 10 //light as balls
	attack_verb = list("bit", "chomped", "booped")
	hitsound = 'sound/weapons/bite.ogg'
	usesound = 'hippiestation/sound/effects/clowndriver.ogg'
	toolspeed = 0.75 // slightly faster than the regular screwdriver
	random_color = FALSE

/obj/item/screwdriver/power/clown/suicide_act(mob/living/user)
	user.visible_message("<span class='suicide'>[src] bites [user]'s head right off! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	if(the_head)
		the_head.dismember()
		return(BRUTELOSS)
	else
		return(BRUTELOSS)

/obj/item/screwdriver/power/clown/attack_self(mob/user)
	playsound(get_turf(user),'sound/items/change_drill.ogg',50,1)
	var/obj/item/wrench/power/clown/b_drill = new /obj/item/wrench/power/clown
	to_chat(user, "<span class='notice'>You remove chompie from [src] and put on a mallet head.</span>")
	qdel(src)
	user.put_in_active_hand(b_drill)

