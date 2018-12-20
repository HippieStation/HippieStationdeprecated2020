// These pins only contain the path of an atom. Helps for future type locators.
/datum/integrated_io/pathtype
	name = "path type pin"

/datum/integrated_io/pathtype/ask_for_pin_data(mob/user) // This clears the pin.
	write_data_to_pin(null)

/datum/integrated_io/pathtype/write_data_to_pin(var/new_data)
	if(isnull(new_data) || ispath(new_data))
		data = new_data
		holder.on_data_written()

/datum/integrated_io/pathtype/display_pin_type()
	return IC_FORMAT_PATHTYPE
