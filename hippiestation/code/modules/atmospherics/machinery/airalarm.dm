/obj/machinery/airalarm/plasma // ignores plasma good for plasman rooms.
    TLV = list(
        "pressure"                    = new/datum/tlv/no_checks,
        "temperature"                = new/datum/tlv/no_checks,
        /datum/gas/oxygen            = new/datum/tlv/no_checks,
        /datum/gas/nitrogen            = new/datum/tlv/no_checks,
        /datum/gas/carbon_dioxide    = new/datum/tlv/no_checks,
        /datum/gas/miasma            = new/datum/tlv/no_checks,
        /datum/gas/plasma            = new/datum/tlv(16, 19, 135, 140),
        /datum/gas/nitrous_oxide    = new/datum/tlv/no_checks,
        /datum/gas/bz                = new/datum/tlv/no_checks,
        /datum/gas/hypernoblium        = new/datum/tlv/no_checks,
        /datum/gas/water_vapor        = new/datum/tlv/no_checks,
        /datum/gas/tritium            = new/datum/tlv/no_checks,
        /datum/gas/stimulum            = new/datum/tlv/no_checks,
        /datum/gas/nitryl            = new/datum/tlv/no_checks,
        /datum/gas/pluoxium            = new/datum/tlv/no_checks
    )
