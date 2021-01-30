/datum/gas_reaction/hippie_fusion
	exclude = FALSE
	priority = 2
	name = "Plasmic Fusion"
	id = "plasmafusion"

/datum/gas_reaction/hippie_fusion/init_reqs()
	min_requirements = list(
		"ENER" = PLASMA_BINDING_ENERGY_HIPPIE,
		/datum/gas/plasma = MINIMUM_HEAT_CAPACITY,
		/datum/gas/carbon_dioxide = MINIMUM_HEAT_CAPACITY
	)

/datum/gas_reaction/hippie_fusion/react(datum/gas_mixture/air, datum/holder)
	var/list/cached_gases = air.gases
	var/temperature = air.temperature
	var/reaction_energy = THERMAL_ENERGY(air)
	var/turf/open/location = isturf(holder) ? holder : null

	if((cached_gases[/datum/gas/plasma][MOLES]+cached_gases[/datum/gas/carbon_dioxide][MOLES])/air.total_moles() < FUSION_PURITY_THRESHOLD_HIPPIE || reaction_energy < PLASMA_BINDING_ENERGY_HIPPIE)
		//Fusion wont occur if the level of impurities is too high.
		return NO_REACTION
	else
		var/moles_impurities = (cached_gases[/datum/gas/plasma][MOLES]+cached_gases[/datum/gas/carbon_dioxide][MOLES])/air.total_moles()//more plasma+carbon = higher chance of collision regardless of actual thermal energy
		var/carbon_plasma_ratio = min(cached_gases[/datum/gas/carbon_dioxide][MOLES] / cached_gases[/datum/gas/plasma][MOLES], MAX_CARBON_EFFICENCY_HIPPIE)//more carbon = more fusion
		var/plasma_fused = max((PLASMA_FUSED_COEFFICENT_HIPPIE * (reaction_energy / PLASMA_BINDING_ENERGY_HIPPIE) * moles_impurities * carbon_plasma_ratio), 0)
		var/carbon_catalyzed = max(plasma_fused * CARBON_CATALYST_COEFFICENT_HIPPIE, 0)
		var/oxygen_added = carbon_catalyzed
		var/nitrogen_added = plasma_fused-oxygen_added
		var/mass_fused = carbon_catalyzed + plasma_fused
		var/mass_created = oxygen_added + nitrogen_added
		var/energy_released = (mass_fused - mass_created) * PLASMA_FUSION_ENERGY_HIPPIE

		air.assert_gases(/datum/gas/oxygen, /datum/gas/nitrogen, /datum/gas/carbon_dioxide, /datum/gas/plasma)

		cached_gases[/datum/gas/plasma][MOLES] -= plasma_fused
		cached_gases[/datum/gas/carbon_dioxide][MOLES] -= carbon_catalyzed
		cached_gases[/datum/gas/oxygen][MOLES] += oxygen_added
		cached_gases[/datum/gas/nitrogen][MOLES] += nitrogen_added

		if(energy_released > 0)
			if(air.heat_capacity() > MINIMUM_HEAT_CAPACITY)
				air.temperature = temperature + max(energy_released / air.heat_capacity(), TCMB)// energy released is thermal energy so we convert back to kelvin via division
				//Prevents whatever mechanism is causing it to hit negative temperatures.
			if(istype(location))
				location.set_light(4, 30)
				location.light_color = LIGHT_COLOR_GREEN
				radiation_pulse(location, 8, energy_released * FUSION_POWER_GENERATION_COEFFICIENT_HIPPIE)//set to an arbitrary value for now because radiation scaling with reaction energy is insane
				addtimer(CALLBACK(location, .atom/proc/set_light, 0, 0), 30)
			return REACTING

/datum/gas_reaction/freonform
	priority = 5
	name = "Freon formation"
	id = "freonformation"

/datum/gas_reaction/freonform/init_reqs() //minimum requirements for freon formation
	min_requirements = list(
		/datum/gas/plasma = 40,
		/datum/gas/carbon_dioxide = 20,
		/datum/gas/bz = 20,
		"TEMP" = FIRE_MINIMUM_TEMPERATURE_TO_EXIST + 100
		)

/datum/gas_reaction/freonform/react(datum/gas_mixture/air)
	var/list/cached_gases = air.gases
	var/temperature = air.temperature
	var/old_heat_capacity = air.heat_capacity()
	var/heat_efficency = min(temperature / (FIRE_MINIMUM_TEMPERATURE_TO_EXIST * 10), cached_gases[/datum/gas/plasma][MOLES], cached_gases[/datum/gas/carbon_dioxide][MOLES], cached_gases[/datum/gas/bz][MOLES])
	var/energy_used = heat_efficency * 100
	ASSERT_GAS(/datum/gas/freon, air)
	if ((cached_gases[/datum/gas/plasma][MOLES] - heat_efficency * 1.5 < 0 ) || (cached_gases[/datum/gas/carbon_dioxide][MOLES] - heat_efficency * 0.75 < 0) || (cached_gases[/datum/gas/bz][MOLES] - heat_efficency * 0.25 < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	cached_gases[/datum/gas/plasma][MOLES] -= heat_efficency * 1.5
	cached_gases[/datum/gas/carbon_dioxide][MOLES] -= heat_efficency * 0.75
	cached_gases[/datum/gas/bz][MOLES] -= heat_efficency * 0.25
	cached_gases[/datum/gas/freon][MOLES] += heat_efficency * 2.5

	if(energy_used > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.temperature = max(((temperature * old_heat_capacity - energy_used)/new_heat_capacity), TCMB)
		return REACTING


//freon: does a freezy thing?
/datum/gas_reaction/freon
	priority = 1
	name = "Freon"
	id = "freon"

/datum/gas_reaction/freon/init_reqs()
	min_requirements = list(/datum/gas/freon = MOLES_GAS_VISIBLE,
							/datum/gas/nitrogen = MINIMUM_MOLE_COUNT)

/datum/gas_reaction/freon/react(datum/gas_mixture/air, datum/holder)
	var/list/cached_gases = air.gases
	var/temperature = air.temperature
	var/turf/open/location = isturf(holder) ? holder : null
	var/air_requirements = cached_gases[/datum/gas/nitrogen][MOLES] * 0.05
	if(air_requirements && air.heat_capacity() > MINIMUM_HEAT_CAPACITY && temperature <= (T0C-5)) //has a turf, the air requirements and it's below 0C
		cached_gases[/datum/gas/freon][MOLES] -= MOLES_GAS_VISIBLE
		cached_gases[/datum/gas/nitrogen][MOLES] -= air_requirements
		if(location?.freon_gas_act())
			air.temperature = max(temperature - max(500 / air.heat_capacity(), TCMB),TCMB)// energy released is thermal energy so we convert back to kelvin via division
			return REACTING
	return NO_REACTION
