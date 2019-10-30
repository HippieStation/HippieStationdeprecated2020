/mob/living/simple_animal/slime/CanFeedon(mob/living/M)
    if(isbot(M))
        return 0
    return ..()
