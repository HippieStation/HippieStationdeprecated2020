/obj/effect/proc_holder/changeling/lesserform
	name = "Lesser Form"
	desc = "We debase ourselves and become lesser. We become a monkey."
	chemical_cost = 20
	dna_cost = 2
	req_human = 1

//Transform into a monkey.
/obj/effect/proc_holder/changeling/lesserform/sting_action(mob/living/carbon/human/user)
	if(!user || user.notransform)
		return 0
	if(user.on_fire)
		to_chat(user, "<span class='warning'>We cannot enter lesser form while on fire!</span>")
		return 0
	if(user.IsKnockdown())
		to_chat(user, "<span class='warning'>We cannot enter lesser form while disabled!</span>")
		return 0
	to_chat(user, "<span class='warning'>Our genes cry out!</span>")

	user.monkeyize(TR_KEEPITEMS | TR_KEEPIMPLANTS | TR_KEEPORGANS | TR_KEEPDAMAGE | TR_KEEPVIRUS | TR_KEEPSE)
	return TRUE