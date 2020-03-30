/obj/item/clothing/under/rank/security
	name = "classic security jumpsuit"
	desc = "The classic, tactical Nanotrasen security outfit, complete with an NT belt buckle."

/obj/item/clothing/under/rank/warden/hippie
	name = "classic warden's jumpsuit"
	desc = "The classic, assorted jumpsuit of the guy who took every gun out of the armory and died instantly."

/obj/item/clothing/under/rank/head_of_security/hippie
	name = "classic head of security's jumpsuit"
	desc = "The classic, decorated jumpsuit of the guy who ran around tasing everyone in sight until he slipped on soap and got dragged into a maint corridor, never to be seen again."

/obj/item/clothing/under/rank/security/hippie
	name = "security jumpsuit"
	desc = "An official security jumpsuit for officers complete with black pants."
	icon = 'hippiestation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/uniform.dmi'
	icon_state = "sec-uniform"
	item_state = "sec-uniform"
	item_color = "sec-uniform"
	can_adjust = FALSE // Unfortunately, the days of MUSCLE SEC are over. Perhaps the biggest crime of the new security.

/obj/item/clothing/under/rank/warden/hippie
	name = "security suit"
	desc = "A formal security suit for wardens complete with Nanotrasen belt buckle."
	icon = 'hippiestation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/uniform.dmi'
	icon_state = "warden-uniform"
	item_state = "warden-uniform"
	item_color = "warden-uniform"
	can_adjust = FALSE

/obj/item/clothing/under/rank/head_of_security/hippie
	name = "head of security's jumpsuit"
	desc = "The most esteemed Security jumpsuit, created from the finest materials in the galaxies, and solid gold to boot. Said to be worth £250,000."
	icon = 'hippiestation/icons/obj/clothing/uniforms.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/uniform.dmi'
	icon_state = "hos-uniform"
	item_state = "hos-uniform"
	item_color = "hos-uniform"
	can_adjust = FALSE

/obj/item/clothing/under/rank/head_of_security/hippie/spare
	name = "head of security's spare jumpsuit"
	desc = "It's just the Warden's jumpsuit, except the accessories are painted yellow. A real, respectable HoS would wear no such thing!"

/obj/item/clothing/under/rank/security/skirt/Initialize()
	qdel(src) // No. 
