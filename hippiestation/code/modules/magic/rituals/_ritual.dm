/obj/effect/ritual_center
	name = "ritualistic circle"
	desc = "A strange, carved circle."
	icon = 'icons/obj/rune.dmi'
	icon_state = "1"
	color = "#7DF9FF"

/obj/effect/ritual_center/attack_hand(mob/living/user)
	if(!SSmagic || !SSmagic.initialized)
		return
	var/antimagic
	var/turf/T = get_turf(src)
	var/list/traits_per_layer = new(MAX_MAGIC_COMPLEXITY)
	for(var/layer = 1 to MAX_MAGIC_COMPLEXITY)
		traits_per_layer[layer] = list()
		for(var/atom/A in orange(layer, src) - orange(layer - 1, src))
			if(isliving(A))
				var/mob/living/L = A
				if(!antimagic && L.anti_magic_check())
					antimagic = layer // the spell will come into contact with antimagic at this layer
			for(var/datum/magic_trait/trait in SSmagic.magic_traits)
				if(!(trait.type in traits_per_layer[layer]))
					if(trait.has_trait(A))
						traits_per_layer[layer] += trait.type
						break

	var/list/to_misfire = list()
	for(var/datum/magic/ritualism/RI in SSmagic.loaded_magic)
		var/diff = 0
		for(var/layer = 1 to RI.complexity)
			var/list/our_traits = traits_per_layer[layer] 
			var/list/their_traits = RI.layers[layer] 
			diff += length(difflist(their_traits, our_traits))
		to_chat(world, "diff for [RI.name] is [diff]")
		if(!diff)
			if(RI.should_reject(user))
				visible_message("<span class='danger'>The carvings begin to flash violently!</span>")
				user.log_message("experienced rejection from [RI.name]", LOG_ATTACK)
				user.visible_message("<span class='danger'>[user]'s blood vessels burst!</span>", "<span class='userdanger'>Your blood vessels burst!</span>")
				user.adjustToxLoss(35 * SSmagic.magical_factor)
				if(iscarbon(user))
					var/mob/living/carbon/C = user
					C.vomit(FALSE, TRUE, TRUE, rand(1, 3))
					if(ishuman(C))
						var/mob/living/carbon/human/H = C
						H.bleed(40 * SSmagic.magical_factor)
						H.bleed_rate = max(H.bleed_rate + (9 * SSmagic.magical_factor), 9 * SSmagic.magical_factor)
			if(RI.antimagic_interaction != ANTIMAGIC_NOTHING && antimagic && antimagic <= RI.complexity)
				switch(RI.antimagic_interaction)
					if(ANTIMAGIC_AMP)
						user.log_message("misfired [RI.name], due to antimagic", LOG_ATTACK)
						to_chat(world, "[src] misfired [RI.name], due to antimagic")
						visible_message("<span class='danger'>The carvings begin to flash violently!</span>")
						RI.misfire(user, T, TRUE)
					if(ANTIMAGIC_NULLIFY)
						visible_message("<span class='warning'>The carvings flash brightly for a split second, then fall dark.</span>")
			else
				visible_message("<span class='warning'>The carvings begin to glow brightly!</span>")
				user.log_message("invoked [RI.name]", LOG_ATTACK)
				to_chat(world, "[src] invoked [RI.name]")
				RI.fire(user, T, FALSE)
			return
		else if(diff <= RI.max_misfire)
			to_misfire += RI
	for(var/datum/magic/ritualism/MI in to_misfire)
		if(MI.should_reject(user))
			visible_message("<span class='danger'>The carvings begin to flash violently!</span>")
			user.log_message("experienced rejection from [MI.name]", LOG_ATTACK)
			user.visible_message("<span class='danger'>[user]'s blood vessels burst!</span>", "<span class='userdanger'>Your blood vessels burst!</span>")
			user.adjustToxLoss(35 * SSmagic.magical_factor)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.vomit(FALSE, TRUE, TRUE, rand(1, 3))
				if(ishuman(C))
					var/mob/living/carbon/human/H = C
					H.bleed(40 * SSmagic.magical_factor)
					H.bleed_rate = max(H.bleed_rate + (10 * SSmagic.magical_factor), 10 * SSmagic.magical_factor)
		if(MI.antimagic_interaction != ANTIMAGIC_NOTHING && antimagic && antimagic <= MI.complexity)
			switch(MI.antimagic_interaction)
				if(ANTIMAGIC_AMP)
					user.log_message("misfired [MI.name], due to antimagic", LOG_ATTACK)
					to_chat(world, "[src] misfired [MI.name], due to antimagic")
					visible_message("<span class='danger'>The carvings begin to flash violently!</span>")
					MI.misfire(user, T, TRUE)
				if(ANTIMAGIC_NULLIFY)
					visible_message("<span class='warning'>The carvings flash erratically for a split second, then fall dark.</span>")
		else
			user.log_message("misfired [MI.name]", LOG_ATTACK)
			to_chat(world, "[src] misfired [MI.name]")
			visible_message("<span class='warning'>The carvings begin to flash erratically!</span>")
			MI.misfire(user, T, FALSE)
		return
	visible_message("<span class='warning'>The carvings pulse with a small flash of light, then fall dark.</span>")
