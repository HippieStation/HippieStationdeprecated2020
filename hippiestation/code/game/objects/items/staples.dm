/obj/item/stack/staples
	name = "staples"
	singular_name = "staple"
	desc = "Staples for use with a staplegun."
	icon = 'hippiestation/icons/obj/staples.dmi'
	icon_state = "staples"
	item_state = "staples"
	force = 0
	throw_speed = 2
	throw_range = 7
	throwforce = 1
	w_class = 1
	materials = list(MAT_METAL = 100)
	max_amount = 10
	attack_verb = list("stapled")

/obj/item/stack/staples/Initialize(loc, amount=0)
	. = ..()
	update_icon()

/obj/item/stack/staples/update_icon()
	if(get_amount() <= 1)
		icon_state = "staple"
		name = "staple"
	else
		icon_state = "staples"
		name = "staples"

/obj/item/staplegun
	name = "Staple gun"
	desc = "Insert paper you want to staple and then use the gun on a wall/floor. CAUTION: Don't use on people."
	icon = 'hippiestation/icons/obj/staples.dmi'
	icon_state = "staplegun"
	force = 0
	throw_speed = 2
	throw_range = 5
	throwforce = 5
	w_class = 2
	attack_verb = list("stapled")
	var/ammo = 5
	var/max_ammo = 10
	var/obj/item/paper/P
	var/obj/item/organ/butt/B

/obj/item/staplegun/Initialize()
	.=..()
	update_icon()

/obj/item/staplegun/examine(mob/user)
	..()
	to_chat(user, "<span class='notice'>It contains [ammo]/[max_ammo] staples.</span>")
	if(istype(P))
		to_chat(user, "<span class='notice'>There's [P] loaded in it.</span>")
	if(istype(B))
		to_chat(user, "<span class='notice'>There's a butt loaded in it... What?</span>")

/obj/item/staplegun/update_icon()
	var/amt = max(0, min(round(ammo/1.5), 6))
	cut_overlays()
	add_overlay(icon(icon, "[icon_state][amt]"))

/obj/item/staplegun/attack(mob/living/target, mob/living/user)
	if(ammo <= 0)
		playsound(user, 'sound/weapons/empty.ogg', 100, 1)
		return

	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		if(user.zone_selected =="groin")
			if(!H.w_uniform)
				if(!(target.getorgan(/obj/item/organ/butt)))
					if(istype(B))
						B.Insert(target)
						user.visible_message("<span class='danger'>[user] staples \the [B] back on [user == target ? "his" : "[target]'s"] groin!</span>", "<span class='userdanger'>You staple [user == target ? "your" : "[target]'s"] butt back on, but it looks loose!</span>")
						B.loose = TRUE
						B = null
				else
					to_chat(user, "<span class='danger'>[target == user ? "You" : "[target]"] already [target == user ? "have" : "has"] a butt!</span>")
					return FALSE
			else
				to_chat(user, "<span class='danger'>You must remove [target == user ? "your" : "[target]'s"] jumpsuit before doing that!</span>")
				return FALSE
		var/obj/item/bodypart/O = H.get_bodypart(ran_zone(user.zone_selected))
		var/armor = H.run_armor_check(O, "melee")
		if(armor <= 40 && istype(O))
			if(istype(P)) //If the staplegun contains paper...
				H.try_to_embed(P,O)//forceembed it
				P = null
			else
				var/obj/item/stack/staples/S = new /obj/item/stack/staples
				H.try_to_embed(S,O)
			user.visible_message("<span class='danger'>[user] has stapled [target] in the [O]!</span>", "<span class='userdanger'>You staple [target]!</span>")
			H.update_damage_overlays()
			log_combat(user, H, "stapled", src)
		else
			visible_message("<span class='danger'>[user] has attempted to staple [target] in the [O]!</span>")
	else
		..()

	playsound(user, 'hippiestation/sound/weapons/staplegun.ogg', 50, 1)
	ammo--
	update_icon()

/obj/item/staplegun/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return

	if(ammo <= 0)
		playsound(user, 'sound/weapons/empty.ogg', 100, 1)
		return

	if(istype(P))
		if(isturf(target))
			var/turf/T = target
			playsound(T, 'hippiestation/sound/weapons/staplegun.ogg', 50, 1)
			user.visible_message("<span class='danger'>[user] has stapled [P] into the [target]!</span>")
			P.forceMove(T)
			P.anchored = TRUE //like why would you want to pull this around
			P = null
			ammo -= 1
			update_icon()

/obj/item/staplegun/attack_self(mob/user)
	if(istype(P))
		to_chat(user, "<span class='notice'>You take out \the [P] out of \the [src].")
		P.forceMove(user.loc)
		P = null
	else if(istype(B))
		to_chat(user, "<span class='notice'>You take out \the [B] out of \the [src].")
		B.forceMove(user.loc)
		B = null
	else if(ammo)
		to_chat(user, "<span class='notice'>You take out the [ammo > 1 ? "staples" : "staple"] out of \the [src].")
		new /obj/item/stack/staples(user.loc, ammo)
		ammo = 0

/obj/item/staplegun/attackby(obj/item/I, mob/user)
	..()
	if(istype(I, /obj/item/stack/staples))
		if(ammo < max_ammo)
			var/obj/item/stack/staples/S = I
			var/maxamt = max_ammo - ammo
			if(S.amount < maxamt)
				maxamt = S.amount
			S.amount -= maxamt
			if(S.amount <= 0)
				user.doUnEquip(S, 1)
				qdel(S)
			ammo += maxamt
			update_icon()
			to_chat(user, "<span class='notice'>You insert [maxamt] staples in \the [src]. Now it contains [ammo] staples.")
		else
			to_chat(user, "<span class='notice'>\The [src] is already full!</span>")

	if(istype(I, /obj/item/paper))
		if(!istype(P))
			user.dropItemToGround(user.get_active_held_item())
			I.forceMove(src)
			P = I
			to_chat(user, "<span class='notice'>You put \the [P] in \the [src].")
		else
			to_chat(user, "<span class='notice'>There is already a paper in \the [src]!")
	if(istype(I, /obj/item/organ/butt))
		if(!istype(P))
			if(!istype(B))
				user.dropItemToGround(user.get_active_held_item())
				I.forceMove(src)
				B = I
				to_chat(user, "<span class='notice'>You put \the [B] in \the [src].</span>")
			else
				to_chat(user, "<span class='notice'>There is already a butt in \the [src]!</span>")
		else
			to_chat(user, "<span class='notice'>There is already a paper in \the [src]!</span>")

//coffin nailing for stapler instead of welding
/obj/structure/closet/coffin/update_icon()
	cut_overlays()
	if(!opened)
		if(icon_door)
			add_overlay("[icon_door]_door")
		else
			add_overlay("[icon_state]_door")
		if(welded)
			add_overlay("nailed")
		if(secure)
			if(!broken)
				if(locked)
					add_overlay("locked")
				else
					add_overlay("unlocked")
			else
				add_overlay("off")

	else if(icon_door_override)
		add_overlay("[icon_door]_open")
	else
		add_overlay("[icon_state]_open")

/obj/structure/closet/coffin/attackby(obj/item/W, mob/user, params)
	if(user in src)
		return
	if(opened)
		if(user.dropItemToGround(W))
			W.forceMove(loc)
			return TRUE
	else if(istype(W, /obj/item/staplegun) && !welded)
		var/obj/item/staplegun/WS = W
		if(WS.ammo >= 10)
			to_chat(user, "<span class='notice'>You begin stapling \the [src]...</span>")
			playsound(loc, 'hippiestation/sound/weapons/staplegun.ogg', 50, 1)
			if(do_after(user,40,5,1, target = src))
				if(opened || !istype(src, /obj/structure/closet) || !user || !WS || !user.loc )
					return
				playsound(loc, 'hippiestation/sound/weapons/staplegun.ogg', 50, 1)
				welded = TRUE
				to_chat(user, "<span class='notice'>You staple [src] shut.</span>")
				update_icon()
				user.visible_message("[user.name] has stapled [src] shut with \the [WS].", "<span class='warning'>You staple [src] shut.</span>")
				WS.ammo -= 10
			return
	else if(istype(W, /obj/item/crowbar) && welded)
		to_chat(user, "<span class='notice'>You begin prying out staples from \the [src]...</span>")
		playsound(loc, 'sound/items/crowbar.ogg', 50, 1)
		if(do_after(user,80,5,1, target = src))
			if(opened || !istype(src, /obj/structure/closet) || !user || !W || !user.loc )
				return
			playsound(loc, 'sound/items/crowbar.ogg', 50, 1)
			welded = FALSE
			to_chat(user, "<span class='notice'>You pry off the staples keeping [src] shut.</span>")
			update_icon()
			user.visible_message("[user.name] has pried out the staples keeping [src] shut.", "<span class='warning'>You pry out staples keeping [src] shut.</span>")
			for(var/i = 1; i <= 9; i++)
				new/obj/item/stack/staples(src.loc)
			return

	else if(istype(W, /obj/item/wrench))
		if(isinspace() && !anchored)
			return
		anchored = !anchored
		playsound(src.loc, W.usesound, 75, 1)
		user.visible_message("<span class='notice'>[user] [anchored ? "anchored" : "unanchored"] \the [src] [anchored ? "to" : "from"] the ground.</span>", \
					"<span class='notice'>You [anchored ? "anchored" : "unanchored"] \the [src] [anchored ? "to" : "from"] the ground.</span>", \
					"<span class='italics'>You hear a ratchet.</span>")

/mob/living/carbon/human/proc/try_to_embed(var/obj/item/I, var/obj/item/bodypart/L, var/message = FALSE)
	if(dna && HAS_TRAIT(src, TRAIT_PIERCEIMMUNE))
		return
	throw_alert("embeddedobject", /obj/screen/alert/embeddedobject)
	L.embedded_objects |= I
	I.add_mob_blood(src)
	I.forceMove(src)
	L.receive_damage(I.w_class*4)
	if(message)
		visible_message("<span class='danger'>\the [I.name] embeds itself in [src]'s [L.name]!</span>","<span class='userdanger'>\the [I.name] embeds itself in your [L.name]!</span>")
