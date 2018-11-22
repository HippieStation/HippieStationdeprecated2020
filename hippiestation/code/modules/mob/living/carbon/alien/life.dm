/mob/living/carbon/alien/Life()
	var/datum/status_effect/incapacitating/stun/S = IsStun()
	if(istype(S))
		S.duration = min(S.duration, 30)

	var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
	if(istype(K))
		K.duration = min(K.duration, 30)

	var/datum/status_effect/incapacitating/immobilized/I = IsImmobilized()
	if(istype(I))
		I.duration = min(I.duration, 30)

	var/datum/status_effect/incapacitating/paralyzed/P = IsParalyzed()
	if(istype(P))
		P.duration = min(P.duration, 30)

	AdjustParalyzed(-(1.025**AmountParalyzed()), FALSE)
	AdjustImmobilized(-(1.025**AmountImmobilized()), FALSE)
	AdjustKnockdown(-(1.025**AmountKnockdown()), FALSE)
	AdjustStun(-(1.025**AmountStun()), FALSE)
	adjustStaminaLoss(-(1.025**getStaminaLoss()), FALSE)
	return ..()