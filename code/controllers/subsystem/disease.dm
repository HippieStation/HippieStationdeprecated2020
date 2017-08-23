SUBSYSTEM_DEF(disease)
	name = "Disease"
	flags = SS_NO_FIRE

	var/list/active_diseases = list() //List of Active disease in all mobs; purely for quick referencing.
	var/list/diseases
	var/list/archive_diseases = list()

	var/static/list/list_symptoms = subtypesof(/datum/symptom)

/datum/controller/subsystem/disease/PreInit()
	if(!diseases)
		diseases = subtypesof(/datum/disease)

/datum/controller/subsystem/disease/stat_entry(msg)
<<<<<<< HEAD
	..("P:[active_diseases.len]")
=======
	..("P:[active_diseases.len]")

/datum/controller/subsystem/disease/proc/get_disease_name(id)
	var/datum/disease/advance/A = archive_diseases[id]
	if(A.name)
		return A.name
	else
		return "Unknown"
>>>>>>> 28a5901170... You can now click on symptoms in the Pandemic to see their description and stats (#29866)
