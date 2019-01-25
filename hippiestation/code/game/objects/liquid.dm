/*

	Authors: banthebantz, steamport <steamport@protonmail.com F3F5C121EA1AADCA>

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU Affero General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Affero General Public License for more details.

	You should have received a copy of the GNU Affero General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#define LIQUID_TICKS_UNTIL_THROTTLE 50
#define LIQUID_TICKS_UNTIL_WAKE_UP 200 //failsafe to make sure sleeping liquids aren't failing to distribute depth
#define REAGENT_TO_DEPTH 10 //fucking cucks too scared of fun
#define LIQUID_TICKS_UNTIL_EVAPORATION 800
#define MAXIMUM_ACTIVITY 1000//if activity goes above max stop this pool
#define MAX_INITIAL_DEPTH 25

/datum/liquid_pool//abstract shit to manage pools of liquid
	var/list/liquids = list()
	var/spread_time = 0
	var/counter = 0
	var/average_viscosity = 0
	var/volatile = TRUE//does it evaporate on its own?
	var/total_activity

/datum/liquid_pool/New()
	..()
	START_PROCESSING(SSliquids, src)

/datum/liquid_pool/Destroy()
	for(var/I in liquids)
		qdel(I)
	STOP_PROCESSING(SSliquids, src)
	return ..()

/datum/liquid_pool/process()
	counter++
	average_viscosity = 0
	if(spread_time < world.time)
		shuffle_inplace(liquids)//randomise
		for(var/I in liquids)//primary loop
			var/obj/effect/liquid/L = I
			if(L.depth <= 1)
				qdel(L)
				continue
			if(L.active)
				INVOKE_ASYNC(L, /obj/effect/liquid.proc/equilibrate)//async to make it more natural
				total_activity += L.cached_activity
				average_viscosity += L.viscosity
			if(L.cached_activity == 0 || L.depth <= 1)//we could have a situation where a liquid of high depth is trapped by dense atoms so it's better to have this affect liquids of any depth that aren't doing anything
				L.active = FALSE

			L.cached_activity = 0
			var/turf/T = get_turf(L)
			if(T && L.is_immersing)
				var/check = 0
				for(var/_A in T.contents)
					if(!isatom(_A))
						continue
					var/atom/A = _A
					if(isobj(A))
						var/obj/O = A
						L.immerse_obj(O)
						if(O != src)
							check++
					if(ismob(A))
						var/mob/M = A
						L.immerse_mob(M)
						check++
				if(!check)
					L.is_immersing = FALSE
			L.update_depth()

		if(average_viscosity && LAZYLEN(liquids))//fucking division by zero shit
			average_viscosity = max(average_viscosity / LAZYLEN(liquids), 0.1)
			spread_time = world.time + average_viscosity

	if(counter >= LIQUID_TICKS_UNTIL_EVAPORATION && volatile)
		for(var/I in liquids)
			var/obj/effect/liquid/L = I
			if(prob(25) && !L.is_static)
				L.depth -= 0.25 // this is a station, there's no sun to speed up evaporation, only artifical lights
				L.update_depth()

	if(total_activity > MAXIMUM_ACTIVITY)
		qdel(src)
	total_activity = 0

/obj/effect/liquid
	name = "liquid"
	desc = "Looks wet."
	icon = 'hippiestation/icons/obj/liquid.dmi'
	icon_state = "liquid0"
	alpha = 100
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_MOB_LAYER
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	pass_flags = PASSTABLE | PASSGRILLE
	var/viscosity = 0//affects the spread and general properties of the liquid
	var/depth = 0//how much liquid is on this tile
	var/spread_rate = 1//self explanatory
	var/is_static = FALSE//a static liquid will never lose volume and will only add to other liquids, good for permanent liquid sources
	var/datum/liquid_pool/pool //a pool is a group of interconnected liquid tiles that process together, this is used for organisation and optimisation
	var/cached_activity = 0//this is used to judge the activity of a pool, if it is 0 or close to 0 the processing for a pool will be throttled or stopped to save performance
	var/is_immersing = FALSE //do we a share a tile with a mob or obj? reduces proc calls
	var/active = TRUE//if it isn't doing much we wait for something to change


/obj/effect/liquid/Initialize()
	. = ..()
	create_reagents(1000)
	addtimer(CALLBACK(src, .proc/get_pool), 0)
	var/turf/T = get_turf(src)
	var/atom/movable/AM = locate() in T//since crossed doesn't work if the liquid is the one doing the 'moving'
	if(AM)
		is_immersing = TRUE
	update_overlays()


/obj/effect/liquid/proc/update_overlays()
	var/l_layer = ABOVE_MOB_LAYER
	var/m_layer = LOW_OBJ_LAYER
	var/h_layer = LOW_OBJ_LAYER
	if(depth > 5)
		m_layer = ABOVE_MOB_LAYER
	if(depth > 9)
		h_layer = ABOVE_MOB_LAYER
	cut_overlays()
	var/mutable_appearance/low_water = mutable_appearance(icon, "liquid1", l_layer)
	var/mutable_appearance/mid_water = mutable_appearance(icon, "liquid2", m_layer)
	var/mutable_appearance/high_water = mutable_appearance(icon, "liquid3", h_layer)
	add_overlay(low_water)
	add_overlay(mid_water)
	add_overlay(high_water)

/obj/effect/liquid/proc/get_pool()
	if(!pool)
		for(var/obj/effect/liquid/L in view(3, src))
			if(L.pool)
				pool = L.pool
				LAZYADD(pool.liquids, src)
				return
		pool = new /datum/liquid_pool
		LAZYADD(pool.liquids, src)


/obj/effect/liquid/proc/equilibrate()
	update_overlays()
	var/turf/OT = get_turf(src)
	if(!OT)
		return//this is stuck here to HUGELY reduce the amount of unneeded immersed calls
	if(!GLOB.space_reagent && isspaceturf(OT))//drain to space?
		for(var/obj/effect/liquid/LD in view(3, OT))
			if(LD.viscosity)
				var/chance = CLAMP(50 / LD.viscosity, 20, 100)
				if(prob(chance))
					step_to(LD, OT)
		qdel(src)
		return
	if(prob(25) && reagents)
		reagents.reaction(OT, TOUCH, 0.1 * depth)

	if(depth < 2)
		return
	var/list/cached_turfs = OT.GetAtmosAdjacentTurfs()
	var/cached_turfs_len = LAZYLEN(cached_turfs)
	if(!cached_turfs_len)
		active = FALSE
		return
	var/block_counter = 0

	for(var/I in 1 to cached_turfs_len)
		var/turf/T = pick(cached_turfs)
		LAZYREMOVE(cached_turfs, T)
		if(GLOB.space_reagent && isspaceturf(T)) // don't drain to space if space is liquid
			continue
		if(!T)
			return
		var/obj/effect/liquid/LT = locate() in T
		if(depth + OT.elevation < T.elevation)
			continue
		if(LT && depth > 1)
			LT.active = TRUE
			if(LT == src || LT.depth >= depth || LT.is_static || (LT.depth + T.elevation) >= (depth + OT.elevation) || !reagents)
				block_counter++
				continue

			LT.depth++
			if(!is_static)
				depth--
			if(reagents)
				reagents.trans_to(LT, REAGENT_TO_DEPTH)
			LT.update_depth()
			update_depth()
			cached_activity++
			block_counter--
			for(var/obj/O in T)
				if(prob(50) && !O.anchored && !O.pulledby && O != src)
					step_to(O, T)
			continue

		if(depth <= 1)
			return

		var/obj/effect/liquid/LN = new(T)
		LN.is_static = is_static
		LN.depth++
		if(!is_static)
			depth--
		LN.pool = pool
		LAZYADD(pool.liquids, LN)
		if(reagents)
			reagents.trans_to(LN, REAGENT_TO_DEPTH)
		LN.update_depth()
		update_depth()
		cached_activity++
		block_counter--
		for(var/atom/movable/AM in OT)
			if(depth >= 3 && prob(50) && !AM.anchored && !AM.pulledby && AM != src)
				step_to(AM, T)

	if(block_counter >= cached_turfs_len)//all adjacent turfs are flagged as blocked
		active = FALSE
	else
		active = TRUE
	update_overlays()

/obj/effect/liquid/proc/update_depth()
	alpha = LERP(100, 240, depth / 15)
	update_overlays()

	if(!active && depth <= 1)//something called this but we either gained no depth or lost depth so do not continue
		return
	if(is_static)
		return
	if(!reagents)
		qdel(src)
		return
	else
		if(depth <= 0 || reagents.total_volume <= 0)
			qdel(src)
			return
		active = TRUE//we must've gained depth!
		viscosity = 0
		var/reag_amount = LAZYLEN(reagents.reagent_list)
		for(var/I in reagents.reagent_list)
			var/datum/reagent/R = I
			R.volume = max((REAGENT_TO_DEPTH * depth) / reag_amount, 0.2)
			viscosity += CLAMP(R.viscosity * (round(R.volume / reagents.total_volume, 0.1)), 0.1, 20)
		var/mixcolor = mix_color_from_reagents(reagents.reagent_list)
		add_atom_colour(mixcolor, FIXED_COLOUR_PRIORITY)
	update_overlays()

/obj/effect/liquid/proc/immerse_mob(mob/any)
	if(iscarbon(any) && reagents)
		var/mob/living/carbon/C = any
		reagents.reaction(C, TOUCH, 0.4)
		if(depth > 9 && reagents)
			reagents.reaction(C, TOUCH, 0.6)//it is added on
			if(!C.internal)
				reagents.copy_to(C, 0.05 * depth)
				reagents.reaction(C, INGEST, 0.05 * depth)
				C.losebreath += 1 //Every second under water is a second not breathing
				if(prob(5))
					to_chat(C, "<span class='userdanger'>You are drowning!</span>")
	if(!any.anchored)
		if(depth > 6 && !(any.movement_type & FLOATING))
			any.float(TRUE)
		else if(depth < 7)
			any.float(FALSE)


/obj/effect/liquid/proc/immerse_obj(obj/O)
	if(istype(O, /obj/effect/decal/cleanable/chempile))
		depth = CLAMP(depth + (O.reagents.total_volume / REAGENT_TO_DEPTH), 0, MAX_INITIAL_DEPTH)
		O.reagents.trans_to(src, O.reagents.total_volume)
		update_depth()
		qdel(O)
	if(depth > 2)
		if(O.reagents && (O.reagents.flags & REFILLABLE) && O.reagents.total_volume)
			for(var/I in O.reagents.reagent_list)
				var/datum/reagent/R = I
				R.handle_state_change(get_turf(O), R.volume, O)
			O.reagents.clear_reagents()
			visible_message("<span class='danger'>The reagents in [O] dissolve into the liquid!</span>")

		if(!O.anchored && O != src)
			if(depth > 6 && !(O.movement_type & FLOATING))
				O.float(TRUE)
			else if(depth < 7)
				O.float(FALSE)

		if(prob(25) && reagents)
			reagents.reaction(O, TOUCH, 0.05 * depth)


/obj/effect/liquid/proc/activate()
	active = TRUE
	for(var/obj/effect/liquid/L in orange(1, src))
		if(L.depth > 1 && L != src)
			L.active = TRUE


/obj/effect/liquid/Crossed(atom/movable/AM, turf/old)
	is_immersing = TRUE
	active = TRUE//a moving atom can trigger a wake up as well
	if(iscarbon(AM) && old)
		var/mob/living/carbon/C = AM
		if(C.movement_type & FLYING)
			return FALSE
		var/turf/T = get_turf(src)
		if(old.elevation > T.elevation + 5 && C.mob_has_gravity())
			var/elevation_difference = old.elevation - T.elevation
			C.Knockdown(elevation_difference * 5)
			to_chat(C, "<span class='userdanger'>You slip off the edge of [old] and plunge straight into the liquid!</span>")
			playsound(C, 'hippiestation/sound/effects/splash.ogg', 60, 1, 1)
			C.emote("cough")
			if(reagents)
				reagents.reaction(C, TOUCH, 4)
				if(!C.internal)
					reagents.copy_to(C, 2)
					reagents.reaction(C, INGEST, 2)

		playsound(src, pick('hippiestation/sound/effects/water_wade1.ogg','hippiestation/sound/effects/water_wade2.ogg','hippiestation/sound/effects/water_wade3.ogg','hippiestation/sound/effects/water_wade4.ogg'), 25, 1)

		if(prob(25))
			var/obj/effect/splash/S = new /obj/effect/splash(T)
			animate(S, alpha = 0,  time = 8)
			S.Move(old)
			QDEL_IN(S, 20)

/obj/effect/liquid/Destroy()
	if(pool)
		LAZYREMOVE(pool.liquids, src)

	if(prob(50) && reagents)
		var/turf/T = get_turf(src)
		var/obj/effect/decal/cleanable/chempile/c = locate() in T//handles merging existing chempiles
		if(c && c.reagents)
			reagents.trans_to(c, max(reagents.total_volume * 0.25, 0.1))
			var/mixcolor = mix_color_from_reagents(c.reagents.reagent_list)
			c.add_atom_colour(mixcolor, FIXED_COLOUR_PRIORITY)
			if(c.reagents && c.reagents.total_volume < 5)
				DISABLE_BITFIELD(c.reagents.flags, NO_REACT)
		else
			var/obj/effect/decal/cleanable/chempile/P = new /obj/effect/decal/cleanable/chempile(T)//otherwise makes a new one
			reagents.trans_to(P, max(reagents.total_volume * 0.25, 0.1))
			var/mixcolor = mix_color_from_reagents(P.reagents.reagent_list)
			P.add_atom_colour(mixcolor, FIXED_COLOUR_PRIORITY)

	return ..()

/obj/effect/liquid/fire_act(exposed_temperature, exposed_volume)
	..()
	if(reagents && reagents.chem_temp)
		reagents.expose_temperature(exposed_temperature)
		if(reagents.chem_temp > 1000)
			for(var/I in reagents.reagent_list)
				var/datum/reagent/R = I
				R.handle_state_change(get_turf(src), R.volume)
			qdel(src)

/mob/living/handle_fire()
	if(!isturf(loc))
		return ..()
	var/turf/T = loc
	var/obj/effect/liquid/L = (/obj/effect/liquid in T.contents)
	if(L && L.depth > 2)
		ExtinguishMob()
		return
	return ..()