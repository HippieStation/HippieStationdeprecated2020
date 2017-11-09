/obj/item/gun/ballistic/crossbow
    name = "crossbow"
    desc = "A powerful crossbow, capable of shooting metal rods. Very effective for hunting."
    icon_state = "shotgun"
    item_state = "shotgun"
    w_class = WEIGHT_CLASS_BULKY
    force = 10
    flags_1 = CONDUCT_1
    slot_flags = SLOT_BACK
    origin_tech = "combat=3;materials=2"
    fire_sound = "hippiestation/sound/weapons/rodgun_fire.ogg"
    var/charge = 0
    var/charging = FALSE
    var/charge_time = 10
    var/draw_sound = "sound/weapons/draw_bow.ogg"
    var/insert_sound = "sound/weapons/bulletinsert.ogg"
    weapon_weight = WEAPON_MEDIUM
    spawnwithmagazine = FALSE
    casing_ejector = FALSE

/obj/item/gun/ballistic/crossbow/attackby(obj/item/A, mob/living/user, params)
    if (!chambered)
        if (charge > 0)
            if (istype(A, /obj/item/stack/rods))
                var/obj/item/stack/rods/R = A
                if (R.use(1))
                    chambered = new /obj/item/ammo_casing/rod
                    var/obj/item/projectile/rod/PR = chambered.BB

                    if (PR)
                        PR.range = PR.range * charge
                        PR.damage = PR.damage * charge
                        PR.charge = charge

                    playsound(user, insert_sound, 50, 1)

                    to_chat(user, "<span class='notice'>You carefully place the [chambered.BB] into the [src]</span>")
        else
            to_chat(user, "<span class='warning'>You need to draw the bow string before loading a bolt!</span>")
    else
        to_chat(user, "<span class='warning'>There's already a [chambered.BB] loaded!<span>")

    return

/obj/item/gun/ballistic/crossbow/process_chamber(empty_chamber = 0)
    chambered = null
    charge = 0
    return

/obj/item/gun/ballistic/crossbow/chamber_round()
    return

/obj/item/gun/ballistic/crossbow/can_shoot()
    if (!chambered)
        return

    if (charge <= 0)
        return

    return (chambered.BB ? 1 : 0)

/obj/item/gun/ballistic/crossbow/attack_self(mob/living/user)
    if (!chambered)
        if (charge < 3)
            if (charging)
                return

            charging = TRUE

            user.visible_message("<span class='notice'>[user] pulls back the bowstring.</span>")
            playsound(user, draw_sound, 50, 1)

            if (do_after(user, charge_time, 0, user) && charging)
                charge = charge + 1
                charging = FALSE

                var/draw = "a little."

                if (charge > 2)
                    draw = "fully."
                else if (charge > 1)
                    draw = "further."

                to_chat(user, "<span class='notice'>You draw the bow string back [draw]</span>")

                return
            else
                charging = FALSE
        else
            to_chat(user, "<span class='warning'>The bow string is fully drawn!</span>")
    else
        to_chat(user, "<span class='notice'>You remove the [chambered.BB] from the crossbow.</span>")
        user.put_in_hands(new /obj/item/stack/rods)
        chambered = null
        playsound(user, insert_sound, 50, 1)

    charging = FALSE
    return

/obj/item/gun/ballistic/crossbow/examine(mob/user)
    ..()

    var/bowstring = "The bow string is "

    if (charge > 2)
        bowstring = bowstring + "drawn back fully!"
    else if (charge > 1)
        bowstring = bowstring + "drawn back most the way."
    else if (charge > 0)
        bowstring = bowstring + "drawn back a little."
    else
        bowstring = bowstring + "not drawn."

    to_chat(user, "[bowstring]")

    if (chambered.BB)
        to_chat(user, "A [chambered.BB] is loaded.")