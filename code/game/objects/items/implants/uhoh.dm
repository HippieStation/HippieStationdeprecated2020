/obj/item/implant/uhoh
	name = "Stinky implant"
	activated = 0

/obj/item/implant/uhoh/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b>Very stinky. Illegal on most stations.<BR>
				<b>Life:</b> Activates upon death.<BR>
				"}
	return dat

/obj/item/implant/uhoh/trigger(emote, mob/source)
	if(emote == "deathgasp")
		playsound(loc, 'face/sound/screams/uhoh.ogg', 50, 0)

/obj/item/implanter/uhoh
	name = "implanter (Stinky)"
	imp_type = /obj/item/implant/uhoh

/obj/item/implantcase/uhoh
	name = "implant case - 'Stinky'"
	desc = "A glass case containing a very stinky implant."
	imp_type = /obj/item/implant/uhoh
