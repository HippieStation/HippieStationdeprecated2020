/*
	There's some Hippie-related vars here that help us unobtrusively manage the products/contraband/premium

	hippie_products contains the normal items available
	hippie_contraband contains the items you need to hack to acquire
	hippie_premium contains the items which require a coin to acquire

	Add items to these lists if you want them to appear in their respective lists
	You can also take away items by using a negative value. If the sum of products + hippie_products
	is less than 0 then the item is taken out altogether (so use -100 to completely remove an item)
*/

/obj/machinery/vending
	icon_hippie = 'hippiestation/icons/obj/vending.dmi'
	light_color = LIGHT_COLOR_WHITE
	var/brightness_on = 4
	var/hippie_products = list()
	var/hippie_contraband = list()
	var/hippie_premium = list()

/obj/machinery/vending/Initialize()
	// Add our items to the list
	// If the item is already a product then add items to it
	if (LAZYLEN(products) && LAZYLEN(hippie_products))
		for (var/i in hippie_products)
			if (products[i])
				if (products[i] + hippie_products[i] <= 0)
					LAZYREMOVE(products, i)
				else
					products[i] = products[i] + hippie_products[i]
			else
				products[i] = hippie_products[i]

	if (LAZYLEN(contraband) && LAZYLEN(hippie_contraband))
		for (var/i in hippie_contraband)
			if (contraband[i])
				if (contraband[i] + hippie_contraband[i] <= 0)
					LAZYREMOVE(contraband, i)
				else
					contraband[i] = contraband[i] + hippie_contraband[i]
			else
				contraband[i] = hippie_contraband[i]

	if (LAZYLEN(premium) && LAZYLEN(hippie_premium))
		for (var/i in hippie_premium)
			if (premium[i])
				if (premium[i] + hippie_premium[i] <= 0)
					LAZYREMOVE(premium, i)
				else
					premium[i] = premium[i] + hippie_premium[i]
			else
				premium[i] = hippie_premium[i]

	return ..()

/obj/machinery/vending/power_change()
	..()
	if(stat & NOPOWER)
		set_light(0)
	else
		set_light(MINIMUM_USEFUL_LIGHT_RANGE, brightness_on)
	update_icon()
	return


/obj/machinery/vending/obj_break(damage_flag)
	..()
	if(!(stat & BROKEN) && !(flags_1 & NODECONSTRUCT_1))
		set_light(0)

/obj/machinery/vending/ui_base_html(html)
	var/datum/asset/spritesheet/assets = get_asset_datum(/datum/asset/spritesheet/vending)
	. = replacetext(html, "<!--customheadhtml-->", assets.css_tag())

/obj/machinery/vending/ui_interact(mob/user, ui_key, datum/tgui/ui = null, force_open, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.always_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "vending", "[name]", 450, 600, master_ui, state)
		ui.set_autoupdate(TRUE)
		ui.open()

/obj/machinery/vending/ui_static_data(mob/user)
	. = list()
	.["onstation"] = onstation
	.["department"] = payment_department
	.["product_records"] = list()
	for (var/datum/data/vending_product/R in product_records)
		var/list/data = list(
			path = replacetext(replacetext("[R.product_path]", "/obj/item/", ""), "/", "-"),
			name = R.name,
			price = R.custom_price || default_price,
			max_amount = R.max_amount,
			ref = REF(R)
		)
		.["product_records"] += list(data)
	.["coin_records"] = list()
	for (var/datum/data/vending_product/R in coin_records)
		var/list/data = list(
			path = replacetext(replacetext("[R.product_path]", "/obj/item/", ""), "/", "-"),
			name = R.name,
			price = R.custom_premium_price || extra_price,
			max_amount = R.max_amount,
			ref = REF(R)
		)
		.["coin_records"] += list(data)
	for (var/datum/data/vending_product/R in hidden_records)
		var/list/data = list(
			path = replacetext(replacetext("[R.product_path]", "/obj/item/", ""), "/", "-"),
			name = R.name,
			price = R.custom_price || default_price,
			max_amount = R.max_amount,
			ref = REF(R),
			extended = TRUE
		)
		.["hidden_records"] += list(data)

/obj/machinery/vending/ui_data(mob/user)
	. = list()
	var/mob/living/carbon/human/H
	var/obj/item/card/id/C
	if(ishuman(user))
		H = user
		C = H.get_idcard(TRUE)
		if(C?.registered_account)
			.["user"] = list()
			.["user"]["name"] = C.registered_account.account_holder
			.["user"]["cash"] = C.registered_account.account_balance
			.["user"]["job"] = C.registered_account.account_job.title
			.["user"]["department"] = C.registered_account.account_job.paycheck_department
	.["stock"] = list()
	for (var/datum/data/vending_product/R in product_records + coin_records + hidden_records)
		.["stock"][R.name] = R.amount
	.["extended_inventory"] = extended_inventory

/obj/machinery/vending/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("vend")
			. = TRUE
			if(!vend_ready)
				return
			if(panel_open)
				to_chat(usr, "<span class='warning'>The vending machine cannot dispense products while its service panel is open!</span>")
				return
			vend_ready = FALSE //One thing at a time!!
			var/datum/data/vending_product/R = locate(params["ref"])
			var/list/record_to_check = product_records + coin_records
			if(extended_inventory)
				record_to_check = product_records + coin_records + hidden_records
			if(!R || !istype(R) || !R.product_path)
				vend_ready = TRUE
				return
			var/price_to_use = default_price
			if(R.custom_price)
				price_to_use = R.custom_price
			if(R in hidden_records)
				if(!extended_inventory)
					vend_ready = TRUE
					return
			else if (!(R in record_to_check))
				vend_ready = TRUE
				message_admins("Vending machine exploit attempted by [ADMIN_LOOKUPFLW(usr)]!")
				return
			if (R.amount <= 0)
				say("Sold out of [R.name].")
				flick(icon_deny,src)
				vend_ready = TRUE
				return
			if(onstation && ishuman(usr))
				var/mob/living/carbon/human/H = usr
				var/obj/item/card/id/C = H.get_idcard(TRUE)

				if(!C)
					say("No card found.")
					flick(icon_deny,src)
					vend_ready = TRUE
					return
				else if (!C.registered_account)
					say("No account found.")
					flick(icon_deny,src)
					vend_ready = TRUE
					return
				var/datum/bank_account/account = C.registered_account
				if(account.account_job && account.account_job.paycheck_department == payment_department)
					price_to_use = 0
				if(coin_records.Find(R) || hidden_records.Find(R))
					price_to_use = R.custom_premium_price ? R.custom_premium_price : extra_price
				if(price_to_use && !account.adjust_money(-price_to_use))
					say("You do not possess the funds to purchase [R.name].")
					flick(icon_deny,src)
					vend_ready = TRUE
					return
				var/datum/bank_account/D = SSeconomy.get_dep_account(payment_department)
				if(D)
					D.adjust_money(price_to_use)
			if(last_shopper != usr || purchase_message_cooldown < world.time)
				say("Thank you for shopping with [src]!")
				purchase_message_cooldown = world.time + 5 SECONDS
				last_shopper = usr
			use_power(5)
			if(icon_vend) //Show the vending animation if needed
				flick(icon_vend,src)
			new R.product_path(get_turf(src))
			R.amount--
			SSblackbox.record_feedback("nested tally", "vending_machine_usage", 1, list("[type]", "[R.product_path]"))
			vend_ready = TRUE

/obj/machinery/vending/custom
	var/list/base64_cache = list()

/obj/machinery/vending/custom/ui_static_data(mob/user)
	return

/obj/machinery/vending/custom/ui_data(mob/user)
	. = ..()
	.["access"] = compartmentLoadAccessCheck(user)
	.["vending_machine_input"] = list()
	for (var/O in vending_machine_input)
		if(vending_machine_input[O] > 0)
			var/base64
			var/price = 0
			for(var/obj/T in contents)
				if(T.name == O)
					price = T.custom_price
					if(!base64)
						if(base64_cache[T.type])
							base64 = base64_cache[T.type]
						else
							base64 = icon2base64(icon(T.icon, T.icon_state))
							base64_cache[T.type] = base64
					break
			var/list/data = list(
				name = O,
				price = price,
				img = base64
			)
			.["vending_machine_input"] += list(data)

/obj/machinery/vending/custom/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("dispense")
			. = TRUE
			if(!vend_ready)
				return
			var/N = params["item"]
			var/obj/S
			vend_ready = FALSE
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				var/obj/item/card/id/C = H.get_idcard(TRUE)

				if(!C)
					say("No card found.")
					flick(icon_deny,src)
					vend_ready = TRUE
					return
				else if (!C.registered_account)
					say("No account found.")
					flick(icon_deny,src)
					vend_ready = TRUE
					return
				var/datum/bank_account/account = C.registered_account
				for(var/obj/O in contents)
					if(O.name == N)
						S = O
						break
				if(S)
					if(compartmentLoadAccessCheck(usr))
						vending_machine_input[N] = max(vending_machine_input[N] - 1, 0)
						S.forceMove(drop_location())
						loaded_items--
						use_power(5)
						vend_ready = TRUE
						updateUsrDialog()
						return
					if(account.has_money(S.custom_price))
						account.adjust_money(-S.custom_price)
						var/datum/bank_account/owner = private_a
						if(owner)
							owner.adjust_money(S.custom_price)
						vending_machine_input[N] = max(vending_machine_input[N] - 1, 0)
						S.forceMove(drop_location())
						loaded_items--
						use_power(5)
						if(last_shopper != usr || purchase_message_cooldown < world.time)
							say("Thank you for buying local and purchasing [S]!")
							purchase_message_cooldown = world.time + 5 SECONDS
							last_shopper = usr
						vend_ready = TRUE
						updateUsrDialog()
						return
					else
						say("You do not possess the funds to purchase this.")
			vend_ready = TRUE
