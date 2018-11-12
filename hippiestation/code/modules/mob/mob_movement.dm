#define MAX_SW_LUMS 0.2
#define ALLOW_PULL_THROUGH_WALLS 0

/mob/living/carbon/Move(atom/newloc, direct)
	. = ..(newloc, direct)
	if(lying && !pulledby && !buckled && (stat == SOFT_CRIT || get_num_legs() == 0) && !inertia_moving)
		if(stat == SOFT_CRIT)
			visible_message("<span class='danger'>[src] painfully crawls forward!</span>", "<span class='userdanger'>You crawl forward at the expense of some of your strength.</span>")
			apply_damage(1, OXY)
		playsound(src, pick('hippiestation/sound/effects/bodyscrape-01.ogg', 'hippiestation/sound/effects/bodyscrape-02.ogg'), 20, 1, -4)
