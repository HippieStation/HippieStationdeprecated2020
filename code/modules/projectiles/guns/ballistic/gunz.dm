/obj/item/weapon/gun/custom
	icon_state = "energy"
	name = "placeholder"
	desc = "A basic energy-based gun."
	icon = 'icons/obj/guns/gunz.dmi'
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'


/obj/item/weapon/gun/ballistic/automatic/pistol/luger
	name = "P10 Luger"
	desc = "A customized P08 Luger. This one fires the now popular 10mm standard, rather then 9mm Luger, giving it an extra punch."
	icon = 'icons/obj/guns/gunz.dmi'
	icon_state = "p08"
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = "combat=3;materials=2;syndicate=2"
	mag_type = /obj/item/ammo_box/magazine/m10mm
	can_suppress = 0
	burst_size = 1
	fire_delay = 0
	actions_types = list()

/obj/item/weapon/gun/energy/laspistol
	name ="Laspistol"
	icon = 'icons/obj/guns/gunz.dmi'
	icon_state = "laspistol"
	desc = "A powerful handgun in ourtime, but in the future it's worth nothing. it's fuckeasy to make, maintain, use, and die with. Especially the latter. The laspistol lacks the range of the lasgun but when in range it has the same effect as the lasgun. Basically, if because the lasgun is a flash light, the laspistol is a pocket light. "
	ammo_x_offset = 3

/obj/item/weapon/gun/ballistic/automatic/mp80
	name = "\improper MP80"
	desc = "The MP80 is a old weapon reimagined. Now with a burst fire, it's become a fast favioute of security, insurgents, terrorists, and police units outside of Nanotrasen space. If you want to arm a organization on a budget, this is the gun for you."
	icon = 'icons/obj/guns/gunz.dmi'
	icon_state = "mp80"
	mag_type = /obj/item/ammo_box/magazine/smgm9mm
	pin = null
	can_suppress = 0
	burst_size = 3
	fire_delay = 2
	actions_types = list(/datum/action/item_action/toggle_firemode)

/obj/item/weapon/gun/ballistic/automatic/co5
	name = "\improper CO5E"
	desc = "A submachine gun that's found its way into private security and space caravans alike. It's small and easy to hide, although it damages leaves something to be desired at best. They've become amazingly cheap as now the C20R has become the goto SMG."
	icon = 'icons/obj/guns/gunz.dmi'
	icon_state = "c05r"
	mag_type = /obj/item/ammo_box/magazine/smgm9mm
	pin = null
	w_class = WEIGHT_CLASS_SMALL
	force = 5
	can_suppress = 0
	burst_size = 3
	fire_delay = 2
	actions_types = list(/datum/action/item_action/toggle_firemode)

/obj/item/weapon/gun/ballistic/pistol/usp
	name = "K&M 10mm Tactical"
	desc = "The Tactical has seen fights from all over the world, seen in the hands of the counter terrorism units in the 20th and 21st century. Yeah, it's a bit old and doesn't even have an ammo counter or attachments, but it does it's duty well. You can put a supressor on this weapon."
	icon = 'icons/obj/guns/gunz.dmi'
	icon_state = "usp"
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = "combat=3;materials=2;syndicate=2"
	mag_type = /obj/item/ammo_box/magazine/m10mm
	can_suppress = 1
	burst_size = 1
	fire_delay = 0
	actions_types = list()
