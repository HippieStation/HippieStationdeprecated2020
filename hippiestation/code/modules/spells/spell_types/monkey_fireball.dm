/obj/effect/proc_holder/spell/aimed/monkey_fireball
	name = "Monkey Decimation Ball"
	desc = "Shoot a monkey-style ball of not-fire at your enemies!"
	school = "evocation"
	charge_max = 1200
	clothes_req = 0
	invocation = "KER-MEH-HER-MEH-HER" //normally this text should not be seen, but if an admin decides to grant the spell then we need invocation
	invocation_type = "shout"
	cooldown_min = 90
	projectile_type = /obj/item/projectile/magic/monkeyman/monkeyball
	sound = 'sound/items/fultext_launch.wav'
	active_msg = "You hunch over and form a blue fireball with your hands! "
	deactive_msg = "You dissipate the ball and assume a normal stance."
	active = FALSE

/obj/effect/proc_holder/spell/aimed/monkey_fireball/perform(list/targets, recharge = 1, mob/user = usr)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.handcuffed)
			to_chat(C, "<span class='notice'>Your hands are restrained!</span>")
			revert_cast(user)
			return
	if(user.incapacitated())
		to_chat(user, "<span class='notice'>You can't move your hands into formation!</span>")
		revert_cast(user)
		return
	..()