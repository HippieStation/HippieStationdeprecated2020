GLOBAL_LIST_INIT(lootrocksks, list(
	/obj/item/paper/crumpled = 6,
	/obj/item/stack/telecrystal = 1,
	/obj/item/gun/ballistic/rifle/boltaction = 2,
	/obj/item/pen/edagger = 3,
	/obj/item/ammo_box/a762 = 2,
	/obj/item/flashlight/emp = 1,
	/obj/item/reagent_containers/syringe/mulligan = 1,
	/obj/item/storage/backpack/satchel/flat/with_tools = 2,
	/obj/item/clothing/suit/space/syndicate/black/red = 2,
	/obj/item/clothing/head/helmet/space/syndicate/black/red = 2,
	/obj/item/cardboard_cutout/adaptive = 3,
	/obj/item/disk/nuclear/fake = 1,
	/obj/item/soap/syndie = 4,
	/obj/item/clothing/under/color/grey/glorf = 2,
	/obj/item/storage/fancy/cigarettes/cigpack_syndicate = 3,
	/obj/item/storage/secure/briefcase/syndie = 1,
	/obj/item/crowbar/red = 4,
	/obj/item/storage/box/donkpockets = 3,
	/obj/item/brick = 4,
	/obj/item/clothing/glasses/sunglasses = 3,
	/obj/item/pen = 4,
	/obj/item/book/manual/wiki/engineering_hacking = 3,
	/obj/item/trash/candy = 2,
	/obj/item/trash/syndi_cakes = 5,
	/obj/item/shard = 4,
	/obj/item/broken_bottle = 4
))

/obj/effect/meteor/lootrock
	name = "space rock"
	desc = "It be a rock, flyin through space! Yee haw!"
	icon = 'hippiestation/icons/dawynethewockjohnson.dmi'
	hitpwr = 3

/obj/effect/meteor/lootrock/Initialize()
	. = ..()
	hits = rand(1, 3)
	icon_state = pick(icon_states(icon))

/obj/effect/meteor/lootrock/make_debris()
	var/enwrock = pickweight(GLOB.lootrocksks)
	new enwrock(get_turf(src.loc))
