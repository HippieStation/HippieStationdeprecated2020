/mob/living/handle_status_effects()
	. = ..()
	var/residual_decay = process_residual_energy()
	if(residual_decay)
		if(SSmagic && SSmagic.initialized)
			residual_decay *= SSmagic.magical_factor
		residual_energy = max(residual_energy - residual_decay, 0)
