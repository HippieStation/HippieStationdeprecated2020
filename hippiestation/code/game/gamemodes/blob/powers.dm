/mob/camera/blob/verb/toggle_cuddles()
	set category = "Blob"
	set name = "Toggle Cuddle Sense"
	set desc = "Toggle your ability to sense cuddles."
	acceptLove = !acceptLove
	if(acceptLove)
		to_chat(src, "<span class='warning'>You can now sense loving cuddles.</span>")
	else
		to_chat(src, "<span class='warning'>You can no longer sense loving cuddles.</span>")
	
