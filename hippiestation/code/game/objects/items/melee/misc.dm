/obj/item/melee/sabre/suicide_act(mob/user)
            user.visible_message("<span class='suicide'>[user] is impaling [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
            return (BRUTELOSS)
