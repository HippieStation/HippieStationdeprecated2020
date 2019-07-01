/obj/effect/proc_holder/spell/proc/pillarmen_check(mob/user = usr)
    if (istype(usr, /mob/living/carbon/human))
        var/mob/living/carbon/human/H = user
        return istype(H.dna?.species, /datum/species/pillarmen)
    return FALSE 
