#define HIPPIE_HOOK_SHUTTLE_AUTH if(LAZYLEN(last_action) && last_action[user] && last_action[user] + 15 >= world.time) return; LAZYSET(last_action, user, world.time)
