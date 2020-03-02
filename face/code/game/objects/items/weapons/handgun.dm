// A literal nerf. What did you expect?
// Cannabailzing the balisong code here, it's a hacky way to do it but it'll do
/obj/item/melee/face/nerf
	name = "Broken Toy Revolver"
	desc = " A old toy gun. Pretty useless, and the spring has broken many years ago. Still, It probably would scare someone if you used harm intent to their back!"
	flags_1 = CONDUCT_1
	force = 0
	icon = 'face/icons/obj/items_and_weapons.dmi'
	icon_state = "nerfpistol"
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi'
	throwforce = 0
	attack_verb = list("points", "slapped", "prodded", "poked")
	w_class = WEIGHT_CLASS_SMALL
	sharpness = IS_BLUNT


/obj/item/melee/face/nerf/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(check_target_facings(user, M) == FACING_SAME_DIR && user.a_intent != INTENT_HELP && ishuman(M))
		var/mob/living/carbon/human/U = M
		return backstab(U,user)

	if(user.zone_selected == "eyes" )
		if(HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50))
			M = user
		return eyestab(M,user)
	else
		return ..()
// leaving this in as a workaround, should be enabled by default

/obj/item/melee/face/nerf/proc/backstab(mob/living/carbon/human/U, mob/living/carbon/user, damage)
	var/obj/item/bodypart/affecting = U.get_bodypart("chest")

	if(!affecting || U == user || U.stat == DEAD) //no chest???!!!!
		return

	U.visible_message("<span class='danger'>[user] has pointed some sort of gun at [U] 's back, and they panic!</span>", \
						"<span class='userdanger'>[user] points something to your back!</span>")

	src.add_fingerprint(user)
	playsound(src,pick('face/sound/weapons/handgun1.ogg', 'face/sound/weapons/handgun2.ogg', 'face/sound/weapons/handgun3.ogg', 'face/sound/weapons/handgun4.ogg', 'face/sound/weapons/handgun5.ogg', 'face/sound/weapons/handgun6.ogg', 'face/sound/weapons/handgun7.ogg', 'face/sound/weapons/handgun8.ogg'), 40, 1, -1)
	user.do_attack_animation(U)
	U.say("*surrender", forced = "handgun")

	log_combat(user, U, "nerfned", "[src.name]", "(INTENT: [uppertext(user.a_intent)])")
