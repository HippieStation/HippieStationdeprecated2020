var/effects = FALSE

/datum/status_effect/monkey_rage
	id = "monkey_rage"
	duration = 300
	tick_interval = 23
	alert_type = /obj/screen/alert/status_effect/monkey_rage

/obj/screen/alert/status_effect/monkey_rage
	name = "Monkey Rage"
	desc = "You bulk up your muscles and unleash a red fire, healing you and increasing your damage! After it wears off, the toll of the ability will hit your body like a dump truck."
	icon_state = "eruption"
	icon = 'hippiestation/icons/mob/actions.dmi'

/datum/status_effect/monkey_rage/on_apply()
	owner.visible_message("<span class='notice'>A blazing red fire surrounds [owner]'s body!</span>", "<span class='notice'>You activate your Monkey Rage!</span>")
	playsound(owner, 'sound/magic/fireball.ogg', 50, 1)
	owner.adjust_fire_stacks(-20)
	toggle_effects(owner)
	addtimer(CALLBACK(src, .proc/toggle_effects, owner), 300, TIMER_UNIQUE)
	return ..()

/datum/status_effect/monkey_rage/proc/toggle_effects(var/mob/living/owner) //guyon we either do it like this or we do it with spawn(20)
    effects = !effects
    var/mutable_appearance/fire_effect= mutable_appearance('hippiestation/icons/mob/onfire.dmi', "monkeyrage")
    if(!effects)
        owner.cut_overlay(fire_effect)
    else
        owner.add_overlay(fire_effect)

/datum/status_effect/monkey_rage/tick()
	owner.adjustBruteLoss(-3)
	owner.adjustFireLoss(-6)
	owner.adjust_fire_stacks(-20)

/datum/status_effect/monkey_rage/on_remove()
	owner.visible_message("<span class='warning'>The red flames around [owner] vanish, and they appear to slow down!</span>", "<span class='warning'>Your body stiffens and breaks down due to the use of Monkey Rage...</span>")
	playsound(owner, 'sound/weapons/resonator_fire.ogg', 50, 1)
	owner.apply_status_effect(STATUS_EFFECT_TIRED_BODY)
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjustStaminaLoss(50)


/datum/status_effect/tired_body
	id = "tired_body"
	duration = 300
	tick_interval = 30
	alert_type = /obj/screen/alert/status_effect/tired_body

/obj/screen/alert/status_effect/tired_body
	name = "Tired Body"
	desc = "Your body stiffens and breaks down due to the use of Monkey Rage."
	icon_state = "raisedead"
	icon = 'hippiestation/icons/mob/actions.dmi'

/datum/status_effect/tired_body/tick()
	SEND_SOUND(owner, sound('sound/magic/summon_karp.ogg', volume = 25))
	owner.adjustBruteLoss(3)
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjustStaminaLoss(5)


/datum/status_effect/monkeyman_curse // the ultimate semi-ensurance of brainloss
	id = "monkeyman_curse"
	duration = -1
	tick_interval = 20
	alert_type = /obj/screen/alert/status_effect/monkeyman_curse

/obj/screen/alert/status_effect/monkeyman_curse
	name = "Monkeyman Curse"
	desc = "You have been possessed by the ghost of the Monkeyman! You will suffer from permanent brain damage."
	icon_state = "monkeymask"
	icon = 'icons/obj/clothing/masks.dmi'

/datum/status_effect/monkeyman_curse/tick()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.setBrainLoss(200)