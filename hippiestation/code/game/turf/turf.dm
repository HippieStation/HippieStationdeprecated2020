/turf
    var/pinned = null

/turf/Destroy(force)
    . = QDEL_HINT_IWILLGC
    if(!changing_turf)
        stack_trace("Incorrect turf deletion")
    changing_turf = FALSE
    if(force)
        ..()
        //this will completely wipe turf state
        var/turf/B = new world.turf(src)
        for(var/A in B.contents)
            qdel(A)
        for(var/I in B.vars)
            B.vars[I] = null
        return
    SSair.remove_from_active(src)
    visibilityChanged()
    QDEL_LIST(blueprint_data)
    initialized = FALSE
    requires_activation = FALSE

    if (pinned)
        var/mob/living/carbon/human/H = pinned

        if (istype(H))
            H.anchored = 0
            H.pinned_to = null
            H.do_pindown(src, 0)
            H.update_canmove()
            
            for (var/obj/item/stack/rods/R in H.contents)
                if (R.pinned)
                    R.pinned = null
    ..()
