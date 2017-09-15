/datum/chemical_reaction/arclumin
	name = "Arc-Luminol"
	id = "arclumin"
	results = list("arclumin" = 2)
	required_reagents = list("teslium" = 2, "rotatium" = 2, "liquid_dark_matter" = 2, "colorful_reagent" = 2) //difficult
	required_catalysts = list("plasma" = 1)
	required_temp = 400
	mix_message = "<span class='danger'>In a blinding flash of light, a glowing frothing solution forms and begins discharging!</span>"
	mix_sound = 'sound/effects/pray_chaplain.ogg'//truly a miracle

/datum/chemical_reaction/arclumin/on_reaction(datum/reagents/holder, created_volume) //so bright it flashbangs
	var/location = get_turf(holder.my_atom)
	for(var/mob/living/carbon/C in get_hearers_in_view(3, location))
		if(C.flash_act())
			if(get_dist(C, location) < 2)
				C.Weaken(5)
			else
				C.Stun(5)
