// I am so, so sorry.
/obj/item/clothing/suit/hippie/ganymedian
	alternate_screams = list('face/sound/screams/thanos1.ogg','face/sound/screams/thanos2.ogg','face/sound/screams/thanos3.ogg','face/sound/screams/thanos4.ogg','face/sound/screams/thanos5.ogg','face/sound/screams/thanos6.ogg')

/obj/item/clothing/under/rank/security/blueshirt
	alternate_screams = list('face/sound/screams/ba1.ogg','face/sound/screams/ba2.ogg','face/sound/screams/ba3.ogg','face/sound/screams/ba4.ogg','face/sound/screams/ba5.ogg','face/sound/screams/ba6.ogg')

// huge, HUGE shout outs to mcbawbag here for the help. he did this all. fucking legend.
/obj/item/robot_module/Initialize()
  . = ..()
  var/mob/living/silicon/robot/R = loc
  R.clear_screams()
  R.add_screams(robot_module_specific_screams)
  R.deathsound = robot_module_specific_death_sound

/* This should be some fallback sound that all borgs inherit just in case */
/obj/item/robot_module
  var/list/robot_module_specific_screams = list('hippiestation/sound/voice/scream_silicon.ogg')
  var/robot_module_specific_death_sound = 'hippiestation/sound/voice/ai_death_hippie.ogg'

/obj/item/robot_module/standard
  robot_module_specific_screams = list('face/sound/screams/silicon/standard1.ogg','face/sound/screams/silicon/standard2.ogg','face/sound/screams/silicon/standard3.ogg','face/sound/screams/silicon/standard4.ogg','face/sound/screams/silicon/standard5.ogg','face/sound/screams/silicon/standard6.ogg','face/sound/screams/silicon/standard7.ogg','face/sound/screams/silicon/standard8.ogg')// Standard has cannabalized the placeholder sounds from other borgo boys, hence why he has so much more.
  robot_module_specific_death_sound = 'face/sound/screams/silicon/standarddeath.ogg'

/obj/item/robot_module/medical
  robot_module_specific_screams = list('face/sound/screams/silicon/med1.ogg','face/sound/screams/silicon/med2.ogg','face/sound/screams/silicon/med3.ogg','face/sound/screams/silicon/med4.ogg','face/sound/screams/silicon/med5.ogg')
  robot_module_specific_death_sound = 'face/sound/screams/silicon/meddie1.ogg'

/obj/item/robot_module/engineering
  robot_module_specific_death_sound = 'face/sound/screams/silicon/engdie.ogg'
  robot_module_specific_screams = list('face/sound/screams/silicon/eng1.ogg','face/sound/screams/silicon/eng2.ogg','face/sound/screams/silicon/eng3.ogg')

/obj/item/robot_module/security
  robot_module_specific_death_sound = 'face/sound/screams/silicon/secdeath.ogg'
  robot_module_specific_screams = list ('face/sound/screams/silicon/sec1.ogg','face/sound/screams/silicon/sec2.ogg','face/sound/screams/silicon/sec3.ogg','face/sound/screams/silicon/sec4.ogg','face/sound/screams/silicon/sec5.ogg','face/sound/screams/silicon/sec6.ogg')

/obj/item/robot_module/peacekeeper
  robot_module_specific_death_sound = 'face/sound/screams/silicon/peadie.ogg'
  robot_module_specific_screams = list('face/sound/screams/silicon/pea1.ogg','face/sound/screams/silicon/pea2.ogg','face/sound/screams/silicon/pea3.ogg','face/sound/screams/silicon/pea4.ogg','face/sound/screams/silicon/pea5.ogg')

/obj/item/robot_module/janitor
  robot_module_specific_death_sound = 'face/sound/screams/silicon/janidie.ogg'
  robot_module_specific_screams = list('face/sound/screams/silicon/jani1.ogg','face/sound/screams/silicon/jani2.ogg','face/sound/screams/silicon/jani3.ogg')

/obj/item/robot_module/clown
  robot_module_specific_death_sound = 'face/sound/screams/silicon/clodie.ogg'
  robot_module_specific_screams = list('face/sound/screams/silicon/clo1.ogg','face/sound/screams/silicon/clo2.ogg','face/sound/screams/silicon/clo3.ogg','face/sound/screams/silicon/clo4.ogg','face/sound/screams/silicon/clo5.ogg')

/obj/item/robot_module/butler
  robot_module_specific_death_sound = 'face/sound/screams/silicon/butdie.ogg'
  robot_module_specific_screams = list('face/sound/screams/silicon/but1.ogg','face/sound/screams/silicon/but2.ogg','face/sound/screams/silicon/but3.ogg')

/obj/item/robot_module/miner
  robot_module_specific_death_sound = 'face/sound/screams/silicon/minedie.ogg'
  robot_module_specific_screams = list('face/sound/screams/silicon/mine1.ogg','face/sound/screams/silicon/mine2.ogg','face/sound/screams/silicon/mine3.ogg','face/sound/screams/silicon/mine4.ogg')

/obj/item/robot_module/syndicate
  robot_module_specific_death_sound = 'face/sound/screams/silicon/synddie.ogg'
  robot_module_specific_screams = list('face/sound/screams/silicon/synd1.ogg','face/sound/screams/silicon/synd2.ogg','face/sound/screams/silicon/synd3.ogg')

/obj/item/robot_module/syndicate_medical
  robot_module_specific_death_sound = 'face/sound/screams/silicon/syndmdie.ogg'
  robot_module_specific_screams = list('face/sound/screams/silicon/syndm1.ogg','face/sound/screams/silicon/syndm2.ogg','face/sound/screams/silicon/syndm3.ogg','face/sound/screams/silicon/syndm4.ogg')
// /obj/item/robot_module/saboteur not changing these fellas screams just yet
