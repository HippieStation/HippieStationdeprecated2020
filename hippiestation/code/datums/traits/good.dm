/* TG Good traits */
/datum/quirk/neet
	name = "NEET"
	desc = "For some reason you qualified for social welfare and you don't really care about your own personal hygiene."
	value = 1
	mob_trait = TRAIT_NEET
	gain_text = "<span class='notice'>You feel useless to society.</span>"
	lose_text = "<span class='danger'>You no longer feel useless to society.</span>"

/datum/quirk/neet/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/datum/bank_account/D = H.get_bank_account()
	if(!D) //if their current mob doesn't have a bank account, likely due to them being a special role (ie nuke op)
		return
	D.welfare = TRUE

/* Hippie Good traits */
/datum/quirk/iron_butt
	name = "Iron Butt"
	desc = "Your butt is stronger than other butts, it will be half as likely to come off when farting."
	value = 1
	gain_text = "<span class='notice'>Your butt feels STRONGER.</span>"
	lose_text = "<span class='notice'>Your butt feels weaker.</span>"

/datum/quirk/iron_butt/add()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		H.lose_butt = 6

/datum/quirk/iron_butt/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		H.lose_butt = initial(H.lose_butt)

/datum/quirk/volatile_butt
	name = "Volatile Butt"
	desc = "Your butt is volatile and far more likely to blow catastrophically when farting as hard as you can."
	value = 2
	gain_text = "<span class='notice'>Your butt feels volatile and unpredictable!</span>"
	lose_text = "<span class='notice'>Your butt feels stable.</span>"

/datum/quirk/volatile_butt/add()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		H.super_fart = 64
		H.super_nova_fart = 18
		H.fart_fly = 18

/datum/quirk/volatile_butt/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		H.super_fart = initial(H.super_fart)
		H.super_nova_fart = initial(H.super_nova_fart)
		H.fart_fly = initial(H.fart_fly)
