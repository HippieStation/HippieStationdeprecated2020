/datum/brain_trauma/special/imaginary_friend/on_gain()
	..()
	make_friend()

/datum/brain_trauma/special/imaginary_friend/on_life()
	if(friend_initialized)
		if(get_dist(owner, friend) > 9)
			friend.yank()
	if(friend)
		if(!friend.client && friend_initialized)
			friend_initialized = FALSE
			addtimer(CALLBACK(src, .proc/reroll_friend), 600)
	if(!owner.client)
		qdel(src)


//If the friend goes afk, make a brand new friend. Plenty of fish in the sea of imagination.
/datum/brain_trauma/special/imaginary_friend/reroll_friend()
	if(friend)
		if(friend.client) //reconnected
			friend_initialized = TRUE
			return
		else
			friend_initialized = FALSE
			QDEL_NULL(friend)
			make_friend()
			get_ghost()

/datum/brain_trauma/special/imaginary_friend/make_friend()
	friend = new(get_turf(owner), src)

/datum/brain_trauma/special/imaginary_friend/get_ghost()
	set waitfor = FALSE
	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you want to play as [owner]'s imaginary friend?", ROLE_PAI, null, null, 75, friend)
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		friend.key = C.key
		friend_initialized = TRUE
	else
		addtimer(CALLBACK(src, .proc/reroll_friend), 1200)

/mob/camera/imaginary_friend
	mouse_opacity = MOUSE_OPACITY_OPAQUE

/mob/camera/imaginary_friend/Initialize(mapload, _trauma)
	. = ..()
	var/gender = pick(MALE, FEMALE)
	real_name = random_unique_name(gender)
	name = real_name
	trauma = _trauma
	owner = trauma.owner
	human_image = get_flat_human_icon(null, pick(SSjob.occupations))

/mob/camera/imaginary_friend/Show()
	if(!client) //nobody home
		return

	//Remove old image from owner and friend
	if(owner.client)
		owner.client.images.Remove(current_image)

	client.images.Remove(current_image)

	//Generate image from the static icon and the current dir
	current_image = image(human_image, src, , MOB_LAYER, dir=src.dir)
	current_image.override = TRUE
	current_image.name = name

	//Add new image to owner and friend

	owner.client.images += current_image

	client.images += current_image

/mob/camera/imaginary_friend/Move(mob/user, newloc, dir)
	if(user)
		Show()
		if(get_dist(user, owner) > 9)
			yank()
			return
	..()

/mob/camera/imaginary_friend/forceMove(atom/destination)
	dir = get_dir(get_turf(src), destination)
	loc = destination
	if(get_dist(src, owner) > 9)
		yank()
		return

/mob/camera/imaginary_friend/yank()
	if(!client) //don't bother if the friend is braindead
		return
	forceMove(get_turf(owner))

/mob/camera/imaginary_friend/movement_delay()
	return -6