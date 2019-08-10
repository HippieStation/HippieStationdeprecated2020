// This file only changes a sound on announcements.

#define COMMUNICATION_COOLDOWN 300
#define COMMUNICATION_COOLDOWN_AI 300

/datum/controller/subsystem/communications/make_announcement(mob/living/user, is_silicon, input)
	if(!can_announce(user, is_silicon))
		return FALSE
	if(is_silicon)
		minor_announce(html_decode(input),"[user.name] Announces:")
		silicon_message_cooldown = world.time + COMMUNICATION_COOLDOWN_AI
	else
		priority_announce(html_decode(user.treat_message(input)), null, 'hippiestation/sound/misc/announce.ogg', "Captain")
		nonsilicon_message_cooldown = world.time + COMMUNICATION_COOLDOWN
	user.log_talk(input, LOG_SAY, tag="priority announcement")
	message_admins("[ADMIN_LOOKUPFLW(user)] has made a priority announcement.")

#undef COMMUNICATION_COOLDOWN
#undef COMMUNICATION_COOLDOWN_AI