/obj/item/projectile/beam
	name = "laser"
	icon_state = "laser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 20
	light_range = 2
	damage_type = BURN
	hitsound = 'sound/weapons/sear.ogg'
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	flag = "laser"
	eyeblur = 2
	impact_effect_type = /obj/effect/temp_visual/impact_effect/red_laser
	light_color = LIGHT_COLOR_RED
	ricochets_max = 50	//Honk!
	ricochet_chance = 80
	reflectable = REFLECT_NORMAL

/obj/item/projectile/beam/laser
	tracer_type = /obj/effect/projectile/tracer/laser
	muzzle_type = /obj/effect/projectile/muzzle/laser
	impact_type = /obj/effect/projectile/impact/laser

/obj/item/projectile/beam/laser/heavylaser
	name = "heavy laser"
	icon_state = "heavylaser"
	damage = 40
	tracer_type = /obj/effect/projectile/tracer/heavy_laser
	muzzle_type = /obj/effect/projectile/muzzle/heavy_laser
	impact_type = /obj/effect/projectile/impact/heavy_laser

/obj/item/projectile/beam/laser/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.IgniteMob()
	else if(isturf(target))
		impact_effect_type = /obj/effect/temp_visual/impact_effect/red_laser/wall

/obj/item/projectile/beam/weak
	damage = 15

/obj/item/projectile/beam/weak/penetrator
	armour_penetration = 50

/obj/item/projectile/beam/practice
	name = "practice laser"
	damage = 0
	nodamage = TRUE

/obj/item/projectile/beam/scatter
	name = "laser pellet"
	icon_state = "scatterlaser"
	damage = 5

/obj/item/projectile/beam/xray
	name = "\improper X-ray beam"
	icon_state = "xray"
	damage = 15
	irradiate = 300
	range = 15
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE | PASSCLOSEDTURF

	impact_effect_type = /obj/effect/temp_visual/impact_effect/green_laser
	light_color = LIGHT_COLOR_GREEN
	tracer_type = /obj/effect/projectile/tracer/xray
	muzzle_type = /obj/effect/projectile/muzzle/xray
	impact_type = /obj/effect/projectile/impact/xray

/obj/item/projectile/beam/disabler
	name = "disabler beam"
	icon_state = "omnilaser"
	damage = 30
	damage_type = STAMINA
	flag = "energy"
	hitsound = 'sound/weapons/tap.ogg'
	eyeblur = 0
	impact_effect_type = /obj/effect/temp_visual/impact_effect/blue_laser
	light_color = LIGHT_COLOR_BLUE
	tracer_type = /obj/effect/projectile/tracer/disabler
	muzzle_type = /obj/effect/projectile/muzzle/disabler
	impact_type = /obj/effect/projectile/impact/disabler

/obj/item/projectile/beam/pulse
	name = "pulse"
	icon_state = "u_laser"
	damage = 50
	impact_effect_type = /obj/effect/temp_visual/impact_effect/blue_laser
	light_color = LIGHT_COLOR_BLUE
	tracer_type = /obj/effect/projectile/tracer/pulse
	muzzle_type = /obj/effect/projectile/muzzle/pulse
	impact_type = /obj/effect/projectile/impact/pulse

/obj/item/projectile/beam/pulse/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if (!QDELETED(target) && (isturf(target) || istype(target, /obj/structure/)))
		target.ex_act(EXPLODE_HEAVY)

/obj/item/projectile/beam/pulse/shotgun
	damage = 40

/obj/item/projectile/beam/pulse/heavy
	name = "heavy pulse laser"
	icon_state = "pulse1_bl"
	var/life = 20

/obj/item/projectile/beam/pulse/heavy/on_hit(atom/target, blocked = FALSE)
	life -= 10
	if(life > 0)
		. = BULLET_ACT_FORCE_PIERCE
	..()

/obj/item/projectile/beam/emitter
	name = "emitter beam"
	icon_state = "emitter"
	damage = 30
	impact_effect_type = /obj/effect/temp_visual/impact_effect/green_laser
	light_color = LIGHT_COLOR_GREEN

/obj/item/projectile/beam/emitter/singularity_pull()
	return //don't want the emitters to miss

/obj/item/projectile/beam/lasertag
	name = "laser tag beam"
	icon_state = "omnilaser"
	hitsound = null
	damage = 0
	damage_type = STAMINA
	flag = "laser"
	var/suit_types = list(/obj/item/clothing/suit/redtag, /obj/item/clothing/suit/bluetag)
	impact_effect_type = /obj/effect/temp_visual/impact_effect/blue_laser
	light_color = LIGHT_COLOR_BLUE

/obj/item/projectile/beam/lasertag/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit))
			if(M.wear_suit.type in suit_types)
				M.adjustStaminaLoss(34)

/obj/item/projectile/beam/lasertag/redtag
	icon_state = "laser"
	suit_types = list(/obj/item/clothing/suit/bluetag)
	impact_effect_type = /obj/effect/temp_visual/impact_effect/red_laser
	light_color = LIGHT_COLOR_RED
	tracer_type = /obj/effect/projectile/tracer/laser
	muzzle_type = /obj/effect/projectile/muzzle/laser
	impact_type = /obj/effect/projectile/impact/laser

/obj/item/projectile/beam/lasertag/redtag/hitscan
	hitscan = TRUE

/obj/item/projectile/beam/lasertag/bluetag
	icon_state = "bluelaser"
	suit_types = list(/obj/item/clothing/suit/redtag)
	tracer_type = /obj/effect/projectile/tracer/laser/blue
	muzzle_type = /obj/effect/projectile/muzzle/laser/blue
	impact_type = /obj/effect/projectile/impact/laser/blue

/obj/item/projectile/beam/lasertag/bluetag/hitscan
	hitscan = TRUE

/obj/item/projectile/beam/instakill
	name = "instagib laser"
	icon_state = "purple_laser"
	damage = 200
	damage_type = BURN
	impact_effect_type = /obj/effect/temp_visual/impact_effect/purple_laser
	light_color = LIGHT_COLOR_PURPLE

/obj/item/projectile/beam/instakill/blue
	icon_state = "blue_laser"
	impact_effect_type = /obj/effect/temp_visual/impact_effect/blue_laser
	light_color = LIGHT_COLOR_BLUE

/obj/item/projectile/beam/instakill/red
	icon_state = "red_laser"
	impact_effect_type = /obj/effect/temp_visual/impact_effect/red_laser
	light_color = LIGHT_COLOR_RED

/obj/item/projectile/beam/instakill/on_hit(atom/target)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.visible_message("<span class='danger'>[M] explodes into a shower of gibs!</span>")
		M.gib()

//////GAUSS RIFLE FUN///////

/obj/item/projectile/beam/gauss_low
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE //The low setting can pass through glass
	name = "gauss bolt"
	icon_state = "gauss_low"
	damage = 20
	damage_type = BRUTE
	hitsound = 'hippiestation/sound/weapons/rodgun_pierce.ogg'
	hitsound_wall = 'sound/weapons/effects/batreflect2.ogg'

/obj/item/projectile/beam/gauss_normal
	pass_flags = PASSTABLE
	name = "gauss bolt"
	icon_state = "gauss_normal"
	damage = 35
	damage_type = BRUTE
	hitsound = 'hippiestation/sound/weapons/rodgun_pierce.ogg'
	hitsound_wall = 'sound/weapons/effects/batreflect2.ogg'

/obj/item/projectile/beam/gauss_normal/proc/Impale(mob/living/carbon/human/H) //Imaples the target, if next to a wall impales them onto that as well.
	if (H)
		var/hit_zone = H.check_limb_hit(def_zone)
		var/obj/item/bodypart/BP = H.get_bodypart(hit_zone)
		var/obj/item/stack/rods/R = new(H.loc, 1, FALSE) // Don't merge

		if (istype(BP))
			R.add_blood_DNA(H.return_blood_DNA())
			R.forceMove(H)
			BP.embedded_objects += R
			H.update_damage_overlays()
			visible_message("<span class='warning'>The [R] has embedded into [H]'s [BP.name]!</span>",
							"<span class='userdanger'>You feel [R] lodge into your [BP.name]!</span>")
			playsound(H, 'hippiestation/sound/weapons/rodgun_pierce.ogg', 50, 1)
			H.emote("scream")
			var/turf/T = get_step(H, dir)
			if (istype(T) && T.density && !H.pinned_to) // Can only pin someone once
				H.pinned_to = T
				T.pinned = H
				H.anchored = TRUE
				H.update_mobility()
				H.do_pindown(T, 1)
				R.pinned = T

			log_combat(firer, H, "shot", src, addition="[H.pinned_to ? " PINNED" : ""]")

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
	if(H.health < 10 && !iscarbon(H) || ismonkey(H) && H.health < 10) //Gibs those inferior simple_animals if they are low enough health
		visible_message("<span class='warning'>[H] is obliterated by the gauss shot!</span>")
		H.gib()
	if(ishuman(H))
		var/hit_zone = H.check_limb_hit(def_zone)
		var/obj/item/bodypart/BP = H.get_bodypart(hit_zone)
		if(prob(20) && hit_zone == "chest" || prob(20) && hit_zone == "head") //20 percent chance to decap/disembowel.
			BP.dismember()
			playsound(H.loc, 'sound/misc/splort.ogg', 60, 1)
			var/obj/effect/decal/cleanable/blood/T = new/obj/effect/decal/cleanable/blood
			T.loc = H.loc
			visible_message("<span class='warning'>[H]'s [BP.name] is obliterated by the gauss shot!</span>",
									"<span class='userdanger'>Your [BP.name] is obliterated by the gauss shot!</span>") //oof
		if(hit_zone != "chest" && hit_zone != "head") //Only dismember arms and legs!
			BP.dismember()
			playsound(H.loc, 'sound/misc/splort.ogg', 60, 1)
			var/obj/effect/decal/cleanable/blood/T = new/obj/effect/decal/cleanable/blood
			T.loc = H.loc
			visible_message("<span class='warning'>[H]'s [BP.name] is obliterated by the gauss shot!</span>",
									"<span class='userdanger'>Your [BP.name] is obliterated by the gauss shot!</span>") //oof

