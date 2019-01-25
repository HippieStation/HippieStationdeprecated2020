/*
Copyright (C) 2019 HippieStation

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

/obj/screen/parallax_layer/Initialize(mapload, view)
	. = ..()
	if(GLOB.space_reagent)
		var/datum/reagent/R = GLOB.chemical_reagents_list[GLOB.space_reagent]
		if(R && R.color)
			color = R.color