/datum/guardian_ability
	var/name = "ERROR"
	var/desc = "You should not see this!"
	var/cost = 0
	var/spell_type
	var/obj/effect/proc_holder/spell/spell
	var/datum/guardian_stats/master_stats

// note -- all guardian abilities should be able to have Apply() ran multiple times with no problems.
/datum/guardian_ability/proc/Apply(mob/living/simple_animal/hostile/guardian/guardian)
	if(spell_type && !spell)
		spell = new spell_type
	if(spell && !(spell in guardian.mob_spell_list))
		guardian.AddSpell(spell)

// major abilities have a mode usually
/datum/guardian_ability/major
	var/has_mode = FALSE
	var/mode = FALSE
	var/recall_mode = FALSE
	var/mode_on_msg = ""
	var/mode_off_msg = ""

/datum/guardian_ability/major/proc/Attack(mob/living/simple_animal/hostile/guardian/guardian, atom/target)

/datum/guardian_ability/major/proc/Manifest(mob/living/simple_animal/hostile/guardian/guardian)

/datum/guardian_ability/major/proc/Recall(mob/living/simple_animal/hostile/guardian/guardian)

/datum/guardian_ability/major/proc/Mode(mob/living/simple_animal/hostile/guardian/guardian)

/datum/guardian_ability/major/proc/AltClickOn(mob/living/simple_animal/hostile/guardian/guardian, atom/A)

/datum/guardian_ability/major/proc/CtrlClickOn(mob/living/simple_animal/hostile/guardian/guardian, atom/A)

// minor ability stub
/datum/guardian_ability/minor
