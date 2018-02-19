/obj/item/clothing/gloves/color/hacker
	desc = "Original H4CK3RM4N gloves, straight from the cereal box. Should not be exposed to humidity, radiation or people under 12 years."
	name = "hacker gloves"
	icon_state = "hacker"
	item_state = "hackergloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	item_color="yellow"
	resistance_flags = NONE

/datum/wires/ui_act(action, params) //enormous thanks to Carbonhell for helping enormously with this

        if("pulse")

                var/mob/living/user = usr

                if(istype(user.slot_gloves, /obj/item/clothing/gloves/color/hacker))

                    I.play_tool_sound(src, 20)

                pulse_color(target_wire, L)

                . = TRUE

        if(..())

            . = TRUE//So we dont end up pulsing twice if we have both gloves and multitool.