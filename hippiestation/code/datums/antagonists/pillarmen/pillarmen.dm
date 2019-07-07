//made by Karma
GLOBAL_LIST_INIT(pm_elements, list("Fire", "Wind", "Ice", "Light"))

/datum/antagonist/pillarmen
	name = "Pillar Man"
	antagpanel_category = "Pillar Men"
	roundend_category = "pillar men"
	job_rank = ROLE_PILLARMEN
	var/datum/team/pillarmen/pillarTeam //Will have the pillar man himself, the vampires and the thralls.
	var/ascended = FALSE
	var/true_name = "" // rng, changed

/datum/antagonist/pillarmen/apply_innate_effects()
	..()
	owner.AddSpell(new /obj/effect/proc_holder/spell/self/pillar_hatch)
	var/obj/item/clothing/mask/stone/SM = new(get_turf(owner.current))
	SM.pillarMan = src
	owner.current.equip_to_slot(SM, SLOT_IN_BACKPACK)
	update_pillar_icons_added()

/datum/antagonist/pillarmen/remove_innate_effects()
	update_pillar_icons_removed()
	..()

/datum/antagonist/pillarmen/on_removal()
	. = ..()
	if(pillarTeam.pillarMan == owner)
		pillarTeam.pillarMan = null

/datum/antagonist/pillarmen/create_team(datum/team/pillarmen/new_team)
	if(istype(new_team))
		pillarTeam = new_team
		pillarTeam.pillarMan = owner

/datum/antagonist/pillarmen/get_team()
	return pillarTeam

/datum/antagonist/pillarmen/greet()
	SEND_SOUND(owner.current, 'hippiestation/sound/ambience/antag/pillar.ogg')
	to_chat(owner.current, "<span class='cultlarge'>You are a <span class='reallybig hypnophrase'>Pillar Man</span>, in disguise.</span>")
	to_chat(owner.current, "<span class='cult'>In order to unlock your immense power, you must emerge first.</span>")
	to_chat(owner.current, "<span class='cult'>Use the Stone Mask in your backpack to raise an army of vampires.</span>")
	to_chat(owner.current, "<span class='cult'>However, you are still mortal. You must ascend to godhood by utilizing the Red Stone of Aja with a stone mask.</span>")
	to_chat(owner.current, "<span class='cult'>There are other Pillar Men, working to get the stone. Get the stone before the others, in order to ascend!</span>")
	to_chat(owner.current, "<span class='cult'>Ascending will allow you to become the ultimate organism, however, you die if you fail to ascend by being stunned while ascending.</span>")

// Dynamically creates the HUD for the team if it doesn't exist already, inserting it into the global huds list, and assigns it to the user. The index is saved into a var owned by the team datum.
/datum/antagonist/pillarmen/proc/update_pillar_icons_added()
	var/datum/atom_hud/antag/pillarhud = GLOB.huds[pillarTeam.hud_entry_num]
	if(!pillarhud)
		pillarhud = new()
		pillarTeam.hud_entry_num = GLOB.huds.len + 1 // the index of the hud inside huds list
		GLOB.huds += pillarhud
	pillarhud.join_hud(owner.current)
	set_antag_hud(owner.current, "pillar")

// Removes hud. Destroying the hud datum itself in case the team is deleted is done on team Destroy().
/datum/antagonist/pillarmen/proc/update_pillar_icons_removed()
	var/datum/atom_hud/antag/pillarhud = GLOB.huds[pillarTeam.hud_entry_num]
	if(pillarhud)
		pillarhud.leave_hud(owner.current)
		set_antag_hud(owner.current, null)
