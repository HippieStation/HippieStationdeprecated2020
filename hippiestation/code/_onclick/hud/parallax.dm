/*
   _____          _          _   ____                 
  / ____|        | |        | | |  _ \                
 | |     ___   __| | ___  __| | | |_) |_   _          
 | |    / _ \ / _` |/ _ \/ _` | |  _ <| | | |         
 | |___| (_) | (_| |  __/ (_| | | |_) | |_| |         
  \_____\___/ \__,_|\___|\__,_| |____/ \__, |     _   
  / ____| |                             __/ |    | |  
 | (___ | |_ ___  __ _ _ __ ___  _ __  |___/ _ __| |_ 
  \___ \| __/ _ \/ _` | '_ ` _ \| '_ \ / _ \| '__| __|
  ____) | ||  __/ (_| | | | | | | |_) | (_) | |  | |_ 
 |_____/ \__\___|\__,_|_| |_| |_| .__/ \___/|_|   \__|
                                | |                   
                                |_|            

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