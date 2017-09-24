/obj/item/implant/krav_magooba
	name = "krav magooba implant"
	desc = "Teaches you the arts of Krav Magooba in 5 short instructional videos beamed directly into your eyeballs."
	icon = 'icons/obj/wizard.dmi'
	icon_state ="scroll2"
	activated = 1
	origin_tech = "materials=2;biotech=4;combat=5;syndicate=4"
	var/datum/martial_art/krav_magooba/style = new

/obj/item/implant/krav_magooba/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Krav Magooba Implant<BR>
				<b>Life:</b> 4 hours after death of host<BR>
				<b>Implant Details:</b> <BR>
				<b>Function:</b> Teaches even the clumsiest host the arts of Krav Magooba."}
	return dat

/obj/item/implant/krav_magooba/activate()
	var/mob/living/carbon/human/H = imp_in
	if(!ishuman(H))
		return
	if(!H.mind)
		return
	if(istype(H.mind.martial_art, /datum/martial_art/krav_magooba))
		style.remove(H)
	else
		style.teach(H,1)

/obj/item/implanter/krav_magooba
	name = "implanter (krav magooba)"
	imp_type = /obj/item/implant/krav_magooba

/obj/item/implantcase/krav_magooba
	name = "implant case - 'Krav Magooba'"
	desc = "A glass case containing an implant that can teach the user the arts of Krav Magooba."
	imp_type = /obj/item/implant/krav_magooba

