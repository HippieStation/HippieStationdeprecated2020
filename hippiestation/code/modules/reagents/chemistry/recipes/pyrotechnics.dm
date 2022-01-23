/datum/chemical_reaction/cryogenic_fluid
	name = "cryogenic_fluid"
	id = "cryogenic_fluid"
	results = list(/datum/reagent/cryogenic_fluid = 4)
	required_reagents = list(/datum/reagent/cryostylane = 2, /datum/reagent/lube = 1, /datum/reagent/pyrosium = 2) //kinda difficult
	required_catalysts = list(/datum/reagent/toxin/plasma = 1)
	required_temp = 100
	is_cold_recipe = TRUE
	mob_react = FALSE
	mix_message = "<span class='danger'>In a sudden explosion of vapour, the container begins to rapidly freeze and a frothing fluid begins to creep up the edges!</span>"

/datum/chemical_reaction/cryogenic_fluid/on_reaction(datum/reagents/holder, created_volume)
	holder.chem_temp = 0 // cools the fuck down
	return

//casschem explosions
/datum/chemical_reaction/reagent_explosion/superboom//explodes on creation
	name = "N-amino azidotetrazole"
	id = "superboom"
	results = list(/datum/reagent/superboom = 4)
	required_reagents = list(/datum/reagent/sboom = 3, /datum/reagent/ammonia = 3, /datum/reagent/dizinc = 2)
	required_catalysts = list(/datum/reagent/toxin/tabun_pb = 1)
	required_temp = 310
	pressure_required = 35
	strengthdiv = 1

/datum/chemical_reaction/reagent_explosion/superboom/on_reaction(datum/reagents/holder, created_volume)//not if stabilising agent is present
	if(holder.has_reagent(/datum/reagent/stabilizing_agent) && holder.chem_pressure < 40)
		return
	holder.remove_reagent(/datum/reagent/sboom, created_volume)

/datum/chemical_reaction/reagent_explosion/superboom_explosion//and when heated slightly
	name = "N-amino azidotetrazole explosion"
	id = "superboom_explosion"
	required_reagents = list(/datum/reagent/superboom = 1)
	required_temp = 315
	strengthdiv = 0.5

/datum/chemical_reaction/reagent_explosion/sazide//explodes on creation
	name = "Sodium Azide"
	id = "sazide"
	results = list(/datum/reagent/toxin/sazide = 4)
	required_reagents = list(/datum/reagent/toxin/acid/hydrazine = 1, /datum/reagent/toxin/acid = 1, /datum/reagent/nitrogen = 1, /datum/reagent/consumable/ethanol = 1)
	centrifuge_recipe = TRUE
	strengthdiv = 8

/datum/chemical_reaction/reagent_explosion/sazide/on_reaction(datum/reagents/holder, created_volume)//not if stabilising agent is present
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	holder.remove_reagent(/datum/reagent/toxin/sazide, created_volume)

/datum/chemical_reaction/reagent_explosion/sazide_explosion//and when heated slightly
	name = "N-amino azidotetrazole explosion"
	id = "superboom_explosion"
	required_reagents = list(/datum/reagent/toxin/sazide = 1)
	required_temp = 574
	strengthdiv = 8

/datum/chemical_reaction/proto_fireball
	name = "Protomatised Plasma Fireball "
	id = "proto_fireball"
	required_reagents = list(/datum/reagent/proto = 1)
	required_temp = 400
	mix_message = "<span class='boldannounce'>The protomatised plasma begins to boil very violently; superheating the surrounding air!</span>"

/datum/chemical_reaction/proto_fireball/on_reaction(datum/reagents/holder, created_volume)
	var/turf/open/T = get_turf(holder.my_atom)
	if(istype(T) && T.air)
		if(created_volume < 15)
			T.atmos_spawn_air("plasma=[created_volume];TEMP=[created_volume * 250]")//very fucking hot
		else
			T.atmos_spawn_air("plasma=[100];co2=[800];TEMP=[created_volume * 1000]")
			var/datum/gas_reaction/hippie_fusion/F = new
			F.react(T.air, T)

	return

/datum/chemical_reaction/reagent_explosion/dizinc_explosion
	name = "Diethly Zinc Explosion"
	id = "dizinc_explosion"
	required_reagents = list(/datum/reagent/dizinc = 1, /datum/reagent/oxygen = 1)
	strengthdiv = 7


//over reaction stuff
/datum/chemical_reaction/proc/over_reaction(datum/reagents/holder, created_volume)
	if(istype(holder, /obj/effect/decal/cleanable/chempile))//smoke spam in chempiles is a big fat sausage of a NO
		holder.clear_reagents()
		return

	var/location = get_turf(holder.my_atom)
	var/datum/effect_system/smoke_spread/chem/S = new
	S.attach(location)
	playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	if(S)
		S.set_up(holder, 4, location, 0)
		S.start()
	if(holder)
		holder.clear_reagents()

/datum/chemical_reaction/over_reactible
	var/exothermic_gain = 0
	var/overheat_threshold = 0
	var/overpressure_threshold = 0
	var/can_overheat = FALSE
	var/can_overpressure = FALSE

/datum/chemical_reaction/over_reactible/on_reaction(datum/reagents/holder, created_volume)
	..()
	holder.chem_temp += exothermic_gain

	if(can_overheat == TRUE && holder.chem_temp >= overheat_threshold)
		over_reaction(holder)
	if(can_overpressure == TRUE && holder.chem_pressure >= overpressure_threshold)
		over_reaction(holder, created_volume)

//all regular pyrotechnic recipes

/datum/chemical_reaction/hydrazine
	name = "Hydrazine"
	id = "hydrazine"
	results = list(/datum/reagent/toxin/acid/hydrazine = 4)
	required_reagents = list(/datum/reagent/toxin/bleach = 1, /datum/reagent/ammonia = 1)
	required_temp = 430
	mix_message = "A furiously fuming oily liquid is produced!"

/datum/chemical_reaction/sboom
	name = "Nitrogenated isopropyl alcohol"
	id = "sboom"
	results = list(/datum/reagent/sboom = 5, /datum/reagent/toxin/tabun_pa = 5)
	required_reagents = list(/datum/reagent/consumable/ethanol/isopropyl = 1, /datum/reagent/nitrogen = 6, /datum/reagent/carbon = 3)
	required_catalysts = list(/datum/reagent/toxin/goop = 1)
	required_temp = 590
	pressure_required = 50

/datum/chemical_reaction/over_reactible/hexamine
	name = "Hexamine"
	id = "hexamine"
	results = list(/datum/reagent/hexamine = 5)
	required_reagents = list(/datum/reagent/ammonia = 3, /datum/reagent/carbon = 3)
	required_catalysts = list(/datum/reagent/iron = 1)
	required_temp = 230
	pressure_required = 35
	is_cold_recipe = TRUE
	exothermic_gain = 25
	can_overheat = TRUE
	overheat_threshold = 245

/datum/chemical_reaction/over_reactible/oxyplas
	name = "Plasminate"
	id = "oxyplas"
	results = list(/datum/reagent/oxyplas = 4, /datum/reagent/hydrogen = 4)
	required_catalysts = list(/datum/reagent/iron = 2)
	required_reagents = list(/datum/reagent/toxin/plasma = 5, /datum/reagent/water = 3)
	required_temp = 340
	can_overheat = TRUE
	overheat_threshold = 370

/datum/chemical_reaction/over_reactible/proto
	name = "Protomatised Plasma"
	id = "proto"
	results = list(/datum/reagent/proto = 2, /datum/reagent/toxin/radgoop = 6)
	required_reagents = list(/datum/reagent/oxyplas = 2, /datum/reagent/hexamine = 3)
	required_temp = 320
	radioactivity_required = 20
	can_overheat = TRUE
	overheat_threshold = 340

/datum/chemical_reaction/over_reactible/proto
	name = "Protomatised Plasma"
	id = "proto"
	results = list(/datum/reagent/proto = 2, /datum/reagent/toxin/radgoop = 6)
	required_reagents = list(/datum/reagent/oxyplas = 2, /datum/reagent/hexamine = 3)
	required_temp = 320
	radioactivity_required = 20
	can_overheat = TRUE
	overheat_threshold = 340

/datum/chemical_reaction/sparky
	name = "Electrostatic substance"
	id = "sparky"
	results = list(/datum/reagent/sparky = 6, /datum/reagent/toxin/radgoop = 4)
	required_reagents = list(/datum/reagent/uranium = 4, /datum/reagent/carbon = 2)
	required_temp = 400
	radioactivity_required = 10

/datum/chemical_reaction/over_reactible/impvolt
	name = "Translucent mixture"
	id = "impvolt"
	results = list(/datum/reagent/impvolt = 4, /datum/reagent/emit_on = 2)
	required_reagents = list(/datum/reagent/sparky = 4, /datum/reagent/teslium = 2)
	required_temp = 290
	is_cold_recipe = TRUE
	bluespace_recipe = TRUE
	can_overheat = TRUE
	overheat_threshold = 310
	exothermic_gain = 20

/datum/chemical_reaction/over_reactible/volt
	name = "Sparking mixture"
	id = "volt"
	results = list(/datum/reagent/volt = 2, /datum/reagent/dizinc = 1)
	required_reagents = list(/datum/reagent/impvolt = 1, /datum/reagent/toxin/methphos = 1)
	required_temp = 250
	is_cold_recipe = TRUE
	can_overheat = TRUE
	overheat_threshold = 270
	exothermic_gain = 30

/datum/chemical_reaction/emit
	name = "Emittrium"
	id = "emit"
	results = list(/datum/reagent/emit = 8, /datum/reagent/uranium/radium = 2)
	required_reagents = list(/datum/reagent/uranium = 2, /datum/reagent/sparky = 4, /datum/reagent/volt = 2)
	bluespace_recipe = TRUE

/datum/chemical_reaction/emit_on
	name = "Emittrium_on"
	id = "emit_on"
	results = list(/datum/reagent/emit_on = 1)
	required_reagents = list(/datum/reagent/emit = 1)
	required_temp = 400

/datum/chemical_reaction/over_reactible/dizinc
	name = "Diethyl Mercury"
	id = "dizinc"
	results = list(/datum/reagent/dizinc = 2)
	required_reagents = list(/datum/reagent/mercury = 1, /datum/reagent/consumable/ethanol = 2)
	required_temp = 290
	is_cold_recipe = TRUE
	can_overheat = TRUE
	overheat_threshold = 310
	exothermic_gain = 30

/datum/chemical_reaction/arclumin
	name = "Arc-Luminol"
	id = "arclumin"
	results = list(/datum/reagent/arclumin = 2)
	required_reagents = list(/datum/reagent/teslium = 2, /datum/reagent/toxin/rotatium = 2, /datum/reagent/liquid_dark_matter = 2, /datum/reagent/colorful_reagent = 2) //difficult
	required_catalysts = list(/datum/reagent/toxin/plasma = 1)
	required_temp = 400
	mix_message = "<span class='danger'>In a blinding flash of light, a glowing frothing solution forms and begins discharging!</span>"
	mix_sound = 'sound/effects/pray_chaplain.ogg'//truly a miracle

/datum/chemical_reaction/arclumin/on_reaction(datum/reagents/holder)//so bright it flashbangs
	var/location = get_turf(holder.my_atom)
	for(var/mob/living/carbon/C in get_hearers_in_view(3, location))
		if(C.flash_act())
			if(get_dist(C, location) < 2)
				C.Knockdown(50)
			else
				C.Stun(50)

/datum/chemical_reaction/reagent_explosion/on_reaction(datum/reagents/holder, created_volume, var/log=TRUE)//added much needed sanity check
	var/turf/T = get_turf(holder.my_atom)
	var/list/log_blacklist_typecache = list(/obj/effect/decal/cleanable/chempile, /obj/effect/particle_effect/vapour)
	log_blacklist_typecache = typecacheof(log_blacklist_typecache)
	if(is_type_in_typecache(holder.my_atom, log_blacklist_typecache))//anti spam
		log = FALSE
	if(isnull(T))
		return FALSE
	var/area/A = get_area(T)
	var/inside_msg
	if(ismob(holder.my_atom))
		var/mob/M = holder.my_atom
		inside_msg = " inside [key_name_admin(M)]"
	var/lastkey = holder.my_atom.fingerprintslast
	var/touch_msg = "N/A"
	if(lastkey)
		var/mob/toucher = get_mob_by_key(lastkey)
		touch_msg = "[ADMIN_LOOKUPFLW(toucher)]"
	if(log)
		message_admins("Reagent explosion reaction occurred at [A] [ADMIN_COORDJMP(T)][inside_msg]. Last Fingerprint: [touch_msg].")
		log_game("Reagent explosion reaction occurred at [A] [COORD(T)]. Last Fingerprint: [lastkey ? lastkey : "N/A"]." )
	var/datum/effect_system/reagents_explosion/e = new()
	e.set_up(modifier + round(created_volume/strengthdiv, 1), T, 0, 0)
	e.start(log)
	holder.clear_reagents()


/datum/chemical_reaction/reagent_explosion/remove_all
	var/chem_to_remove
	modifier = 1

/datum/chemical_reaction/reagent_explosion/remove_all/on_reaction(datum/reagents/holder, created_volume, var/log=TRUE)
	. = ..()
	holder.remove_reagent(chem_to_remove)

/datum/chemical_reaction/reagent_explosion/remove_all/meth_a
	name = "Meth Collapse"
	chem_to_remove = "methamphetamine"
	required_catalysts = list(/datum/reagent/drug/methamphetamine = 1, /datum/reagent/smoke_powder = 1)
	
/datum/chemical_reaction/reagent_explosion/remove_all/meth_b
	name = "Meth Collapse"
	chem_to_remove = "methamphetamine"
	required_catalysts = list(/datum/reagent/drug/methamphetamine = 1, /datum/reagent/potassium = 1, /datum/reagent/consumable/sugar = 1, /datum/reagent/phosphorus = 1)

/datum/chemical_reaction/reagent_explosion/remove_all/blackpowder_a
	name = "Black Powder Collapse"
	chem_to_remove = "blackpowder"
	required_catalysts = list(/datum/reagent/blackpowder = 1, /datum/reagent/smoke_powder = 1)
	
/datum/chemical_reaction/reagent_explosion/remove_all/blackpowder_b
	name = "Black Powder Collapse"
	chem_to_remove = "blackpowder"
	required_catalysts = list(/datum/reagent/blackpowder = 1, /datum/reagent/potassium = 1, /datum/reagent/consumable/sugar = 1, /datum/reagent/phosphorus = 1)

/datum/chemical_reaction/reagent_explosion/remove_all/superboom_a
	name = "N-amino azidotetrazole Collapse"
	chem_to_remove = "superboom"
	required_catalysts = list(/datum/reagent/superboom = 1, /datum/reagent/smoke_powder = 1)
	modifier = 4
	
/datum/chemical_reaction/reagent_explosion/remove_all/superboom_b
	name = "N-amino azidotetrazole Collapse"
	chem_to_remove = "superboom"
	required_catalysts = list(/datum/reagent/superboom = 1, /datum/reagent/potassium = 1, /datum/reagent/consumable/sugar = 1, /datum/reagent/phosphorus = 1)
	modifier = 4
	
	
