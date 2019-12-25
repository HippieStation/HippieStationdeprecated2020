/obj/item/clothing/head/helmet/juggernaut
    name = "juggernaut helmet"
    desc = "<span class='big bold red'>DON'T YOU KNOW WHO I AM?</span>"
    item_flags = DROPDEL
    clothing_flags = THICKMATERIAL | STOPSPRESSUREDAMAGE | SHOWEROKAY
    icon = 'hippiestation/icons/mob/head.dmi'
    icon_state = "juggernaut_helmet"
    item_state = "juggernaut_helmet"
    slowdown = -1
    alternate_worn_icon = 'hippiestation/icons/mob/head.dmi'
    item_color = "juggernaut_helmet"

/obj/item/clothing/head/helmet/juggernaut/dropped()
    qdel(src)
    return ..()

/obj/item/clothing/head/helmet/juggernaut/equipped(mob/M, slot)
    ADD_TRAIT(src, TRAIT_NODROP, JUGGERNAUT_TRAIT)

    var/mob/living/carbon/human/owner = M
    ADD_TRAIT(owner, TRAIT_IGNORESLOWDOWN, JUGGERNAUT_TRAIT)
    ADD_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, JUGGERNAUT_TRAIT)
    ADD_TRAIT(owner, TRAIT_SLEEPIMMUNE, JUGGERNAUT_TRAIT)
    ADD_TRAIT(owner, TRAIT_STUNIMMUNE, JUGGERNAUT_TRAIT)
    ADD_TRAIT(owner, TRAIT_NODISMEMBER, JUGGERNAUT_TRAIT)
    ADD_TRAIT(owner, TRAIT_PIERCEIMMUNE, JUGGERNAUT_TRAIT)

    ADD_TRAIT(owner, TRAIT_NOGUNS, JUGGERNAUT_TRAIT)
    ADD_TRAIT(owner, TRAIT_MONKEYLIKE, JUGGERNAUT_TRAIT)
    //No shock immunity, enjoy an electric cable up the anus

    owner.move_resist = INFINITY
    owner.move_force = INFINITY
    owner.physiology.brute_mod -= 0.5
    owner.physiology.burn_mod -= 0.9
    owner.physiology.heat_mod -= 0.9
    owner.physiology.stamina_mod = 0

    owner.dna.species.punchdamagehigh = 50
    owner.dna.species.punchdamagelow = 30
    return ..()

