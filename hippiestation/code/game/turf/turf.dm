/turf
    var/pinned = null

/turf/Destroy(force)
    ..()
    
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
