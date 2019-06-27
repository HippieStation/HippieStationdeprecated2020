/obj/item/clothing/glasses/thermal/meson
	name = "optical meson scanner"
	desc = "Used by engineering and mining staff to see basic structural and terrain layouts through walls, regardless of lighting conditions."
	icon_state = "meson"
	item_state = "meson"

/obj/item/clothing/glasses/thermal/meson/examine(mob/user) // newlines the examine
	. = ..()
	. += "Upon closer examination, the goggles appear to check for heat signatures, not the station."