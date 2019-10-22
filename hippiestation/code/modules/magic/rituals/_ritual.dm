/obj/effect/ritual_center
	name = "ritualistic circle"
	desc = "A strange, carved circle."
	icon = 'hippiestation/icons/obj/magic.dmi'
	icon_state = "rune"
	var/complexity = 1
	var/mutable_appearance/mid
	var/mutable_appearance/big

/obj/effect/ritual_center/Initialize()
	. = ..()
	mid = mutable_appearance('hippiestation/icons/obj/magic_96x96.dmi', "rune_1")
	mid.pixel_x = -32
	mid.pixel_y = -32
	big = mutable_appearance('hippiestation/icons/obj/magic_96x96.dmi', "rune_2")
	big.pixel_x = -32
	big.pixel_y = -32
	for(var/layer = 1 to MAX_MAGIC_COMPLEXITY)
		for(var/turf/closed/T in orange(layer, src) - orange(layer - 1, src))
			complexity = layer - 1
			update_icon()
			return

/obj/effect/ritual_center/update_icon()
	cut_overlays()
	if(complexity > 1)
		add_overlay(mid)
	if(complexity > 2)
		add_overlay(big)

/obj/effect/ritual_center/attack_hand(mob/living/user)
	if(!SSmagic || !SSmagic.initialized)
		return
	var/antimagic
	var/turf/T = get_turf(src)
	var/list/traits_per_layer = new(complexity)
	for(var/layer = 1 to complexity)
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
			user.handle_rejection(RI)
			if(RI.antimagic_interaction != ANTIMAGIC_NOTHING && antimagic && antimagic <= RI.complexity)
				switch(RI.antimagic_interaction)
					if(ANTIMAGIC_AMP)
						user.log_message("misfired [RI.name] ([RI.type]), due to antimagic", LOG_ATTACK)
						to_chat(world, "misfired [RI.name] ([RI.type]), due to antimagic")
						visible_message("<span class='danger'>The carvings begin to flash violently!</span>")
						RI.misfire(user, T, TRUE)
						user.residual_energy += RI.residual_cost * SSmagic.magical_factor 
					if(ANTIMAGIC_NULLIFY)
						visible_message("<span class='warning'>The carvings flash brightly for a split second, then fall dark.</span>")
			else
				visible_message("<span class='warning'>The carvings begin to glow brightly!</span>")
				user.log_message("invoked [RI.name] ([RI.type])", LOG_ATTACK)
				to_chat(world, "invoked [RI.name] ([RI.type])")
				RI.fire(user, T, FALSE)
				user.residual_energy += RI.residual_cost * SSmagic.magical_factor 
			return
		else if(diff <= RI.max_misfire)
			to_misfire += RI
	for(var/datum/magic/ritualism/MI in to_misfire)
		user.handle_rejection(MI)
		if(MI.antimagic_interaction != ANTIMAGIC_NOTHING && antimagic && antimagic <= MI.complexity)
			switch(MI.antimagic_interaction)
				if(ANTIMAGIC_AMP)
					user.log_message("misfired [MI.name] ([MI.type]), due to antimagic", LOG_ATTACK)
					to_chat(world, "misfired [MI.name] ([MI.type]), due to antimagic")
					visible_message("<span class='danger'>The carvings begin to flash violently!</span>")
					MI.misfire(user, T, TRUE)
					user.residual_energy += MI.residual_cost * SSmagic.magical_factor 
				if(ANTIMAGIC_NULLIFY)
					visible_message("<span class='warning'>The carvings flash erratically for a split second, then fall dark.</span>")
		else
			user.log_message("misfired [MI.name] ([MI.type])", LOG_ATTACK)
			to_chat(world, "misfired [MI.name] ([MI.type])")
			visible_message("<span class='warning'>The carvings begin to flash erratically!</span>")
			MI.misfire(user, T, FALSE)
			user.residual_energy += MI.residual_cost * SSmagic.magical_factor 
		return
	visible_message("<span class='warning'>The carvings pulse with a small flash of light, then fall dark.</span>")
