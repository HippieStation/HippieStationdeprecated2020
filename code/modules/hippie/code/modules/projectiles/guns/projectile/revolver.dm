/obj/item/weapon/gun/energy/revolver/plasmoidcombi
	name = "Plasma-.357 Combi Revolver"
	desc = "A highly advanced ballistic-energy weapon hybrid capable of firing both singular plasmoid bursts and printed .357 rounds, printing .357 rounds incurs a significant power draw"
	cell_type = /obj/item/weapon/stock_parts/cell/combi
	icon = 'icons/hippie/obj/guns/energy.dmi'
	icon_state = "plasmoid_combi_revolver"
	ammo_type = list(/obj/item/ammo_casing/energy/plasmoid, /obj/item/ammo_casing/energy/e357)
	pin = /obj/item/device/firing_pin

/obj/item/weapon/gun/energy/revolver/plasmoidcombi/attack_self(mob/living/user)
	select_fire(user)