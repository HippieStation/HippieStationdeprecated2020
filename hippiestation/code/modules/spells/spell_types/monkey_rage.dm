/obj/effect/proc_holder/spell/targeted/monkey_rage_spell/
    name = "Monkey Rage"
    desc = "This spell causes you to become incredibly powerful for a short time. Once the spell ends, it'll wreak havoc on your body."
    school = "transmutation"
    charge_max = 600
    clothes_req = 0
    invocation = "KAY-OH KIN" // again, normally you shouldn't see this text.
    invocation_type = "shout"
    range = -1
    include_user = 1
    action_icon_state = "mutate"
    sound = 'sound/magic/mutate.ogg'

/obj/effect/proc_holder/spell/targeted/monkey_rage_spell/cast(list/targets,mob/living/user = usr)
    user.apply_status_effect(STATUS_EFFECT_MONKEY_RAGE)