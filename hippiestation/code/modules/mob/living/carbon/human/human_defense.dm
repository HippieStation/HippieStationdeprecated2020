
/mob/living/carbon/human/help_shake_act(mob/living/carbon/M)
    if(!istype(M))
        return

    if(health >= 0)
        if(src == M)
            visible_message("[src] examines [p_them()]self.", \
                "<span class='notice'>You check yourself for injuries.</span>")

            var/list/missing = list("head", "chest", "l_arm", "r_arm", "l_leg", "r_leg")
            for(var/X in bodyparts)
                var/obj/item/bodypart/LB = X
                missing -= LB.body_zone
                var/status = ""
                var/brutedamage = LB.brute_dam
                var/burndamage = LB.burn_dam
                if(hallucination)
                    if(prob(30))
                        brutedamage += rand(30,40)
                    if(prob(30))
                        burndamage += rand(30,40)

                if(brutedamage > 0)
                    status = "bruised"
                if(brutedamage > 20)
                    status = "battered"
                if(brutedamage > 40)
                    status = "mangled"
                if(brutedamage > 0 && burndamage > 0)
                    status += " and "
                if(burndamage > 40)
                    status += "peeling away"

                else if(burndamage > 10)
                    status += "blistered"
                else if(burndamage > 0)
                    status += "numb"
                if(status == "")
                    status = "OK"
                to_chat(src, "\t <span class='[status == "OK" ? "notice" : "warning"]'>Your [LB.name] is [status].</span>")

                for(var/obj/item/I in LB.embedded_objects)
                    to_chat(src, "\t <a href='?src=[REF(src)];embedded_object=[REF(I)];embedded_limb=[REF(LB)]' class='warning'>There is \a [I] embedded in your [LB.name]!</a> [I.pinned ? "It has also pinned you down!" : ""]")

            for(var/t in missing)
                to_chat(src, "<span class='boldannounce'>Your [parse_zone(t)] is missing!</span>")

            if(bleed_rate)
                to_chat(src, "<span class='danger'>You are bleeding!</span>")
            if(staminaloss)
                if(staminaloss > 30)
                    to_chat(src, "<span class='info'>You're completely exhausted.</span>")
                else
                    to_chat(src, "<span class='info'>You feel fatigued.</span>")
        else
            if(wear_suit)
                wear_suit.add_fingerprint(M)
            else if(w_uniform)
                w_uniform.add_fingerprint(M)

            ..()
