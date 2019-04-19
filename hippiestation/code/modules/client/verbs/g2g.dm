/mob/living/verb/g2g()
	set category = "IC"
	set name = "G2G"
	set desc = "Give your body up to ghosts."
	if(alert("Are you sure you want to give your body up to ghosts?", "Confirm", "Yes", "No") == "Yes")
		offer_control(src)
