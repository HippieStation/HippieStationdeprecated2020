/*
Authors: steamport <steamport@protonmail.com F3F5C121EA1AADCA>

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

/client/proc/make_liquid()
	set name = "Spawn Liquid Pool"
	set category = "Fun"
	set desc = "Spawn A Liquid Pool"
	var/list/reagent_options = sortList(GLOB.chemical_reagents_list)
	var/chosen_id
	switch(alert(usr, "Choose a method.", "Add Reagents", "Enter ID", "Choose ID"))
		if("Enter ID")
			var/valid_id
			while(!valid_id)
				chosen_id = stripped_input(usr, "Enter the ID of the reagent you want to add.")
				if(!chosen_id) //Get me out of here!
					break
				for(var/ID in reagent_options)
					if(ID == chosen_id)
						valid_id = TRUE
				if(!valid_id)
					to_chat(usr, "<span class='warning'>A reagent with that ID doesn't exist!</span>")
					return
		if("Choose ID")
			chosen_id = input(usr, "Choose a reagent to add.", "Choose a reagent.") as null|anything in reagent_options
			if(!chosen_id)
				return
	var/amount = input(usr, "Choose the amount to add.", "Choose the amount.", 1000) as num
	if(!amount)
		return
	var/turf/T = get_turf(usr)
	message_admins("[key_name(src)] has created a pool of '[chosen_id]' liquid, with a volume of [amount]u, at [COORD(T)].")
	log_game("[key_name(src)] has created a pool of '[chosen_id]' liquid, with a volume of [amount]u, at [COORD(T)].")

	var/obj/effect/liquid/W = new /obj/effect/liquid(T)
	W.reagents.maximum_volume = max(W.reagents.maximum_volume, amount)
	W.reagents.add_reagent("[chosen_id]", amount)
	W.depth = max(amount / REAGENT_TO_DEPTH, 0)
	if(W.depth <= 0)
		return
	W.update_depth()
	INVOKE_ASYNC(W, /obj/effect/liquid.proc/equilibrate)