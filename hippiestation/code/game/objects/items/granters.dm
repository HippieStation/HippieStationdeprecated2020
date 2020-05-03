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

/obj/item/book/granter/crafting_recipe/anarch
	name = "Anarchist's Compendium"
	desc = "A collection of different anarchist works from authors such as Ted Kaczynski, Peter Kropotkin, Mikhail Bakunin and James Mason? Wait, this isn't right, who compiled this? There's a page taped on in the middle detailing different pyrotechnics blueprints."
	crafting_recipe_types = list(
		/datum/crafting_recipe/learned/c4,
		/datum/crafting_recipe/learned/grenade,
		/datum/crafting_recipe/learned/holyhandgrenade,
		/datum/crafting_recipe/learned/warcrimegrenade,
		/datum/crafting_recipe/learned/empbomb
	)
	icon_state = "anarchist_cb"
	oneuse = FALSE
	remarks = list("..were a disaster for mankind? Explains a lot of what happens on here, actually.", "Where am I supposed to get holy water?", "Napalm's surprisingly easy to make.", "I can't actually read, I just realized", "Wait, why a republic if we're talking about anarchism?", "This pleases my ego.", "Now that I think about it, I'm not sure I ever saw a tree!", "Oh, so that wasn't real anarchism, but this will be? Sounds fishy...", "Wait a minute, I know Paris, ain't that the city from old Earth?")

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
	remarks = list("Orogami? Orgami? Oragami? Who spellchecked this book?","...and then what? Paper wizards?","Origami came from old Earth? Well I guess a lot of things did...","How did he get that from step 6?","...include paper cults? Am I reading the right book?","Inside reverse folds and outside reverse folds sure are complicated.","...Chinese culture...")

/obj/item/choice_beacon/crafting
	name = "Nanotrasen Brand Crafting Book Summoning Device"
	desc = "The NBCBSD. Summon a crafting book of your choice with the simple press of a button! Fit for curators everywhere."

/obj/item/choice_beacon/crafting/generate_display_names()
	var/static/list/crafting_book_list
	if(!crafting_book_list)
		crafting_book_list = list()
		var/list/templist = typesof(/obj/item/book/granter/crafting_recipe) //we have to convert type = name to name = type, how lovely!
		for(var/V in templist)
			var/atom/A = V
			crafting_book_list[initial(A.name)] = A
	return crafting_book_list
