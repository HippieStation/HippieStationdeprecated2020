/obj/item/stack/teeth
	name = "teeth"
	singular_name = "tooth"
	w_class = 1
	throwforce = 2
	max_amount = 32
	// gender = PLURAL
	desc = "Welp. Someone had their teeth knocked out."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "teeth"

/obj/item/stack/teeth/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] jams [src] into \his eyes! It looks like \he's trying to commit suicide.</span>")
	return (BRUTELOSS)

/obj/item/stack/teeth/human
	name = "human teeth"
	singular_name = "human tooth"

/obj/item/stack/teeth/human/New()
	..()
	transform *= TransformUsingVariable(0.25, 1, 0.5) //Half-size the teeth

/obj/item/stack/teeth/human/gold //Special traitor objective maybe?
	name = "golden teeth"
	singular_name = "gold tooth"
	desc = "Someone spent a fortune on these."
	icon_state = "teeth_gold"

/obj/item/stack/teeth/human/wood
	name = "wooden teeth"
	singular_name = "wooden tooth"
	desc = "Made from the worst trees botany can provide."
	icon_state = "teeth_wood"

/obj/item/stack/teeth/generic //Used for species without unique teeth defined yet
	name = "teeth"

/obj/item/stack/teeth/generic/New()
	..()
	transform *= TransformUsingVariable(0.25, 1, 0.5) //Half-size the teeth

/obj/item/stack/teeth/replacement
	name = "replacement teeth"
	singular_name = "replacement tooth"
	// gender = PLURAL
	desc = "First teeth, now replacements. When does it end?"
	icon_state = "dentals"

/obj/item/stack/teeth/replacement/New()
	..()
	transform *= TransformUsingVariable(0.25, 1, 0.5) //Half-size the teeth

/obj/item/stack/teeth/cat
	name = "tarajan teeth"
	singular_name = "tarajan tooth"
	desc = "Treasured trophy."
	sharpness = IS_SHARP
	icon_state = "teeth_cat"

/obj/item/stack/teeth/cat/New()
	..()
	transform *= TransformUsingVariable(0.35, 1, 0.5) //resize the teeth

/obj/item/stack/teeth/lizard
	name = "lizard teeth"
	singular_name = "lizard tooth"
	desc = "They're quite sharp."
	sharpness = IS_SHARP
	icon_state = "teeth_cat"

/obj/item/stack/teeth/lizard/New()
	..()
	transform *= TransformUsingVariable(0.30, 1, 0.5) //resize the teeth

/obj/item/stack/teeth/xeno
	name = "xenomorph teeth"
	singular_name = "xenomorph tooth"
	desc = "The only way to get these is to capture a xenomorph and surgically remove their teeth."
	throwforce = 4
	sharpness = IS_SHARP
	icon_state = "teeth_xeno"
	max_amount = 48