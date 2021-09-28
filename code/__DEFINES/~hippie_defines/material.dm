#define MAT_REAGENT "$reagent"

/// Hard materials, such as iron or silver
#define MAT_CATEGORY_RIGID "rigid material"
/// Is the material from an ore? currently unused but exists atm for categorizations sake
#define MAT_CATEGORY_ORE "ore capable"

/// Hard materials, such as iron or silver
#define MAT_CATEGORY_RIGID "rigid material"

/// Materials that can be used to craft items
#define MAT_CATEGORY_ITEM_MATERIAL "item material"

///Use this flag on TRUE if you want the basic recipes
#define MAT_CATEGORY_BASE_RECIPES "basic recipes"

/// Used to make a material initialize at roundstart.
#define MATERIAL_INIT_MAPLOAD (1<<0)
/// Used to make a material type able to be instantiated on demand after roundstart.
#define MATERIAL_INIT_BESPOKE (1<<1)

//Material Container Flags.
///If the container shows the amount of contained materials on examine.
#define MATCONTAINER_EXAMINE (1<<0)
///If the container cannot have materials inserted through attackby().
#define MATCONTAINER_NO_INSERT (1<<1)
///if the user can insert mats into the container despite the intent.
#define MATCONTAINER_ANY_INTENT (1<<2)
///if the user won't receive a warning when attacking the container with an unallowed item.
#define MATCONTAINER_SILENT (1<<3)
