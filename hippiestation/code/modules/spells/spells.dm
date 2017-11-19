/datum/action/spell_action/New(Target)
	..()
	var/obj/effect/proc_holder/spell/S = Target
	icon_icon = S.action_icon

/obj/effect/proc_holder/spell/self/basic_heal // We stole your debugging tool and turned it into a fully fledged spell
	name = "Basic Heal"
	human_req = 0 //Liches and non-humans can use this spell
	charge_max = 400 //60 seconds
	cooldown_min = 200
	invocation_type = "shout"

/obj/effect/proc_holder/spell/self/basic_heal/cast(mob/living/carbon/human/user)
	user.adjustBruteLoss(-20)
	user.adjustFireLoss(-20)

/obj/effect/proc_holder/spell/self/advanced_heal //This is not just a simple heal. This is an ADVANCED heal
	name = "Advanced Heal"
	desc = "Heals a moderate amount of damage of ALL types. Requires robes."
	human_req = 0
	clothes_req = 1
	charge_max = 600
	cooldown_min = 400
	invocation = "Victus Sano XL!"
	invocation_type = "shout"
	school = "restoration"
	sound = 'sound/effects/curse1.ogg'

/obj/effect/proc_holder/spell/self/advanced_heal/cast(mob/living/carbon/human/user)
	user.visible_message("<span class='warning'>[user]'s body quickly twists and contorts before it snaps back, seemingly refreshed!</span>", "<span class='notice'>You involuntarily contort, twist, then snap back! You feel refreshed!</span>")
	user.adjustBruteLoss(-30)
	user.adjustFireLoss(-30)
	user.adjustToxLoss(-10)
	user.adjustOxyLoss(-50)
	user.adjustBrainLoss(-10)
	user.adjustCloneLoss(-10)