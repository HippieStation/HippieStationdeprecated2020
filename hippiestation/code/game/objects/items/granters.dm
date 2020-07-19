/obj/item/choice_beacon/crafting //no longer used
	name = "Nanotrasen Brand Crafting Book Summoning Device"
	desc = "The NBCBSD. Summon a crafting book of your choice with the simple press of a button! Fit for curators everywhere."

/obj/item/choice_beacon/crafting/generate_display_names()
	var/static/list/crafting_book_list
	if(!crafting_book_list)
		crafting_book_list = list()
		var/list/templist = typesof(/obj/item/book/granter/crafting_recipe/)
		for(var/V in templist)
			var/atom/A = V
			crafting_book_list[initial(A.name)] = A
	return crafting_book_list

//***********************
//*Crafting Recipe books*
//***********************

/obj/item/book/granter/crafting_recipe/
	name = "Anarchist's Compendium"
	desc = "A collection of different anarchist works from authors such as Ted Kaczynski, Peter Kropotkin, Mikhail Bakunin and James Mason? Wait, this isn't right, who compiled this? There's a page taped on in the middle detailing different pyrotechnics blueprints."
	var/crafting_recipe_types = list(
		/datum/crafting_recipe/learned/c4,
		/datum/crafting_recipe/learned/grenade,
		/datum/crafting_recipe/learned/holyhandgrenade,
		/datum/crafting_recipe/learned/warcrimegrenade,
		/datum/crafting_recipe/learned/empbomb
	)
	icon_state = "anarchist_cb"
	oneuse = FALSE
	remarks = list("..were a disaster for mankind? Explains a lot of what happens on here, actually.", "Where am I supposed to get holy water?", "Napalm's surprisingly easy to make.", "I can't actually read, I just realized", "Wait, why a republic if we're talking about anarchism?", "This pleases my ego.", "Now that I think about it, I'm not sure I ever saw a tree!", "Oh, so that wasn't real anarchism, but this will be? Sounds fishy...", "Wait a minute, I know Paris, ain't that the city from old Earth?")


/obj/item/book/granter/crafting_recipe/on_reading_finished(mob/user)
	. = ..()
	if(!user.mind)
		return
	for(var/crafting_recipe_type in crafting_recipe_types)
		var/datum/crafting_recipe/R = crafting_recipe_type
		user.mind.teach_crafting_recipe(crafting_recipe_type)
		to_chat(user,"<span class='notice'>You learned how to make [initial(R.name)].</span>")

/obj/item/book/granter/crafting_recipe/USSR3
	name = "USSR-3 Public Disturbance Manual"
	desc = "A subversive manual dispersed by the remnants of USSR-3, filled to the brim with ideological slogans and easy to use blueprints to arm the proletariat against the mega-corporations. Owning one of these is equal to a death penalty in most orbital stations"
	crafting_recipe_types = list(
		/datum/crafting_recipe/learned/ushanka,
		/datum/crafting_recipe/learned/moistnugget,
		/datum/crafting_recipe/learned/bodka,
		/datum/crafting_recipe/learned/russiansuit,
		/datum/crafting_recipe/learned/moistclip,
		/datum/crafting_recipe/learned/beans
	)
	icon_state = "USSR3"
	oneuse = FALSE
	remarks = list("What even IS ethical consumption...?", "Nuclear war equals revolutionary war? Sounds...interesting.", "Where would I even get real leather on a space station?", "If it worked in Stalingrad, it should work here too...", "Potatoes sure are versatile.", "So that's why they're so cheap...", "Who the hell is Deng?", "The War of the Sickle is what made Earth unlivable?")

/obj/item/book/granter/crafting_recipe/USSR3/on_reading_finished(mob/user)
	..()
	if(prob(1))
		to_chat(user, "Perhaps Lenin wasn't so bad, after all...")
		sleep(1)
		to_chat(user, "Wait a minute...")
		sleep(1)
		user.playsound_local(user, 'hippiestation/sound/effects/liberty.ogg', 50, FALSE)
		user.mind.make_Rev()
	else
		return

/obj/item/book/granter/crafting_recipe/origami1
	name = "Robert Lang's Origami Unveiled Vol. 1"
	desc = "The first book in a series that aims to thoroughly explain and teach origami to almost any individual who isn't braindead. Created by a genius from old Earth, it has been documented by Nanotrasen, who sometimes lends copies of the books to the crews of their space stations. "
	crafting_recipe_types = list(
		/datum/crafting_recipe/learned/paperhouse,
		/datum/crafting_recipe/learned/fakespellbook,
		/datum/crafting_recipe/learned/papersword,
		/datum/crafting_recipe/learned/paperstar,
		/datum/crafting_recipe/learned/papercuffs,
		/datum/crafting_recipe/learned/paperid
		)
	icon = 'hippiestation/icons/obj/library.dmi'
	icon_state = "origamiv1"
	oneuse = FALSE
	remarks = list("Orogami? Orgami? Oragami? Who spell-checked this book?","...and then what? Paper wizards?","Origami came from old Earth? Well I guess a lot of things did...","How did he get that from step 6?","...include paper cults? Am I reading the right book?","Inside reverse folds and outside reverse folds sure are complicated.","...Chinese culture...")

/obj/item/book/granter/crafting_recipe/obelisk
	name = "M'`nt a'd B,`'e"
	desc = "Obsession with madness or a maddening obsession?"
	crafting_recipe_types = list(
		/datum/crafting_recipe/tier1/obelisk,
		)
	icon_state = "book1"
	remarks = list("A wizard really wrote this? Huh.","... magic...","What are the magic words?","Hammerman...what?","The accursed knowledge, I can feel it flowing.","How did Nanotrasen get ahold of this book?","Where do I find a wendigo?","Magic is divided into...","Most powerful force in the universe...")
	oneuse = TRUE

/obj/item/book/granter/crafting_recipe/obelisk/on_reading_finished(mob/user)
	..()
	to_chat(user, "<span class ='warning'>[src] vanishes into thin air.")
	qdel(src)


/obj/item/book/granter/crafting_recipe/trapping
	name = "Exoplanet Exploration Vol. 13: Trapping"
	desc = "An extensive manual for exoplanet explorers that delves into various trap improvisations."
	crafting_recipe_types = list(
		/datum/crafting_recipe/learned/beartrap,
		/datum/crafting_recipe/mousetrap,
		/datum/crafting_recipe/learned/dummymine,
		/datum/crafting_recipe/learned/explosivemine,
		/datum/crafting_recipe/learned/plasmamine,
		/datum/crafting_recipe/learned/honkmine,
		/datum/crafting_recipe/learned/bwoinkmine,
	)
	icon_state = "trappers"
	remarks = list("I never knew that thrumbos could get drunk!","I don't think plasma is very effective on Lavaland creatures...","Why don't we have traps for space carps?","Humans have hunted 310 species to extinction... wow.","Nuclear landmines aren't that bad of an idea!","...so hunting IS still necessary!","According to this law passed in 1918, it is still illegal to hunt swans.","Santa got caught in the box-and-bait trap at Fort Knox?")
	oneuse = FALSE

/obj/item/book/granter/crafting_recipe/clowninstruments
	name = "The Sound of Clown"
	desc = "This book somehow understands and explains the musical culture of the clowns. The original copy was discovered by a Nanotrasen deep-space probe on board a clown shuttle that had crashed into an asteroid. This work of literature is now revered in clown society."
	crafting_recipe_types = list(
		/datum/crafting_recipe/learned/musicalbikehorn,
		/datum/crafting_recipe/learned/toysaxophone,
		/datum/crafting_recipe/learned/toyguitar,
		/datum/crafting_recipe/learned/vuvuzela,
	)
	icon_state = "c_minor_manual"
	remarks = list("HONK!","Where is Clown Planet anyway?","Why do I hear laughter?","So many honks...","Haha!","Clowns are exposed to HONKING at a very young age.","This book is written in crayon!","There is a rotten banana peel stuck on the page...","Since when can clowns do that?")
	oneuse = FALSE

/obj/item/book/granter/crafting_recipe/workenvironment
	name = "UAW Environment"
	desc = "Back when worker unions were still around, aesthetically pleasing working environments were demanded by workers abroad. This novel goes into detail about the pyschological well-being that those exposed to an aesthetically pleasing working environment will endure."
	crafting_recipe_types = list(
		/datum/crafting_recipe/learned/poster,
		/datum/crafting_recipe/learned/pottedplant,
		/datum/crafting_recipe/learned/statuebust,
		)
	icon_state = "workplace"
	remarks = list("Janitors were reprimanded for not cleaning?","I've never seen a floor mat before.","UAW seems to have loved their workers a little too much...","You had to pay to be in a worker union? Who made up that balarky?","So the Great Scandal of 2358 is how unions got phased out...","Is Nanotrasen totalitarian? Kind of hard to tell given how great it is.","It seems unions rose to popularity during the industrial revolution.","I feel old reading this.")
	oneuse = FALSE

/obj/item/book/granter/crafting_recipe/stargazing
	name = "Squod Word's Astrological Journal"
	desc = "Stargazing is a not-so-simple art. First you must understand the various stars and their meanings."
	crafting_recipe_types = list(
		/datum/crafting_recipe/learned/binoculars,
		/datum/crafting_recipe/learned/superbinoculars,
		)
	icon_state = "stargazing"
	remarks = list("How do you find the North Star in space?","My zodiac sign is... Cancer.","Is astrology even relevant anymore?","...the Draco star, 'tail of the dolphin'.","The Orion star! From Orion Trail.")
	oneuse = FALSE
	var/list/users = list()

/obj/item/book/granter/crafting_recipe/stargazing/on_reading_finished(mob/user)
	..()
	//for(var/i = 0; i < users.length; i++)
	//	if(user == users(i))
	//		return

	if(prob(5))
		to_chat(user, "Wow, star gazing is actually really interesting...")
		sleep(1)
		to_chat(user, "Wait a minute...")
		sleep(1)
		user.playsound_local(user, 'sound/ambience/seag1.ogg', 50, FALSE)
		user.set_species(/datum/species/jelly/stargazer)
	else
		return

	users.Add(user)

/obj/item/book/granter/crafting_recipe/audio
	name = "Grabar: A Slow Mindkill"
	desc = "Paris is where it all began."
	crafting_recipe_types = list(
		/datum/crafting_recipe/learned/taperecorder,
		/datum/crafting_recipe/learned/recordtape,
		)
	icon_state = "a_slow_mindkill"
	remarks = list("Yeah I know sound waves can't travel through a vacuum.","The top of a wave is called a crest and the bottom is called the trough.","zzzzzzzz...","Says here that the first sound recording device was invented in Paris on old Earth.","Louder = higher wave yada yada yada...","Why isn't Graham spelled Gram?","Who leaves cassette tapes in a forest?")
	oneuse = FALSE

/obj/item/book/granter/crafting_recipe/gang
	name = "Straight Outa' Compton"
	desc = "YOU wanna form a gang? YOU wanna become as legendary as the Italian Mafia, Crips, Bloods, and the Irish mob? Follow these simple instructions to lead a path of prosperity and crookedness and make your own gang today."
	crafting_recipe_types = list(
		/datum/crafting_recipe/learned/blingshoes,
		/datum/crafting_recipe/learned/switchblade,
		/datum/crafting_recipe/learned/spraycan,
		/datum/crafting_recipe/learned/contrabandposter,
		/datum/crafting_recipe/learned/implantbreaker,
		/datum/crafting_recipe/learned/redjumpsuit,
		/datum/crafting_recipe/learned/bluejumpsuit,
		/datum/crafting_recipe/learned/godfathersuit,
		/datum/crafting_recipe/learned/mafiososuit,
		)
	icon_state = "gang"
	remarks = list("How do I hold my gun sideways if dynamic hand controls aren't a thing?","Turns out the Italian Mafia hated 'The Godfather'...","What if security restricts access to chemistry?","Step 27: Raid the vault...","People actually thought of Al Capone as a 'modern day' robinhood? Wow.","Step 30: Assassinate the captain.","Step 14: Gain all access.","Step 50: Remove Central Command as the leading power of Nanotrasen.", "How am I prospering if I'm living in constant fear?")
	oneuse = FALSE

/obj/item/book/granter/crafting_recipe/vampire
	name = "The Mark of Cain"
	desc = "This book, a relic of the past, thoroughly explains the mythological creature know as a 'vampire'."
	crafting_recipe_types = list(
		/datum/crafting_recipe/learned/witchhunterhat,
		/datum/crafting_recipe/learned/woodenstake,
		)
	icon_state = "vampire"
	remarks = list("Now I will know why I fear the night... in space.","The Syndicate employs vampires? Figures.","Vampire clowns are a scary thought.","If vampires grow stronger with more blood they have and we have technology to synthesize unlimited amounts of blood then why haven't vampires become dominant?","I wonder how the Blood Cult and vampires would get along.", "Vlad The Impaler?", "Vampires are totally invisible to cameras and mirrors...")
	oneuse = FALSE

/obj/item/book/granter/crafting_recipe/illegalweapons
	name = "CODEWORD Arabian"
	desc = "A biography about a Syndicate weapons manufacturer by the name of Adnan Khashoggi, who is of Arabian heritage. His weapons are known to be extra illegal in Nanotrasen space."
	crafting_recipe_types = list(
		/datum/crafting_recipe/learned/ballisticcrossbow,
		/datum/crafting_recipe/learned/hookspear,
		/datum/crafting_recipe/learned/edagger,
		)
	icon_state = "illegalweapons"
	remarks = list("Adnan Khashoggi eh? What a mouthful.","So he makes weapons from thousands of years ago and weapons with modern day technology?","I wish I could go to Victoria College and get off this dump of a station.","...weapons deals with Nanotrasen at one point?","This guy knows how to grow a good stache!","I wonder what it's like being in the one percent...","There was a plot by the Space Wizard Federation to assassinate him? Typical.")
	oneuse = FALSE
	var/chance = TRUE

/obj/item/book/granter/crafting_recipe/illegalweapons/on_reading_finished(mob/user)
	..()
	if(chance)
		chance = FALSE
		if(prob(50))
			new /obj/item/gun/ballistic/automatic/pistol/g17/improvised(get_turf(src))
			to_chat(user, "<span class ='warning'>An improvised glock 17 that was hidden between the pages of [name] has fallen out!")

/obj/item/book/granter/crafting_recipe/obelisk/obelisktier1 //Make sure these books stay consistent with the curator magic recipes that
	name = "'p^ce"                                  //can be found in crafting.dm starting on line 422.
	desc = "Others may learn the knowledge."
	crafting_recipe_types = list(
		/datum/crafting_recipe/tier1/obelisk,
		/datum/crafting_recipe/tier1/upgradescroll,
		/datum/crafting_recipe/tier1/sord,
		/datum/crafting_recipe/tier1/magicsoap,
		/datum/crafting_recipe/tier1/immortalitytalisman,
		/datum/crafting_recipe/tier1/d100,
		/datum/crafting_recipe/tier1/doorwand,
		/datum/crafting_recipe/tier1/lazarusinjector
		)
	icon_state = "tier1"
	remarks = list("This magic book is very interesting.","I can feel the knowledge flowing.")
	layer = ABOVE_OBJ_LAYER + 0.1 //so it is above the obelisks and not below them

/obj/item/book/granter/crafting_recipe/obelisk/obelisktier1/on_reading_finished(mob/living/user)
	..()
	user.Paralyze(20)
	user.adjustBrainLoss(20)
	to_chat(user, "<span class='userdanger'>Knowledge flows into your brain! It hurts!")

/obj/item/book/granter/crafting_recipe/obelisk/obelisktier2
	name = "W^'ar-"
	desc = "Others may learn the knowledge."
	crafting_recipe_types = list(
		/datum/crafting_recipe/tier2/obelisk,
		/datum/crafting_recipe/tier2/telecrystal,
		/datum/crafting_recipe/tier2/shittyrevivewand,
		/datum/crafting_recipe/tier2/shittysafetywand,
		/datum/crafting_recipe/tier2/monstercube,
		/datum/crafting_recipe/tier2/soulshard,
		/datum/crafting_recipe/tier2/spectralblade,
		/datum/crafting_recipe/tier2/lighteater
		)
	icon_state = "tier2"
	remarks = list("Reading this is probably illegal...","The symbols on the pages are moving.")
	layer = ABOVE_OBJ_LAYER + 0.1 //so it is above the obelisks and not below them

/obj/item/book/granter/crafting_recipe/obelisk/obelisktier2/on_reading_finished(mob/living/user)
	..()
	user.Paralyze(50)
	user.adjustBrainLoss(35)
	to_chat(user, "<span class='userdanger'>Knowledge flows into your brain! Your head is pounding!")

/obj/item/book/granter/crafting_recipe/obelisk/obelisktier3
	name = "`e`er,t'~n"
	desc = "Others may learn the knowledge."
	crafting_recipe_types = list(
		/datum/crafting_recipe/tier3/obelisk,
		/datum/crafting_recipe/tier3/nullrod,
		/datum/crafting_recipe/tier3/oneusedieoffate,
		/datum/crafting_recipe/tier3/portalgun,
		/datum/crafting_recipe/tier3/gravitygun
		)
	icon_state = "tier3"
	remarks = list("Powerful knowledge is at hand.","I can feel the energy emanating from the book.")
	layer = ABOVE_OBJ_LAYER + 0.1 //so it is above the obelisks and not below them

/obj/item/book/granter/crafting_recipe/obelisk/obelisktier3/on_reading_finished(mob/living/user)
	..()
	user.Paralyze(80)
	user.adjustBrainLoss(50)
	to_chat(user, "<span class='userdanger'>Knowledge flows into your brain! Your brain feels like it is melting!")