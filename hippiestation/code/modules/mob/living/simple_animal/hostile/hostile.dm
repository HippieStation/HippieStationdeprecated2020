/mob/living/simple_animal/hostile/CanAttack(atom/the_target)
  if(search_objects < 2)
		if(istype(the_target, /obj/item/electronic_assembly))
			var/obj/item/electronic_assembly/O = the_target
			if(O.combat_circuits)
				return TRUE
  return(..(target))
