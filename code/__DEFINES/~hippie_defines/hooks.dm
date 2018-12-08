#define HIPPIE_HOOK_SHUTTLE_AUTH if(LAZYLEN(last_action) && last_action[user] && last_action[user] + 15 >= world.time) return; LAZYSET(last_action, user, world.time)

#define HIPPIE_HOOK_FATASS if(head.brute_dam < 100 && H.has_trait(TRAIT_FAT) && prob(50)) { H.emote("scream"); H.apply_damage(15 * blade_sharpness, BRUTE, head); log_combat(user, H, "dropped the blade on", src, " non-fatally"); visible_message("<span class='warning'>[src] fails to chop [H]'s fat neck off!</span>"); blade_sharpness--; return }
