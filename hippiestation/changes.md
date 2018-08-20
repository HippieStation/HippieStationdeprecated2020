# Differences with /tg/

The best practice to have while coding is to keep everything modularized, or the most possible. Sometimes, through,
 it's not possible and you're required to edit some files inside the code folder, which is /tg/'s code. This file is intended to have a list of the files changed.

# Sorted alphabetically filepath-wise.

## code/__DEFINES/diseases.dm
## code/__DEFINES/misc.dm
## code/__DEFINES/mobs.dm
## code/__DEFINES/role_preferences.dm
## code/__HELPERS/unsorted.dm
## code/controllers/subsystem/job.dm
## code/controllers/subsystem/throwing.dm
## code/controllers/subsystem/ticker.dm
## code/controllers/subsystem/vote.dm
## code/datums/datumvars.dm
## code/datums/hud.dm
## code/datums/progressbar.dm
## code/datums/wires/airlock.dm
## code/game/gamemodes/changeling/changeling.dm !Should be modularized. Can be done easily.
## code/game/gamemodes/game_mode.dm
## code/game/gamemodes/traitor/traitor.dm !Should be modularized. Can be done easily.
## code/game/machinery/computer/cloning.dm
## code/game/machinery/doors/airlock_types.dm !Should be modularized. Can be done easily.
## code/game/machinery/doors/brigdoors.dm
## code/game/objects/effects/effect_system/effects_smoke.dm
## code/game/objects/empulse.dm !Should be modularized. Can be done easily.
## code/game/objects/items.dm
## code/game/objects/items/crayons.dm
## code/game/objects/items/devices/flashlight.dm !Should be modularized. Can be done easily.
## code/game/objects/items/stacks/rods.dm
## code/game/objects/items/tools/wirecutters.dm !Should be modularized. Can be done easily.
## code/game/turfs/open.dm
## code/game/world.dm !Needs modularization! This stuff is crap.
## code/modules/admin/admin.dm
## code/modules/admin/admin_verbs.dm
## code/modules/admin/secrets.dm
## code/modules/admin/topic.dm
## code/modules/admin/verbs/one_click_antag.dm
## code/modules/awaymissions/capture_the_flag.dm
## code/modules/awaymissions/corpse.dm
## code/modules/client/client_procs.dm
## code/modules/client/preferences.dm
## code/modules/client/preferences_savefile.dm
## code/modules/client/verbs/ooc.dm
## code/modules/clothing/clothing.dm
## code/modules/food_and_drinks/drinks/drinks.dm !Should be modularized. Can be done easily.
## code/modules/food_and_drinks/drinks/drinks/drinkingglass.dm
## code/modules/hydroponics/grown/banana.dm !Should be modularized. Can be done easily.
## code/modules/integrated_electronics/subtypes/input.dm
## code/modules/integrated_electronics/subtypes/manipulation.dm
## code/modules/integrated_electronics/subtypes/smart.dm
## code/modules/mining/equipment/survival_pod.dm !Should be modularized. Can be done easily.
## code/modules/mob/living/carbon/alien/alien.dm !Should be modularized. Can be done easily.
## code/modules/mob/living/carbon/carbon_defense.dm
## code/modules/mob/living/carbon/death.dm !Should be modularized. Can be done easily.
## code/modules/mob/living/carbon/human/examine.dm
## code/modules/mob/living/carbon/human/human.dm !Should be modularized. Can be done easily.
## code/modules/mob/living/carbon/human/human_defense.dm
## code/modules/mob/living/carbon/human/species.dm
## code/modules/mob/living/carbon/monkey/monkey.dm !Should be modularized. Can be done easily.
## code/modules/mob/living/carbon/update_icons.dm
## code/modules/mob/living/living.dm 
## code/modules/mob/living/say.dm
## code/modules/mob/living/silicon/ai/ai.dm
## code/modules/mob/living/silicon/pai/pai_shell.dm
## code/modules/mob/living/silicon/robot/robot.dm
## code/modules/mob/living/simple_animal/bot/medbot.dm
## code/modules/mob/living/simple_animal/friendly/dog.dm
## code/modules/mob/living/simple_animal/hostile/headcrab.dm
## code/modules/mob/living/simple_animal/slime/slime.dm
## code/modules/mob/mob_movement.dm !Horrible code alert, how did this even get merged?
## code/modules/photography/camera/camera_image_capturing.dm
## code/modules/reagents/chem_splash.dm !Could probably be improved to avoid cutting out the whole tg proc
## code/modules/reagents/chemistry/holder.dm !Same as above.
## code/modules/reagents/chemistry/recipes/pyrotechnics.dm !Same as above.
## code/modules/reagents/reagent_containers.dm !Could be modularized.
## code/modules/spells/spell.dm
## code/modules/surgery/bodyparts/head.dm
## code/modules/surgery/helpers.dm
## code/modules/surgery/organs/vocal_cords.dm
