/obj/item/organ/internal/shadowtumor
	name = "black tumor"
	desc = "A tiny black mass with red tendrils trailing from it. It seems to shrivel in the light."
	icon_state = "blacktumor"
	origin_tech = "biotech=4"
	w_class = 1
	zone = "head"
	slot = "brain_tumor"
	var/health = 3

/obj/item/organ/internal/shadowtumor/New()
	..()
	SSobj.processing |= src

/obj/item/organ/internal/shadowtumor/Destroy()
	SSobj.processing.Remove(src)
	..()

/obj/item/organ/shadowtumor/process()
	if(isturf(loc))
		var/turf/T = loc
		var/light_count = T.get_lumcount()
		if(light_count > LIGHT_DAM_THRESHOLD && health > 0) //Die in the light
			health--
		else if(light_count < LIGHT_HEAL_THRESHOLD && health < 3) //Heal in the dark
			health++
		if(health <= 0)
			visible_message("<span class='warning'>[src] collapses in on itself!</span>")
			qdel(src)
	else
		health += 0.5

/obj/item/organ/shadowtumor/Insert(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()
	SSticker.mode.add_thrall(M.mind)

/obj/item/organ/shadowtumor/on_find(mob/living/finder)
	. = ..()
	finder.visible_message("<span class='danger'>[finder] opens up [owner]'s skull, revealing a pulsating black mass on [owner.p_their()] brain, with red tendrils attaching to other parts of [owner.p_their()] brain.</span>'")

/obj/item/organ/shadowtumor/Remove(mob/living/carbon/M, special)
	if(M.dna.species.id == "l_shadowling") //Empowered thralls cannot be deconverted
		to_chat(M, "<span class='shadowling'><b><i>NOT LIKE THIS!</i></b></span>")
		M.visible_message("<span class='danger'>[M] suddenly slams upward and knocks down everyone!</span>")
		
		M.resting = FALSE //Remove all stuns
		M.SetStun(0, FALSE)
		M.SetKnockdown(FALSE)
		M.SetUnconscious(FALSE)
		for(var/mob/living/user in range(2, src))
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.Knockdown(6)
				C.apply_damage(20, "brute", "chest")
			else if(issilicon(user))
				var/mob/living/silicon/S = user
				S.Knockdown(8)
				S.apply_damage(20, "brute")
				playsound(S, 'sound/effects/bang.ogg', 50, 1)
		return FALSE
	SSticker.mode.remove_thrall(target.mind, FALSE)
	target.visible_message("<span class='warning'>A strange black mass falls from [target]'s head!</span>")
	new /obj/item/organ/internal/shadowtumor(get_turf(target))
	return ..()