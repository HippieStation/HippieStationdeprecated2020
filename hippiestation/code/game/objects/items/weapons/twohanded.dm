#define FAXE_GOUT_TIME 15
#define FAXE_BURNWALL_TIME 100

/obj/item/twohanded/fireaxe/fireyaxe
	desc = "This axe has become touched by the very flames it was built to destroy..."
	force_wielded = 5
	damtype = "fire" //do do doooo, I'll take you to buurn.
	heat = 1000
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	icon_state = "fireaxe0"
	alternate_worn_icon = 'hippiestation/icons/mob/back.dmi'
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi'
	attack_verb = list("incinerated", "conflagrated", "seared", "scorched", "roasted", "immolated")
	var/charged = TRUE
	var/burnwall = TRUE
	var/static/list/extra_damage_targets = typecacheof(list(/obj/structure/door_assembly, /obj/structure/grille, /obj/structure/mineral_door, /obj/structure/window, /obj/machinery/door))

/obj/item/twohanded/fireaxe/fireyaxe/Initialize()
	.=..()

/obj/item/twohanded/fireaxe/fireyaxe/update_icon()
	icon_state = "fireaxe[wielded]"
	return

/obj/item/projectile/bullet/incendiary/shell/firehammer
	name = "fiery gout"
	damage = 0 //Its for burnin' not shootin'

/obj/item/twohanded/fireaxe/fireyaxe/attack(mob/living/carbon/M, mob/user)
	if(!wielded)
		return ..()
	if(isliving(M))
		var/def_check = M.getarmor(type = "fire")
		to_chat(M, "<span class='danger'>The fires of the [name] burn you!</span>")
		if(M.on_fire)
			to_chat(M, "<span class='danger'>The fire burns hotter!</span>")
			M.apply_damage(25, BURN, blocked = def_check)
		M.adjust_fire_stacks(3)
		if(M.IgniteMob())
			message_admins("[key_name_admin(user)] set [key_name_admin(M)] on fire")
			log_game("[key_name(user)] set [key_name(M)] on fire")
	..()

/obj/item/twohanded/fireaxe/fireyaxe/afterattack(atom/target, mob/living/user, proximity_flag)
	if(!proximity_flag && charged && wielded)
		var/turf/proj_turf = user.loc
		if(!isturf(proj_turf))
			return
		var/obj/item/projectile/bullet/incendiary/shell/firehammer/F = new /obj/item/projectile/bullet/incendiary/shell/firehammer(proj_turf)
		F.preparePixelProjectile(target, get_turf(target), user)
		F.firer = user
		playsound(user, 'sound/magic/Fireball.ogg', 100, 1)
		F.fire()
		charged = FALSE
		addtimer(CALLBACK(src, .proc/recharge), FAXE_GOUT_TIME)
		return
	if(wielded && proximity_flag)
		var/obj/J = target
		if(is_type_in_typecache(J, extra_damage_targets))
			J.take_damage(75, BRUTE, "melee", 0)
	if(iswallturf(target))
		var/turf/closed/wall/Wall = target
		if(Wall.hardness <= 10)// Rwalls have hardness 10, this can be adjusted to make certain walls resistant to burning
			to_chat(user, "<span class='danger'>This wall is to strong to be burned by the flames!</span>")
		else if(burnwall)
			Wall.thermite += 50 //how wall.thermite works is funny but the end result of any logic needs to be 50 for a wall to melt
			Wall.overlays = list()
			Wall.add_overlay(mutable_appearance('icons/effects/effects.dmi', "thermite"))
			to_chat(user, "<span class='danger'>The wall has been marked, strike it once more to ignite the flames!</span>")
			burnwall = FALSE
			addtimer(CALLBACK(src, .proc/rekindle), FAXE_BURNWALL_TIME)
		else
			to_chat(user, "<span class='danger'>The flames need time to rekindle!</span>")
		..()

/obj/item/twohanded/fireaxe/fireyaxe/proc/recharge()
	if(!charged)
		charged = TRUE
		playsound(src.loc, 'hippiestation/sound/effects/corpseexplosion.ogg', 100, 1)

/obj/item/twohanded/fireaxe/fireyaxe/proc/rekindle()
	if(!burnwall)
		burnwall = TRUE
		var/mob/M = get(src, /mob)
		to_chat(M, "<span class='danger'>The axe grows warmer in your hands, it's ready to mark another wall!</span>")

#undef FAXE_GOUT_TIME
#undef FAXE_BURNWALL_TIME