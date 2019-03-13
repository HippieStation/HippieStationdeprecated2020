/mob/living/silicon/robot/update_icons()
    if(module.hippie_cyborg_base_icon)
        module.cyborg_base_icon = module.hippie_cyborg_base_icon
        icon = 'hippiestation/icons/mob/robots.dmi'
    return ..()