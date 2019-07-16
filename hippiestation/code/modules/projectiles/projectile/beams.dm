//////GAUSS RIFLE FUN///////

/obj/item/projectile/beam/gauss_low
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE //The low setting can pass through glass
	name = "gauss bolt"
	icon = 'hippiestation/icons/obj/projectiles.dmi'
	icon_state = "gauss_low"
	damage = 20
	damage_type = BRUTE
	hitsound = 'hippiestation/sound/weapons/rodgun_pierce.ogg'
	hitsound_wall = 'sound/weapons/effects/batreflect2.ogg'

/obj/item/projectile/beam/gauss_normal
	pass_flags = PASSTABLE
	name = "gauss bolt"
	icon = 'hippiestation/icons/obj/projectiles.dmi'
	icon_state = "gauss_normal"
	damage = 35
	damage_type = BRUTE
	hitsound = 'hippiestation/sound/weapons/rodgun_pierce.ogg'
	hitsound_wall = 'sound/weapons/effects/batreflect2.ogg'

/obj/item/projectile/beam/gauss_normal/proc/Impale(mob/living/carbon/human/H) //Imaples the target,
	if (H)
		var/hit_zone = H.check_limb_hit(def_zone)
		var/obj/item/bodypart/BP = H.get_bodypart(hit_zone)
		var/obj/item/stack/rods/R = new(H.loc, 1, FALSE) // Don't merge

		if (istype(BP))
			R.add_blood_DNA(H.return_blood_DNA())
			R.forceMove(H)
			BP.embedded_objects += R
			H.update_damage_overlays()
			H.visible_message("<span class='warning'>The [R] has embedded into [H]'s [BP.name]!</span>",
							"<span class='userdanger'>You feel [R] lodge into your [BP.name]!</span>")
			playsound(H, 'hippiestation/sound/weapons/rodgun_pierce.ogg', 50, 1)
			H.emote("scream")

/obj/item/projectile/beam/gauss_normal/on_hit(atom/target, blocked = FALSE)
	..()
	var/volume = vol_by_damage()
	if (istype(target, /mob))
		playsound(target, 'hippiestation/sound/weapons/rodgun_pierce.ogg', volume, 1, -1)
		if (ishuman(target)) //Only humans!!
			var/mob/living/carbon/human/H = target
			Impale(H)
		else
			new /obj/item/stack/rods(get_turf(src))
	else
		playsound(target, 'hippiestation/sound/weapons/rodgun_pierce.ogg', volume, 1, -1)
		new /obj/item/stack/rods(get_turf(src)) //If we failed to impale it drops a rod where it hit.
	qdel(src)

obj/item/projectile/beam/gauss_overdrive
	pass_flags = PASSTABLE
	name = "overdrive gauss bolt"
	icon = 'hippiestation/icons/obj/projectiles.dmi'
	icon_state = "gauss_overdrive"
	damage = 45 //HNNNGH
	damage_type = BRUTE
	hitsound = 'hippiestation/sound/weapons/rodgun_pierce.ogg'
	hitsound_wall = 'sound/weapons/effects/batreflect2.ogg'

obj/item/projectile/beam/gauss_overdrive/on_hit(atom/target, blocked = FALSE) //Time for dismemberment
	..()
	var/mob/living/carbon/H = target
	if(!ismob(H))
		do_sparks(2, TRUE, src)
		new /obj/item/stack/broken_rods(get_turf(src))
	if(ismob(H) && !iscarbon(H) || ismonkey(H)) //Gibs those inferior simple_animals if they are low enough health
		if(H.health < 10)
			H.visible_message("<span class='warning'>[H] is obliterated by the gauss shot!</span>")
			playsound(H.loc, 'hippiestation/sound/misc/heavysmash.ogg', 60, 1)
			H.gib()
	if(ishuman(H))
		var/hit_zone = H.check_limb_hit(def_zone)
		var/obj/item/bodypart/BP = H.get_bodypart(hit_zone)
		if(prob(15) && hit_zone == "chest" || prob(10) && hit_zone == "head") //10 percent chance to decap/15 to disembowel.
			BP.dismember()
			playsound(H.loc, 'hippiestation/sound/misc/heavysmash.ogg', 60, 1)
			var/obj/effect/decal/cleanable/blood/T = new/obj/effect/decal/cleanable/blood
			T.loc = H.loc
			H.visible_message("<span class='warning'>[H]'s [BP.name] is obliterated by the gauss shot!</span>",
									"<span class='userdanger'>Your [BP.name] is obliterated by the gauss shot!</span>") //oof
			if(hit_zone == "chest")
				to_chat(H, "<span class='userdanger'>Your internal organs slop out of your abdomen! Holy shit!</span>")
		if(hit_zone != "chest" && hit_zone != "head" && prob(80)) //Only dismember arms and legs!
			BP.dismember()
			playsound(H.loc, 'hippiestation/sound/misc/heavysmash.ogg', 60, 1)
			var/obj/effect/decal/cleanable/blood/T = new/obj/effect/decal/cleanable/blood
			T.loc = H.loc
			H.visible_message("<span class='warning'>[H]'s [BP.name] is obliterated by the gauss shot!</span>",
									"<span class='userdanger'>Your [BP.name] is obliterated by the gauss shot!</span>") //oof

