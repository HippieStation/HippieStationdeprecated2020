#warn DO NOT LEAVE guardiantesting.dm TICKED!!!

/mob/living/carbon/human
	var/datum/guardianbuilder/builder

/mob/living/carbon/human/Initialize()
	. = ..()
	builder = new("Guardian Spirit", "magic", "", "", 100, TRUE)

/mob/living/carbon/human/verb/guardian_test_stats()
	set name = "Guardian Testing - Stats"
	builder.ui_interact(src)

/mob/living/carbon/human/verb/guardian_test_spawn()
	set name = "Guardian Testing - Spawn"
	var/mob/living/simple_animal/hostile/guardian/G = new(src, "magic")
	G.summoner = src
	G.key = key
	G.mind.enslave_mind_to_creator(src)
	G.RegisterSignal(G.summoner, COMSIG_MOVABLE_MOVED, /mob/living/simple_animal/hostile/guardian.proc/OnMoved)
	var/datum/antagonist/guardian/S = new
	S.stats = builder.saved_stats
	S.summoner = mind.name
	G.mind.add_antag_datum(S)
	G.stats = builder.saved_stats
	G.stats.Apply(G)
	G.show_detail()
